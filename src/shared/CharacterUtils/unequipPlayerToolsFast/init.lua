local getPlayerHumanoidFast = require(script.Parent.getPlayerHumanoidFast)

local function unequipPlayerToolsFast(player: Player)
	local humanoid = getPlayerHumanoidFast(player)
	if humanoid then
		humanoid:UnequipTools()
	end
end

return unequipPlayerToolsFast
