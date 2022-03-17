export type Queue = {
	enqueue: (...any) -> (),
	dequeue: () -> ...any,
	getFront: () -> ...any,
	getBack: () -> ...any,
	getLength: () -> number,
}

return {}
