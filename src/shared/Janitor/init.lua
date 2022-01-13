type StringOrTrue = string | boolean

local Promise = require(script.Parent.Promise)
local Symbol = require(script.Parent.Symbol)

local IndicesReference = Symbol.named("IndicesReference")
local LinkToInstanceIndex = Symbol.named("LinkToInstanceIndex")

local WARNING_METHOD_NOT_FOUND = "Object %s doesn't have method %s, are you sure you want to add it? Traceback: %s"

local DefaultMethodNames = {
	["function"] = true,
	RBXScriptConnection = "Disconnect",
}

local function isObjectCallable(object: any): boolean
	return type(object) == "function" or (type(object) == "table" and type(getmetatable(object).__call) == "function")
end

local Janitor = {}
Janitor.__index = Janitor

function Janitor.new()
	return setmetatable({}, Janitor)
end

function Janitor.is(object: any): boolean
	return type(object) == "table" and getmetatable(object) == Janitor
end

function Janitor:add(object: any, methodName: StringOrTrue?, index: any): any
	if index then
		self:remove(index)

		local this = self[IndicesReference]
		if not this then
			this = {}
			self[IndicesReference] = this
		end

		this[index] = object
	end

	methodName = methodName or DefaultMethodNames[typeof(object)] or "Destroy"

	if not isObjectCallable(object) and not object[methodName] then
		warn(WARNING_METHOD_NOT_FOUND:format(tostring(object), tostring(methodName), debug.traceback(nil, 2)))
	end

	self[object] = methodName

	return object
end

function Janitor:addPromise(promise)
	if promise:getStatus() ~= Promise.Status.Started then
		return promise
	end

	local proxy = newproxy(false)
	self:add(promise, "cancel", proxy)

	promise:finally(function()
		self:remove(proxy)
	end)

	return promise
end

function Janitor:remove(index: any)
	local this = self[IndicesReference]

	if this then
		local object = this[index]

		if object then
			local methodName = self[object]

			if methodName then
				if methodName == true then
					object()
				else
					local ObjectMethod = object[methodName]
					if ObjectMethod then
						ObjectMethod(object)
					end
				end

				self[object] = nil
			end

			this[index] = nil
		end
	end

	return self
end

function Janitor:get(index: any): any
	local this = self[IndicesReference]
	return if this then this[index] else nil
end

local function getNextTask(self)
	return function()
		for Object, MethodName in pairs(self) do
			if Object ~= IndicesReference then
				return Object, MethodName
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
			local method = object[methodName]
			if method then
				method(object)
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

function Janitor:destroy()
	self:cleanup()
	table.clear(self)
	setmetatable(self, nil)
end

Janitor.__call = Janitor.cleanup

function Janitor:linkToInstance(object: Instance, allowMultiple: boolean?)
	local indexToUse = allowMultiple and newproxy(false) or LinkToInstanceIndex

	local isNilParented: boolean = object.Parent == nil
	local isConnected: boolean = true

	local function onAncestryChanged(_, newParent: Instance?)
		if not isConnected then
			return nil
		end

		isNilParented = newParent == nil
		if isNilParented then
			task.defer(function()
				if not isConnected then
					return nil
				end

				isConnected = false
				self:cleanup()
			end)
		end
	end

	local ancestryConnection: RBXScriptConnection = object.AncestryChanged:Connect(onAncestryChanged)

	local linkConnection = {}

	function linkConnection:disconnect()
		ancestryConnection:Disconnect()
	end

	if isNilParented then
		onAncestryChanged(nil, object.Parent)
	end

	return self:add(linkConnection, "disconnect", indexToUse)
end

function Janitor:linkToInstances(...: Instance)
	local linkJanitor = Janitor.new()

	for _, object in ipairs({ ... }) do
		linkJanitor:add(self:linkToInstance(object, true), "disconnect")
	end

	return linkJanitor
end

return Janitor
