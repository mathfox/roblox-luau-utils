local getAlivePlayerRootPartFast = require(script.Parent.getAlivePlayerRootPartFast)

local function getAlivePlayerRootPart(player: Player)
	if player == nil then
		error("missing argument #1 to 'getAlivePlayerRootPart' (Player expected)", 2)
	elseif typeof(player) ~= "Instance" then
		error(("invalid argument #1 to 'getAlivePlayerRootPart' (Player expected, got %s)"):format(typeof(player)), 2)
	elseif not player:IsA("Player") then
		error(("invalid argument #1 to 'getAlivePlayerRootPart' (Player expected, got %s)"):format(player.ClassName), 2)
	end

	return getAlivePlayerRootPartFast(player)
end

return getAlivePlayerRootPart
