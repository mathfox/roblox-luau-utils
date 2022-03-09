local getPlayerHumanoidFast = require(script.Parent.getPlayerHumanoidFast)

local function getAlivePlayerHumanoidFast(player: Player)
	local humanoid = getPlayerHumanoidFast(player)
	return if humanoid and humanoid.Health > 0 then humanoid :: Humanoid else nil
end

return getAlivePlayerHumanoidFast
