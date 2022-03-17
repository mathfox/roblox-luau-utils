local function teleportHumanoidToPosition(humanoid: Humanoid, position: Vector3)
	local rootPart = humanoid.RootPart
	if rootPart then
		rootPart.Position = position + Vector3.new(0, rootPart.Size.Y / 2 + humanoid.HipHeight, 0)
	end
end

return teleportHumanoidToPosition
