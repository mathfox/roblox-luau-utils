local function areTeamMates(...: Player)
	local mates = { ... }

	if #mates < 2 then
		error("at least two mates must be provided", 2)
	end

	local teams: { Team } = {}

	for _, mate in mates do
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

return areTeamMates
