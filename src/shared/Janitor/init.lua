local Promise = require(script.Parent.Promise)
local Symbol = require(script.Symbol)

local IndicesReference = Symbol("IndicesReference")
local LinkToInstanceIndex = Symbol("LinkToInstanceIndex")

local WARNING_METHOD_NOT_FOUND = "Object %s doesn't have method %s, are you sure you want to add it? Traceback: %s"
local ERROR_NOT_PROMISE_PROVIDED = "Invalid argument #1 to 'Janitor:AddPromise' (Promise expected, got %s (%s))"

local MethodNameDefaults = {
	["function"] = true,
	RBXScriptConnection = "Disconnect",
}

local function isObjectCallable(object: any): boolean
	return type(object) == "function" or (type(object) == "table" and type(getmetatable(object).__call) == "function")
end

local JanitorPrototype = {}
JanitorPrototype.__index = JanitorPrototype

function JanitorPrototype:add(object: any, methodName: StringOrTrue?, index: any): any
	if index then
		self:remove(index)

		local this = self[IndicesReference]
		if not this then
			this = {}
			self[IndicesReference] = this
		end

		this[index] = object
	end

	methodName = methodName or MethodNameDefaults[typeof(object)] or "Destroy"

	if not isObjectCallable(object) and not object[methodName] then
		warn(WARNING_METHOD_NOT_FOUND:format(tostring(object), tostring(methodName), debug.traceback(nil, 2)))
	end

	self[object] = methodName

	return object
end

function JanitorPrototype:addPromise(promise)
	if not Promise.is(PromiseObject) then
		error(string.format(NOT_A_PROMISE, typeof(PromiseObject), tostring(PromiseObject)))
	end

	if PromiseObject:getStatus() == Promise.Status.Started then
		local Id = newproxy(false)
		local NewPromise = self:Add(
			Promise.new(function(Resolve, _, OnCancel)
				if OnCancel(function()
					PromiseObject:cancel()
				end) then
					return
				end

				Resolve(PromiseObject)
			end),
			"cancel",
			Id
		)

		NewPromise:finallyCall(self.Remove, self, Id)
		return NewPromise
	else
		return PromiseObject
	end
end

--[=[
	Cleans up whatever `Object` was set to this namespace by the 3rd parameter of [Janitor.Add](#Add).

	```lua
	local Obliterator = Janitor.new()
	Obliterator:Add(workspace.Baseplate, "Destroy", "Baseplate")
	Obliterator:Remove("Baseplate")
	```

	```ts
	import { Workspace } from "@rbxts/services";
	import { Janitor } from "@rbxts/janitor";

	const Obliterator = new Janitor<{ Baseplate: Part }>();
	Obliterator.Add(Workspace.FindFirstChild("Baseplate") as Part, "Destroy", "Baseplate");
	Obliterator.Remove("Baseplate");
	```

	@param Index any -- The index you want to remove.
	@return Janitor
]=]
function Janitor:Remove(Index: any)
	local This = self[IndicesReference]

	if This then
		local Object = This[Index]

		if Object then
			local MethodName = self[Object]

			if MethodName then
				if MethodName == true then
					Object()
				else
					local ObjectMethod = Object[MethodName]
					if ObjectMethod then
						ObjectMethod(Object)
					end
				end

				self[Object] = nil
			end

			This[Index] = nil
		end
	end

	return self
end

--[=[
	Gets whatever object is stored with the given index, if it exists. This was added since Maid allows getting the task using `__index`.

	```lua
	local Obliterator = Janitor.new()
	Obliterator:Add(workspace.Baseplate, "Destroy", "Baseplate")
	print(Obliterator:Get("Baseplate")) -- Returns Baseplate.
	```

	```ts
	import { Workspace } from "@rbxts/services";
	import { Janitor } from "@rbxts/janitor";

	const Obliterator = new Janitor<{ Baseplate: Part }>();
	Obliterator.Add(Workspace.FindFirstChild("Baseplate") as Part, "Destroy", "Baseplate");
	print(Obliterator.Get("Baseplate")); // Returns Baseplate.
	```

	@param Index any -- The index that the object is stored under.
	@return any? -- This will return the object if it is found, but it won't return anything if it doesn't exist.
]=]
function Janitor:Get(Index: any): any?
	local This = self[IndicesReference]
	if This then
		return This[Index]
	else
		return nil
	end
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

--[=[
	Calls each Object's `MethodName` (or calls the Object if `MethodName == true`) and removes them from the Janitor. Also clears the namespace.
	This function is also called when you call a Janitor Object (so it can be used as a destructor callback).

	```lua
	Obliterator:Cleanup() -- Valid.
	Obliterator() -- Also valid.
	```

	```ts
	Obliterator.Cleanup()
	```
]=]
function Janitor:Cleanup()
	if not self.CurrentlyCleaning then
		self.CurrentlyCleaning = nil

		local Get = GetFenv(self)
		local Object, MethodName = Get()

		while Object and MethodName do -- changed to a while loop so that if you add to the janitor inside of a callback it doesn't get untracked (instead it will loop continuously which is a lot better than a hard to pindown edgecase)
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

		self.CurrentlyCleaning = false
	end
end

--[=[
	Calls [Janitor.Cleanup](#Cleanup) and renders the Janitor unusable.

	:::warning
	Running this will make any attempts to call a function of Janitor error.
	:::
]=]
function Janitor:Destroy()
	self:Cleanup()
	table.clear(self)
	setmetatable(self, nil)
end

Janitor.__call = Janitor.Cleanup

local Janitor = {}
Janitor.CurrentlyCleaning = true
Janitor[IndicesReference] = nil

function Janitor.is(object: any): boolean
	return type(object) == "table" and getmetatable(object) == JanitorPrototype
end

type StringOrTrue = string | boolean

local ConnectionPrototype = {}
ConnectionPrototype.__index = ConnectionPrototype

local Connection = {}

local RbxScriptConnection = {}
RbxScriptConnection.Connected = true
RbxScriptConnection.__index = RbxScriptConnection

--[=[
	Disconnects the Signal.
]=]
function RbxScriptConnection:Disconnect()
	if self.Connected then
		self.Connected = false
		self.Connection:Disconnect()
	end
end

function RbxScriptConnection._new(RBXScriptConnection: RBXScriptConnection)
	return setmetatable({
		Connection = RBXScriptConnection,
	}, RbxScriptConnection)
end

function RbxScriptConnection:__tostring()
	return "RbxScriptConnection<" .. tostring(self.Connected) .. ">"
end

type RbxScriptConnection = typeof(RbxScriptConnection._new(
	game:GetPropertyChangedSignal("ClassName"):Connect(function() end)
))

function Janitor:LinkToInstance(Object: Instance, AllowMultiple: boolean?): RbxScriptConnection
	local Connection
	local IndexToUse = AllowMultiple and newproxy(false) or LinkToInstanceIndex
	local IsNilParented = Object.Parent == nil
	local ManualDisconnect = setmetatable({}, RbxScriptConnection)

	local function ChangedFunction(_DoNotUse, NewParent)
		if ManualDisconnect.Connected then
			_DoNotUse = nil
			IsNilParented = NewParent == nil

			if IsNilParented then
				task.defer(function()
					if not ManualDisconnect.Connected then
						return
					elseif not Connection.Connected then
						self:Cleanup()
					else
						while IsNilParented and Connection.Connected and ManualDisconnect.Connected do
							task.wait()
						end

						if ManualDisconnect.Connected and IsNilParented then
							self:Cleanup()
						end
					end
				end)
			end
		end
	end

	Connection = Object.AncestryChanged:Connect(ChangedFunction)
	ManualDisconnect.Connection = Connection

	if IsNilParented then
		ChangedFunction(nil, Object.Parent)
	end

	Object = nil :: any
	return self:Add(ManualDisconnect, "Disconnect", IndexToUse)
end

--[=[
	Links several instances to a new Janitor, which is then returned.

	@param ... Instance -- All the Instances you want linked.
	@return Janitor -- A new Janitor that can be used to manually disconnect all LinkToInstances.
]=]
function Janitor:LinkToInstances(...: Instance)
	local ManualCleanup = Janitor.new()
	for _, Object in ipairs({ ... }) do
		ManualCleanup:Add(self:LinkToInstance(Object, true), "Disconnect")
	end

	return ManualCleanup
end

function Janitor.new()
	return setmetatable({
		CurrentlyCleaning = false,
		[IndicesReference] = nil,
	}, Janitor)
end

return Janitor
