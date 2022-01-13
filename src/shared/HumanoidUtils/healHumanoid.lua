local function healHumanoid(humanoid: Humanoid, healNumber: number)
	if typeof(humanoid) ~= "Instance" or not humanoid:IsA("Humanoid") then
		error("#1 argument must be a Humanoid!", 2)
	elseif type(healNumber) ~= "number" then
		error("#2 argument must be a number!", 2)
	end

	humanoid.Health = math.min(humanoid.MaxHealth, humanoid.Health + healNumber)
end

return healHumanoid
