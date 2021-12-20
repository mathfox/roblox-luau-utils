type Mate = Player | { Team: Team?, Neutral: boolean }

local function areTeamMates(...: Mate): boolean
	local mates = { ... }
	if #mates < 2 then
		error("at least two mates must be provided", 2)
	end

	local teams: { Team } = {}

	for _, mate in ipairs(mates) do
		if mate.Neutral then
			return false
		end

		table.insert(teams, mate.Team :: Team)
	end

	for teamId = 2, #teams do
		if teams[teamId] ~= teams[1] then
			return false
		end
	end

	return true
end

local function areOpponents(...: Mate)
	local mates = { ... }
	if #mates < 2 then
		error("at least two mates must be provided", 2)
	end

	local teams: { Team } = {}

	for _, mate in ipairs(mates) do
		if mate.Neutral then
			return false
		end

		table.insert(teams, mate.Team :: Team)
	end

	for id1 = 1, #teams do
		for id2 = 1, #teams do
			if id1 ~= id2 and teams[id1] == teams[id2] then
				return false
			end
		end
	end

	return true
end

local TeamUtils = {
	areTeamMates = areTeamMates,
	AreTeamMates = areTeamMates,
	areOpponents = areOpponents,
	AreOpponents = areOpponents,
}

return TeamUtils
