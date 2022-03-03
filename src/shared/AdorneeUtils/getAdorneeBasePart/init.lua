local getAdorneeBasePartFast = require(script.Parent.getAdorneeBasePartFast)

local function getAdorneeBasePart(adornee: Instance)
	if adornee == nil then
		error("missing argument #1 to 'getAdorneeBasePart' (Instance expected)", 2)
	elseif typeof(adornee) ~= "Instance" then
		error(("invalid argument #1 to 'getAdorneeBasePart' (Instance expected, got %s)"):format(typeof(adornee)), 2)
	end

	return getAdorneeBasePartFast(adornee)
end

return getAdorneeBasePart
