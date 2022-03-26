export type CancellationHook = () -> ()

export type Executor<V...> = (
	resolve: (V...) -> (),
	reject: (...any) -> (),
	onCancel: (cancellationHook: CancellationHook?) -> boolean
) -> ()

export type Error = {
	error: string,
	trace: string?,
	context: string,
	kind: string,
	parent: Error?,
	createdTick: number,
	createdTrace: string,
}

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

return nil
