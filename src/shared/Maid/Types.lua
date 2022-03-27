local PromiseTypes = require(script.Parent.Parent.Promise.Types)

type Promise<V...> = PromiseTypes.Promise<V...>

export type FunctionTask = (...any) -> ...any

export type TableTask = { destroy: FunctionTask, [any]: any }

export type MaidTask = RBXScriptConnection | FunctionTask | TableTask

export type Maid = {
	giveTask: (self: Maid, newTask: MaidTask) -> string,
	finalizeTask: (self: Maid, taskId: string) -> (),
	givePromise: (self: Maid, Promise<...any>) -> (false, string),
	destroy: (self: Maid) -> (),
}

return nil
