local getPlayerHumanoid = require(script.Parent.getPlayerHumanoid)

local function getAlivePlayerHumanoid(player: Player)
	local humanoid = getPlayerHumanoid(player)
	return if humanoid and humanoid.Health > 0 then humanoid :: Humanoid else nil
end

return getAlivePlayerHumanoid
