local getAlivePlayerHumanoidFast = require(script.Parent.getAlivePlayerHumanoidFast)

local function getAlivePlayerHumanoid(player: Player)
	if player == nil then
		error("missing argument #1 to 'getAlivePlayerHumanoid' (Player expected)", 2)
	elseif typeof(player) ~= "Instance" then
		error(("invalid argument #1 to 'getAlivePlayerHumanoid' (Player expected, got %s)"):format(typeof(player)), 2)
	elseif not player:IsA("Player") then
		error(("invalid argument #1 to 'getAlivePlayerHumanoid' (Player expected, got %s)"):format(player.ClassName), 2)
	end

	return getAlivePlayerHumanoidFast(player)
end

return getAlivePlayerHumanoid
