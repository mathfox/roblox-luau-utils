local Players = game:GetService("Players")

local function getPlayersAndTheirCharactersInRadiusList(position: Vector3, radius: number, overlapParams: OverlapParams)
	local playersAndTheirCharactersInRadiusList = {}

	local function inPlayerAlreadyInRadiusList(player: Player): boolean
		for _, tbl in ipairs(playersAndTheirCharactersInRadiusList) do
			if tbl[1] == player then
				return true
			end
		end

		return false
	end

	for _, basePart in ipairs(workspace:GetPartBoundsInRadius(position, radius, overlapParams)) do
		local player: Player? = Players:GetPlayerFromCharacter(basePart.Parent)
		if player and not inPlayerAlreadyInRadiusList(player) then
			table.insert(playersAndTheirCharactersInRadiusList, { player, basePart.Parent })
		end
	end

	return playersAndTheirCharactersInRadiusList
end

return getPlayersAndTheirCharactersInRadiusList
