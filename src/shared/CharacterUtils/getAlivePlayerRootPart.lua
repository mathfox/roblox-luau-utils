local getPlayerHumanoid = require(script.Parent.getPlayerHumanoid)

local function getAlivePlayerRootPart(player: Player): BasePart?
	if player == nil then
		error("missing argument #1 to 'getAlivePlayerRootPart' (Player expected)", 2)
	elseif typeof(player) ~= "Instance" or not player:IsA("Player") then
		error(("invalid argument #1 to 'getAlivePlayerRootPart' (Player expected, got %s)"):format(typeof(player)), 2)
	end

	local humanoid = getPlayerHumanoid(player)
	return if humanoid and humanoid.Health > 0 then humanoid.RootPart else nil
end

return getAlivePlayerRootPart
