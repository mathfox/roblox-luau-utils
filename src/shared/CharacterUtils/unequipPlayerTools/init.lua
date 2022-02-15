local unequipPlayerToolsFast = require(script.Parent.unequipPlayerToolsFast)

local function unequipPlayerTools(player: Player)
	if player == nil then
		error("missing argument #1 to 'unequipPlayerTools' (Player expected)", 2)
	elseif typeof(player) ~= "Instance" or not player:IsA("Player") then
		error(("invalid argument #1 to 'unequipPlayerTools' (Player expected, got %s)"):format(typeof(player)), 2)
	end

	unequipPlayerToolsFast(player)
end

return unequipPlayerTools
