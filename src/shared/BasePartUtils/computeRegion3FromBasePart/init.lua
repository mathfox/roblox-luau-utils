local computeRegion3FromBasePartFast = require(script.Parent.computeRegion3FromBasePartFast)

local function computeRegion3FromBasePart(part: BasePart)
	if part == nil then
		error("missing argument #1 to 'computeRegion3FromBasePart' (BasePart expected)", 2)
	elseif typeof(part) ~= "Instance" then
		error(
			("invalid argument #1 to 'computeRegion3FromBasePart' (BasePart expected, got %s)"):format(typeof(part)),
			2
		)
	elseif not part:IsA("BasePart") then
		error(
			("invalid argument #1 to 'computeRegion3FromBasePart' (BasePart expected, got %s)"):format(part.ClassName),
			2
		)
	end

	return computeRegion3FromBasePartFast(part)
end

return computeRegion3FromBasePart
