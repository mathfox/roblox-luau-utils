export type InstanceCache = {
	params: InstanceCacheParams,
	parent: Instance?,

	getInstance: (self: InstanceCache) -> Instance,
	returnInstance: (self: InstanceCache) -> (),
	setParent: (self: InstanceCache, parent: Instance?) -> (),
	expand: (self: InstanceCache, amount: number) -> (),
	destroy: (self: InstanceCache) -> (),
}

export type InstanceCacheParams = {
	template: Instance,
	amount: { initial: number, expansion: number },
	parent: Instance?,
}

return {}
