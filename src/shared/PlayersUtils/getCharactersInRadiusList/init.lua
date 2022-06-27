local Players = game:GetService("Players")

local function getCharactersInRadiusList(position: Vector3, radius: number, overlapParams: OverlapParams?)
	local list: { Model } = {}

	for _, part in workspace:GetPartBoundsInRadius(position, radius, overlapParams) do
		if Players:GetPlayerFromCharacter(part.Parent) and not table.find(list, part.Parent) then
			table.insert(list, part.Parent)
		end
	end

	return list
end

return getCharactersInRadiusList
