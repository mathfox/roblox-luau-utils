local Promise = require(script.Parent.Promise)
local Symbol = require(script.Parent.Symbol)

local LinkToInstanceIndex = Symbol.named("LinkToInstanceIndex")
local IndicesReference = Symbol.named("IndicesReference")

local WARNING_METHOD_NOT_FOUND = "Object %s doesn't have method %s, are you sure you want to add it? Traceback: %s"

local DefaultMethodNamesOrMethods = {
	["function"] = true,
	RBXScriptConnection = "Disconnect",
	thread = coroutine.close,
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

function Janitor:add(object: any, methodNameOrMethod: string | boolean | (...any) -> ...any, index: any): any
	if index then
		self:remove(index)

		local this = self[IndicesReference]
		if not this then
			this = {}
			self[IndicesReference] = this
		end

		this[index] = object
	end

	local typeOfObject = typeof(object)
	methodNameOrMethod = methodNameOrMethod or DefaultMethodNamesOrMethods[typeOfObject] or "Destroy"

	if typeOfObject ~= "thread" and not isObjectCallable(object) and not object[methodNameOrMethod] then
		warn(WARNING_METHOD_NOT_FOUND:format(tostring(object), tostring(methodNameOrMethod), debug.traceback(nil, 2)))
	end

	self[object] = methodNameOrMethod

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
			local methodNameOrMethod = self[object]

			if methodNameOrMethod then
				if methodNameOrMethod == true then
					object()
				else
					local objectMethod = object[methodNameOrMethod]
					if objectMethod then
						objectMethod(object)
					else
						methodNameOrMethod(object)
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
		for object, methodNameOrMethod in pairs(self) do
			if object ~= IndicesReference then
				return object, methodNameOrMethod
			end
		end
	end
end

function Janitor:cleanup()
	local getNext = getNextTask(self)
	local object, methodNameOrMethod = getNext()

	while object and methodNameOrMethod do
		if methodNameOrMethod == true then
			object()
		else
			local objectMethod = object[methodNameOrMethod]
			if objectMethod then
				objectMethod(object)
			else
				methodNameOrMethod(object)
			end
		end

		self[object] = nil
		object, methodNameOrMethod = getNext()
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

	local linkConnection = {}

	function linkConnection:disconnect()
		ancestryConnection:Disconnect()
	end

	if isNilParented then
		onAncestryChanged(nil, object.Parent)
	end

	return self:add(linkConnection, "disconnect", if allowMultiple then newproxy(false) else LinkToInstanceIndex)
end

function Janitor:linkToInstances(...: Instance)
	local linkJanitor = Janitor.new()

	for _, object in ipairs({ ... }) do
		linkJanitor:add(self:linkToInstance(object, true), "disconnect")
	end

	return linkJanitor
end

return Janitor
