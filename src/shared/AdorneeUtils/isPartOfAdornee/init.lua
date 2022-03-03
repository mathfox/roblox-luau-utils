local isPartOfAdorneeFast = require(script.Parent.isPartOfAdorneeFast)

local function isPartOfAdornee(adornee: Instance, part: BasePart)
	if adornee == nil then
		error("missing argument #1 to 'isPartOfAdornee' (Instance expected)", 2)
	elseif typeof(adornee) ~= "Instance" then
		error(("invalid argument #1 to 'isPartOfAdornee' (Instance expected, got %s)"):format(typeof(adornee)), 2)
	elseif part == nil then
		error("missing argument #2 to 'isPartOfAdornee' (BasePart expected)", 2)
	elseif typeof(part) ~= "Instance" then
		error(("invalid argument #2 to 'isPartOfAdornee' (BasePart expected, got %s)"):format(typeof(part)), 2)
	elseif not part:IsA("BasePart") then
		error(("invalid argument #2 to 'isPartOfAdornee' (BasePart expected, got %s)"):format(part.ClassName), 2)
	end

	return isPartOfAdorneeFast(adornee, part)
end

return isPartOfAdornee
