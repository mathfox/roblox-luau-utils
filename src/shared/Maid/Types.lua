export type FunctionTask = (...any) -> ...any

export type TableTask = { Destroy: FunctionTask, [any]: any } | { destroy: FunctionTask, [any]: any }

export type MaidTask = RBXScriptConnection | FunctionTask | TableTask | thread

return {}
