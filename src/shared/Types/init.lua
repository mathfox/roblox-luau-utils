--!strict

-- the table returned by the table.pack function: https://create.roblox.com/docs/reference/engine/libraries/table#pack
export type PackedValues<T> = { n: number, [number]: T }

export type Symbol = typeof(setmetatable({}, {} :: {
	__tostring: () -> string,
}))

export type EnumeratorItem<T = string> = typeof(setmetatable({} :: {
	name: string,
	value: T,
	type: Enumerator<T>,
}, {} :: {
	__tostring: () -> string,
}))
export type Enumerator<T = string> = typeof(setmetatable(
	{} :: {
		fromRawValue: (rawValue: T) -> EnumeratorItem<T>?,
		isEnumeratorItem: (value: any) -> boolean,
		getEnumeratorItems: () -> { EnumeratorItem<T> },
	},
	{} :: {
		__tostring: () -> string,
		__index: { [string]: EnumeratorItem<T> },
	}
))

-- reference: https://doc.rust-lang.org/std/result/enum.Result.html#
type ResultImpl<T, E> = {
	__tostring: () -> string,
	__index: ResultImpl<T, E>,
	__eq: <U>(U) -> boolean,

	isOk: (self: Result<T, E>) -> boolean,
	isOkAnd: (self: Result<T, E>, f: (T) -> boolean) -> boolean,
	isErr: (self: Result<T, E>) -> boolean,
	isErrAnd: (self: Result<T, E>, f: (E) -> boolean) -> boolean,
	mapOr: <U>(self: Result<T, E>, default: U, f: (T) -> U) -> U,
	mapOrElse: <U>(self: Result<T, E>, default: (E) -> U, f: (T) -> U) -> U,
	inspect: (self: Result<T, E>, f: (T) -> ()) -> Result<T, E>,
	inspectErr: (self: Result<T, E>, f: (E) -> ()) -> Result<T, E>,
	expect: (self: Result<T, E>, msg: string) -> T,
	unwrap: (self: Result<T, E>) -> T,
	expectErr: (self: Result<T, E>, msg: string) -> E,
	unwrapErr: (self: Result<T, E>) -> E,
	unwrapOr: (self: Result<T, E>, default: T) -> T,
	unwrapOrElse: (self: Result<T, E>, op: (E) -> T) -> T,
	contains: <U>(self: Result<T, E>, x: U) -> boolean,
	containsErr: <F>(self: Result<T, E>, f: F) -> boolean,
	-- luau specific method in order to simulate match keyword from rust
	match: <S, F>(self: Result<T, E>, onOk: (T) -> S, onErr: (E) -> F) -> S | F,
}
export type Result<T, E> = typeof(setmetatable({}, {} :: ResultImpl<T, E>))
export type Ok<T> = Result<T, nil>
export type Err<E> = Result<nil, E>

-- reference: https://doc.rust-lang.org/std/option/enum.Option.html
type OptionImpl<T> = {
	__tostring: () -> string,
	__index: OptionImpl<T>,

	isSome: (self: Option<T>) -> boolean,
	isSomeWith: (self: Option<T>, f: () -> boolean) -> boolean,
	isNone: (self: Option<T>) -> boolean,
	expect: (self: Option<T>, msg: string) -> T,
	unwrap: (self: Option<T>) -> T,
	unwrapOr: (self: Option<T>, default: T) -> T,
	unwrapOrElse: (self: Option<T>, f: () -> T) -> T,
	inspect: (self: Option<T>, f: () -> ()) -> Option<T>,
	map: <U>(self: Option<T>, f: (T) -> U) -> Option<T>,
	mapOr: <U>(self: Option<T>, default: U, f: () -> U) -> U,
	mapOrElse: <U>(self: Option<T>, default: () -> U, f: () -> U) -> U,
	okOr: <E>(self: Option<T>, err: E) -> Result<T, E>,
	okOrElse: <E>(self: Option<T>, err: () -> E) -> Result<T, E>,
	filter: (self: Option<T>, predicate: () -> boolean) -> Option<T>,
	contains: <U>(self: Option<T>, x: U) -> boolean,
	-- luau specific method in order to simulate match keyword from rust
	match: <U...>(self: Option<T>, onSome: (T) -> U..., onNone: () -> U...) -> U...,
}
export type Option<T> = typeof(setmetatable({}, {} :: OptionImpl<T>))
export type Some<T> = Option<T>
export type None = Option<nil>

type ConnectionImpl = {
	__index: ConnectionImpl,
	__tostring: () -> "Connection",

	connected: true,
	disconnect: (self: Connection) -> (),
}
export type Connection = typeof(setmetatable({} :: {
	connected: false?,
}, {} :: ConnectionImpl))
export type Signal<T... = ...any> = typeof(setmetatable(
	{},
	{} :: {
		__tostring: () -> "Signal",
		__index: {
			connect: (self: Signal<T...>, fn: (T...) -> ()) -> Connection,
			once: (self: Signal<T...>, fn: (T...) -> ()) -> Connection,
			fire: (self: Signal<T...>, T...) -> (),
			wait: (self: Signal<T...>) -> T...,
			destroy: (self: Signal<T...>) -> (),
		},
	}
))

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

type JanitorIndex = boolean | number | string | (...any) -> ...any | { [any]: any } | thread
-- * this type is not supposed to be used externally
export type JanitorImpl = {
	__index: JanitorImpl,
	__tostring: () -> "Janitor",
	__call: (self: Janitor) -> (),

	add: <T>(self: Janitor, object: T, methodNameOrTrue: (string | true)?, index: JanitorIndex) -> T,
	addPromise: (self: Janitor, promise: Promise<...any>) -> Symbol,
	get: (self: Janitor, index: JanitorIndex) -> any,
	remove: (self: Janitor, index: JanitorIndex) -> Janitor,
	linkToInstance: (self: Janitor, object: Instance, allowMultiple: true?) -> RBXScriptConnection,
	linkToInstances: (self: Janitor, ...Instance) -> (),
	cleanup: (self: Janitor) -> (),
	destroy: (self: Janitor) -> (),
}
export type Janitor = typeof(setmetatable({}, {} :: JanitorImpl))

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
export type RoduxReducer<State = any, Action = RoduxAnyAction> = (State?, Action) -> State
export type RoduxAction<Type = any> = { type: Type, [any]: any }
export type RoduxAnyAction = RoduxAction
export type RoduxActionCreator<Type, Action, Args...> = typeof(setmetatable({} :: { name: Type }, {} :: { __call: (any, Args...) -> Action & { type: Type } }))

-- roact related types, reference: https://roblox.github.io/roact/
export type RoactFunctionComponent = ({ [any]: any }) -> RoactElement
type RoactStatefulComponentImpl = {
	__index: RoactStatefulComponentImpl,
	__tostring: (self: RoactStatefulComponent) -> string,

	-- reference: https://roblox.github.io/roact/api-reference/#setstate
	setState: (self: RoactStatefulComponent, mapState: { [any]: any } | (previousState: { [any]: any }, props: { [any]: any }) -> ()) -> (),
	-- reference: https://roblox.github.io/roact/api-reference/#getelementtraceback
	getElementTraceback: (self: RoactStatefulComponent) -> string?,

	-- * must be overriden, otherwise an error will be thrown when attempting to render
	render: (self: RoactStatefulComponent) -> (),
}
export type RoactStatefulComponent = typeof(setmetatable(
	{} :: {
		-- reference: https://roblox.github.io/roact/api-reference/#defaultprops
		defaultProps: { [any]: any }?,

		-- reference: https://roblox.github.io/roact/api-reference/#init
		init: ((self: RoactStatefulComponent, initialProps: { [any]: any }) -> ())?,
		-- reference: https://roblox.github.io/roact/api-reference/#render
		render: (self: RoactStatefulComponent) -> RoactElement?,
		-- reference: https://roblox.github.io/roact/api-reference/#shouldupdate
		shouldUpdate: ((nextProps: { [any]: any }, nextState: { [any]: any }) -> boolean)?,
		-- * static lifecycle function, reference: https://roblox.github.io/roact/api-reference/#validateprops
		validateProps: ((props: { [any]: any }) -> (boolean, string?))?,

		-- reference: https://roblox.github.io/roact/api-reference/#didmount
		didMount: ((self: RoactStatefulComponent) -> ())?,
		-- reference: https://roblox.github.io/roact/api-reference/#willunmount
		willUnmount: ((self: RoactStatefulComponent) -> ())?,
		-- reference: https://roblox.github.io/roact/api-reference/#willupdate
		willUpdate: ((self: RoactStatefulComponent, nextProps: { [any]: any }, nextState: { [any]: any }) -> ())?,
		-- reference: https://roblox.github.io/roact/api-reference/#didupdate
		didUpdate: ((self: RoactStatefulComponent, previousProps: { [any]: any }, previousState: { [any]: any }) -> ())?,

		-- * static lifecycle function, reference: https://roblox.github.io/roact/api-reference/#getderivedstatefromprops
		getDerivedStateFromProps: (nextProps: { [any]: any }, lastState: { [any]: any }) -> { [any]: any }?,
	},
	{} :: RoactStatefulComponentImpl
))
export type RoactElement = {
	props: { [any]: any },
	component: string | RoactFunctionComponent | RoactStatefulComponent | RoactFragment | RoactPortal,
	source: string?,
}
export type RoactFragment = {
	elements: { [any]: RoactElement },
}
export type RoactPortal = Symbol
-- TODO: add generic render value type
type RoactContextConsumer = typeof(setmetatable(
	{} :: {
		validateProps: (props: { render: (any) -> () }) -> (boolean, string?),
		init: (self: RoactContextConsumer) -> (),
		render: (self: RoactContextConsumer) -> RoactElement?,
		didUpdate: (self: RoactContextConsumer) -> (),
		didMount: (self: RoactContextConsumer) -> (),
		willUnmount: (self: RoactContextConsumer) -> (),
	},
	{} :: RoactStatefulComponentImpl
))
type RoactContextProvider = typeof(setmetatable(
	{} :: {
		init: (self: RoactContextProvider, props: { [any]: any }) -> (),
		willUpdate: (self: RoactContextProvider, nextProps: { [any]: any }) -> (),
		didUpdate: (self: RoactContextProvider, prevProps: { [any]: any }) -> (),
		render: (self: RoactContextProvider) -> RoactFragment,
	},
	{} :: RoactStatefulComponentImpl
))
export type RoactContext = {
	Consumer: RoactContextConsumer,
	Provider: RoactContextProvider,
}

return nil
