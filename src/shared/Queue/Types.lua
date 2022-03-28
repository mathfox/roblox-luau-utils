export type Queue<V...> = {
	enqueue: (self: Queue<V...>, V...) -> (),
	dequeue: (self: Queue<V...>, posOverride: number?) -> V...,
	getFront: (self: Queue<V...>) -> V...,
	getBack: (self: Queue<V...>) -> V...,
	getLength: (self: Queue<V...>) -> number,
}

return nil
