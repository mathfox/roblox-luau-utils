type FunctionTask = (...any) -> ...any
type TableTask = { Destroy: FunctionTask, [any]: any } | { destroy: FunctionTask, [any]: any }
type MaidTask = RBXScriptConnection | FunctionTask | TableTask

local HttpService = game:GetService("HttpService")

local Promise = require(script.Parent.Promise)

local Maid = {}
Maid.prototype = {}
Maid.__index = Maid.prototype

function Maid.is(object: any): boolean
	return type(object) == "table" and getmetatable(object) == Maid
end

function Maid.new(): Maid
	return setmetatable({
		_tasks = {},
	}, Maid)
end

export type Maid = typeof(Maid.new())

local function finalizeTask(oldTask: MaidTask)
	if type(oldTask) == "function" then
		oldTask()
	elseif typeof(oldTask) == "RBXScriptConnection" then
		oldTask:Disconnect()
	elseif oldTask.Destroy then
		oldTask:Destroy()
	elseif oldTask.destroy then
		oldTask:destroy()
	end
end

function Maid.prototype:__index(index: any): any
	if Maid.prototype[index] then
		return Maid.prototype[index]
	end

	return self._tasks[index]
end

function Maid.prototype:__newindex(index: any, newTask: MaidTask | nil)
	if Maid.prototype[index] ~= nil then
		error(("'%s' is reserved"):format(tostring(index)), 2)
	end

	local tasks = self._tasks
	local oldTask = tasks[index]

	if oldTask == newTask then
		return
	end

	tasks[index] = newTask

	if oldTask then
		finalizeTask(oldTask)
	end
end

function Maid.prototype:giveTask(newTask: MaidTask): string
	if not newTask then
		error("task can't be false or nil", 2)
	end

	local taskId = HttpService:GenerateGUID(false)
	self[taskId] = newTask
	return taskId
end

function Maid.prototype:finalizeTask(taskId: string)
	if not self._tasks[taskId] then
		error("attempt to finalize ungiven task", 2)
	end

	self[taskId] = nil
end

function Maid.prototype:givePromise(promise)
	if not Promise.is(promise) then
		error("no promise provided", 2)
	elseif promise:getStatus() ~= Promise.Status.Started then
		return promise
	end

	local taskId = self:giveTask(function()
		if promise:getStatus() == Promise.Status.Started then
			promise:cancel()
		end
	end)

	promise:finally(function()
		self[taskId] = nil
	end)

	return promise
end

function Maid.prototype:destroy()
	local tasks = self._tasks

	for index, oldTask in pairs(tasks) do
		if typeof(oldTask) == "RBXScriptConnection" then
			tasks[index] = nil
			oldTask:Disconnect()
		end
	end

	local index, oldTask = next(tasks)
	while oldTask ~= nil do
		tasks[index] = nil
		finalizeTask(oldTask)
		index, oldTask = next(tasks)
	end
end

Maid.prototype.GiveTask = Maid.prototype.giveTask
Maid.prototype.GivePromise = Maid.prototype.givePromise
Maid.prototype.FinalizeTask = Maid.prototype.finalizeTask
Maid.prototype.Destroy = Maid.prototype.destroy

return Maid
