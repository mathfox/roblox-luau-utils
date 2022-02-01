local getAdorneeCenterPositionFast = require(script.Parent.getAdorneeCenterPositionFast)

local function getAdorneeCenterPosition(adornee: Instance): Vector3?
	if adornee == nil then
		error("missing argument #1 to 'getAdorneeCenterPosition' (Instance expected)", 2)
	elseif typeof(adornee) ~= "Instance" then
		error(
			("invalid argument #1 to 'getAdorneeCenterPosition' (Instance expected, got %s)"):format(typeof(adornee)),
			2
		)
	end

	return getAdorneeCenterPositionFast(adornee)
end

return getAdorneeCenterPosition
