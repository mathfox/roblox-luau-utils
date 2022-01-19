local getPlayersAndTheirCharactersInRadiusList = require(script.Parent.getPlayersAndTheirCharactersInRadiusList)

local function getClosestPlayerInRadius(position: Vector3, radius: number, overlapParams: OverlapParams): Player?
	local closestPlayer: Player? = nil
	local closestMagnitude: number? = nil

	for _, tbl in ipairs(getPlayersAndTheirCharactersInRadiusList(position, radius, overlapParams)) do
		local humanoid: Humanoid? = tbl[2]:FindFirstChildOfClass("Humanoid")
		if humanoid then
			local rootPart = humanoid.RootPart
			if rootPart then
				local magnitude = (rootPart.Position - position).Magnitude
				if not closestMagnitude or magnitude < closestMagnitude then
					closestMagnitude = magnitude
					closestPlayer = tbl[1]
				end
			end
		end
	end

	return closestPlayer
end

return getClosestPlayerInRadius
