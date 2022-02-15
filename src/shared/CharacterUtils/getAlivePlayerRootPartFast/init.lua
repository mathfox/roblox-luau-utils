local getPlayerHumanoidFast = require(script.Parent.getPlayerHumanoidFast)

local function getAlivePlayerRootPartFast(player: Player): BasePart?
	local humanoid = getPlayerHumanoidFast(player)
	return if humanoid and humanoid.Health > 0 then humanoid.RootPart else nil
end

return getAlivePlayerRootPartFast
