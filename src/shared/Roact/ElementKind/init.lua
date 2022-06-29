--[[
	Contains markers for annotating the type of an element.

	Use `ElementKind` as a key, and values from it as the value.

		local element = {
			[ElementKind] = ElementKind.Host,
		}
]]

local Symbol = require(script.Parent.Parent.Symbol)

local Portal = require(script.Parent.Portal)

local ElementKind = {}

local ElementKindInternal = {
	Portal = Symbol("Portal"),
	Host = Symbol("Host"),
	Function = Symbol("Function"),
	Stateful = Symbol("Stateful"),
	Fragment = Symbol("Fragment"),
}

function ElementKindInternal.of(value)
	return if typeof(value) ~= "table" then nil else value[ElementKind]
end

local componentTypesToKinds = {
	["string"] = ElementKindInternal.Host,
	["function"] = ElementKindInternal.Function,
	["table"] = ElementKindInternal.Stateful,
}

function ElementKindInternal.fromComponent(component)
	return if component == Portal then ElementKind.Portal else componentTypesToKinds[typeof(component)]
end

local elementKindMetatable = { __index = ElementKindInternal }

table.freeze(elementKindMetatable)

setmetatable(ElementKind, elementKindMetatable)

table.freeze(ElementKind)

return ElementKind
