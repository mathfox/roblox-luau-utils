local CollectionService = game:GetService("CollectionService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

local Janitor = require(script.Parent.Janitor)
local Signal = require(script.Parent.Signal)

local Types = require(script.Parent.Types)

local DEFAULT_ANCESTORS = { workspace, game:GetService("Players") }

local function GET_NEXT_RENDER_NAME()
	return "ComponentRender" .. HttpService:GenerateGUID(false)
end

local function INVOKE_EXTENSIONS_FUNCTION(component, extensionList: { Types.CollectionComponentExtension }, name: string)
	for _, extension in extensionList do
		local fn = extension[name]
		if type(fn) == "function" then
			fn(component)
		end
	end
end

local CollectionComponent = {}
CollectionComponent.prototype = {}
CollectionComponent.__index = CollectionComponent.prototype

function CollectionComponent:__tostring()
	return "CollectionComponent<" .. self.tag .. ">"
end

function CollectionComponent.is(object)
	return type(object) == "table" and getmetatable(object) == CollectionComponent
end

function CollectionComponent.new(description: Types.CollectionComponentDescription): Types.CollectionComponent
	local self = setmetatable({
		Started = Signal.new(),
		Stopped = Signal.new(),
		tag = description.tag,

		_ancestors = description.ancestors or DEFAULT_ANCESTORS,
		_extensions = description.extensions or {},
		_instancesToComponents = {},
		_components = {},
		_janitor = Janitor.new(),
	}, CollectionComponent)
	self.__index = self

	local watchingInstances = {}

	local function constructComponent(instance: Instance)
		if self._instancesToComponents[instance] then
			return
		end

		local component = setmetatable({
			instance = instance,
			_janitor = Janitor.new(),
		}, self)

		INVOKE_EXTENSIONS_FUNCTION(component, self._extensions, "constructing")

		if type(component.construct) == "function" then
			component:construct()
		end

		INVOKE_EXTENSIONS_FUNCTION(component, self._extensions, "constructed")

		self._instancesToComponents[instance] = component

		table.insert(self._components, component)

		task.defer(function()
			if self._instancesToComponents[instance] == component then
				if type(component.start) == "function" then
					INVOKE_EXTENSIONS_FUNCTION(component, self._extensions, "starting")
					component:start()
					INVOKE_EXTENSIONS_FUNCTION(component, self._extensions, "started")
				end

				if typeof(component.heartbeatUpdate) == "function" then
					component._janitor:add(RunService.Heartbeat:Connect(function(dt)
						component:heartbeatUpdate(dt)
					end))
				end

				if typeof(component.steppedUpdate) == "function" then
					component._janitor:add(RunService.Stepped:Connect(function(duration, dt)
						component:steppedUpdate(dt, duration)
					end))
				end

				if typeof(component.renderSteppedUpdate) == "function" and not RunService:IsServer() then
					local function onRenderStepped(dt)
						component:renderSteppedUpdate(dt)
					end

					if component.renderPriority then
						local renderName = GET_NEXT_RENDER_NAME()

						RunService:BindToRenderStep(renderName, component.renderPriority, onRenderStepped)

						component._janitor:add(function()
							RunService:UnbindFromRenderStep(renderName)
						end)
					else
						component._janitor:add(RunService.RenderStepped:Connect(onRenderStepped))
					end
				end

				component._isStarted = true
				self.Started:fire(component)
			end
		end)
	end

	local function deconstructComponent(instance: Instance)
		local component = self._instancesToComponents[instance]
		if not component then
			return
		end
		self._instancesToComponents[instance] = nil

		table.remove(self._components, table.find(self._components, component))

		if component._isStarted then
			task.spawn(function()
				component._janitor:destroy()

				if type(component.stop) == "function" then
					INVOKE_EXTENSIONS_FUNCTION(component, self._extensions, "stopping")
					component:stop()
					INVOKE_EXTENSIONS_FUNCTION(component, self._extensions, "stopped")
				end

				self.Stopped:fire(component)
			end, component)
		end
	end

	local function onInstanceTagged(instance: Instance)
		if watchingInstances[instance] then
			return
		end

		watchingInstances[instance] = self._janitor:add(instance.AncestryChanged:Connect(function()
			(if self:_isInstanceInAncestorList(instance) then constructComponent else deconstructComponent)(instance)
		end))

		if self:_isInstanceInAncestorList(instance) then
			constructComponent(instance)
		end
	end

	self._janitor:add(CollectionService:GetInstanceAddedSignal(self.tag):Connect(onInstanceTagged))
	self._janitor:add(CollectionService:GetInstanceRemovedSignal(self.tag):Connect(function(instance: Instance)
		watchingInstances[instance]:Disconnect()
		watchingInstances[instance] = nil

		deconstructComponent(instance)
	end))

	for _, instance in CollectionService:GetTagged(self.tag) do
		task.defer(onInstanceTagged, instance)
	end

	return self
end

function CollectionComponent.prototype:_isInstanceInAncestorList(instance: Instance)
	for _, parent in self._ancestors do
		if instance:IsDescendantOf(parent) then
			return true
		end
	end

	return false
end

function CollectionComponent.prototype:fromInstance(instance: Instance): CollectionComponentInstance?
	return self._instancesToComponents[instance]
end

function CollectionComponent.prototype:destroy()
	self._janitor:destroy()
end

return CollectionComponent
