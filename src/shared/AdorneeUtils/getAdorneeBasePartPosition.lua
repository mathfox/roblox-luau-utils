local getAdorneeBasePart = require(script.Parent.getAdorneeBasePart)

local function getAdorneeBasePartPosition(adornee: Instance): Vector3?
	if adornee == nil then
		error("missing argument #1 to 'getAdorneeBasePartPosition' (Instance expected)", 2)
	elseif typeof(adornee) ~= "Instance" then
		error(
			("invalid argument #1 to 'getAdorneeBasePartPosition' (Instance expected, got %s)"):format(typeof(adornee)),
			2
		)
	end

	local part: BasePart? = getAdorneeBasePart(adornee)

	return if part then part.Position else nil
end

return getAdorneeBasePartPosition
