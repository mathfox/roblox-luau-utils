export type CharactersInRadiusList = { Model }

local Players = game:GetService("Players")

local function getCharactersInRadiusList(
	position: Vector3,
	radius: number,
	overlapParams: OverlapParams
): CharactersInRadiusList
	local charactersInRadiusList: CharactersInRadiusList = {}

	for _, basePart in ipairs(workspace:GetPartBoundsInRadius(position, radius, overlapParams)) do
		local player: Player? = Players:GetPlayerFromCharacter(basePart.Parent)
		if player and not table.find(charactersInRadiusList, basePart.Parent) then
			table.insert(charactersInRadiusList, basePart.Parent)
		end
	end

	return charactersInRadiusList
end

return getCharactersInRadiusList
