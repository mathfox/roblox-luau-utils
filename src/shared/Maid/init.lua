local HttpService = game:GetService("HttpService")

local PromiseTypes = require(script.Parent.Promise.Types)
local Promise = require(script.Parent.Promise)
local Types = require(script.Types)

type Maid = Types.Maid
type MaidTask = Types.MaidTask
type Promise<V...> = PromiseTypes.Promise<V...>

local Maid = {}
Maid.__index = Maid

function Maid.is(object)
	return type(object) == "table" and getmetatable(object) == Maid
end

function Maid.new()
	return setmetatable({
		_tasks = {},
	}, Maid) :: Maid
end

function Maid:__index(index)
	return if Maid[index] then Maid[index] else self._tasks[index]
end

function Maid:__newindex(index, newTask: MaidTask?)
	if Maid[index] ~= nil then
		error(("'%s' is reserved"):format(tostring(index)), 2)
	end

	local oldTask = self._tasks[index]
	if oldTask == newTask then
		return
	end

	self._tasks[index] = newTask

	if oldTask then
		if type(oldTask) == "function" then
			oldTask()
		elseif oldTask.Disconnect then
			oldTask:Disconnect()
		elseif oldTask.disconnect then
			oldTask:disconnect()
		elseif oldTask.Destroy then
			oldTask:Destroy()
		elseif oldTask.destroy then
			oldTask:destroy()
		end
	end
end

function Maid:giveTask(newTask: MaidTask)
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

function Maid:givePromise(promise: Promise<...any>): (false | string)
	if not Promise.is(promise) then
		error("no promise provided", 2)
	elseif promise:getStatus() ~= Promise.Status.Started then
		return false
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
		if typeof(oldTask) == "RBXScriptConnection" or type(oldTask) == "table" then
			if oldTask.Disconnect then
				tasks[index] = nil
				oldTask:Disconnect()
			elseif oldTask.disconnect then
				tasks[index] = nil
				oldTask:disconnect()
			end
		end
	end

	local index, oldTask = next(tasks)
	while oldTask ~= nil do
		tasks[index] = nil
		if type(oldTask) == "function" then
			oldTask()
		elseif oldTask.Destroy then
			oldTask:Destroy()
		elseif oldTask.destroy then
			oldTask:destroy()
		end
		index, oldTask = next(tasks)
	end
end

return Maid :: {
	is: (object: any) -> boolean,
	new: () -> Maid,
}
