local teleportHumanoidToCFrameFast = require(script.Parent.teleportHumanoidToCFrameFast)

local function teleportHumanoidToCFrame(humanoid: Humanoid, cframe: CFrame)
	if humanoid == nil then
		error("missing argument #1 to 'teleportHumanoidToCFrame' (Humanoid expected)", 2)
	elseif typeof(humanoid) ~= "Instance" then
		error(
			("invalid argument #1 to 'teleportHumanoidToCFrame' (Humanoid expected, got %s)"):format(typeof(humanoid)),
			2
		)
	elseif not humanoid:IsA("Humanoid") then
		error(
			("invalid argument #1 to 'teleportHumanoidToCFrame' (Humanoid expected, got %s)"):format(humanoid.ClassName),
			2
		)
	elseif cframe == nil then
		error("missing argument #1 to 'teleportHumanoidToCFrame' (CFrame expected)", 2)
	elseif typeof(cframe) ~= "CFrame" then
		error(("invalid argument #1 to 'teleportHumanoidToCFrame' (CFrame expected, got %s)"):format(typeof(cframe)), 2)
	end

	teleportHumanoidToCFrameFast(humanoid, cframe)
end

return teleportHumanoidToCFrame
