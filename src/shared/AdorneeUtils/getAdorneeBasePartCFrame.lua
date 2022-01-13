local getAdorneeBasePart = require(script.Parent.getAdorneeBasePart)

local function getAdorneeBasePartCFrame(adornee: Instance): CFrame?
	if adornee == nil then
		error("missing argument #1 to 'getAdorneeBasePartCFrame' (Instance expected)", 2)
	elseif typeof(adornee) ~= "Instance" then
		error(
			("invalid argument #1 to 'getAdorneeBasePartCFrame' (Instance expected, got %s)"):format(typeof(adornee)),
			2
		)
	end

	local part: BasePart? = getAdorneeBasePart(adornee)

	return if part then part.CFrame else nil
end

return getAdorneeBasePartCFrame
