export type InstanceCache = {
	params: InstanceCacheParams,
	parent: Instance?,

	GetInstance: (self: InstanceCache) -> Instance,
	ReturnInstance: (self: InstanceCache, instance: Instance) -> (),
	SetParent: (self: InstanceCache, parent: Instance?) -> (),
	Expand: (self: InstanceCache, amount: number) -> (),
	Destroy: (self: InstanceCache) -> (),

	getInstance: (self: InstanceCache) -> Instance,
	returnInstance: (self: InstanceCache, instance: Instance) -> (),
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
