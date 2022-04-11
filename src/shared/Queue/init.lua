local Types = require(script.Parent.Types)

type Queue<V...> = Types.Queue<V...>

local Queue = {}
Queue.prototype = {} :: Queue<any> & {
	_queue: { { [number]: any, n: number } },
}
Queue.__index = Queue.prototype

function Queue.is(object)
	return type(object) == "table" and getmetatable(object) == Queue
end

function Queue.new(): Queue
	return setmetatable({
		_queue = {},
	}, Queue)
end

function Queue.prototype:enqueue(...)
	table.insert(self._queue, 1, table.pack(...))
end

function Queue.prototype:dequeue(posOverride: number?)
	local tbl = table.remove(self._queue, posOverride)
	return unpack(tbl, 1, tbl.n)
end

function Queue.prototype:getFront(): ...any
	return unpack(self._queue[#self._queue])
end

function Queue.prototype:getBack(): ...any
	return unpack(self._queue[1])
end

function Queue.prototype:getLength()
	return #self._queue
end

return Queue :: {
	is: (object: any) -> boolean,
	new: <V...>() -> Queue<V...>,
}
