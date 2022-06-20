local function getAlivePlayerHumanoid(player: Player)
	local character = player.Character
	if not character then
		return nil
	end

	local humanoid = character:FindFirstChildOfClass("Humanoid")
	return if humanoid and humanoid.Health > 0 then humanoid else nil
end

return getAlivePlayerHumanoid
