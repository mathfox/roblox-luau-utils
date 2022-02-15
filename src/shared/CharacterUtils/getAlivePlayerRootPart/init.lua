local getAlivePlayerRootPartFast = require(script.Parent.getAlivePlayerRootPartFast)

local function getAlivePlayerRootPart(player: Player): BasePart?
	if player == nil then
		error("missing argument #1 to 'getAlivePlayerRootPart' (Player expected)", 2)
	elseif typeof(player) ~= "Instance" or not player:IsA("Player") then
		error(("invalid argument #1 to 'getAlivePlayerRootPart' (Player expected, got %s)"):format(typeof(player)), 2)
	end

	return getAlivePlayerRootPartFast(player)
end

return getAlivePlayerRootPart
