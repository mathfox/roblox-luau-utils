local getRenderAdorneeFast = require(script.Parent.getRenderAdorneeFast)
local Types = require(script.Parent.Types)

local function getRenderAdornee(adornee: Instance): Types.RenderAdornee?
	if adornee == nil then
		error("missing argument #1 to 'getRenderAdornee' (Instance expected)", 2)
	elseif typeof(adornee) ~= "Instance" then
		error(("invalid argument #1 to 'getRenderAdornee' (Instance expected, got %s)"):format(typeof(adornee)), 2)
	end

	return getRenderAdorneeFast(adornee)
end

return getRenderAdornee
