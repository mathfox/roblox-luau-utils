local healHumanoidFast = require(script.Parent.healHumanoidFast)

-- returns a number which indicates how much heal got lost due to the fact the health is maximum already
local function healHumanoid(humanoid: Humanoid, heal: number): number
	if humanoid == nil then
		error("missing argument #1 to 'healHumanoid' (Humanoid expected)", 2)
	elseif typeof(humanoid) ~= "Instance" or not humanoid:IsA("Humanoid") then
		error(("invalid argument #1 to 'healHumanoid' (Humanoid expected, got %s)"):format(typeof(humanoid)), 2)
	elseif heal == nil then
		error("missing argument #2 to 'healHumanoid' (number expected)", 2)
	elseif type(heal) ~= "number" then
		error(("invalid argument #2 to 'healHumanoid' (number expected, got %s)"):format(typeof(heal)), 2)
	end

	return healHumanoidFast(humanoid, heal)
end

return healHumanoid
