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

function Result:isOkWith(f: (any) -> boolean)
	local bool = f(self._v)
	if type(bool) ~= "boolean" then
		error(("f function should return a boolean, got (%s) instead"):format(typeof(bool)), 2)
	end
	return getmetatable(self) == Ok and bool
end

function Result:isErr()
	return getmetatable(self) == Err
end

function Result:isErrWith(f: (any) -> boolean)
	return getmetatable(self) == Err and f(self._v)
end

function Result:ok()
	return if getmetatable(self) == Ok
		then require(script.Parent.Option).Some(self._v)
		else require(script.Parent.Option).None
end

function Result:err()
	return if getmetatable(self) == Err
		then require(script.Parent.Option).Some(self._v)
		else require(script.Parent.Option).None
end

function Result:map(op)
	return if getmetatable(self) == Ok then table.freeze(setmetatable({ _v = op(self._v) }, Ok)) else self
end

function Result:mapOr(default, f)
	return if getmetatable(self) == Err then default else f(self._v)
end

function Result:mapOrElse(default, f)
	return if getmetatable(self) == Err then default(self._v) else f(self._v)
end

function Result:mapErr(op)
	return if getmetatable(self) == Err then table.freeze(setmetatable({ _v = op(self._v) }, Err)) else self
end

function Result:inspect(f)
	if getmetatable(self) == Ok then
		f(self._v)
	end
end

function Result:inspectErr(f)
	if getmetatable(self) == Err then
		f(self._v)
	end
end

function Result:expect(msg)
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

function Result:expectErr(msg)
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

Result["and"] = function(self, res)
	return if getmetatable(self) == Ok then res else self
end

function Result:andThen(op)
	return if getmetatable(self) == Ok then op(self._v) else self
end

Result["or"] = function(self, res)
	return if getmetatable(self) == Err then res else self
end

function Result:orElse(op)
	return if getmetatable(self) == Err then op(self._v) else self
end

function Result:unwrapOr(default)
	return if getmetatable(self) == Ok then self._v else default
end

function Result:unwrapOrElse(op)
	return if getmetatable(self) == Ok then self._v else op(self._v)
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

Err.__index = Result

function Err:__tostring()
	return "Err<" .. typeof(self._v) .. ">"
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
	Ok: <T>(T) -> Ok<T>,
	Err: <E>(E) -> Err<E>,
}
