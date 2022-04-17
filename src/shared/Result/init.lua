-- reference: https://doc.rust-lang.org/std/result/enum.Result.html#
local Types = require(script.Parent.Types)

type Result<T, E> = Types.Result<T, E>
type Option<T> = Types.Option<T>
type Err<E> = Types.Err<E>
type Ok<T> = Types.Ok<T>

local Ok = {}
local Err = {}
local Result = {}

function Result:isOk()
	return getmetatable(self) == Ok
end

function Result:isOkWith<T>(f: (T) -> boolean)
	local bool = f(self._v :: T)
	if type(bool) ~= "boolean" then
		error(("f function should return a boolean, got (%s) instead"):format(typeof(bool)), 2)
	end
	return getmetatable(self) == Ok and bool
end

function Result:isErr()
	return getmetatable(self) == Err
end

function Result:isErrWith<E>(f: (E) -> boolean)
	local bool = f(self._v :: E)
	if type(bool) ~= "boolean" then
		error(("f function should return a boolean, got (%s) instead"):format(typeof(bool)), 2)
	end
	return getmetatable(self) == Err and bool
end

function Result:ok<T>()
	return if getmetatable(self) == Ok
		then require(script.Parent.Option).Some(self._v :: T) :: Option<T>
		else require(script.Parent.Option).None
end

function Result:err<T>()
	return if getmetatable(self) == Err
		then require(script.Parent.Option).Some(self._v :: T) :: Option<T>
		else require(script.Parent.Option).None
end

function Result:map<T, E, U>(op: (T) -> U)
	if type(op) ~= "function" then
		error(("'op' (#1 argument) must be a function, but (%s) provided instead"):format(typeof(op)), 2)
	end
	return if getmetatable(self) == Ok
		then table.freeze(setmetatable({ _v = op(self._v :: T) }, Ok)) :: Result<U, E>
		else self :: Result<T, E>
end

function Result:mapOr<T, U>(default: U, f: (T) -> U)
	if type(f) ~= "function" then
		error(("'f' (#2 argument) must be a function, got (%s) instead"):format(typeof(f)), 2)
	end
	return if getmetatable(self) == Err then default else f(self._v :: T)
end

function Result:mapOrElse<T, E, U>(default: (E) -> U, f: (T) -> U)
	if type(default) ~= "function" then
		error(("'default' (#1 argument) must be a function, got (%s) instead"):format(typeof(default)), 2)
	elseif type(f) ~= "function" then
		error(("'f' (#2 argument) must be a function, got (%s) instead"):format(typeof(f)), 2)
	end
	return if getmetatable(self) == Err then default(self._v :: E) else f(self._v :: T)
end

function Result:mapErr<T, E, F>(op: (E) -> F)
	if type(op) ~= "function" then
		error(("'op' (#1 argument) must be a function, got (%s) instead"):format(typeof(op)), 2)
	end
	return if getmetatable(self) == Err
		then table.freeze(setmetatable({ _v = op(self._v :: E) }, Err)) :: Result<T, F>
		else self :: Result<T, E>
end

function Result:inspect<T>(f: (T) -> ())
	if type(f) ~= "function" then
		error(("'f' (#1 argument) must be a function, got (%s) instead"):format(typeof(f)), 2)
	end
	if getmetatable(self) == Ok then
		if select("#", f(self._v :: T)) > 0 then
			error("f function passed to the `inspect` method should return ()", 2)
		end
	end
end

function Result:inspectErr<E>(f: (E) -> ())
	if type(f) ~= "function" then
		error(("'f' (#1 argument) must be a function, got (%s) instead"):format(typeof(f)), 2)
	end
	if getmetatable(self) == Err then
		if select("#", f(self._v :: E)) > 0 then
			error("f function passed to the `inspectErr` method should return ()", 2)
		end
	end
end

function Result:expect(msg: string)
	if getmetatable(self) == Err then
		error(msg, 2)
	end
	return self._v
end

function Result:unwrap()
	if getmetatable(self) == Err then
		error()
	end
	return self._v
end

function Result:expectErr(msg: string)
	if getmetatable(self) == Ok then
		error(msg, 2)
	end
	return self._v
end

function Result:unwrapErr()
	if getmetatable(self) == Ok then
		error()
	end
	return self._v
end

Result["and"] = function<T, E, U>(self: Result<T, E>, res: Result<U, E>)
	return if getmetatable(self) == Ok then res else self
end

function Result:andThen<T, E, U>(op: (T) -> Result<U, E>)
	return if getmetatable(self) == Ok then op(self._v :: T) else self :: Result<T, E>
end

Result["or"] = function<T, E, F>(self: Result<T, E>, res: Result<T, F>)
	return if getmetatable(self) == Err then res else self
end

function Result:orElse<T, E, F>(op: (E) -> Result<T, F>)
	return if getmetatable(self) == Err then op(self._v :: E) else self :: Result<T, E>
end

function Result:unwrapOr<T>(default: T)
	return if getmetatable(self) == Ok then self._v :: T else default
end

function Result:unwrapOrElse<T, E>(op: (E) -> T)
	return if getmetatable(self) == Ok then self._v :: T else op(self._v :: T)
end

function Result:contains(x)
	return getmetatable(self) == Ok and self._v == x
end

function Result:containsErr(f)
	return getmetatable(self) == Err and self._v == f
end

table.freeze(Result)

Ok.__index = Result

function Ok:__tostring()
	return "Ok<" .. typeof(self._v) .. ">"
end

function Ok:__eq(value)
	return type(value) == "table" and getmetatable(value) == Ok and value._v == self._v
end

Err.__index = Result

function Err:__tostring()
	return "Err<" .. typeof(self._v) .. ">"
end

function Err:__eq(value)
	return type(value) == "table" and getmetatable(value) == Err and value._v == self._v
end

-- make sure no more edits could be applied
table.freeze(Ok)
table.freeze(Err)

local ResultExport = {
	Ok = function(v)
		return table.freeze(setmetatable({ _v = v }, Ok))
	end,

	Err = function(v)
		return table.freeze(setmetatable({ _v = v }, Err))
	end,

	_ok = Ok,
	_err = Err,
	_result = Result,
}

table.freeze(ResultExport)

return ResultExport :: {
	Ok: <T>(T) -> Result<T, nil>,
	Err: <E>(E) -> Result<nil, E>,
}
