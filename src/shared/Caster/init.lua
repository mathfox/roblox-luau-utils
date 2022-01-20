--[[
	Remember -- A "Caster" represents an entire gun (or whatever is launching your projectiles), *NOT* the individual bullets.
	Make the caster once, then use the caster to fire your bullets. Do not make a caster for each bullet.
--]]

local RunService = game:GetService("RunService")

local cloneRaycastParams = require(script.Parent.RaycastParamsUtils.cloneRaycastParams)
local Vector3Utils = require(script.Parent.Vector3Utils)
local Signal = require(script.Parent.Signal)
local Types = require(script.Types)

-- If pierce callback has to run more than this many times, it will register a hit and stop calculating pierces.
-- This only applies for repeated piercings, e.g. the amount of parts that fit within the space of a single cast segment (NOT the whole bullet's trajectory over its entire lifetime)
local MAX_PIERCE_TEST_COUNT = 100

local function getTrajectoryInfo(cast: Types.ActiveCast, index: number): { Vector3 }
	local trajectories = cast.stateInfo.trajectories
	local trajectory = trajectories[index]
	local duration = trajectory.endTime - trajectory.startTime

	local velocity = trajectory.initialVelocity
	local acceleration = trajectory.acceleration

	return {
		Vector3Utils.getPositionAtTime(duration, trajectory.origin, velocity, acceleration),
		Vector3Utils.getVelocityAtTime(duration, velocity, acceleration),
	}
end

local function getLatestTrajectoryEndInfo(cast: Types.ActiveCast): { Vector3 }
	return getTrajectoryInfo(cast, #cast.stateInfo.trajectories)
end

local function sendRayHit(
	cast: Types.ActiveCast,
	resultOfCast: RaycastResult,
	segmentVelocity: Vector3,
	cosmeticBulletObject: Instance?
)
	cast.caster.RayHit:fire(cast, resultOfCast, segmentVelocity, cosmeticBulletObject)
end

local function sendRayPierced(
	cast: Types.ActiveCast,
	resultOfCast: RaycastResult,
	segmentVelocity: Vector3,
	cosmeticBulletObject: Instance?
)
	cast.caster.RayPierced:fire(cast, resultOfCast, segmentVelocity, cosmeticBulletObject)
end

-- simulate a raycast by one tick
local function simulateCast(cast: Types.ActiveCast, delta: number, expectingShortCall: boolean)
	local stateInfo = cast.stateInfo
	local latestTrajectory = stateInfo.trajectories[#stateInfo.trajectories]

	local origin = latestTrajectory.origin
	local totalDelta = stateInfo.totalRuntime - latestTrajectory.startTime
	local initialVelocity = latestTrajectory.initialVelocity
	local acceleration = latestTrajectory.acceleration

	local lastPoint = Vector3Utils.getPositionAtTime(totalDelta, origin, initialVelocity, acceleration)
	local lastDelta = stateInfo.totalRuntime - latestTrajectory.startTime

	stateInfo.totalRuntime += delta

	-- recalculate this
	totalDelta = stateInfo.totalRuntime - latestTrajectory.startTime

	local currentTarget = Vector3Utils.getPositionAtTime(totalDelta, origin, initialVelocity, acceleration)
	local segmentVelocity = Vector3Utils.getVelocityAtTime(totalDelta, initialVelocity, acceleration)

	-- This is the displacement from where the ray was on the last from to where the ray is now.
	local totalDisplacement = currentTarget - lastPoint

	local rayDir = totalDisplacement.Unit * segmentVelocity.Magnitude * delta

	local rayInfo = cast.rayInfo
	local targetWorldRoot = rayInfo.worldRoot
	local resultOfCast = targetWorldRoot:Raycast(lastPoint, rayDir, rayInfo.raycastParams)

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

	cast.caster.LengthChanged:fire(
		cast,
		lastPoint,
		rayDir,
		rayDisplacement,
		segmentVelocity,
		rayInfo.cosmeticBulletObject
	)
	-- sendLengthChanged(cast, lastPoint, rayDir.Unit, rayDisplacement, segmentVelocity, cast.RayInfo.CosmeticBulletObject)

	stateInfo.distanceCovered += rayDisplacement

	-- HIT DETECTED. Handle all that garbage, and also handle behaviors 1 and 2 (default behavior, go high res when hit) if applicable.
	-- CAST BEHAVIOR 2 IS HANDLED IN THE CODE THAT CALLS THIS FUNCTION.

	if part and part ~= rayInfo.cosmeticBulletObject then
		-- SANITY CHECK: Don't allow the user to yield or run otherwise extensive code that takes longer than one frame/heartbeat to execute.
		if rayInfo.canPierceCallback ~= nil then
			if not expectingShortCall then
				if stateInfo.isActivelySimulatingPierce then
					cast:terminate()

					error(
						"ERROR: The latest call to CanPierceCallback took too long to complete! This cast is going to suffer desyncs which WILL cause unexpected behavior and errors. Please fix your performance problems, or remove statements that yield (e.g. wait() calls)"
					)
				end
			end

			-- expectingShortCall is used to determine if we are doing a forced resolution increase,
			-- in which case this will be called several times in a single frame, which throws this error
			stateInfo.isActivelySimulatingPierce = true
		end

		if
			not rayInfo.canPierceCallback
			or not rayInfo.canPierceCallback(cast, resultOfCast, segmentVelocity, rayInfo.cosmeticBulletObject)
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
					cast:terminate()

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
				-- local realSegmentLength = rayDisplacement / numSegmentsReal -- this spits out 0.51, which isn't exact to the defined 0.5, but it's close

				-- Now the real hard part is converting this to time.
				local timeIncrement = delta / numSegmentsReal
				for segmentIndex = 1, numSegmentsReal do
					if stateInfo.cancelHighResCast then
						stateInfo.cancelHighResCast = false
						break
					end

					local subPosition = Vector3Utils.getPositionAtTime(
						lastDelta + (timeIncrement * segmentIndex),
						origin,
						initialVelocity,
						acceleration
					)

					local subVelocity = Vector3Utils.getVelocityAtTime(
						lastDelta + (timeIncrement * segmentIndex),
						initialVelocity,
						acceleration
					)
					local subRayDir = subVelocity * delta
					local subResult = targetWorldRoot:Raycast(subPosition, subRayDir, rayInfo.raycastParams)

					if subResult then
						if
							not rayInfo.canPierceCallback
							or not rayInfo.canPierceCallback(cast, subResult, subVelocity, rayInfo.cosmeticBulletObject)
						then
							-- still hit even at high res
							stateInfo.isActivelyResimulating = false

							sendRayHit(cast, subResult, subVelocity, rayInfo.cosmeticBulletObject)
							cast:terminate()

							return nil
						else
							-- Recalculating hit something pierceable instead.
							sendRayPierced(cast, subResult, subVelocity, rayInfo.cosmeticBulletObject)
							-- This may result in CancelHighResCast being set to true.
						end
					end
				end

				-- If the script makes it here, then it wasn't a real hit (higher resolution revealed that the low-res hit was faulty)
				-- Just let it keep going.
				stateInfo.isActivelyResimulating = false
			elseif stateInfo.highFidelityBehavior ~= 1 and stateInfo.highFidelityBehavior ~= 3 then
				cast:terminate()

				error("Invalid value " .. stateInfo.highFidelityBehavior .. " for HighFidelityBehavior.")
			else
				-- This is not a physics cast, or recalculation is off.
				-- Hit was successful. Terminating.
				sendRayHit(cast, resultOfCast, segmentVelocity, rayInfo.cosmeticBulletObject)
				cast:terminate()

				return nil
			end
		else
			-- Piercing function returned TRUE to pierce this part.

			local params = rayInfo.raycastParams
			local alteredParts = {}
			local currentPierceTestCount = 0
			local originalFilter = params.FilterDescendantsInstances
			local brokeFromSolidObject = false

			while true do
				-- So now what I need to do is redo this entire cast, just with the new filter list

				-- Catch case: Is it terrain?
				if resultOfCast.Instance:IsA("Terrain") then
					if material == Enum.Material.Water then
						-- Special case: Pierced on water?
						cast:terminate()

						error(
							"Do not add Water as a piercable material. If you need to pierce water, set cast.RayInfo.Parameters.IgnoreWater = true instead",
							0
						)
					end

					warn(
						"WARNING: The pierce callback for this cast returned TRUE on Terrain! This can cause severely adverse effects."
					)
				end

				if params.FilterType == Enum.RaycastFilterType.Blacklist then
					-- blacklist
					-- DO NOT DIRECTLY TABLE.INSERT ON THE PROPERTY
					local filter = params.FilterDescendantsInstances
					table.insert(filter, resultOfCast.Instance)
					table.insert(alteredParts, resultOfCast.Instance)
					params.FilterDescendantsInstances = filter
				else
					-- whitelist
					-- method implemeneted by custom table system
					-- DO NOT DIRECTLY TABLE.REMOVEOBJECT ON THE PROPERTY
					local filter = params.FilterDescendantsInstances
					table.remove(filter, table.find(filter, resultOfCast.Instance))
					table.insert(alteredParts, resultOfCast.Instance)
					params.FilterDescendantsInstances = filter
				end

				sendRayPierced(cast, resultOfCast, segmentVelocity, rayInfo.cosmeticBulletObject)

				-- List has been updated, so let's cast again.
				resultOfCast = targetWorldRoot:Raycast(lastPoint, rayDir, params)

				-- No hit? No simulation. Break.
				if resultOfCast == nil then
					break
				end

				if currentPierceTestCount >= MAX_PIERCE_TEST_COUNT then
					warn(
						"WARNING: Exceeded maximum pierce test budget for a single ray segment (attempted to test the same segment "
							.. MAX_PIERCE_TEST_COUNT
							.. " times!)"
					)

					break
				end
				currentPierceTestCount += 1

				if not rayInfo.canPierceCallback(cast, resultOfCast, segmentVelocity, rayInfo.cosmeticBulletObject) then
					brokeFromSolidObject = true

					break
				end
			end

			-- Restore the filter to its default state.
			rayInfo.raycastParams.FilterDescendantsInstances = originalFilter
			stateInfo.isActivelySimulatingPierce = false

			if brokeFromSolidObject then
				-- We actually hit something while testing.
				sendRayHit(cast, resultOfCast, segmentVelocity, rayInfo.cosmeticBulletObject)
				cast:terminate()

				return
			end

			-- And exit the function here too.
		end
	end

	if stateInfo.distanceCovered >= rayInfo.maxDistance then
		-- SendRayHit(cast, nil, segmentVelocity, cast.RayInfo.CosmeticBulletObject)
		cast:terminate()
	end
end

local function modifyTransformation(
	cast: Types.ActiveCast,
	velocity: Vector3?,
	acceleration: Vector3?,
	position: Vector3?
)
	local stateInfo = cast.stateInfo

	local trajectories = stateInfo.trajectories
	local lastTrajectory = trajectories[#trajectories]

	-- NEW BEHAVIOR: Don't create a new trajectory if we haven't even used the current one.
	if lastTrajectory.startTime == stateInfo.totalRuntime then
		-- This trajectory is fresh out of the box. Let's just change it since it hasn't actually affected the cast yet, so changes won't have adverse effects.
		lastTrajectory.origin = position or lastTrajectory.origin
		lastTrajectory.initialVelocity = velocity or lastTrajectory.initialVelocity
		lastTrajectory.acceleration = acceleration or lastTrajectory.acceleration
	else
		-- The latest trajectory is done. Set its end time and get its location.
		lastTrajectory.endTime = stateInfo.totalRuntime

		local point, velAtPoint = unpack(getLatestTrajectoryEndInfo(cast))

		table.insert(stateInfo.trajectories, {
			startTime = stateInfo.totalRuntime,
			endTime = -1,
			origin = position or point,
			initialVelocity = velocity or velAtPoint,
			acceleration = acceleration or lastTrajectory.acceleration,
		})

		stateInfo.cancelHighResCast = true
	end
end

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
		autoIgnoreContainer = true,
	}
end

local Cast = {}
Cast.__index = Cast

function Cast:setVelocity(velocity: Vector3)
	modifyTransformation(self, velocity, nil, nil)
end

function Cast:setAcceleration(acceleration: Vector3)
	modifyTransformation(self, nil, acceleration, nil)
end

function Cast:setPosition(position: Vector3)
	modifyTransformation(self, nil, nil, position)
end

function Cast:getVelocity(): Vector3
	local stateInfo = self.stateInfo
	local currentTrajectory = stateInfo.trajectories[#stateInfo.trajectories]

	return Vector3Utils.getVelocityAtTime(
		stateInfo.totalRuntime - currentTrajectory.startTime,
		currentTrajectory.initialVelocity,
		currentTrajectory.acceleration
	)
end

function Cast:getAcceleration(): Vector3
	local stateInfo = self.stateInfo
	return stateInfo.trajectories[#stateInfo.trajectories].acceleration
end

function Cast:getPosition(): Vector3
	local stateInfo = self.stateInfo
	local currentTrajectory = stateInfo.trajectories[#stateInfo.trajectories]

	return Vector3Utils.getPositionAtTime(
		stateInfo.totalRuntime - currentTrajectory.startTime,
		currentTrajectory.origin,
		currentTrajectory.initialVelocity,
		currentTrajectory.acceleration
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

function Cast:terminate()
	-- First: Set EndTime on the latest trajectory since it is now done simulating.
	local trajectories = self.stateInfo.trajectories
	trajectories[#trajectories].endTime = self.stateInfo.totalRuntime

	-- Disconnect the update connection.
	self.stateInfo.updateConnection:Disconnect()

	-- Now fire CastTerminating
	self.caster.CastTerminating:fire(self)

	-- And now set the update connection object to nil.
	self.stateInfo.updateConnection = nil

	-- And nuke everything in the table + clear the metatable.
	self.caster = nil
	self.stateInfo = nil
	self.rayInfo = nil
	self.userData = nil

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
		CastTerminating = Signal.new(),
		worldRoot = workspace,
	}, Caster)

	return self
end

local DEFAULT_CASTER_BEHAVIOR = Behavior.new()

function Caster:Fire(
	origin: Vector3,
	direction: Vector3,
	velocity: Vector3 | number,
	casterBehavior: Types.CasterBehavior?
): Types.ActiveCast
	casterBehavior = casterBehavior or DEFAULT_CASTER_BEHAVIOR

	if casterBehavior.highFidelitySegmentSize <= 0 then
		error("can not set FastCastBehavior.HighFidelitySegmentSize <= 0!", 0)
	end

	-- Data that keeps track of what's going on as well as edits we might make during runtime.
	local stateInfo = {
		paused = false,
		totalRuntime = 0,
		distanceCovered = 0,
		highFidelitySegmentSize = casterBehavior.highFidelitySegmentSize,
		highFidelityBehavior = casterBehavior.highFidelityBehavior ~= 2 and casterBehavior.highFidelityBehavior or 3,
		isActivelySimulatingPierce = false,
		isActivelyResimulating = false,
		cancelHighResCast = false,
		trajectories = {
			{
				startTime = 0,
				endTime = -1,
				origin = origin,
				initialVelocity = if typeof(velocity) == "number" then direction.Unit * velocity else velocity,
				acceleration = casterBehavior.acceleration,
			},
		},
	}

	-- Information pertaining to actual raycasting.
	local rayInfo = {
		raycastParams = if casterBehavior.raycastParams then cloneRaycastParams(casterBehavior.raycastParams) else RaycastParams.new(),
		worldRoot = self.worldRoot,
		maxDistance = casterBehavior.maxDistance or 1000,
		cosmeticBulletObject = casterBehavior.cosmeticBulletTemplate, -- This is intended. We clone it a smidge of the way down.
		canPierceCallback = casterBehavior.canPierceFunction,
	}

	local cast = setmetatable({
		caster = self,
		stateInfo = stateInfo,
		rayInfo = rayInfo,
		userData = {},
	}, Cast)

	if not casterBehavior.cosmeticBulletProvider then
		error("no cosmetic bullet provider was set", 2)
	end

	rayInfo.cosmeticBulletObject = casterBehavior.cosmeticBulletProvider:GetPart()
	rayInfo.cosmeticBulletObject.CFrame = CFrame.new(origin, origin + direction)

	local targetContainer = casterBehavior.cosmeticBulletProvider.parent

	if casterBehavior.autoIgnoreContainer and targetContainer then
		local ignoreList = rayInfo.raycastParams.FilterDescendantsInstances
		if not table.find(ignoreList, targetContainer) then
			table.insert(ignoreList, targetContainer)

			rayInfo.raycastParams.FilterDescendantsInstances = ignoreList
		end
	end

	stateInfo.updateConnection =
		(if RunService:IsClient() then RunService.RenderStepped else RunService.Heartbeat):Connect(
			function(delta: number)
				if stateInfo.paused then
					return nil
				end

				-- Casting for frame.
				local latestTrajectory = stateInfo.trajectories[#stateInfo.trajectories]
				if
					stateInfo.highFidelityBehavior == 3
					and latestTrajectory.acceleration ~= Vector3.zero
					and stateInfo.highFidelitySegmentSize > 0
				then
					local timeAtStart = tick()

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

					local lastPoint = Vector3Utils.getPositionAtTime(totalDelta, origin, initialVelocity, acceleration)

					stateInfo.totalRuntime += delta

					-- Recalculate this.
					totalDelta = stateInfo.totalRuntime - latestTrajectory.startTime

					local currentPoint = Vector3Utils.getPositionAtTime(
						totalDelta,
						origin,
						initialVelocity,
						acceleration
					)
					local currentVelocity = Vector3Utils.getVelocityAtTime(totalDelta, initialVelocity, acceleration)

					-- This is the displacement from where the ray was on the last from to where the ray is now.
					local totalDisplacement = currentPoint - lastPoint

					local rayDir = totalDisplacement.Unit * currentVelocity.Magnitude * delta

					local resultOfCast = rayInfo.worldRoot:Raycast(lastPoint, rayDir, rayInfo.raycastParams)

					local point = if resultOfCast == nil then currentPoint else resultOfCast.Position

					local rayDisplacement = (point - lastPoint).Magnitude

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

						simulateCast(cast, timeIncrement, true)
					end

					if getmetatable(cast) == nil then
						return nil
					end -- Could have been disposed.
					stateInfo.isActivelyResimulating = false

					if (tick() - timeAtStart) > 0.016 * 5 then
						warn("Extreme cast lag encountered! Consider increasing HighFidelitySegmentSize.")
					end
				else
					simulateCast(cast, delta, false)
				end
			end
		)

	return cast
end

Caster.fire = Caster.Fire

return Caster
