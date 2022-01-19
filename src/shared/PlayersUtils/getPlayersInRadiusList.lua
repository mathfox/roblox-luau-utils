export type PlayersInRadiusList = { Player }

local Players = game:GetService("Players")

local function getPlayersInRadiusList(
	position: Vector3,
	radius: number,
	overlapParams: OverlapParams?
): PlayersInRadiusList
	local playersInRadiusList: PlayersInRadiusList = {}

	for _, basePart in ipairs(workspace:GetPartBoundsInRadius(position, radius, overlapParams)) do
		local player: Player? = Players:GetPlayerFromCharacter(basePart.Parent)
		if player and not table.find(playersInRadiusList, player) then
			table.insert(playersInRadiusList, player)
		end
	end

	return playersInRadiusList
end

return getPlayersInRadiusList
