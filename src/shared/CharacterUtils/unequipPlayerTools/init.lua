local getPlayerHumanoid = require(script.Parent.getPlayerHumanoid)

local function unequipPlayerTools(player: Player)
	local humanoid = getPlayerHumanoid(player)
	if humanoid then
		humanoid:UnequipTools()
	end
end

return unequipPlayerTools
