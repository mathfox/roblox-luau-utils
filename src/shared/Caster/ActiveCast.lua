local RunService = game:GetService("RunService")

local Types = require(script.Parent.Types)
local Caster = nil

local ActiveCast = {}
ActiveCast.__index = ActiveCast

-- If pierce callback has to run more than this many times, it will register a hit and stop calculating pierces.
-- This only applies for repeated piercings, e.g. the amount of parts that fit within the space of a single cast segment (NOT the whole bullet's trajectory over its entire lifetime)
local MAX_PIERCE_TEST_COUNT = 100

-- Thanks to zoebasil for supplying the velocity and position functions below. (I've modified these functions)
-- I was having a huge issue trying to get it to work and I had overcomplicated a bunch of stuff.
-- getPositionAtTime is used in physically simulated rays (Where Caster.HasPhysics == true or the specific Fire has a specified acceleration).
-- This returns the location that the bullet will be at when you specify the amount of time the bullet has existed, the original location of the bullet, and the velocity it was launched with.
local function getPositionAtTime(
	time: number,
	origin: Vector3,
	initialVelocity: Vector3,
	acceleration: Vector3
): Vector3
	local timePow2 = time ^ 2

	return origin
		+ (initialVelocity * time)
		+ Vector3.new((acceleration.X * timePow2) / 2, (acceleration.Y * timePow2) / 2, (acceleration.Z * timePow2) / 2)
end

-- A variant of the function above that returns the velocity at a given point in time.
local function getVelocityAtTime(time: number, initialVelocity: Vector3, acceleration: Vector3): Vector3
	return initialVelocity + acceleration * time
end

local function getTrajectoryInfo(cast: Types.ActiveCast, index: number): { Vector3 }
	local trajectories = cast.StateInfo.Trajectories
	local trajectory = trajectories[index]
	local duration = trajectory.EndTime - trajectory.StartTime

	local origin = trajectory.Origin
	local vel = trajectory.InitialVelocity
	local accel = trajectory.Acceleration

	return { getPositionAtTime(duration, origin, vel, accel), getVelocityAtTime(duration, vel, accel) }
end

local function getLatestTrajectoryEndInfo(cast: Types.ActiveCast): { Vector3 }
	return getTrajectoryInfo(cast, #cast.StateInfo.Trajectories)
end

local function cloneRaycastParams(params: RaycastParams): RaycastParams
	local raycastParams = RaycastParams.new()

	raycastParams.CollisionGroup = params.CollisionGroup
	raycastParams.FilterType = params.FilterType
	raycastParams.FilterDescendantsInstances = params.FilterDescendantsInstances
	raycastParams.IgnoreWater = params.IgnoreWater

	return raycastParams
end

local function sendRayHit(
	cast: Types.ActiveCast,
	resultOfCast: RaycastResult,
	segmentVelocity: Vector3,
	cosmeticBulletObject: Instance?
)
	cast.Caster.RayHit:fire(cast, resultOfCast, segmentVelocity, cosmeticBulletObject)
end

local function sendRayPierced(
	cast: Types.ActiveCast,
	resultOfCast: RaycastResult,
	segmentVelocity: Vector3,
	cosmeticBulletObject: Instance?
)
	cast.Caster.RayPierced:fire(cast, resultOfCast, segmentVelocity, cosmeticBulletObject)
end

local function sendLengthChanged(
	cast: Types.ActiveCast,
	lastPoint: Vector3,
	rayDir: Vector3,
	rayDisplacement: number,
	segmentVelocity: Vector3,
	cosmeticBulletObject: Instance?
)
	cast.Caster.LengthChanged:fire(cast, lastPoint, rayDir, rayDisplacement, segmentVelocity, cosmeticBulletObject)
end

-- Simulate a raycast by one tick.
local function simulateCast(cast: Types.ActiveCast, delta: number, expectingShortCall: boolean)
	local latestTrajectory = cast.StateInfo.Trajectories[#cast.StateInfo.Trajectories]

	local origin = latestTrajectory.Origin
	local totalDelta = cast.StateInfo.TotalRuntime - latestTrajectory.StartTime
	local initialVelocity = latestTrajectory.InitialVelocity
	local acceleration = latestTrajectory.Acceleration

	local lastPoint = getPositionAtTime(totalDelta, origin, initialVelocity, acceleration)
	-- local lastVelocity = getVelocityAtTime(totalDelta, initialVelocity, acceleration)
	local lastDelta = cast.StateInfo.TotalRuntime - latestTrajectory.StartTime

	cast.StateInfo.TotalRuntime += delta

	-- Recalculate this.
	totalDelta = cast.StateInfo.TotalRuntime - latestTrajectory.StartTime

	local currentTarget = getPositionAtTime(totalDelta, origin, initialVelocity, acceleration)
	local segmentVelocity = getVelocityAtTime(totalDelta, initialVelocity, acceleration)
	local totalDisplacement = currentTarget - lastPoint -- This is the displacement from where the ray was on the last from to where the ray is now.

	local rayDir = totalDisplacement.Unit * segmentVelocity.Magnitude * delta
	local targetWorldRoot = cast.RayInfo.WorldRoot
	local resultOfCast = targetWorldRoot:Raycast(lastPoint, rayDir, cast.RayInfo.Parameters)

	local point = currentTarget
	local part: Instance? = nil
	local material = Enum.Material.Air
	-- local normal = Vector3.zero

	if resultOfCast ~= nil then
		point = resultOfCast.Position
		part = resultOfCast.Instance
		material = resultOfCast.Material
		-- normal = resultOfCast.Normal
	end

	local rayDisplacement = (point - lastPoint).Magnitude
	-- For clarity -- totalDisplacement is how far the ray would have traveled if it hit nothing,
	-- and rayDisplacement is how far the ray really traveled (which will be identical to totalDisplacement if it did indeed hit nothing)

	sendLengthChanged(cast, lastPoint, rayDir.Unit, rayDisplacement, segmentVelocity, cast.RayInfo.CosmeticBulletObject)
	cast.StateInfo.DistanceCovered += rayDisplacement

	-- HIT DETECTED. Handle all that garbage, and also handle behaviors 1 and 2 (default behavior, go high res when hit) if applicable.
	-- CAST BEHAVIOR 2 IS HANDLED IN THE CODE THAT CALLS THIS FUNCTION.

	if part and part ~= cast.RayInfo.CosmeticBulletObject then
		-- local start = tick()

		-- SANITY CHECK: Don't allow the user to yield or run otherwise extensive code that takes longer than one frame/heartbeat to execute.
		if cast.RayInfo.CanPierceCallback ~= nil then
			if not expectingShortCall then
				if cast.StateInfo.IsActivelySimulatingPierce then
					cast:terminate()

					error(
						"ERROR: The latest call to CanPierceCallback took too long to complete! This cast is going to suffer desyncs which WILL cause unexpected behavior and errors. Please fix your performance problems, or remove statements that yield (e.g. wait() calls)"
					)
				end
			end

			-- expectingShortCall is used to determine if we are doing a forced resolution increase,
			-- in which case this will be called several times in a single frame, which throws this error
			cast.StateInfo.IsActivelySimulatingPierce = true
		end

		if
			cast.RayInfo.CanPierceCallback == nil
			or (
				cast.RayInfo.CanPierceCallback ~= nil
				and cast.RayInfo.CanPierceCallback(
						cast,
						resultOfCast,
						segmentVelocity,
						cast.RayInfo.CosmeticBulletObject
					)
					== false
			)
		then
			-- Piercing function is nil or it returned FALSE to not pierce this hit.
			cast.StateInfo.IsActivelySimulatingPierce = false

			if
				cast.StateInfo.HighFidelityBehavior == 2
				and latestTrajectory.Acceleration ~= Vector3.zero
				and cast.StateInfo.HighFidelitySegmentSize ~= 0
			then
				cast.StateInfo.CancelHighResCast = false -- Reset this here.

				if cast.StateInfo.IsActivelyResimulating then
					cast:terminate()

					error(
						"Cascading cast lag encountered! The caster attempted to perform a high fidelity cast before the previous one completed, resulting in exponential cast lag. Consider increasing HighFidelitySegmentSize."
					)
				end

				cast.StateInfo.IsActivelyResimulating = true

				-- This is a physics based cast and it needs to be recalculated.
				-- "Hit was registered, but recalculation is on for physics based casts. Recalculating to verify a real hit..."

				-- Split this ray segment into smaller segments of a given size.
				-- In 99% of cases, it won't divide evently (e.g. I have a distance of 1.25 and I want to divide into 0.1 -- that won't work)
				-- To fix this, the segments need to be stretched slightly to fill the space (rather than having a single shorter segment at the end)

				local numSegmentsDecimal = rayDisplacement / cast.StateInfo.HighFidelitySegmentSize -- say rayDisplacement is 5.1, segment size is 0.5 -- 10.2 segments
				local numSegmentsReal = math.floor(numSegmentsDecimal) -- 10 segments + 0.2 extra segments
				-- local realSegmentLength = rayDisplacement / numSegmentsReal -- this spits out 0.51, which isn't exact to the defined 0.5, but it's close

				-- Now the real hard part is converting this to time.
				local timeIncrement = delta / numSegmentsReal
				for segmentIndex = 1, numSegmentsReal do
					if cast.StateInfo.CancelHighResCast then
						cast.StateInfo.CancelHighResCast = false
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
					local subRayDir = subVelocity * delta
					local subResult = targetWorldRoot:Raycast(subPosition, subRayDir, cast.RayInfo.Parameters)

					-- local subDisplacement = (subPosition - (subPosition + subVelocity)).Magnitude

					if subResult ~= nil then
						-- local subDisplacement = (subPosition - subResult.Position).Magnitude

						if
							cast.RayInfo.CanPierceCallback == nil
							or (
								cast.RayInfo.CanPierceCallback ~= nil
								and cast.RayInfo.CanPierceCallback(
										cast,
										subResult,
										subVelocity,
										cast.RayInfo.CosmeticBulletObject
									)
									== false
							)
						then
							-- Still hit even at high res
							cast.StateInfo.IsActivelyResimulating = false

							sendRayHit(cast, subResult, subVelocity, cast.RayInfo.CosmeticBulletObject)
							cast:terminate()

							return nil
						else
							-- Recalculating hit something pierceable instead.
							sendRayPierced(cast, subResult, subVelocity, cast.RayInfo.CosmeticBulletObject)
							-- This may result in CancelHighResCast being set to true.
						end
					end
				end

				-- If the script makes it here, then it wasn't a real hit (higher resolution revealed that the low-res hit was faulty)
				-- Just let it keep going.
				cast.StateInfo.IsActivelyResimulating = false
			elseif cast.StateInfo.HighFidelityBehavior ~= 1 and cast.StateInfo.HighFidelityBehavior ~= 3 then
				cast:terminate()

				error("Invalid value " .. cast.StateInfo.HighFidelityBehavior .. " for HighFidelityBehavior.")
			else
				-- This is not a physics cast, or recalculation is off.
				-- Hit was successful. Terminating.
				sendRayHit(cast, resultOfCast, segmentVelocity, cast.RayInfo.CosmeticBulletObject)
				cast:terminate()

				return nil
			end
		else
			-- Piercing function returned TRUE to pierce this part.

			local params = cast.RayInfo.Parameters
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

				sendRayPierced(cast, resultOfCast, segmentVelocity, cast.RayInfo.CosmeticBulletObject)

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

				if
					not cast.RayInfo.CanPierceCallback(
						cast,
						resultOfCast,
						segmentVelocity,
						cast.RayInfo.CosmeticBulletObject
					)
				then
					brokeFromSolidObject = true

					break
				end
			end

			-- Restore the filter to its default state.
			cast.RayInfo.Parameters.FilterDescendantsInstances = originalFilter
			cast.StateInfo.IsActivelySimulatingPierce = false

			if brokeFromSolidObject then
				-- We actually hit something while testing.
				sendRayHit(cast, resultOfCast, segmentVelocity, cast.RayInfo.CosmeticBulletObject)
				cast:terminate()

				return
			end

			-- And exit the function here too.
		end
	end

	if cast.StateInfo.DistanceCovered >= cast.RayInfo.MaxDistance then
		-- SendRayHit(cast, nil, segmentVelocity, cast.RayInfo.CosmeticBulletObject)
		cast:terminate()
	end
end

function ActiveCast.new(
	caster: Types.Caster,
	origin: Vector3,
	direction: Vector3,
	velocity: Vector3 | number,
	castDataPacket: Types.CasterBehavior
): Types.ActiveCast
	if castDataPacket.HighFidelitySegmentSize <= 0 then
		error("can not set FastCastBehavior.HighFidelitySegmentSize <= 0!", 0)
	end

	-- Basic setup
	local cast = {
		Caster = caster,

		-- Data that keeps track of what's going on as well as edits we might make during runtime.
		StateInfo = {
			Paused = false,
			TotalRuntime = 0,
			DistanceCovered = 0,
			HighFidelitySegmentSize = castDataPacket.HighFidelitySegmentSize,
			HighFidelityBehavior = castDataPacket.HighFidelityBehavior,
			IsActivelySimulatingPierce = false,
			IsActivelyResimulating = false,
			CancelHighResCast = false,
			Trajectories = {
				{
					StartTime = 0,
					EndTime = -1,
					Origin = origin,
					InitialVelocity = if typeof(velocity) == "number" then direction.Unit * velocity else velocity,
					Acceleration = castDataPacket.Acceleration,
				},
			},
		},

		-- Information pertaining to actual raycasting.
		RayInfo = {
			Parameters = castDataPacket.RaycastParams,
			WorldRoot = workspace,
			MaxDistance = castDataPacket.MaxDistance or 1000,
			CosmeticBulletObject = castDataPacket.CosmeticBulletTemplate, -- This is intended. We clone it a smidge of the way down.
			CanPierceCallback = castDataPacket.CanPierceFunction,
		},

		UserData = {},
	}

	if cast.StateInfo.HighFidelityBehavior == 2 then
		cast.StateInfo.HighFidelityBehavior = 3
	end

	cast.RayInfo.Parameters =
		if cast.RayInfo.Parameters then cloneRaycastParams(cast.RayInfo.Parameters) else RaycastParams.new()

	local usingProvider = false
	if castDataPacket.CosmeticBulletProvider == nil then
		-- The provider is nil. Use a cosmetic object clone.
		if cast.RayInfo.CosmeticBulletObject ~= nil then
			cast.RayInfo.CosmeticBulletObject = cast.RayInfo.CosmeticBulletObject:Clone()
			cast.RayInfo.CosmeticBulletObject.CFrame = CFrame.new(origin, origin + direction)
			cast.RayInfo.CosmeticBulletObject.Parent = castDataPacket.CosmeticBulletContainer
		end
	else
		-- The provider is not nil. Is it what we want?
		if castDataPacket.CosmeticBulletProvider then
			if cast.RayInfo.CosmeticBulletObject ~= nil then
				-- They also set the template. Not good. Warn + clear this up.
				warn(
					"Do not define FastCastBehavior.CosmeticBulletTemplate and FastCastBehavior.CosmeticBulletProvider at the same time! The provider will be used, and CosmeticBulletTemplate will be set to nil."
				)
				cast.RayInfo.CosmeticBulletObject = nil
				castDataPacket.CosmeticBulletTemplate = nil
			end

			cast.RayInfo.CosmeticBulletObject = castDataPacket.CosmeticBulletProvider:GetPart()
			cast.RayInfo.CosmeticBulletObject.CFrame = CFrame.new(origin, origin + direction)
			usingProvider = true
		else
			warn(
				"FastCastBehavior.CosmeticBulletProvider was not an instance of the PartCache module (an external/separate model)! Are you inputting an instance created via PartCache.new? If so, are you on the latest version of PartCache? Setting FastCastBehavior.CosmeticBulletProvider to nil."
			)
			castDataPacket.CosmeticBulletProvider = nil
		end
	end

	local targetContainer: Instance = if usingProvider then
         castDataPacket.CosmeticBulletProvider.CurrentCacheParent
      else
         castDataPacket.CosmeticBulletContainer

	if castDataPacket.AutoIgnoreContainer and targetContainer then
		local ignoreList = cast.RayInfo.Parameters.FilterDescendantsInstances
		if not table.find(ignoreList, targetContainer) then
			table.insert(ignoreList, targetContainer)
			cast.RayInfo.Parameters.FilterDescendantsInstances = ignoreList
		end
	end

	local event = if RunService:IsClient() then RunService.RenderStepped else RunService.Heartbeat

	setmetatable(cast, ActiveCast)

	cast.StateInfo.UpdateConnection = event:Connect(function(delta: number)
		if cast.StateInfo.Paused then
			return nil
		end

		-- Casting for frame.
		local latestTrajectory = cast.StateInfo.Trajectories[#cast.StateInfo.Trajectories]
		if
			cast.StateInfo.HighFidelityBehavior == 3
			and latestTrajectory.Acceleration ~= Vector3.zero
			and cast.StateInfo.HighFidelitySegmentSize > 0
		then
			local timeAtStart = tick()

			if cast.StateInfo.IsActivelyResimulating then
				cast:terminate()

				error(
					"Cascading cast lag encountered! The caster attempted to perform a high fidelity cast before the previous one completed, resulting in exponential cast lag. Consider increasing HighFidelitySegmentSize."
				)
			end

			cast.StateInfo.IsActivelyResimulating = true

			-- Actually want to calculate this early to find displacement
			local origin = latestTrajectory.Origin
			local totalDelta = cast.StateInfo.TotalRuntime - latestTrajectory.StartTime
			local initialVelocity = latestTrajectory.InitialVelocity
			local acceleration = latestTrajectory.Acceleration

			local lastPoint = getPositionAtTime(totalDelta, origin, initialVelocity, acceleration)
			-- local lastVelocity = getVelocityAtTime(totalDelta, initialVelocity, acceleration)
			-- local lastDelta = cast.StateInfo.TotalRuntime - latestTrajectory.StartTime

			cast.StateInfo.TotalRuntime += delta

			-- Recalculate this.
			totalDelta = cast.StateInfo.TotalRuntime - latestTrajectory.StartTime

			local currentPoint = getPositionAtTime(totalDelta, origin, initialVelocity, acceleration)
			local currentVelocity = getVelocityAtTime(totalDelta, initialVelocity, acceleration)
			local totalDisplacement = currentPoint - lastPoint -- This is the displacement from where the ray was on the last from to where the ray is now.

			local rayDir = totalDisplacement.Unit * currentVelocity.Magnitude * delta
			local targetWorldRoot = cast.RayInfo.WorldRoot
			local resultOfCast = targetWorldRoot:Raycast(lastPoint, rayDir, cast.RayInfo.Parameters)

			local point = if resultOfCast == nil then currentPoint else resultOfCast.Position

			local rayDisplacement = (point - lastPoint).Magnitude

			-- Now undo this. The line below in the for loop will add this time back gradually.
			cast.StateInfo.TotalRuntime -= delta

			-- And now that we have displacement, we can calculate segment size.
			local numSegmentsDecimal = rayDisplacement / cast.StateInfo.HighFidelitySegmentSize -- say rayDisplacement is 5.1, segment size is 0.5 -- 10.2 segments

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

				if cast.StateInfo.CancelHighResCast then
					cast.StateInfo.CancelHighResCast = false
					break
				end

				simulateCast(cast, timeIncrement, true)
			end

			if getmetatable(cast) == nil then
				return nil
			end -- Could have been disposed.
			cast.StateInfo.IsActivelyResimulating = false

			if (tick() - timeAtStart) > 0.016 * 5 then
				warn("Extreme cast lag encountered! Consider increasing HighFidelitySegmentSize.")
			end
		else
			simulateCast(cast, delta, false)
		end
	end)

	return cast
end

function ActiveCast.setCasterReference(casterReference)
	Caster = casterReference
end

local function modifyTransformation(
	cast: Types.ActiveCast,
	velocity: Vector3?,
	acceleration: Vector3?,
	position: Vector3?
)
	local trajectories = cast.StateInfo.Trajectories
	local lastTrajectory = trajectories[#trajectories]

	-- NEW BEHAVIOR: Don't create a new trajectory if we haven't even used the current one.
	if lastTrajectory.StartTime == cast.StateInfo.TotalRuntime then
		-- This trajectory is fresh out of the box. Let's just change it since it hasn't actually affected the cast yet, so changes won't have adverse effects.
		if velocity == nil then
			velocity = lastTrajectory.InitialVelocity
		end
		if acceleration == nil then
			acceleration = lastTrajectory.Acceleration
		end
		if position == nil then
			position = lastTrajectory.Origin
		end

		lastTrajectory.Origin = position
		lastTrajectory.InitialVelocity = velocity
		lastTrajectory.Acceleration = acceleration
	else
		-- The latest trajectory is done. Set its end time and get its location.
		lastTrajectory.EndTime = cast.StateInfo.TotalRuntime

		local point, velAtPoint = unpack(getLatestTrajectoryEndInfo(cast))

		if velocity == nil then
			velocity = velAtPoint
		end

		if acceleration == nil then
			acceleration = lastTrajectory.Acceleration
		end

		if position == nil then
			position = point
		end

		table.insert(cast.StateInfo.Trajectories, {
			StartTime = cast.StateInfo.TotalRuntime,
			EndTime = -1,
			Origin = position,
			InitialVelocity = velocity,
			Acceleration = acceleration,
		})

		cast.StateInfo.CancelHighResCast = true
	end
end

function ActiveCast:setVelocity(velocity: Vector3)
	modifyTransformation(self, velocity, nil, nil)
end

function ActiveCast:setAcceleration(acceleration: Vector3)
	modifyTransformation(self, nil, acceleration, nil)
end

function ActiveCast:setPosition(position: Vector3)
	modifyTransformation(self, nil, nil, position)
end

function ActiveCast:getVelocity(): Vector3
	local currentTrajectory = self.StateInfo.Trajectories[#self.StateInfo.Trajectories]
	return getVelocityAtTime(
		self.StateInfo.TotalRuntime - currentTrajectory.StartTime,
		currentTrajectory.InitialVelocity,
		currentTrajectory.Acceleration
	)
end

function ActiveCast:getAcceleration(): Vector3
	return self.StateInfo.Trajectories[#self.StateInfo.Trajectories].Acceleration
end

function ActiveCast:getPosition(): Vector3
	local currentTrajectory = self.StateInfo.Trajectories[#self.StateInfo.Trajectories]

	return getPositionAtTime(
		self.StateInfo.TotalRuntime - currentTrajectory.StartTime,
		currentTrajectory.Origin,
		currentTrajectory.InitialVelocity,
		currentTrajectory.Acceleration
	)
end

function ActiveCast:addVelocity(velocity: Vector3)
	self:setVelocity(self:getVelocity() + velocity)
end

function ActiveCast:addAcceleration(acceleration: Vector3)
	self:setAcceleration(self:getAcceleration() + acceleration)
end

function ActiveCast:addPosition(position: Vector3)
	self:setPosition(self:getPosition() + position)
end

function ActiveCast:pause()
	self.StateInfo.Paused = true
end

function ActiveCast:resume()
	self.StateInfo.Paused = false
end

function ActiveCast:terminate()
	-- First: Set EndTime on the latest trajectory since it is now done simulating.
	local trajectories = self.StateInfo.Trajectories
	local lastTrajectory = trajectories[#trajectories]
	lastTrajectory.EndTime = self.StateInfo.TotalRuntime

	-- Disconnect the update connection.
	self.StateInfo.UpdateConnection:Disconnect()

	-- Now fire CastTerminating
	self.Caster.CastTerminating:fire(self)

	-- And now set the update connection object to nil.
	self.StateInfo.UpdateConnection = nil

	-- And nuke everything in the table + clear the metatable.
	self.Caster = nil
	self.StateInfo = nil
	self.RayInfo = nil
	self.UserData = nil

	setmetatable(self, nil)
end

return ActiveCast
