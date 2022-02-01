local getPlayerHumanoid = require(script.Parent.getPlayerHumanoid)

local function getAlivePlayerHumanoid(player: Player): Humanoid?
	if player == nil then
		error("missing argument #1 to 'getAlivePlayerHumanoid' (Player expected)", 2)
	elseif typeof(player) ~= "Instance" or not player:IsA("Player") then
		error(("invalid argument #1 to 'getAlivePlayerHumanoid' (Player expected, got %s)"):format(typeof(player)), 2)
	end

	local humanoid = getPlayerHumanoid(player)
	return if humanoid and humanoid.Health > 0 then humanoid else nil
end

return getAlivePlayerHumanoid
