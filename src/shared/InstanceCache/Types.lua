export type InstanceCache<I> = {
	params: InstanceCacheParams<I>,
	parent: Instance?,

	getInstance: (self: InstanceCache<I>) -> I,
	returnInstance: (self: InstanceCache<I>, instance: I) -> (),
	setParent: (self: InstanceCache<I>, parent: Instance?) -> (),
	expand: (self: InstanceCache<I>, amount: number) -> (),
	destroy: (self: InstanceCache<I>) -> (),
}

export type InstanceCacheParams<I> = {
	instance: I,
	amount: { initial: number, expansion: number },
	parent: Instance?,
}

return nil
