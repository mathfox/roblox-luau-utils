-- reference: https://doc.rust-lang.org/std/result/enum.Result.html#

local Types = require(script.Parent.Types)

export type Result<T, E> = Types.Result<T, E>
export type Err<E> = Types.Err<E>
export type Ok<T> = Types.Ok<T>
type Array<T> = Types.Array<T>
type Some<T> = Types.Some<T>

local function packResult(...)
	return select("#", ...), { ... }, (...)
end

local function outputHelper(...)
	local length = select("#", ...)
	local tbl: Array<string> = table.create(length)

	for index = 1, length do
		local value = select(index, ...)
		table.insert(tbl, ('"%s": %s'):format(tostring(value), typeof(value)))
	end

	return table.concat(tbl, ", ")
end

local Ok = {}
local Err = {}
local Result = {}

function Result:isOk(...)
	if select("#", ...) > 0 then
		error(('"isOk" method expects no values, got (%s) instead'):format(outputHelper(...)), 2)
	end

	return getmetatable(self) == Ok
end

function Result:isOkAnd<T>(f: (T) -> boolean, ...)
	if select("#", ...) > 0 then
		error(('"isOkAnd" method expects exactly one function of type (T) -> boolean, got (%s) as well'):format(outputHelper(...)), 2)
	elseif type(f) ~= "function" then
		error(('"f" (#1 argument) must be a function of type (T) -> boolean, got (%s) instead'):format(outputHelper(f)), 2)
	end

	if getmetatable(self) == Err then
		return false
	end

	local length, values, bool = packResult(f(self._v :: T))

	if length ~= 1 then
		error(('"f" (#1 argument) function must return exactly one boolean, got (%s) instead'):format(outputHelper(unpack(values, 1, length))), 2)
	elseif type(bool) ~= "boolean" then
		error(('"f" (#1 argument) function must return a boolean, got (%s) instead'):format(outputHelper(bool)), 2)
	end

	return bool :: boolean
end

function Result:isErr(...)
	if select("#", ...) > 0 then
		error(('"isErr" method expects no values, got (%s) instead'):format(outputHelper(...)), 2)
	end

	return getmetatable(self) == Err
end

function Result:isErrAnd<E>(f: (E) -> boolean, ...)
	if select("#", ...) > 0 then
		error(('"isErrAnd" method expects exactly one function of type (E) -> boolean, got (%s) as well'):format(outputHelper(...)), 2)
	elseif type(f) ~= "function" then
		error(('"f" (#1 argument) must be a function of type (E) -> boolean, got (%s) instead'):format(outputHelper(f)), 2)
	end

	if getmetatable(self) == Ok then
		return false
	end

	local length, values, bool = packResult(f(self._v :: E))

	if length ~= 1 then
		error(('"f" (#1 argument) function must return exactly one boolean, got (%s) instead'):format(outputHelper(unpack(values, 1, length))), 2)
	elseif type(bool) ~= "boolean" then
		error(('"f" (#1 argument) function must return a boolean, got (%s) instead'):format(outputHelper(bool)), 2)
	end

	return bool :: boolean
end

function Result:ok<T>(...)
	if select("#", ...) > 0 then
		error(('"ok" method expects no values, got (%s) instead'):format(outputHelper(...)), 2)
	end

	return if getmetatable(self) == Ok then require(script.Parent.Option).Some(self._v :: T) :: Some<T> else require(script.Parent.Option).None
end

function Result:err<E>(...)
	if select("#", ...) > 0 then
		error(('"err" method expects no values, got (%s) instead'):format(outputHelper(...)), 2)
	end

	return if getmetatable(self) == Err then require(script.Parent.Option).Some(self._v :: E) :: Some<E> else require(script.Parent.Option).None
end

local function createOk<T>(value: T)
	return table.freeze(setmetatable({ _v = value }, Ok)) :: Ok<T>
end

function Result:map<T, E, U>(op: (T) -> U, ...)
	if select("#", ...) > 0 then
		error(('"map" method expects exactly one function of type (T) -> U, got (%s) as well'):format(outputHelper(...)), 2)
	elseif type(op) ~= "function" then
		error(('"op" (#1 argument) must be a function of type (T) -> U, got (%s) instead'):format(outputHelper(op)), 2)
	end

	if getmetatable(self) == Err then
		return self :: Result<T, E>
	end

	local length, values, newValue: U = packResult(op(self._v :: T))

	if length ~= 1 then
		error(('"op" (#1 argument) function must return exactly one value, got (%s) instead'):format(outputHelper(unpack(values, 1, length))), 2)
	end

	return createOk(newValue) :: Result<U, E>
end

function Result:mapOr<T, U>(default: U, f: (T) -> U, ...)
	if select("#", ...) > 0 then
		error(('"mapOr" method expects exactly two values (default: U, f: (T) -> U), got (%s) as well'):format(outputHelper(...)), 2)
	elseif type(f) ~= "function" then
		error(('"f" (#2 argument) must be a function of type (T) -> U, got (%s) instead'):format(outputHelper(f)), 2)
	end

	if getmetatable(self) == Err then
		return default
	end

	local length, values, newValue: U = packResult(f(self._v :: T))

	if length ~= 1 then
		error(('"f" (#2 argument) function must return exactly one value, got (%s) instead'):format(outputHelper(unpack(values, 1, length))), 2)
	end

	return newValue
end

function Result:mapOrElse<T, E, U>(default: (E) -> U, f: (T) -> U, ...)
	if select("#", ...) > 0 then
		error(('"mapOrElse" method expects exactly two values (default: (E) -> U, f: (T) -> U), got (%s) as well'):format(outputHelper(...)), 2)
	elseif type(default) ~= "function" then
		error(('"default" (#1 argument) must be a function of type (E) -> U, got (%s) instead'):format(outputHelper(default)), 2)
	elseif type(f) ~= "function" then
		error(('"f" (#2 argument) must be a function of type (T) -> U, got (%s) instead'):format(outputHelper(f)), 2)
	end

	if getmetatable(self) == Err then
		local length, values, newValue: U = packResult(default(self._v :: E))

		if length ~= 1 then
			error(('"default" (#1 argument) function must return exactly one value, got (%s) instead'):format(outputHelper(unpack(values, 1, length))), 2)
		end

		return newValue
	end

	local length, values, newValue: U = packResult(f(self._v :: T))

	if length ~= 1 then
		error(('"f" (#2 argument) function must return exactly one value, got (%s) instead'):format(outputHelper(unpack(values, 1, length))), 2)
	end

	return newValue
end

local function createErr<E>(value: E)
	return table.freeze(setmetatable({ _v = value }, Err)) :: Err<E>
end

function Result:mapErr<T, E, F>(op: (E) -> F, ...)
	if select("#", ...) > 0 then
		error(('"mapErr" method expects exactly one function of type (E) -> F, got (%s) as well'):format(outputHelper(...)), 2)
	elseif type(op) ~= "function" then
		error(('"op" (#1 argument) must be a function of type (E) -> F, got (%s) instead'):format(outputHelper(op)), 2)
	end

	if getmetatable(self) == Ok then
		return self :: Result<T, E>
	end

	local length, values, newValue: F = packResult(op(self._v :: E))

	if length ~= 1 then
		error(('"op" (#1 argument) function must return exactly one value, got (%s) instead'):format(outputHelper(unpack(values, 1, length))), 2)
	end

	return createErr(newValue) :: Result<T, F>
end

function Result:inspect<T>(f: (T) -> (), ...)
	if select("#", ...) > 0 then
		error(('"inspect" method expects exactly one function of type (T) -> (), got (%s) as well'):format(outputHelper(...)), 2)
	elseif type(f) ~= "function" then
		error(('"f" (#1 argument) must be a function of type (T) -> (), got (%s) instead'):format(outputHelper(f)), 2)
	end

	if getmetatable(self) == Ok then
		local length, values = packResult(f(self._v :: T))

		if length > 0 then
			error(('"f" (#1 argument) function must return no values, got (%s) instead'):format(outputHelper(unpack(values, 1, length))), 2)
		end
	end

	return self :: Result<T, any>
end

function Result:inspectErr<E>(f: (E) -> (), ...)
	if select("#", ...) > 0 then
		error(('"inspectErr" method expects exactly one function of type (E) -> (), got (%s) as well'):format(outputHelper(...)), 2)
	elseif type(f) ~= "function" then
		error(('"f" (#1 argument) must be a function of type (E) -> (), got (%s) instead'):format(outputHelper(f)), 2)
	end

	if getmetatable(self) == Err then
		local length, values = packResult(f(self._v :: E))

		if length > 0 then
			error(('"f" (#1 argument) function must return no values, got (%s) instead'):format(outputHelper(unpack(values, 1, length))), 2)
		end
	end

	return self :: Result<any, E>
end

function Result:expect(msg: string, ...)
	if select("#", ...) > 0 then
		error(('"expect" method expects exactly one string, got (%s) as well'):format(outputHelper(...)), 2)
	elseif type(msg) ~= "string" then
		error(('"msg" (#1 argument) must be a string, got (%s) instead'):format(outputHelper(msg)), 2)
	elseif getmetatable(self) == Err then
		error(msg, 2)
	end

	return self._v
end

function Result:unwrap(...)
	if select("#", ...) > 0 then
		error(('"unwrap" method expects no values, got (%s) instead'):format(outputHelper(...)), 2)
	elseif getmetatable(self) == Err then
		error('called "Result:unwrap()" on an "Err" value', 2)
	end

	return self._v
end

function Result:expectErr(msg: string, ...)
	if select("#", ...) > 0 then
		error(('"expectErr" method expects exactly one string, got (%s) as well'):format(outputHelper(...)), 2)
	elseif type(msg) ~= "string" then
		error(('"msg" (#1 argument) must be a string, got (%s) instead'):format(outputHelper(msg)), 2)
	elseif getmetatable(self) == Ok then
		error(msg, 2)
	end

	return self._v
end

function Result:unwrapErr(...)
	if select("#", ...) > 0 then
		error(('"unwrapErr" method expects no values, got (%s) instead'):format(outputHelper(...)), 2)
	elseif getmetatable(self) == Ok then
		error('called "Result:unwrapErr()" on an "Ok" value', 2)
	end

	return self._v
end

local function isResult(value)
	if type(value) ~= "table" then
		return false
	end

	local metatable = getmetatable(value)
	return if metatable then metatable.__index == Result else false
end

-- original naming: https://doc.rust-lang.org/std/result/enum.Result.html#method.and
function Result:andRes<T, E, U>(res: Result<U, E>, ...)
	if select("#", ...) > 0 then
		error(('"andRes" method expects exactly one Result, got (%s) as well'):format(outputHelper(...)), 2)
	elseif not isResult(res) then
		error(('"res" (#1 argument) must be a Result, got (%s) instead'):format(outputHelper(res)), 2)
	end

	return if getmetatable(self) == Ok then res else self :: Result<T, E>
end

function Result:andThen<T, E, U>(op: (T) -> Result<U, E>, ...)
	if select("#", ...) > 0 then
		error(('"andThen" method expects exactly one function of type (T) -> Result<U, E>, got (%s) as well'):format(outputHelper(...)), 2)
	elseif type(op) ~= "function" then
		error(('"op" (#1 argument) must be a function, got (%s) instead'):format(outputHelper(op)), 2)
	end

	if getmetatable(self) == Err then
		return self :: Result<T, E>
	end

	local length, values, res = packResult(op(self._v :: T))

	if length ~= 1 then
		error(('"op" (#1 argument) function must return exactly one Result, got (%s) instead'):format(outputHelper(unpack(values, 1, length))), 2)
	elseif not isResult(res) then
		error(('"op" (#1 argument) function must return a Result, got (%s) instead'):format(outputHelper(res)), 2)
	end

	return res :: Result<U, E>
end

-- original naming: https://doc.rust-lang.org/std/result/enum.Result.html#method.or
function Result:orRes<T, E, F>(res: Result<T, F>, ...)
	if select("#", ...) > 0 then
		error(('"orRes" method expects exactly one Result, got (%s) as well'):format(outputHelper(...)), 2)
	elseif not isResult(res) then
		error(('"res" (#1 argument) must be a Result, got (%s) instead'):format(outputHelper(res)), 2)
	end

	return if getmetatable(self) == Err then res else self :: Result<T, E>
end

function Result:orElse<T, E, F>(op: (E) -> Result<T, F>, ...)
	if select("#", ...) > 0 then
		error(('"orElse" method expects exatly one function of type (E) -> Result<T, F>, got (%s) instead'):format(outputHelper(...)), 2)
	elseif type(op) ~= "function" then
		error(('"op" (#1 argument) must be a function, got (%s) instead'):format(outputHelper(op)))
	end

	if getmetatable(self) == Ok then
		return self :: Result<T, E>
	end

	local length, values, res = packResult(op(self._v :: E))

	if length ~= 1 then
		error(('"op" (#1 argument) function must return exactly one Result, got (%s) instead'):format(outputHelper(unpack(values, 1, length))), 2)
	elseif not isResult(res) then
		error(('"op" (#1 argument) function must return Result, got (%s) instead'):format(outputHelper(res)), 2)
	end

	return res :: Result<T, F>
end

function Result:unwrapOr<T>(...)
	if select("#", ...) ~= 1 then
		error(('"unwrapOr" method expects exactly one value, got (%s) instead'):format(outputHelper(...)), 2)
	end

	return if getmetatable(self) == Ok then self._v :: T else (...) :: T
end

function Result:unwrapOrElse<T, E>(op: (E) -> T, ...)
	if select("#", ...) > 0 then
		error(('"unwrapOrElse" method excepts exactly one function of type (E) -> T, got (%s) as well'):format(outputHelper(...)), 2)
	elseif type(op) ~= "function" then
		error(('"op" (#1 argument) must be a function of type (E) -> T, got (%s) instead'):format(outputHelper(op)), 2)
	end

	if getmetatable(self) == Ok then
		return self._v :: T
	end

	local length, values, computedValue: T = packResult(op(self._v :: E))

	if length ~= 1 then
		error(('"op" (#1 argument) function must return exactly one value, got (%s) instead'):format(outputHelper(unpack(values, 1, length))), 2)
	end

	return computedValue
end

function Result:contains(...)
	if select("#", ...) ~= 1 then
		error(('"contains" method expects exactly one value, got (%s) instead'):format(outputHelper(...)), 2)
	end

	return getmetatable(self) == Ok and self._v == (...)
end

function Result:containsErr(...)
	if select("#", ...) ~= 1 then
		error(('"containsErr" method expects exactly one value, got (%s) instead'):format(outputHelper(...)), 2)
	end

	return getmetatable(self) == Err and self._v == (...)
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
	Ok = createOk,
	Err = createErr,

	_ok = Ok,
	_err = Err,
	_result = Result,
	is = isResult,
}

table.freeze(ResultExport)

return ResultExport :: {
	Ok: <T>(T) -> Result<T, nil>,
	Err: <E>(E) -> Result<nil, E>,
	is: (value: any) -> boolean,
}
