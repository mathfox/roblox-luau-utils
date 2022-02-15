local function getPlayerHumanoidFast(player: Player): Humanoid?
	local character = player.Character
	return if character then character:FindFirstChildOfClass("Humanoid") else nil
end

return getPlayerHumanoidFast
