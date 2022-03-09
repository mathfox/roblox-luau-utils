local Players = game:GetService("Players")

local function getPlayersAndTheirCharactersInRadiusList(
	position: Vector3,
	radius: number,
	overlapParams: OverlapParams?
)
	local list = {}

	local function inPlayerAlreadyInList(player: Player)
		for _, tbl in ipairs(list) do
			if tbl[1] == player then
				return true
			end
		end

		return false
	end

	for _, part in ipairs(workspace:GetPartBoundsInRadius(position, radius, overlapParams)) do
		local player: Player? = Players:GetPlayerFromCharacter(part.Parent)
		if player and not inPlayerAlreadyInList(player) then
			table.insert(list, { player, part.Parent })
		end
	end

	return list
end

return getPlayersAndTheirCharactersInRadiusList
