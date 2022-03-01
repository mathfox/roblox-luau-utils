local multiplyNumberSequenceFast = require(script.Parent.multiplyNumberSequenceFast)

local function multiplyNumberSequence(numberSequence: NumberSequence, value: number)
	if numberSequence == nil then
		error("missing argument #1 to 'multiplyNumberSequence' (NumberSequence expected)", 2)
	elseif typeof(numberSequence) ~= "NumberSequence" then
		error(
			("invalid argument #1 to 'multiplyNumberSequence' (NumberSequence expected, got %s)"):format(
				typeof(numberSequence)
			),
			2
		)
	elseif value == nil then
		error("missing argument #2 to 'multiplyNumberSequence' (number expected)", 2)
	elseif type(value) ~= "number" then
		error(("invalid argument #2 to 'multiplyNumberSequence' (number expected, got %s)"):format(typeof(value)), 2)
	end

	return multiplyNumberSequenceFast(numberSequence, value)
end

return multiplyNumberSequence
