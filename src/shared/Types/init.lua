export type Dictionary<T> = { [string]: T }
export type Array<T> = { T }

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

return nil
