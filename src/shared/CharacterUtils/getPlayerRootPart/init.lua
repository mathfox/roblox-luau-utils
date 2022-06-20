local function getPlayerRootPart(player: Player)
	local character = player.Character
	if not character then
		return nil
	end

	local humanoid = character:FindFirstChildOfClass("Humanoid")
	return if humanoid then humanoid.RootPart else nil
end

return getPlayerRootPart
