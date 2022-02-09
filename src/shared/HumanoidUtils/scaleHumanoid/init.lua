local scaleHumanoidFast = require(script.Parent.scaleHumanoidFast)

local function scaleHumanoid(humanoid: Humanoid, scale: number)
	if humanoid == nil then
		error("missing argument #1 to 'scaleHumanoid' (Humanoid expected)", 2)
	elseif typeof(humanoid) ~= "Instance" or not humanoid:IsA("Humanoid") then
		error(("invalid argument #1 to 'scaleHumanoid' (Humanoid expected, got %s)"):format(typeof(humanoid)), 2)
	elseif scale == nil then
		error("missing argument #2 to 'scaleHumanoid' (number expected)", 2)
	elseif type(scale) ~= "number" then
		error(("invalid argument #2 to 'scaleHumanoid' (number expected, got %s)"):format(typeof(scale)), 2)
	end

	scaleHumanoidFast(humanoid, scale)
end

return scaleHumanoid
