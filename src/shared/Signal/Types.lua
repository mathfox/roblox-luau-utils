local FunctionUtilsTypes = require(script.Parent.Parent.FunctionUtils.Types)

export type Signal = {
	Connect: (self: Signal, fn: FunctionUtilsTypes.GenericFunction) -> Connection,
	Fire: (self: Signal, ...any) -> (),
	Wait: (self: Signal) -> ...any,
	Destroy: (self: Signal) -> (),

	connect: (self: Signal, fn: FunctionUtilsTypes.GenericFunction) -> Connection,
	fire: (self: Signal, ...any) -> (),
	wait: (self: Signal) -> ...any,
	destroy: (self: Signal) -> (),
}

export type Connection = {
	Connected: boolean,

	Disconnect: (self: Connection) -> (),
	disconnect: (self: Connection) -> (),
}

return {}
