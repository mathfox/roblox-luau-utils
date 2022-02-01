local function getPlayerHumanoid(player: Player): Humanoid?
	if player == nil then
		error("missing argument #1 to 'getPlayerHumanoid' (Player expected)", 2)
	elseif typeof(player) ~= "Instance" or not player:IsA("Player") then
		error(("invalid argument #1 to 'getPlayerHumanoid' (Player expected, got %s)"):format(typeof(player)), 2)
	end

	local character = player.Character
	return if character then character:FindFirstChildOfClass("Humanoid") else nil
end

return getPlayerHumanoid
