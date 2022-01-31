local CollectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService")

local Maid = require(script.Parent.Parent.Maid)

type Extension = (...any) -> nil
export type ExtensionList = { {
	constructing: Extension?,
	constructed: Extension?,

	starting: Extension?,
	started: Extension?,

	stopping: Extension?,
	stopped: Extension?,
} }

local GET_NEXT_RENDER_NAME
do
	local currentRenderId = 0

	function GET_NEXT_RENDER_NAME()
		currentRenderId += 1
		return "ComponentRender" .. currentRenderId
	end
end

local function INVOKE_EXTENSIONS_FUNCTION(component, extensionList: ExtensionList, name: string)
	for _, extension in ipairs(extensionList) do
		local fn = extension[name]
		if type(fn) == "function" then
			fn(component)
		end
	end
end

local CollectionComponentPrototype = {}
CollectionComponentPrototype.__index = CollectionComponentPrototype

function CollectionComponentPrototype:_instantiate(instance: Instance)
	local component = setmetatable({
		instance = instance,
		_maid = Maid.new(),
	}, self)

	INVOKE_EXTENSIONS_FUNCTION(component, self._extensions, "constructing")

	if type(component.construct) == "function" then
		component:construct()
	end

	INVOKE_EXTENSIONS_FUNCTION(component, self._extensions, "Constructed")

	return component
end

function CollectionComponentPrototype:_setup()
	local watchingInstances = {}

	local function startComponent(component)
		if type(component.start) == "function" then
			INVOKE_EXTENSIONS_FUNCTION(component, self._extensions, "starting")
			component:start()
			INVOKE_EXTENSIONS_FUNCTION(component, self._extensions, "started")
		end

		if typeof(component.heartbeatUpdate) == "function" then
			component._maid:giveTask(RunService.Heartbeat:Connect(function(dt)
				component:heartbeatUpdate(dt)
			end))
		end

		if typeof(component.steppedUpdate) == "function" then
			component._maid:giveTask(RunService.Stepped:Connect(function(duration, dt)
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

				component._maid:giveTask(function()
					RunService:UnbindFromRenderStep(renderName)
				end)
			else
				component._maid:giveTask(RunService.RenderStepped:Connect(onRenderStepped))
			end
		end

		component._isStarted = true
		self.Started:Fire(component)
	end

	local function stopComponent(component)
		component._maid:destroy()

		if type(component.stop) == "function" then
			INVOKE_EXTENSIONS_FUNCTION(component, self._extensions, "stopping")
			component:stop()
			INVOKE_EXTENSIONS_FUNCTION(component, self._extensions, "stopped")
		end

		self.Stopped:Fire(component)
	end

	local function constructComponent(instance)
		if self._instancesToComponents[instance] then
			return
		end

		local component = self:_instantiate(instance)

		self._instancesToComponents[instance] = component

		table.insert(self._components, component)
		task.defer(function()
			if self._instancesToComponents[instance] == component then
				startComponent(component)
			end
		end)
	end

	local function deconstructComponent(instance)
		local component = self._instancesToComponents[instance]
		if not component then
			return
		end

		self._instancesToComponents[instance] = nil

		table.remove(self._components, table.find(self._components, component))

		if component._isStarted then
			task.spawn(stopComponent, component)
		else
			warn("no reason to decos")
		end
	end

	local function onInstanceTagged(instance: Instance)
		if watchingInstances[instance] then
			return
		end

		local function isInAncestorList(): boolean
			for _, parent in ipairs(self._ancestors) do
				if instance:IsDescendantOf(parent) then
					return true
				end
			end
			return false
		end

		watchingInstances[instance] = self._maid:giveTask(instance.AncestryChanged:Connect(function(_, parent)
			if parent and isInAncestorList() then
				constructComponent(instance)
			else
				deconstructComponent(instance)
			end
		end))

		if isInAncestorList() then
			constructComponent(instance)
		end
	end

	local function onInstanceUntagged(instance: Instance)
		local taksId = watchingInstances[instance]
		self._maid:finalizeTask(taksId)
		watchingInstances[instance] = nil

		deconstructComponent(instance)
	end

	self._maid:giveTask(CollectionService:GetInstanceAddedSignal(self.tag):Connect(onInstanceTagged))
	self._maid:giveTask(CollectionService:GetInstanceRemovedSignal(self.tag):Connect(onInstanceUntagged))

	for _, instance in ipairs(CollectionService:GetTagged(self.tag)) do
		task.defer(onInstanceTagged, instance)
	end
end

function CollectionComponentPrototype:getComponent(componentClass)
	return componentClass._instancesToComponents[self.instance]
end

return CollectionComponentPrototype
