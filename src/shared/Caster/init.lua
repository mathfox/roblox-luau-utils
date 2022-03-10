--[[
	Remember -- A "Caster" represents an entire gun (or whatever is launching your projectiles), *NOT* the individual bullets.
	Make the caster once, then use the caster to fire your bullets. Do not make a caster for each bullet.
--]]

local RunService = game:GetService("RunService")

local cloneRaycastParams = require(script.Parent.RaycastParamsUtils.cloneRaycastParams)
local getPositionAtTime = require(script.Parent.Vector3Utils.getPositionAtTime)
local getVelocityAtTime = require(script.Parent.Vector3Utils.getVelocityAtTime)
local Signal = require(script.Parent.Signal)
local Types = require(script.Types)

local HighFidelityBehavior = {
	Default = 1,
	Always = 3,
}

local Behavior = {}

function Behavior.new(): Types.CasterBehavior
	return {
		acceleration = Vector3.zero,
		maxDistance = 1000,
		highFidelityBehavior = HighFidelityBehavior.Default,
		highFidelitySegmentSize = 0.5,
		maxPierceCount = 100,
	}
end

local Cast = {}
Cast.__index = Cast

function Cast:_sendRayPierced(result: RaycastResult, segmentVelocity: Vector3, projectile: Instance?)
	self.caster.RayPierced:fire(self, result, segmentVelocity, projectile)
end

function Cast:_sendRayHit(result: RaycastResult, segmentVelocity: Vector3, projectile: Instance?)
	self.caster.RayHit:fire(self, result, segmentVelocity, projectile)
end

function Cast:_modifyTransformation(velocity: Vector3?, acceleration: Vector3?, position: Vector3?)
	local stateInfo = self.stateInfo
	local lastTrajectory = stateInfo.latestTrajectory

	if lastTrajectory.startTime == stateInfo.totalRuntime then
		-- This trajectory is fresh out of the box. Let's just change it since it hasn't actually affected the cast yet, so changes won't have adverse effects.
		lastTrajectory.origin = position or lastTrajectory.origin
		lastTrajectory.initialVelocity = velocity or lastTrajectory.initialVelocity
		lastTrajectory.acceleration = acceleration or lastTrajectory.acceleration
	else
		-- The latest trajectory is done. Set its end time and get its location.
		lastTrajectory.endTime = stateInfo.totalRuntime

		local trajectories = stateInfo.trajectories
		local point, velocityAtPoint = self:_getTrajectoryInfo(#trajectories)

		local latestTrajectory = {
			startTime = stateInfo.totalRuntime,
			endTime = -1,
			origin = position or point,
			initialVelocity = velocity or velocityAtPoint,
			acceleration = acceleration or lastTrajectory.acceleration,
		}

		stateInfo.latestTrajectory = latestTrajectory
		table.insert(trajectories, latestTrajectory)

		stateInfo.cancelHighResCast = true
	end
end

function Cast:_getTrajectoryInfo(index: number): (Vector3, Vector3)
	local trajectory = self.stateInfo.trajectories[index]
	local duration = trajectory.endTime - trajectory.startTime

	local velocity = trajectory.initialVelocity
	local acceleration = trajectory.acceleration

	return getPositionAtTime(duration, trajectory.origin, velocity, acceleration),
		getVelocityAtTime(duration, velocity, acceleration)
end

function Cast:setVelocity(velocity: Vector3)
	self:_modifyTransformation(velocity, nil, nil)
end

function Cast:setAcceleration(acceleration: Vector3)
	self:_modifyTransformation(nil, acceleration, nil)
end

function Cast:setPosition(position: Vector3)
	self:_modifyTransformation(nil, nil, position)
end

function Cast:getVelocity(): Vector3
	local stateInfo = self.stateInfo
	local latestTrajectory = stateInfo.latestTrajectory

	return getVelocityAtTime(
		stateInfo.totalRuntime - latestTrajectory.startTime,
		latestTrajectory.initialVelocity,
		latestTrajectory.acceleration
	)
end

function Cast:getAcceleration(): Vector3
	return self.stateInfo.latestTrajectory.acceleration
end

function Cast:getPosition(): Vector3
	local stateInfo = self.stateInfo
	local latestTrajectory = stateInfo.latestTrajectory

	return getPositionAtTime(
		stateInfo.totalRuntime - latestTrajectory.startTime,
		latestTrajectory.origin,
		latestTrajectory.initialVelocity,
		latestTrajectory.acceleration
	)
end

function Cast:addVelocity(velocity: Vector3)
	self:setVelocity(self:getVelocity() + velocity)
end

function Cast:addAcceleration(acceleration: Vector3)
	self:setAcceleration(self:getAcceleration() + acceleration)
end

function Cast:addPosition(position: Vector3)
	self:setPosition(self:getPosition() + position)
end

function Cast:pause()
	self.stateInfo.paused = true
end

function Cast:resume()
	self.stateInfo.paused = false
end

function Cast:_simulate(delta: number, expectingShortCall: boolean)
	local stateInfo = self.stateInfo
	local latestTrajectory = stateInfo.latestTrajectory

	local origin = latestTrajectory.origin
	local totalDelta = stateInfo.totalRuntime - latestTrajectory.startTime
	local initialVelocity = latestTrajectory.initialVelocity
	local acceleration = latestTrajectory.acceleration

	local lastPoint = getPositionAtTime(totalDelta, origin, initialVelocity, acceleration)
	local lastDelta = stateInfo.totalRuntime - latestTrajectory.startTime

	stateInfo.totalRuntime += delta

	-- recalculate this
	totalDelta = stateInfo.totalRuntime - latestTrajectory.startTime

	local currentTarget = getPositionAtTime(totalDelta, origin, initialVelocity, acceleration)
	local segmentVelocity = getVelocityAtTime(totalDelta, initialVelocity, acceleration)

	-- This is the displacement from where the ray was on the last from to where the ray is now.
	local totalDisplacement = currentTarget - lastPoint

	local rayDir = totalDisplacement.Unit * segmentVelocity.Magnitude * delta

	local rayInfo = self.rayInfo
	local targetWorldRoot = rayInfo.worldRoot
	local raycastParams = rayInfo.raycastParams
	local resultOfCast = targetWorldRoot:Raycast(lastPoint, rayDir, raycastParams)

	local point = currentTarget
	local part: Instance? = nil
	local material = Enum.Material.Air

	if resultOfCast ~= nil then
		point = resultOfCast.Position
		part = resultOfCast.Instance
		material = resultOfCast.Material
	end

	local rayDisplacement = (point - lastPoint).Magnitude
	-- For clarity -- totalDisplacement is how far the ray would have traveled if it hit nothing,
	-- and rayDisplacement is how far the ray really traveled (which will be identical to totalDisplacement if it did indeed hit nothing)

	self.caster.LengthChanged:fire(
		self,
		lastPoint,
		rayDir,
		rayDisplacement,
		segmentVelocity,
		rayInfo.cosmeticBulletObject
	)

	stateInfo.distanceCovered += rayDisplacement

	-- HIT DETECTED. Handle all that garbage, and also handle behaviors 1 and 2 (default behavior, go high res when hit) if applicable.
	-- CAST BEHAVIOR 2 IS HANDLED IN THE CODE THAT CALLS THIS FUNCTION.

	if part and part ~= rayInfo.cosmeticBulletObject then
		local canPierceFunction = self.behavior.canPierceFunction

		-- SANITY CHECK: Don't allow the user to yield or run otherwise extensive code that takes longer than one frame/heartbeat to execute.
		if canPierceFunction then
			if not expectingShortCall then
				if stateInfo.isActivelySimulatingPierce then
					self:terminate()

					error(
						"the latest call to canPierceFunction took too long to complete! This cast is going to suffer desyncs which WILL cause unexpected behavior and errors. Please fix your performance problems, or remove statements that yield (e.g. wait() calls)"
					)
				end
			end

			-- expectingShortCall is used to determine if we are doing a forced resolution increase,
			-- in which case this will be called several times in a single frame, which throws this error
			stateInfo.isActivelySimulatingPierce = true
		end

		if
			not canPierceFunction
			or not canPierceFunction(self, resultOfCast, segmentVelocity, rayInfo.cosmeticBulletObject)
		then
			-- Piercing function is nil or it returned FALSE to not pierce this hit.
			stateInfo.isActivelySimulatingPierce = false

			if
				stateInfo.highFidelityBehavior == 2
				and latestTrajectory.acceleration ~= Vector3.zero
				and stateInfo.highFidelitySegmentSize ~= 0
			then
				stateInfo.cancelHighResCast = false -- Reset this here.

				if stateInfo.isActivelyResimulating then
					self:terminate()

					error(
						"Cascading cast lag encountered! The caster attempted to perform a high fidelity cast before the previous one completed, resulting in exponential cast lag. Consider increasing HighFidelitySegmentSize."
					)
				end

				stateInfo.isActivelyResimulating = true

				-- This is a physics based cast and it needs to be recalculated.
				-- "Hit was registered, but recalculation is on for physics based casts. Recalculating to verify a real hit..."

				-- Split this ray segment into smaller segments of a given size.
				-- In 99% of cases, it won't divide evently (e.g. I have a distance of 1.25 and I want to divide into 0.1 -- that won't work)
				-- To fix this, the segments need to be stretched slightly to fill the space (rather than having a single shorter segment at the end)

				local numSegmentsDecimal = rayDisplacement / stateInfo.highFidelitySegmentSize -- say rayDisplacement is 5.1, segment size is 0.5 -- 10.2 segments
				local numSegmentsReal = math.floor(numSegmentsDecimal) -- 10 segments + 0.2 extra segments

				-- Now the real hard part is converting this to time.
				local timeIncrement = delta / numSegmentsReal
				for segmentIndex = 1, numSegmentsReal do
					if stateInfo.cancelHighResCast then
						stateInfo.cancelHighResCast = false
						break
					end

					local subPosition = getPositionAtTime(
						lastDelta + (timeIncrement * segmentIndex),
						origin,
						initialVelocity,
						acceleration
					)

					local subVelocity = getVelocityAtTime(
						lastDelta + (timeIncrement * segmentIndex),
						initialVelocity,
						acceleration
					)

					local subResult = targetWorldRoot:Raycast(subPosition, subVelocity * delta, raycastParams)

					if subResult then
						if
							not canPierceFunction
							or not canPierceFunction(self, subResult, subVelocity, rayInfo.cosmeticBulletObject)
						then
							-- still hit even at high res
							stateInfo.isActivelyResimulating = false

							self:_sendRayHit(subResult, subVelocity, rayInfo.cosmeticBulletObject)
							self:terminate()

							return nil
						else
							-- Recalculating hit something pierceable instead.
							self:_sendRayPierced(subResult, subVelocity, rayInfo.cosmeticBulletObject)
							-- This may result in CancelHighResCast being set to true.
						end
					end
				end

				-- If the script makes it here, then it wasn't a real hit (higher resolution revealed that the low-res hit was faulty)
				-- Just let it keep going.
				stateInfo.isActivelyResimulating = false
			elseif stateInfo.highFidelityBehavior ~= 1 and stateInfo.highFidelityBehavior ~= 3 then
				self:terminate()

				error("Invalid value " .. stateInfo.highFidelityBehavior .. " for HighFidelityBehavior.")
			else
				-- This is not a physics cast, or recalculation is off.
				-- Hit was successful. Terminating.
				self:_sendRayHit(resultOfCast, segmentVelocity, rayInfo.cosmeticBulletObject)
				self:terminate()

				return nil
			end
		else
			-- Piercing function returned TRUE to pierce this part.
			local currentPierceCount = 0
			local originalFilter = raycastParams.FilterDescendantsInstances
			local brokeFromSolidObject = false

			while true do
				-- So now what I need to do is redo this entire cast, just with the new filter list

				if resultOfCast.Instance:IsA("Terrain") then
					if material == Enum.Material.Water then
						self:terminate()

						error(
							"Do not add Water as a piercable material. If you need to pierce water, set cast.RayInfo.Parameters.IgnoreWater = true instead"
						)
					end

					warn(
						"WARNING: The pierce callback for this cast returned TRUE on Terrain! This can cause severely adverse effects."
					)
				end

				if raycastParams.FilterType == Enum.RaycastFilterType.Blacklist then
					local filter = raycastParams.FilterDescendantsInstances
					table.insert(filter, resultOfCast.Instance)
					raycastParams.FilterDescendantsInstances = filter
				else
					local filter = raycastParams.FilterDescendantsInstances
					table.remove(filter, table.find(filter, resultOfCast.Instance))
					raycastParams.FilterDescendantsInstances = filter
				end

				self:_sendRayPierced(resultOfCast, segmentVelocity, rayInfo.cosmeticBulletObject)

				-- List has been updated, so let's cast again.
				resultOfCast = targetWorldRoot:Raycast(lastPoint, rayDir, raycastParams)

				-- No hit? No simulation. Break.
				if resultOfCast == nil then
					break
				end

				if currentPierceCount >= self.behavior.maxPierceCount then
					warn(
						"WARNING: Exceeded maximum pierce budget for a single ray segment (attempted to test the same segment "
							.. self.behavior.maxPierceCount
							.. " times!)"
					)

					break
				end
				currentPierceCount += 1

				if not canPierceFunction(self, resultOfCast, segmentVelocity, rayInfo.cosmeticBulletObject) then
					brokeFromSolidObject = true

					break
				end
			end

			-- Restore the filter to its default state.
			raycastParams.FilterDescendantsInstances = originalFilter
			stateInfo.isActivelySimulatingPierce = false

			if brokeFromSolidObject then
				self:_sendRayHit(resultOfCast, segmentVelocity, rayInfo.cosmeticBulletObject)
				self:terminate()

				return
			end
		end
	end

	if stateInfo.distanceCovered >= rayInfo.maxDistance then
		self.caster.RayOutranged:fire(self, resultOfCast, segmentVelocity, rayInfo.cosmeticBulletObject)

		self:terminate()
	end
end

function Cast:terminate()
	local stateInfo = self.stateInfo

	stateInfo.latestTrajectory.endTime = self.stateInfo.totalRuntime
	stateInfo.updateConnection:Disconnect()

	self.caster.CastTerminating:fire(self)

	setmetatable(self, nil)
end

local Caster = {}
Caster.Cast = Cast
Caster.Behavior = Behavior
Caster.HighFidelityBehavior = HighFidelityBehavior
Caster.__index = Caster

function Caster.new()
	local self = setmetatable({
		LengthChanged = Signal.new(),
		RayHit = Signal.new(),
		RayPierced = Signal.new(),
		RayOutranged = Signal.new(),
		CastTerminating = Signal.new(),
		worldRoot = workspace,
	}, Caster)

	return self
end

function Caster:fire(
	origin: Vector3,
	direction: Vector3,
	velocity: Vector3 | number,
	casterBehavior: Types.CasterBehavior
): Types.Cast
	if casterBehavior.highFidelitySegmentSize <= 0 then
		error("can not set FastCastBehavior.HighFidelitySegmentSize <= 0!", 0)
	end

	local stateInfo = nil

	do
		local latestTrajectory = {
			startTime = 0,
			endTime = -1,
			origin = origin,
			initialVelocity = if typeof(velocity) == "number" then direction.Unit * velocity else velocity,
			acceleration = casterBehavior.acceleration,
		}

		stateInfo = {
			paused = false,
			totalRuntime = 0,
			distanceCovered = 0,
			highFidelitySegmentSize = casterBehavior.highFidelitySegmentSize,
			highFidelityBehavior = casterBehavior.highFidelityBehavior ~= 2 and casterBehavior.highFidelityBehavior
				or 3,
			isActivelySimulatingPierce = false,
			isActivelyResimulating = false,
			cancelHighResCast = false,
			trajectories = { latestTrajectory },
			latestTrajectory = latestTrajectory,
		}
	end

	local raycastParams = if casterBehavior.raycastParams
		then cloneRaycastParams(casterBehavior.raycastParams)
		else RaycastParams.new()

	local rayInfo = {
		raycastParams = raycastParams,
		worldRoot = self.worldRoot,
		maxDistance = casterBehavior.maxDistance or 1000,
	}

	local cast = setmetatable({
		caster = self,
		stateInfo = stateInfo,
		rayInfo = rayInfo,
		behavior = casterBehavior,
		userData = {},
	}, Cast)

	if not casterBehavior.cosmeticBulletProvider then
		error("no cosmetic bullet provider was set", 2)
	end

	rayInfo.cosmeticBulletObject = casterBehavior.cosmeticBulletProvider:getInstance()
	rayInfo.cosmeticBulletObject.CFrame = CFrame.new(origin, origin + direction)

	stateInfo.updateConnection =
		(if RunService:IsClient() then RunService.RenderStepped else RunService.Heartbeat):Connect(
			function(delta: number)
				if stateInfo.paused then
					return nil
				end

				local latestTrajectory = stateInfo.latestTrajectory
				if stateInfo.highFidelityBehavior == 3 and latestTrajectory.acceleration ~= Vector3.zero then
					local timeAtStart = os.clock()

					if stateInfo.isActivelyResimulating then
						cast:terminate()

						error(
							"Cascading cast lag encountered! The caster attempted to perform a high fidelity cast before the previous one completed, resulting in exponential cast lag. Consider increasing HighFidelitySegmentSize."
						)
					end

					stateInfo.isActivelyResimulating = true

					-- Actually want to calculate this early to find displacement
					local origin = latestTrajectory.origin
					local totalDelta = stateInfo.totalRuntime - latestTrajectory.startTime
					local initialVelocity = latestTrajectory.initialVelocity
					local acceleration = latestTrajectory.acceleration

					local lastPoint = getPositionAtTime(totalDelta, origin, initialVelocity, acceleration)

					stateInfo.totalRuntime += delta

					-- Recalculate this.
					totalDelta = stateInfo.totalRuntime - latestTrajectory.startTime

					local currentPoint = getPositionAtTime(totalDelta, origin, initialVelocity, acceleration)
					local currentVelocity = getVelocityAtTime(totalDelta, initialVelocity, acceleration)

					-- This is the displacement from where the ray was on the last from to where the ray is now.
					local totalDisplacement = currentPoint - lastPoint

					local raycastResult = rayInfo.worldRoot:Raycast(
						lastPoint,
						totalDisplacement.Unit * currentVelocity.Magnitude * delta,
						raycastParams
					)

					local rayDisplacement = (if not raycastResult
						then currentPoint
						else raycastResult.Position - lastPoint).Magnitude

					-- Now undo this. The line below in the for loop will add this time back gradually.
					stateInfo.totalRuntime -= delta

					-- And now that we have displacement, we can calculate segment size.
					local numSegmentsDecimal = rayDisplacement / stateInfo.highFidelitySegmentSize -- say rayDisplacement is 5.1, segment size is 0.5 -- 10.2 segments

					-- 10 segments + 0.2 extra segments
					local numSegmentsReal = math.floor(numSegmentsDecimal)
					if numSegmentsReal == 0 then
						numSegmentsReal = 1
					end

					local timeIncrement = delta / numSegmentsReal

					for _ = 1, numSegmentsReal do
						if getmetatable(cast) == nil then
							return nil
						end -- Could have been disposed.

						if stateInfo.cancelHighResCast then
							stateInfo.cancelHighResCast = false
							break
						end

						cast:_simulate(timeIncrement, true)
					end

					if getmetatable(cast) == nil then
						return nil
					end -- Could have been disposed.
					stateInfo.isActivelyResimulating = false

					if (os.clock() - timeAtStart) > 0.016 * 5 then
						warn("extreme cast lag encountered! Consider increasing HighFidelitySegmentSize")
					end
				else
					cast:_simulate(delta, false)
				end
			end
		)

	return cast
end

function Caster:destroy()
	self.LengthChanged:destroy()
	self.RayHit:destroy()
	self.RayPierced:destroy()
	self.RayOutranged:destroy()
	self.CastTerminating:destroy()

	setmetatable(self, nil)
end

return Caster
