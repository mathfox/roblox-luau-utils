local function teleportHumanoidToPosition(humanoid: Humanoid, position)
	local rootPart = humanoid.RootPart
	if not rootPart then
		return
	end

	local rootOffset = rootPart.Size.Y / 2
	local hipHeight = humanoid.HipHeight
	local vectorOffset = Vector3.new(0, rootOffset + hipHeight, 0)
	rootPart.CFrame = rootPart.Position + position + vectorOffset
end

local function teleportHumanoidToCFrame()
	return
end

local HumanoidTeleportUtils = {
	teleportHumanoidToPosition = teleportHumanoidToPosition,
	teleportHumanoidToCFrame = teleportHumanoidToCFrame,
}

return HumanoidTeleportUtils
