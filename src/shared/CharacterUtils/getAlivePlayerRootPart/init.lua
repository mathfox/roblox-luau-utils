--!strict

local getPlayerHumanoid = require(script.Parent.getPlayerHumanoid)

local function getAlivePlayerRootPart(player: Player)
	local humanoid = getPlayerHumanoid(player)
	return if humanoid and humanoid.Health > 0 then humanoid.RootPart else nil
end

return getAlivePlayerRootPart
