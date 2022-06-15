-- reference: https://www.typescriptlang.org/docs/handbook/utility-types.html#recordkeys-type
export type Record<K, V = K> = { [K]: V }
export type Array<T> = { T }
export type EmptyTable = {}
-- a type all of the tables can be downcasted to
export type AnyTable = Record<any>

export type Proc<T... = ...any> = (T...) -> ()

-- the table returned by the table.pack function: https://create.roblox.com/docs/reference/engine/libraries/table#pack
export type PackedValues<T = any> = { n: number, [number]: T }

export type Symbol = typeof(setmetatable({}, {} :: { __tostring: () -> string }))

-- reference: https://doc.rust-lang.org/std/result/enum.Result.html#
export type Ok<T> = Result<T, nil>
export type Err<E> = Result<nil, E>
export type Result<T, E> = {
	isOk: (self: Result<T, E>) -> boolean,
	isOkAnd: (self: Result<T, E>, f: (T) -> boolean) -> boolean,
	isErr: (self: Result<T, E>) -> boolean,
	isErrAnd: (self: Result<T, E>, f: (E) -> boolean) -> boolean,
	ok: (self: Result<T, E>) -> None | Some<T>,
	err: (self: Result<T, E>) -> None | Some<E>,
	map: <U>(self: Result<T, E>, op: (T) -> U) -> Result<T, E> | Result<U, E>,
	mapOr: <U>(self: Result<T, E>, default: U, f: (T) -> U) -> U,
	mapOrElse: <U>(self: Result<T, E>, default: (E) -> U, f: (T) -> U) -> U,
	mapErr: <F>(self: Result<T, E>, op: (E) -> F) -> Result<T, E> | Result<T, F>,
	inspect: (self: Result<T, E>, f: (T) -> ()) -> Result<T, E>,
	inspectErr: (self: Result<T, E>, f: (E) -> ()) -> Result<T, E>,
	expect: (self: Result<T, E>, msg: string) -> T,
	unwrap: (self: Result<T, E>) -> T,
	expectErr: (self: Result<T, E>, msg: string) -> E,
	unwrapErr: (self: Result<T, E>) -> E,
	-- originally named "and": https://doc.rust-lang.org/std/result/enum.Result.html#method.and
	andRes: <U>(self: Result<T, E>, res: Result<U, E>) -> Result<T, E> | Result<U, E>,
	andThen: <U>(self: Result<T, E>, op: (T) -> Result<U, E>) -> Result<T, E> | Result<U, E>,
	-- originally named "or": https://doc.rust-lang.org/std/result/enum.Result.html#method.or
	orRes: <F>(self: Result<T, E>, res: Result<T, F>) -> Result<T, E> | Result<T, F>,
	orElse: <F>(self: Result<T, E>, op: (E) -> Result<T, F>) -> Result<T, E> | Result<T, F>,
	unwrapOr: (self: Result<T, E>, default: T) -> T,
	unwrapOrElse: (self: Result<T, E>, op: (E) -> T) -> T,
	contains: <U>(self: Result<T, E>, x: U) -> boolean,
	containsErr: <F>(self: Result<T, E>, f: F) -> boolean,
	-- luau specific method in order to simulate match keyword from rust
	match: <U>(self: Result<T, E>, onOk: (T) -> U, onErr: (E) -> U) -> U,
}

-- reference: https://doc.rust-lang.org/std/option/enum.Option.html
export type Some<T> = Option<T>
export type None = Option<nil>
export type Option<T> = {
	isSome: (self: Option<T>) -> boolean,
	isSomeWith: (self: Option<T>, f: (T) -> boolean) -> boolean,
	isNone: (self: Option<T>) -> boolean,
	expect: (self: Option<T>, msg: string) -> T,
	unwrap: (self: Option<T>) -> T,
	unwrapOr: (self: Option<T>, default: T) -> T,
	unwrapOrElse: (self: Option<T>, f: () -> T) -> T,
	map: <U>(self: Option<T>, f: (T) -> U) -> Option<U>,
	inspect: (self: Option<T>, f: (T) -> ()) -> Option<T>,
	mapOr: <U>(self: Option<T>, default: U, f: (T) -> U) -> U,
	mapOrElse: <U>(self: Option<T>, default: () -> U, f: (T) -> U) -> U,
	okOr: <E>(self: Option<T>, err: E) -> Result<T, E>,
	okOrElse: <E>(self: Option<T>, err: () -> E) -> Result<T, E>,
	-- originally named "and": https://doc.rust-lang.org/std/option/enum.Option.html#method.and
	andRes: <U>(self: Option<T>, optb: Option<U>) -> Option<U>,
	andThen: <U>(self: Option<T>, f: (T) -> Option<U>) -> Option<U>,
	filter: (self: Option<T>, predicate: (T) -> boolean) -> Option<T>,
	-- originally named "or": https://doc.rust-lang.org/std/option/enum.Option.html#method.or
	orRes: (self: Option<T>, optb: Option<T>) -> Option<T>,
	orElse: (self: Option<T>, f: () -> Option<T>) -> Option<T>,
	xor: (self: Option<T>, optb: Option<T>) -> Option<T>,
	take: (self: Option<T>) -> Option<T>,
	replace: (self: Option<T>, value: T) -> Option<T>,
	contains: <U>(self: Option<T>, x: U) -> boolean,
	-- luau specific method in order to simulate match keyword from rust
	match: <U>(self: Option<T>, onSome: (T) -> U, onNone: () -> U) -> U,
}

export type Connection = {
	connected: boolean,
	disconnect: (self: Connection) -> (),
}
export type Signal<T... = ...any> = {
	connect: (self: Signal<T...>, fn: Proc<T...>) -> Connection,
	fire: (self: Signal<T...>, T...) -> (),
	wait: (self: Signal<T...>) -> T...,
	destroy: (self: Signal<T...>) -> (),
}

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

export type SerializedColor3 = { number }
export type SerializedCFrame = { number }

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
	linkToInstance: (self: Janitor, object: Instance, allowMultiple: true | nil) -> (),
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
-- some types reference: https://github.com/Roblox/rodux/commit/07f634e1dffd173f9e160fed40e1f03b9d17e619
export type RoduxStore = {
	getState: (self: RoduxStore) -> {},
	dispatch: (self: RoduxStore, action: RoduxAction) -> (),
	flush: (self: RoduxStore) -> (),
	destruct: (self: RoduxStore) -> (),
}
export type RoduxAction<Type = any> = AnyTable & { type: Type }
export type RoduxActionCreator<Type, Action, Args...> = typeof(setmetatable({} :: { name: Type }, {} :: { __call: (any, Args...) -> Action & { type: Type } }))
export type RoduxReducer<State = any, Action = RoduxAction> = (State?, Action) -> State

return nil
