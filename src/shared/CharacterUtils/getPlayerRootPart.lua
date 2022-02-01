local getPlayerHumanoid = require(script.Parent.getPlayerHumanoid)

local function getPlayerRootPart(player: Player): BasePart?
	if player == nil then
		error("missing argument #1 to 'getPlayerRootPart' (Player expected)", 2)
	elseif typeof(player) ~= "Instance" or not player:IsA("Player") then
		error(("invalid argument #1 to 'getPlayerRootPart' (Player expected, got %s)"):format(typeof(player)), 2)
	end

	local humanoid = getPlayerHumanoid(player)
	return if humanoid then humanoid.RootPart else nil
end

return getPlayerRootPart
