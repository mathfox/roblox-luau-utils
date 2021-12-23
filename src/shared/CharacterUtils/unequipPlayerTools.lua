local getPlayerHumanoid = require(script.Parent.getPlayerHumanoid)

local function unequipPlayerTools(player: Player)
	if player == nil then
		error("missing argument #1 to 'unequipPlayerTools' (Player expected)", 2)
	elseif typeof(player) ~= "Instance" or not player:IsA("Player") then
		error(("invalid argument #1 to 'unequipPlayerTools' (Player expected, got %s)"):format(typeof(player)), 2)
	end

	local humanoid = getPlayerHumanoid(player)
	if humanoid then
		humanoid:UnequipTools()
	end
end

return unequipPlayerTools
