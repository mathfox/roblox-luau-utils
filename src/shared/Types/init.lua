export type Dictionary<T> = { [string]: T }
export type Array<T> = { T }

export type Symbol = {}

-- reference: https://doc.rust-lang.org/std/result/enum.Result.html#
export type Ok<T> = T
export type Err<E> = E
export type Result<T, E> = {
	isOk: (self: Result<T, E>) -> boolean,
	isOkWith: (self: Result<T, E>, f: (T) -> boolean) -> boolean,
	isErr: (self: Result<T, E>) -> boolean,
	isErrWith: (self: Result<T, E>, f: (E) -> boolean) -> boolean,
	ok: (self: Result<T, E>) -> Option<T>,
	err: (self: Result<T, E>) -> Option<E>,
	map: <U>(self: Result<T, E>, op: (T) -> U) -> Result<U, E>,
	mapOr: <U>(self: Result<T, E>, default: U, f: (T) -> U) -> U,
	mapOrElse: <U>(self: Result<T, E>, default: (E) -> U, f: (T) -> U) -> U,
	mapErr: <F>(self: Result<T, E>, op: (E) -> F) -> Result<T, F>,
	inspect: (self: Result<T, E>, f: (T) -> ()) -> Result<T, E>,
	inspectErr: (self: Result<T, E>, f: (E) -> ()) -> Result<T, E>,
	expect: (self: Result<T, E>, msg: string) -> T,
	unwrap: (self: Result<T, E>) -> T,
	expectErr: (self: Result<T, E>, msg: string) -> E,
	unwrapErr: (self: Result<T, E>) -> E,
	["and"]: <U>(self: Result<T, E>, res: Result<U, E>) -> Result<U, E>,
	andThen: <U>(self: Result<T, E>, op: (T) -> Result<U, E>) -> Result<U, E>,
	["or"]: <F>(self: Result<T, E>, res: Result<T, F>) -> Result<T, F>,
	orElse: <F>(self: Result<T, E>, op: (E) -> Result<T, F>) -> Result<T, F>,
	unwrapOr: (self: Result<T, E>, default: T) -> T,
	unwrapOrElse: (self: Result<T, E>, op: (E) -> T) -> Result<T, E>,
	contains: <U>(self: Result<T, E>, x: U) -> boolean,
	containsErr: <F>(self: Result<T, E>, f: F) -> boolean,
}

-- reference: https://doc.rust-lang.org/std/option/enum.Option.html
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
	["and"]: <U>(self: Option<T>, optb: Option<U>) -> Option<U>,
	andThen: <U>(self: Option<T>, f: (T) -> Option<U>) -> Option<U>,
	filter: (self: Option<T>, predicate: (T) -> boolean) -> Option<T>,
	["or"]: (self: Option<T>, optb: Option<T>) -> Option<T>,
	orElse: (self: Option<T>, f: () -> Option<T>) -> Option<T>,
	xor: (self: Option<T>, optb: Option<T>) -> Option<T>,
	take: (self: Option<T>) -> Option<T>,
	replace: (self: Option<T>, value: T) -> Option<T>,
	contains: <U>(self: Option<T>, x: U) -> boolean,
}

export type Signal<T...> = {
	connect: (self: Signal<T...>, fn: (T...) -> ()) -> Connection,
	fire: (self: Signal<T...>, T...) -> (),
	wait: (self: Signal<T...>) -> T...,
	destroy: (self: Signal<T...>) -> (),
}
export type Connection = {
	connected: boolean,
	disconnect: (self: Connection) -> (),
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

export type EnumeratorItem<V> = { name: string, type: Enumerator<V>, value: V }
export type Enumerator<V> = {
	fromRawValue: (rawValue: V) -> EnumeratorItem<V>?,
	isEnumeratorItem: (value: any) -> boolean,
	getEnumeratorItems: () -> { EnumeratorItem<V> },
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

export type Executor<V...> = (
	resolve: (V...) -> (),
	reject: (...any) -> (),
	onCancel: (cancellationHook: (() -> ())?) -> boolean
) -> ()
export type Promise<V...> = {
	andThen: <R...>(
		self: Promise<V...>,
		successHandler: (V...) -> R...,
		failureHandler: (...any) -> R...
	) -> Promise<R...>,
	andThenCall: <T..., R...>(self: Promise<V...>, callback: (T...) -> R..., T...) -> Promise<R...>,
	andThenReturn: <R...>(self: Promise<V...>, R...) -> Promise<R...>,
	await: (self: Promise<V...>) -> (boolean, V...),
	awaitStatus: (self: Promise<V...>) -> (string, V...),
	cancel: (self: Promise<V...>) -> (),
	catch: (self: Promise<V...>, failureHandler: <R...>(...any) -> R...) -> Promise<R...>,
	expect: (self: Promise<V...>) -> V...,
	finally: (self: Promise<V...>, finallyHandler: (status: string) -> ...any) -> Promise<V...>,
	finallyCall: <R...>(self: Promise<V...>, callback: (R...) -> ...any, R...) -> Promise<V...>,
	finallyReturn: <R...>(self: Promise<V...>, R...) -> Promise<V...>,
	getStatus: (self: Promise<V...>) -> number,
	now: (self: Promise<V...>, rejectionValue: any) -> Promise<V...>,
	tap: (self: Promise<V...>, tapHandler: (...any) -> ...any) -> Promise<V...>,
	timeout: (self: Promise<V...>, seconds: number, rejectionValue: any) -> Promise<V...>,
}

export type FunctionTask = (...any) -> ...any
export type TableTask = { destroy: FunctionTask, [any]: any }
export type MaidTask = RBXScriptConnection | FunctionTask | TableTask
export type Maid = {
	giveTask: (self: Maid, newTask: MaidTask) -> string,
	finalizeTask: (self: Maid, taskId: string) -> (),
	givePromise: (self: Maid, Promise<...any>) -> (false, string),
	destroy: (self: Maid) -> (),
}

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
	type: string,
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

return nil
