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

type JanitorImpl = Types.JanitorImpl
type Promise<T...> = Types.Promise<T...>
export type Janitor = Types.Janitor
type Symbol = Types.Symbol

local Janitor = {} :: JanitorImpl
Janitor.__index = Janitor

function Janitor.__tostring()
	return "Janitor"
end

function Janitor:add<T>(object: T, methodNameOrTrue, index): T
	if index then
		local this = self:remove(index)[IndicesReference]
		if not this then
			this = {}
			self[IndicesReference] = this
		end

		this[index] = object
	end

	self[object] = if methodNameOrTrue then methodNameOrTrue else DEFAULT_METHOD_NAMES[typeof(object)]

	return object
end

function Janitor:addPromise(promise): Symbol
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
			local methodNameOrTrue: (string | true)? = self[object]
			if methodNameOrTrue then
				if methodNameOrTrue == true then
					object()
				else
					local objectMethod = (object :: string | { [any]: any } | Instance)[methodNameOrTrue :: string]
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

function Janitor:linkToInstance(object, allowMultiple)
	return self:add(
		object.Destroying:Connect(function()
			self:cleanup()
		end),
		"Disconnect",
		allowMultiple and newproxy(false) or LinkToInstanceIndex
	)
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
