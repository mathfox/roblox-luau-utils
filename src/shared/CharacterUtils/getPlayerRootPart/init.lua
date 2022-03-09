local getPlayerHumanoid = require(script.Parent.getPlayerHumanoid)

local function getPlayerRootPart(player: Player)
	local humanoid = getPlayerHumanoid(player)
	return if humanoid then humanoid.RootPart else nil
end

return getPlayerRootPart
