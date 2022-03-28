local PromiseTypes = require(script.Parent.Parent.Promise.Types)

type Promise<V...> = PromiseTypes.Promise<V...>

export type Janitor = {
	add: <V>(self: Janitor, object: V, methodNameOrTrue: string | true, index: any) -> V,
	addPromise: (self: Janitor, promise: Promise<...any>) -> (false, userdata),
	get: (self: Janitor, index: any) -> any,
	remove: (self: Janitor, index: any) -> Janitor,
	linkToInstance: (self: Janitor, object: Instance, allowMultiple: true | nil) -> (),
	linkToInstances: (self: Janitor, ...Instance) -> (),
	cleanup: (self: Janitor) -> (),
	destroy: (self: Janitor) -> (),
}

return nil
