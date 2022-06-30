--[[
	Packages up the internals of Roact and exposes a public API for it.
]]

local createReconciler = require(script.createReconciler)
local RobloxRenderer = require(script.RobloxRenderer)
local GlobalConfig = require(script.GlobalConfig)
local Binding = require(script.Binding)

local robloxReconciler = createReconciler(RobloxRenderer)

local Roact = {
	Component = require(script.Component),
	createElement = require(script.createElement),
	createFragment = require(script.createFragment),
	oneChild = require(script.oneChild),
	PureComponent = require(script.PureComponent),
	Portal = require(script.Portal),
	createRef = require(script.createRef),
	forwardRef = require(script.forwardRef),
	createBinding = Binding.create,
	joinBindings = Binding.join,
	createContext = require(script.createContext),

	Change = require(script.PropMarkers.Change),
	Children = require(script.PropMarkers.Children),
	Event = require(script.PropMarkers.Event),
	Ref = require(script.PropMarkers.Ref),

	mount = robloxReconciler.mountVirtualTree,
	unmount = robloxReconciler.unmountVirtualTree,
	update = robloxReconciler.updateVirtualTree,

	setGlobalConfig = GlobalConfig.set,
}

table.freeze(Roact)

return Roact
