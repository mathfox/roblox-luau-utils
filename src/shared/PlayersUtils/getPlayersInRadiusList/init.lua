local Players = game:GetService("Players")

local function getPlayersInRadiusList(position: Vector3, radius: number, overlapParams: OverlapParams?)
	local list: { Player } = {}

	for _, basePart in workspace:GetPartBoundsInRadius(position, radius, overlapParams) do
		local player: Player? = Players:GetPlayerFromCharacter(basePart.Parent)
		if player and not table.find(list, player) then
			table.insert(list, player)
		end
	end

	return list
end

return getPlayersInRadiusList
