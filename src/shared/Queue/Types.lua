export type Queue = {
	enqueue: (self: Queue, ...any) -> (),
	dequeue: (self: Queue) -> ...any,
	getFront: (self: Queue) -> ...any,
	getBack: (self: Queue) -> ...any,
	getLength: (self: Queue) -> number,
}

return nil
