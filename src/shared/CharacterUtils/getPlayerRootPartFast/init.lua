local getPlayerHumanoidFast = require(script.Parent.getPlayerHumanoidFast)

local function getPlayerRootPartFast(player: Player): BasePart?
	local humanoid = getPlayerHumanoidFast(player)
	return if humanoid then humanoid.RootPart else nil
end

return getPlayerRootPartFast
