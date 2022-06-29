--[[
	Contains markers for annotating objects with types.

	To set the type of an object, use `Type` as a key and the actual marker as
	the value:

		local foo = {
			[Type] = Type.Foo,
		}
]]

local Symbol = require(script.Parent.Parent.Symbol)

local Type = {}

local TypeInternal = {}

local function addType(name)
	TypeInternal[name] = Symbol("Roact" .. name)
end

addType("Binding")
addType("Element")
addType("HostChangeEvent")
addType("HostEvent")
addType("StatefulComponentClass")
addType("StatefulComponentInstance")
addType("VirtualNode")
addType("VirtualTree")

function TypeInternal.of(value)
	return if typeof(value) ~= "table" then nil else value[Type]
end

setmetatable(
	Type,
	table.freeze({
		__index = TypeInternal,
		__tostring = function()
			return "RoactType"
		end,
	})
)

table.freeze(Type)

return Type
