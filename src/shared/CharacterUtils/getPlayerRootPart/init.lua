local getPlayerRootPartFast = require(script.Parent.getPlayerRootPartFast)

local function getPlayerRootPart(player: Player)
	if player == nil then
		error("missing argument #1 to 'getPlayerRootPart' (Player expected)", 2)
	elseif typeof(player) ~= "Instance" then
		error(("invalid argument #1 to 'getPlayerRootPart' (Player expected, got %s)"):format(typeof(player)), 2)
	elseif not player:IsA("Player") then
		error(("invalid argument #1 to 'getPlayerRootPart' (Player expected, got %s)"):format(player.ClassName), 2)
	end

	return getPlayerRootPartFast(player)
end

return getPlayerRootPart
