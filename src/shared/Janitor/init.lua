local PromiseTypes = require(script.Parent.Promise.Types)
local Promise = require(script.Parent.Promise)
local Symbol = require(script.Parent.Symbol)
local Types = require(script.Types)

local LinkToInstanceIndex = Symbol.named("LinkToInstanceIndex")
local IndicesReference = Symbol.named("IndicesReference")

local DEFAULT_METHOD_NAMES = {
	RBXScriptConnection = "Disconnect",
	["function"] = true,
}

type Promise<V...> = PromiseTypes.Promise<V...>
type Janitor = Types.Janitor

local Janitor = {}
Janitor.prototype = {} :: Janitor
Janitor.__index = Janitor.prototype

function Janitor.is(object)
	return type(object) == "table" and getmetatable(object) == Janitor
end

function Janitor.new(): Janitor
	return setmetatable({}, Janitor)
end

function Janitor.prototype:add<V>(object: V, methodNameOrTrue: string | true, index): V
	if index then
		local this = self:remove(index)[IndicesReference]
		if not this then
			this = {}
			self[IndicesReference] = this
		end

		this[index] = object
	end

	self[object] = if methodNameOrTrue then methodNameOrTrue else DEFAULT_METHOD_NAMES[typeof(object)] or "Destroy"

	return object
end

function Janitor.prototype:addPromise(promise: Promise<...any>): (false | userdata)
	if promise:getStatus() ~= Promise.Status.Started then
		return false
	end

	local proxy = newproxy(false)
	self:add(promise, "cancel", proxy)

	promise:finally(function()
		self:remove(proxy)
	end)

	return proxy
end

function Janitor.prototype:get(index)
	local this = self[IndicesReference]
	return if this then this[index] else nil
end

function Janitor.prototype:remove(index)
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

function Janitor.prototype:cleanup()
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

Janitor.__call = Janitor.prototype.cleanup

function Janitor.prototype:destroy()
	self:cleanup()
	table.clear(self)
	setmetatable(self, nil)
end

function Janitor.prototype:linkToInstance(object: Instance, allowMultiple: true | nil)
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

function Janitor.prototype:linkToInstances(...: Instance)
	local linkJanitor = Janitor.new()

	for _, object in ipairs({ ... }) do
		linkJanitor:add(self:linkToInstance(object, true), true)
	end

	return linkJanitor
end

return Janitor :: {
	is: (object: any) -> boolean,
	new: () -> Janitor,
}
