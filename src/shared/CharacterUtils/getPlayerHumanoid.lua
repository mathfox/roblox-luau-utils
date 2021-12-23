local function getPlayerHumanoid(player: Player): Humanoid?
	if player == nil then
		error("missing argument #1 to 'getPlayerHumanoid' (Player expected)", 2)
	elseif typeof(player) ~= "Instance" or not player:IsA("Player") then
		error(("invalid argument #1 to 'getPlayerHumanoid' (Player expected, got %s)"):format(typeof(player)), 2)
	end

	local character = player.Character
	if character then
		return character:FindFirstChildOfClass("Humanoid")
	end

	return nil
end

return getPlayerHumanoid
