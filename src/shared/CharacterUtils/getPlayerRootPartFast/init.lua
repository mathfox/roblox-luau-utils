local getPlayerHumanoidFast = require(script.Parent.getPlayerHumanoidFast)

local function getPlayerRootPartFast(player: Player)
	local humanoid = getPlayerHumanoidFast(player)
	return if humanoid then humanoid.RootPart else nil
end

return getPlayerRootPartFast
