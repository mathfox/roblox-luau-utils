--[[
	Contains markers for annotating the type of an element.

	Use `ElementKind` as a key, and values from it as the value.

		local element = {
			[ElementKind] = ElementKind.Host,
		}
]]

local Symbol = require(script.Parent.Parent.Symbol)
local Portal = require(script.Parent.Portal)

local ElementKind = newproxy(true)

local ElementKindInternal = {
	Portal = Symbol("Portal"),
	Host = Symbol("Host"),
	Function = Symbol("Function"),
	Stateful = Symbol("Stateful"),
	Fragment = Symbol("Fragment"),
}

function ElementKindInternal.of(value)
	if typeof(value) ~= "table" then
		return nil
	end

	return value[ElementKind]
end

local componentTypesToKinds = {
	["string"] = ElementKindInternal.Host,
	["function"] = ElementKindInternal.Function,
	["table"] = ElementKindInternal.Stateful,
}

function ElementKindInternal.fromComponent(component)
	if component == Portal then
		return ElementKind.Portal
	else
		return componentTypesToKinds[typeof(component)]
	end
end

getmetatable(ElementKind).__index = ElementKindInternal

table.freeze(ElementKindInternal)

return ElementKind
