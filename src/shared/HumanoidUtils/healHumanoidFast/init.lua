-- returns a number which indicates how much heal got lost due to the fact the health is maximum already
local function healHumanoidFast(humanoid: Humanoid, heal: number): number
	local potentialResultHealth = humanoid.Health + heal
	local actualResultHealth = math.min(humanoid.MaxHealth, potentialResultHealth)

	humanoid.Health = actualResultHealth

	return potentialResultHealth - actualResultHealth
end

return healHumanoidFast
