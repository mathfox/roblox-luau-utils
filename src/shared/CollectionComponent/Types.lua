local Types = require(script.Parent.Parent.Signal.Types)

export type CollectionComponentDescription = {
	tag: string,
	ancestors: { Instance }?,
	extensions: { CollectionComponentExtension },
}

export type CollectionComponent = {
	tag: string,
	Started: Types.Signal,
	Stopped: Types.Signal,

	fromInstance: (self: CollectionComponent, instance: Instance) -> CollectionComponentInstance?,
	destroy: (self: CollectionComponent) -> (),
}

export type CollectionComponentInstance = {
	instance: Instance,
}

export type CollectionComponentExtension = {
	shouldExtend: (Instance) -> boolean,
	shouldConstruct: (Instance) -> boolean,
	constructing: (CollectionComponentInstance) -> (),
	constructed: (CollectionComponentInstance) -> (),
	starting: (CollectionComponentInstance) -> (),
	started: (CollectionComponentInstance) -> (),
	stopping: (CollectionComponentInstance) -> (),
	stopped: (CollectionComponentInstance) -> (),
}

return nil
