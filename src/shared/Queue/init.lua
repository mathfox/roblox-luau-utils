local Queue = {}
Queue.prototype = {}
Queue.__index = Queue.prototype

function Queue.is(object: any): boolean
	return type(object) == "table" and getmetatable(object) == Queue
end

local function new()
	return setmetatable({
		_queue = {},
	}, Queue)
end

export type Queue = typeof(new())

function Queue.new(): Queue
	return new()
end

function Queue.prototype:enqueue(...: any)
	table.insert(self._queue, 1, table.pack(...))
end

function Queue.prototype:dequeue(): ...any
	local tbl = table.remove(self._queue)
	return table.unpack(tbl, 1, tbl.n)
end

function Queue.prototype:getFront(): ...any
	local queue = self._queue
	return table.unpack(queue[#queue])
end

function Queue.prototype:getBack(): ...any
	return table.unpack(self._queue[1])
end

function Queue.prototype:getLength(): number
	return #self._queue
end

Queue.prototype.Enqueue = Queue.prototype.enqueue
Queue.prototype.Dequeue = Queue.prototype.dequeue
Queue.prototype.GetFront = Queue.prototype.getFront
Queue.prototype.GetBack = Queue.prototype.getBack
Queue.prototype.GetLength = Queue.prototype.getLength

return Queue
