local Types = require(script.Parent.Parent.Types)

local ElementKind = require(script.Parent.ElementKind)
local Type = require(script.Parent.Type)

type Element = Types.RoactElement

local function createFragment(elements: { [any]: Element })
	return {
		[Type] = Type.Element,
		[ElementKind] = ElementKind.Fragment,
		elements = elements,
	}
end

return createFragment
