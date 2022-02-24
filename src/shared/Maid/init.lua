local HttpService = game:GetService("HttpService")

local Promise = require(script.Parent.Promise)
local Types = require(script.Types)

local Maid = {}
Maid.__index = Maid
Maid.__metatable = "The metatable is locked"

function Maid.is(object: any): boolean
	return type(object) == "table" and getmetatable(object) == Maid
end

function Maid.new(): Maid
	return setmetatable({
		_tasks = {},
	}, Maid)
end

export type Maid = typeof(Maid.new())

local function finalizeTask(oldTask: Types.MaidTask)
	if type(oldTask) == "function" then
		oldTask()
	elseif typeof(oldTask) == "RBXScriptConnection" then
		oldTask:Disconnect()
	elseif type(oldTask) == "thread" then
		coroutine.close(oldTask)
	elseif oldTask.Destroy then
		oldTask:Destroy()
	elseif oldTask.Disconnect then
		oldTask:Disconnect()
	elseif oldTask.destroy then
		oldTask:destroy()
	elseif oldTask.disconnect then
		oldTask:disconnect()
	end
end

function Maid:__index(index: any): any
	return if Maid[index] then Maid[index] else self._tasks[index]
end

function Maid:__newindex(index: any, newTask: Types.MaidTask | nil)
	if Maid[index] ~= nil then
		error(("'%s' is reserved"):format(tostring(index)), 2)
	end

	local tasks = self._tasks
	local oldTask = tasks[index]

	if oldTask == newTask then
		return nil
	end

	tasks[index] = newTask

	if oldTask then
		finalizeTask(oldTask)
	end
end

function Maid:giveTask(newTask: Types.MaidTask): string
	if not newTask then
		error("task can not be false or nil", 2)
	end

	local taskId = HttpService:GenerateGUID(false)
	self[taskId] = newTask
	return taskId
end

function Maid:finalizeTask(taskId: string)
	if not self._tasks[taskId] then
		error("attempt to finalize ungiven task", 2)
	end

	self[taskId] = nil
end

function Maid:givePromise(promise): string
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

	return taskId
end

function Maid:destroy()
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

return Maid
