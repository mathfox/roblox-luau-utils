-- the table returned by the table.pack function: https://create.roblox.com/docs/reference/engine/libraries/table#pack
export type PackedValues<T = any> = { n: number, [number]: T }

export type Symbol = typeof(setmetatable({}, {} :: { __tostring: () -> string }))

-- reference: https://doc.rust-lang.org/std/result/enum.Result.html#
type ResultIndexTable<self, T, E> = {
	isOk: (self) -> boolean,
	isOkAnd: (self, f: (T) -> boolean) -> boolean,
	isErr: (self) -> boolean,
	isErrAnd: (self, f: (E) -> boolean) -> boolean,
	mapOr: <U>(self, default: U, f: (T) -> U) -> U,
	mapOrElse: <U>(self, default: (E) -> U, f: (T) -> U) -> U,
	inspect: (self, f: (T) -> ()) -> self,
	inspectErr: (self, f: (E) -> ()) -> self,
	expect: (self, msg: string) -> T,
	unwrap: (self) -> T,
	expectErr: (self, msg: string) -> E,
	unwrapErr: (self) -> E,
	unwrapOr: (self, default: T) -> T,
	unwrapOrElse: (self, op: (E) -> T) -> T,
	contains: <U>(self, x: U) -> boolean,
	containsErr: <F>(self, f: F) -> boolean,
	-- luau specific method in order to simulate match keyword from rust
	match: <U>(self, onOk: (T) -> U, onErr: (E) -> U) -> U,
}
export type Ok<T> = Result<T, nil>
export type Err<E> = Result<nil, E>
export type Result<T, E> = typeof(setmetatable({}, {} :: {
	__tostring: () -> string,
	__eq: (any) -> boolean,
	__index: ResultIndexTable<Result<T, E>, T, E>,
}))

-- reference: https://doc.rust-lang.org/std/option/enum.Option.html
type OptionIndex<self, Type, Args...> = {
	isSome: (self) -> boolean,
	isSomeWith: (self, f: (Args...) -> boolean) -> boolean,
	isNone: (self) -> boolean,
	expect: (self, msg: string) -> Type,
	unwrap: (self) -> Type,
	unwrapOr: (self, default: Type) -> Type,
	unwrapOrElse: (self, f: () -> Type) -> Type,
	inspect: (self, f: (Args...) -> ()) -> self,
	map: <U>(self, f: (Type) -> U) -> self,
	mapOr: <U>(self, default: U, f: (Args...) -> U) -> U,
	mapOrElse: <U>(self, default: () -> U, f: (Args...) -> U) -> U,
	okOr: <E>(self, err: E) -> Result<Type, E>,
	okOrElse: <E>(self, err: () -> E) -> Result<Type, E>,
	filter: (self, predicate: (Args...) -> boolean) -> self,
	contains: <U>(self, x: U) -> boolean,
	-- luau specific method in order to simulate match keyword from rust
	match: <U...>(self, onSome: (Args...) -> U..., onNone: () -> U...) -> U...,
}
export type Some<T> = typeof(setmetatable({}, {} :: {
	__tostring: () -> string,
	__eq: (any) -> boolean,
	__index: OptionIndex<Some<T>, T, (T)>,
}))
export type None = typeof(setmetatable({}, {} :: {
	__tostring: () -> "Option<_>",
	__index: OptionIndex<None, nil, ()>,
}))
export type Option<T> = typeof(setmetatable({}, {} :: {
	__tostring: () -> string,
	__index: OptionIndex<Option<T>, T, (T)>,
}))

export type Connection = typeof(setmetatable({} :: {
	connected: boolean,
}, {} :: {
	__tostring: () -> "Connection",
	__index: {
		disconnect: (Connection) -> (),
	},
}))
export type Signal<T... = ...any> = typeof(setmetatable(
	{},
	{} :: {
		__tostring: () -> "Signal",
		__index: {
			connect: (Signal<T...>, fn: Proc<T...>) -> Connection,
			once: (Signal<T...>, fn: Proc<T...>) -> Connection,
			fire: (Signal<T...>, T...) -> (),
			wait: (Signal<T...>) -> T...,
			destroy: (Signal<T...>) -> (),
		},
	}
))

export type InstanceCache<T> = {
	params: InstanceCacheParams<T>,
	parent: Instance?,

	getInstance: (self: InstanceCache<T>) -> T,
	returnInstance: (self: InstanceCache<T>, instance: T) -> (),
	setParent: (self: InstanceCache<T>, parent: Instance?) -> (),
	expand: (self: InstanceCache<T>, amount: number) -> (),
	destroy: (self: InstanceCache<T>) -> (),
}
export type InstanceCacheParams<T> = {
	instance: T,
	amount: { initial: number, expansion: number },
	parent: Instance?,
}

export type EnumeratorItem<T = string> = { name: string, value: T, type: Enumerator<T> }
export type Enumerator<T = string> = {
	fromRawValue: (rawValue: T) -> EnumeratorItem<T>?,
	isEnumeratorItem: (value: any) -> boolean,
	getEnumeratorItems: () -> { EnumeratorItem<T> },
}

export type CollectionComponentDescription = {
	tag: string,
	ancestors: { Instance }?,
	extensions: { CollectionComponentExtension },
}
export type CollectionComponent = {
	tag: string,
	Started: Signal,
	Stopped: Signal,

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

export type PromiseExecutor<T...> = (resolve: (T...) -> (), reject: (...any) -> (), onCancel: (cancellationHook: (() -> ())?) -> boolean) -> ()
-- reference: https://eryn.io/roblox-lua-promise/api/Promise
export type Promise<T...> = {
	andThen: <R...>(self: Promise<T...>, successHandler: (T...) -> R..., failureHandler: (...any) -> R...) -> Promise<R...>,
	andThenCall: <V..., R...>(self: Promise<T...>, callback: (V...) -> R..., V...) -> Promise<R...>,
	andThenReturn: <R...>(self: Promise<T...>, R...) -> Promise<R...>,
	await: (self: Promise<T...>) -> (boolean, T...),
	awaitStatus: (self: Promise<T...>) -> (EnumeratorItem<string>, T...),
	cancel: (self: Promise<T...>) -> (),
	catch: (self: Promise<T...>, failureHandler: <R...>(...any) -> R...) -> Promise<R...>,
	expect: (self: Promise<T...>) -> T...,
	finally: (self: Promise<T...>, finallyHandler: (status: EnumeratorItem<string>) -> ...any) -> Promise<T...>,
	finallyCall: <R...>(self: Promise<T...>, callback: (R...) -> ...any, R...) -> Promise<T...>,
	finallyReturn: <R...>(self: Promise<T...>, R...) -> Promise<T...>,
	getStatus: (self: Promise<T...>) -> EnumeratorItem<string>,
	-- originally was able to return a Promise.reject with only one value passed in: https://eryn.io/roblox-lua-promise/api/Promise#now
	now: <E...>(self: Promise<T...>, E...) -> Promise<T...> | Promise<E...>,
	tap: (self: Promise<T...>, tapHandler: (T...) -> ...any) -> Promise<T...>,
	-- originally was able to return a Promise.reject with only one value passed in: https://eryn.io/roblox-lua-promise/api/Promise#timeout
	timeout: <E...>(self: Promise<T...>, seconds: number, E...) -> Promise<T...> | Promise<E...>,
}

export type Janitor = {
	add: <T>(self: Janitor, object: T, methodName: string?, index: any) -> T,
	addPromise: (self: Janitor, promise: Promise<...any>) -> Symbol,
	get: (self: Janitor, index: any) -> any,
	remove: (self: Janitor, index: any) -> Janitor,
	linkToInstance: (self: Janitor, object: Instance, allowMultiple: true?) -> (),
	linkToInstances: (self: Janitor, ...Instance) -> (),
	cleanup: (self: Janitor) -> (),
	destroy: (self: Janitor) -> (),
}

export type Caster = {
	worldRoot: WorldRoot,
	LengthChanged: Signal,
	RayHit: Signal,
	RayPierced: Signal,
	RayOutranged: Signal,
	CastTerminating: Signal,
	fire: (Vector3, Vector3, Vector3 | number, CasterBehavior) -> (),
}
export type CasterBehavior = {
	raycastParams: RaycastParams?,
	maxDistance: number,
	acceleration: Vector3,
	highFidelityBehavior: number,
	highFidelitySegmentSize: number,
	cosmeticBulletTemplate: Instance?,
	cosmeticBulletProvider: any,
	cosmeticBulletContainer: Instance?,
	canPierceFunction: (Cast, RaycastResult, Vector3) -> boolean,
}
export type CastTrajectory = {
	startTime: number,
	endTime: number,
	origin: Vector3,
	initialVelocity: Vector3,
	acceleration: Vector3,
}
export type CastStateInfo = {
	updateConnection: RBXScriptConnection,
	highFidelityBehavior: number,
	highFidelitySegmentSize: number,
	paused: boolean,
	totalRuntime: number,
	distanceCovered: number,
	isActivelySimulatingPierce: boolean,
	isActivelyResimulating: boolean,
	cancelHighResCast: boolean,
	trajectories: { CastTrajectory },
	latestTrajectory: CastTrajectory,
}
export type CastRayInfo = {
	raycastParams: RaycastParams,
	worldRoot: WorldRoot,
	maxDistance: number,
	cosmeticBulletObject: Instance?,
}
export type Cast = {
	caster: Caster,
	stateInfo: CastStateInfo,
	rayInfo: CastRayInfo,
	behavior: CasterBehavior,
	userData: { [any]: any },
}

export type Debounce = {
	type: EnumeratorItem<string>,
	invoke: (self: Debounce, ...any) -> ...any,
	unbounce: (self: Debounce) -> (),
	destroy: (self: Debounce) -> (),
}

export type Queue<V...> = {
	enqueue: (self: Queue<V...>, V...) -> (),
	dequeue: (self: Queue<V...>, posOverride: number?) -> V...,
	getFront: (self: Queue<V...>) -> V...,
	getBack: (self: Queue<V...>) -> V...,
	getLength: (self: Queue<V...>) -> number,
}

export type Friend = {
	Id: number,
	Username: string,
	DisplayName: string,
	IsOnline: boolean,
}

-- rodux related types, reference: https://roblox.github.io/rodux/
-- some types references:
-- https://github.com/Roblox/rodux/commit/07f634e1dffd173f9e160fed40e1f03b9d17e619
-- https://github.com/Roblox/rodux/commit/ce63e3d57b55c6af9805a92cc04691e98c8027a8
export type IRoduxDispatch<Store> = <Action>(self: Store, action: Action & RoduxAction) -> ()
export type RoduxDispatch<State = any> = IRoduxDispatch<RoduxStore<State>>
type RoduxStoreSignal<State> = {
	connect: (self: RoduxStoreSignal<State>, callback: (State) -> ()) -> (),
}
export type IRoduxStore<State, Dispatch> = {
	dispatch: Dispatch,
	getState: (self: IRoduxStore<State, Dispatch>) -> State,
	destruct: (self: IRoduxStore<State, Dispatch>) -> (),
	flush: (self: IRoduxStore<State, Dispatch>) -> (),
	changed: RoduxStoreSignal<State>,
}
export type RoduxStore<State = any> = IRoduxStore<State, RoduxDispatch<State>>
export type RoduxAction<Type = any> = { type: Type, [any]: any }
export type RoduxAnyAction = RoduxAction
export type RoduxActionCreator<Type, Action, Args...> = typeof(setmetatable({} :: { name: Type }, {} :: { __call: <self>(self, Args...) -> Action & { type: Type } }))
export type RoduxReducer<State = any, Action = RoduxAnyAction> = (State?, Action) -> State

export type RoactFunctionComponent = ({ [any]: any }) -> RoactElement
export type RoactStatefulComponent = {}
export type RoactElement = {
	props: { [any]: any }?,
	component: string | RoactFunctionComponent | RoactStatefulComponent | RoactFragment | RoactPortal,
}
export type RoactFragment = {}
export type RoactPortal = Symbol
export type RoactContext = {
	Consumer: {},
	Provider: {},
}

return nil
