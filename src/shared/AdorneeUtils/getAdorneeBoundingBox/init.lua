local getAdorneeBoundingBoxFast = require(script.Parent.getAdorneeBoundingBoxFast)

local function getAdorneeBoundingBox(adornee: Instance): (CFrame?, Vector3?)
	if adornee == nil then
		error("missing argument #1 to 'getAdorneeBoundingBox' (Instance expected)", 2)
	elseif typeof(adornee) ~= "Instance" then
		error(("invalid argument #1 to 'getAdorneeBoundingBox' (Instance expected, got %s)"):format(typeof(adornee)), 2)
	end

	return getAdorneeBoundingBoxFast(adornee)
end

return getAdorneeBoundingBox
