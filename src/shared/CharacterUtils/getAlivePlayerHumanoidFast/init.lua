local getPlayerHumanoidFast = require(script.Parent.getPlayerHumanoidFast)

local function getAlivePlayerHumanoidFast(player: Player): Humanoid?
	local humanoid = getPlayerHumanoidFast(player)
	return if humanoid and humanoid.Health > 0 then humanoid else nil
end

return getAlivePlayerHumanoidFast
