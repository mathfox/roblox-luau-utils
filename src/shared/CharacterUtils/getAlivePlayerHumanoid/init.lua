--!strict

local getPlayerHumanoid = require(script.Parent.getPlayerHumanoid)

local function getAlivePlayerHumanoid(player: Player)
	local humanoid = getPlayerHumanoid(player)
	return if humanoid and humanoid.Health > 0 then humanoid else nil
end

return getAlivePlayerHumanoid
