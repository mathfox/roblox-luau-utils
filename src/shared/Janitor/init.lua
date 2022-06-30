local Promise = require(script.Parent.Promise)
local Symbol = require(script.Parent.Symbol)
local Types = require(script.Parent.Types)

local LinkToInstanceIndex = Symbol("LinkToInstanceIndex")
local IndicesReference = Symbol("IndicesReference")

local DEFAULT_METHOD_NAMES = {
	RBXScriptConnection = "Disconnect",
	Instance = "Destroy",
	["function"] = true,
}

type Promise<T...> = Types.Promise<T...>
export type Janitor = Types.Janitor
type Symbol = Types.Symbol

local Janitor = {}
Janitor.__index = Janitor

function Janitor:add<T>(object: T, methodName: string?, index): T
	if index then
		local this = self:remove(index)[IndicesReference]
		if not this then
			this = {}
			self[IndicesReference] = this
		end

		this[index] = object
	end

	self[object] = if methodName then methodName else DEFAULT_METHOD_NAMES[typeof(object)]

	return object
end

function Janitor:addPromise(promise: Promise<...any>): Symbol
	if promise:getStatus() ~= Promise.Status.Started then
		error("provided Promise must have Started status!", 2)
	end

	local proxy = newproxy(false)
	self:add(promise, "cancel", proxy)

	promise:finally(function()
		self:remove(proxy)
	end)

	return proxy
end

function Janitor:get(index)
	local this = self[IndicesReference]
	return if this then this[index] else nil
end

function Janitor:remove(index)
	local this = self[IndicesReference]

	if this then
		local object = this[index]

		if object then
			local methodName = self[object]

			if methodName then
				if methodName == true then
					object()
				else
					local objectMethod = object[methodName]
					if objectMethod then
						objectMethod(object)
					end
				end

				self[object] = nil
			end

			this[index] = nil
		end
	end

	return self
end

local function getNextTask(self)
	return function()
		for object, methodName in pairs(self) do
			if object ~= IndicesReference then
				return object, methodName
			end
		end
	end
end

function Janitor:cleanup()
	local getNext = getNextTask(self)
	local object, methodName = getNext()

	while object and methodName do
		if methodName == true then
			object()
		else
			local objectMethod = object[methodName]
			if objectMethod then
				objectMethod(object)
			end
		end

		self[object] = nil
		object, methodName = getNext()
	end

	local this = self[IndicesReference]
	if this then
		table.clear(this)
		self[IndicesReference] = {}
	end
end

Janitor.__call = Janitor.cleanup

function Janitor:destroy()
	self:cleanup()
	setmetatable(self, nil)
	table.clear(self)
end

function Janitor:linkToInstance(object: Instance, allowMultiple: true | nil)
	local isNilParented = object.Parent == nil
	local isConnected = true

	local function onAncestryChanged(_, newParent: Instance?)
		if isConnected then
			isNilParented = newParent == nil

			if isNilParented then
				task.defer(function()
					if isConnected then
						isConnected = false
						self:cleanup()
					end
				end)
			end
		end
	end

	local ancestryConnection = object.AncestryChanged:Connect(onAncestryChanged)

	if isNilParented then
		onAncestryChanged(nil, object.Parent)
	end

	return self:add(function()
		ancestryConnection:Disconnect()
	end, true, if allowMultiple then newproxy(false) else LinkToInstanceIndex)
end

function Janitor:linkToInstances(...: Instance)
	local linkJanitor = Janitor.new()

	for _, object in { ... } do
		linkJanitor:add(self:linkToInstance(object, true), true)
	end

	return linkJanitor
end

local JanitorExport = {
	is = function(object)
		return type(object) == "table" and getmetatable(object) == Janitor
	end,

	new = function(): Janitor
		return setmetatable({}, Janitor)
	end,
}

table.freeze(JanitorExport)

return JanitorExport :: {
	is: (object: any) -> boolean,
	new: () -> Janitor,
}
