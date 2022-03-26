export type Signal = {
	connect: (self: Signal, fn: (...any) -> ...any) -> Connection,
	fire: (self: Signal, ...any) -> (),
	wait: (self: Signal) -> ...any,
	destroy: (self: Signal) -> (),
}

export type Connection = {
	connected: boolean,
	disconnect: (self: Connection) -> (),
}

return nil
