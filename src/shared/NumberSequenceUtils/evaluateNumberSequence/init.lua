local evaluateNumberSequenceFast = require(script.Parent.evaluateNumberSequenceFast)

local function evaluateNumberSequence(numberSequence: NumberSequence, t: number)
	if numberSequence == nil then
		error("missing argument #1 to 'evaluateNumberSequence' (NumberSequence expected)", 2)
	elseif typeof(numberSequence) ~= "NumberSequence" then
		error(
			("invalid argument #1 to 'evaluateNumberSequence' (NumberSequence expected, got %s)"):format(
				typeof(numberSequence)
			),
			2
		)
	elseif t == nil then
		error("missing argument #2 to 'evaluateNumberSequence' (number expected)", 2)
	elseif type(t) ~= "number" then
		error(("invalid argument #2 to 'evaluateNumberSequence' (number expected, got %s)"):format(typeof(t)), 2)
	elseif t < 0 or t > 1 then
		error(
			("invalid argument #2 to 'evaluateNumberSequence' (number from 0 to 1 inclusive expected, got %f)"):format(
				t
			),
			2
		)
	end

	return evaluateNumberSequenceFast(numberSequence, t)
end

return evaluateNumberSequence
