local RunService = game:GetService("RunService")

local Signal = require(script.Parent.Signal)
local Maid = require(script.Parent.Maid)

local CollectionComponentPrototype = require(script.CollectionComponentPrototype)

type ComponentDescription = {
	tag: string,
	ancestors: { Instance }?,
	extensions: CollectionComponentPrototype.ExtensionList?,
}

local DEFAULT_ANCESTORS = { workspace, game:GetService("Players") }

local CollectionComponent = {}

function CollectionComponent.new(config: ComponentDescription)
	local component = {}
	component.__index = component
	component.__tostring = function()
		return "Component<" .. config.tag .. ">"
	end

	component.Started = Signal.new()
	component.Stopped = Signal.new()
	component.tag = config.tag

	component._ancestors = config.ancestors or DEFAULT_ANCESTORS
	component._instancesToComponents = {}
	component._components = {}
	component._extensions = config.extensions or {}
	component._maid = Maid.new()

	setmetatable(component, CollectionComponentPrototype)

	component:_setup()

	return component
end

function CollectionComponent.fromInstance(instance: Instance, component)
	return component._instancesToComponents[instance]
end

return CollectionComponent
