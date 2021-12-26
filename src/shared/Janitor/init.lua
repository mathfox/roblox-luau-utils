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
Janitor.prototype = {}
Janitor.__index = Janitor.prototype

function Janitor.new()
	local self = setmetatable({}, Janitor)

	return self
end

function Janitor.is(object: any): boolean
	return type(object) == "table" and getmetatable(object) == Janitor
end

function Janitor.prototype:add(object: any, methodName: StringOrTrue?, index: any): any
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

function Janitor.prototype:addPromise(promise)
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

function Janitor.prototype:remove(index: any)
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

function Janitor.prototype:get(index: any): any
	local this = self[IndicesReference]
	if this then
		return this[index]
	end

	return nil
end

local function GetFenv(self)
	return function()
		for Object, MethodName in pairs(self) do
			if Object ~= IndicesReference then
				return Object, MethodName
			end
		end
	end
end

function Janitor.prototype:cleanup()
	local Get = GetFenv(self)
	local Object, MethodName = Get()

	while Object and MethodName do
		if MethodName == true then
			Object()
		else
			local ObjectMethod = Object[MethodName]
			if ObjectMethod then
				ObjectMethod(Object)
			end
		end

		self[Object] = nil
		Object, MethodName = Get()
	end

	local This = self[IndicesReference]
	if This then
		table.clear(This)
		self[IndicesReference] = {}
	end
end

function Janitor:destroy()
	self:cleanup()
	table.clear(self)
	setmetatable(self, nil)
end

Janitor.prototype.__call = Janitor.prototype.cleanup

function Janitor.prototype:linkToInstance(object: Instance, allowMultiple: boolean?)
	local IndexToUse = allowMultiple and newproxy(false) or LinkToInstanceIndex

	local isNilParented = object.Parent == nil
	local isConnected = true
	local linkConnection = {}

	local function onAncestryChanged(_, newParent: Instance?)
		if not isConnected then
			return
		end

		isNilParented = newParent == nil
		if isNilParented then
			task.defer(function()
				if not isConnected then
					return
				end

				isConnected = false
				self:cleanup()
			end)
		end
	end

	local ancestryConnection = object.AncestryChanged:Connect(onAncestryChanged)

	function linkConnection:disconnect()
		ancestryConnection:Disconnect()
	end

	if isNilParented then
		onAncestryChanged(nil, object.Parent)
	end

	return self:add(linkConnection, "disconnect", IndexToUse)
end

function Janitor.prototype:linkToInstances(...: Instance)
	local linkJanitor = Janitor.new()

	for _, object in ipairs({ ... }) do
		linkJanitor:add(self:linkToInstance(object, true), "disconnect")
	end

	return linkJanitor
end

return Janitor
