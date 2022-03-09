local teleportHumanoidToPositionFast = require(script.Parent.teleportHumanoidToPositionFast)

local function teleportHumanoidToPosition(humanoid: Humanoid, position: Vector3)
	if humanoid == nil then
		error("missing argument #1 to 'teleportHumanoidToPosition' (Humanoid expected)", 2)
	elseif typeof(humanoid) ~= "Instance" then
		error(
			("invalid argument #1 to 'teleportHumanoidToPosition' (Humanoid expected, got %s)"):format(typeof(humanoid)),
			2
		)
	elseif not humanoid:IsA("Humanoid") then
		error(
			("invalid argument #1 to 'teleportHumanoidToPosition' (Humanoid expected, got %s)"):format(
				humanoid.ClassName
			),
			2
		)
	elseif position == nil then
		error("missing argument #1 to 'teleportHumanoidToPosition' (Vector3 expected)", 2)
	elseif typeof(position) ~= "Vector3" then
		error(
			("invalid argument #1 to 'teleportHumanoidToPosition' (Vector3 expected, got %s)"):format(typeof(position)),
			2
		)
	end

	teleportHumanoidToPositionFast(humanoid, position)
end

return teleportHumanoidToPosition
