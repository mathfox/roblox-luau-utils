local getAdorneeBasePartsFast = require(script.Parent.getAdorneeBasePartsFast)

local function getAdorneeBaseParts(adornee: Instance)
	if adornee == nil then
		error("missing argument #1 to 'getAdorneeBaseParts' (Instance expected)", 2)
	elseif typeof(adornee) ~= "Instance" then
		error(("invalid argument #1 to 'getAdorneeBaseParts' (Instance expected, got %s)"):format(typeof(adornee)), 2)
	end

	return getAdorneeBasePartsFast(adornee)
end

return getAdorneeBaseParts
