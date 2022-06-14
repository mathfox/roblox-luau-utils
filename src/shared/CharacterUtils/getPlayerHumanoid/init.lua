--!strict

local function getPlayerHumanoid(player: Player)
	local character = player.Character
	return if character then character:FindFirstChildOfClass("Humanoid") else nil
end

return getPlayerHumanoid
