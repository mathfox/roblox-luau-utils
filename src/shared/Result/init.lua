-- reference: https://doc.rust-lang.org/std/result/enum.Result.html#

local Types = require(script.Parent.Types)

type PackedValues = Types.PackedValues
type Result<T, E> = Types.Result<T, E>
type Option<T> = Types.Option<T>
type Err<E> = Types.Err<E>
type Ok<T> = Types.Ok<T>

local function valuesOutputHelper(values: PackedValues)
	local tbl: { string } = table.create(values.n)
	for i = 1, values.n do
		table.insert(tbl, ('"%s": %s'):format(tostring(values[i]), typeof(values[i])))
	end
	return table.concat(tbl, ", ")
end

local Ok = {}
local Err = {}
local Result = {}

function Result:isOk(...)
	if select("#", ...) > 0 then
		error(('"isOk" method expects no values, got (%s) instead'):format(valuesOutputHelper(table.pack(...))), 2)
	end

	return getmetatable(self) == Ok
end

function Result:isOkAnd<T>(f: (T) -> boolean, ...)
	if select("#", ...) > 0 then
		error(
			('"isOkAnd" method expects exactly one function, got (%s) as well'):format(
				valuesOutputHelper(table.pack(...))
			),
			2
		)
	elseif type(f) ~= "function" then
		error(('"f" (#1 argument) must be a function, got ("%s": %s) instead'):format(tostring(f), typeof(f)), 2)
	end

	if getmetatable(self) == Err then
		return false
	end

	local values = table.pack(f(self._v :: T))

	if values.n ~= 1 then
		error(
			('"f" (#1 argument) function must return exactly one boolean, got (%s) instead'):format(
				valuesOutputHelper(values)
			),
			2
		)
	elseif type(values[1]) ~= "boolean" then
		error(
			('"f" (#1 argument) function must return a boolean, got (%s) instead'):format(valuesOutputHelper(values)),
			2
		)
	end

	return values[1] :: boolean
end

function Result:isErr(...)
	if select("#", ...) > 0 then
		error(('"isErr" method expects no values, got (%s) instead'):format(valuesOutputHelper(table.pack(...))), 2)
	end

	return getmetatable(self) == Err
end

function Result:isErrAnd<E>(f: (E) -> boolean, ...)
	if select("#", ...) > 0 then
		error(
			('"isErrAnd" method expects exactly one function, got (%s) as well'):format(
				valuesOutputHelper(table.pack(...))
			),
			2
		)
	elseif type(f) ~= "function" then
		error(('"f" (#1 argument) must be a function, got ("%s": %s) instead'):format(tostring(f), typeof(f)), 2)
	end

	if getmetatable(self) == Ok then
		return false
	end

	local values = table.pack(f(self._v :: E))

	if values.n ~= 1 then
		error(
			('"f" (#1 argument) function must return exactly one boolean, got (%s) instead'):format(
				valuesOutputHelper(values)
			),
			2
		)
	elseif type(values[1]) ~= "boolean" then
		error(
			('"f" (#1 argument) function must return a boolean, got (%s) instead'):format(valuesOutputHelper(values)),
			2
		)
	end

	return values[1] :: boolean
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

function Result:map<T, E, U>(op: (T) -> U, ...)
	if select("#", ...) > 0 then
		error(
			('"map" method expects exactly one function, got (%s) as well'):format(valuesOutputHelper(table.pack(...))),
			2
		)
	elseif type(op) ~= "function" then
		error(('"op" (#1 argument) must be a function, got (%s) instead'):format(typeof(op)), 2)
	end

	if getmetatable(self) == Err then
		return self :: Result<T, E>
	end

	local values = table.pack(op(self._v :: T))

	if values.n ~= 1 then
		error(
			('"op" (#1 argument) function must return exactly one value, got (%s) instead'):format(
				valuesOutputHelper(values)
			),
			2
		)
	end

	return table.freeze(setmetatable({ _v = values[1] }, Ok)) :: Result<U, E>
end

function Result:mapOr<T, U>(default: U, f: (T) -> U, ...)
	if select("#", ...) > 0 then
		error(
			('"mapOr" method expects exactly two values, got (%s) as well'):format(valuesOutputHelper(table.pack(...))),
			2
		)
	elseif type(f) ~= "function" then
		error(('"f" (#2 argument) must be a function, got ("%s": %s) instead'):format(tostring(f), typeof(f)), 2)
	end

	if getmetatable(self) == Err then
		return default
	end

	local values = table.pack(f(self._v :: T))

	if values.n ~= 1 then
		error(
			('"f" (#2 argument) function must return exactly one value, got (%s) instead'):format(
				valuesOutputHelper(values)
			),
			2
		)
	end

	return values[1] :: U
end

function Result:mapOrElse<T, E, U>(default: (E) -> U, f: (T) -> U, ...)
	if select("#", ...) > 0 then
		error(
			('"mapOrElse" method expects exactly two values, got (%s) as well'):format(
				valuesOutputHelper(table.pack(...))
			),
			2
		)
	elseif type(default) ~= "function" then
		error(
			('"default" (#1 argument) must be a function, got ("%s": %s) instead'):format(
				tostring(default),
				typeof(default)
			),
			2
		)
	elseif type(f) ~= "function" then
		error(('"f" (#2 argument) must be a function, got ("%s": %s) instead'):format(tostring(f), typeof(f)), 2)
	end

	if getmetatable(self) == Err then
		local values = table.pack(default(self._v :: E))

		if values.n ~= 1 then
			error(
				('"default" (#1 argument) function must return exactly one value, got (%s) instead'):format(
					valuesOutputHelper(values)
				),
				2
			)
		end

		return values[1] :: U
	end

	local values = table.pack(f(self._v :: T))

	if values.n ~= 1 then
		error(
			('"f" (#2 argument) function must return exactly one value, got (%s) instead'):format(
				valuesOutputHelper(values)
			),
			2
		)
	end

	return values[1] :: U
end

function Result:mapErr<T, E, F>(op: (E) -> F, ...)
	if select("#", ...) > 0 then
		error(
			('"mapErr" method expects exactly one function, got (%s) as well'):format(
				valuesOutputHelper(table.pack(...))
			),
			2
		)
	elseif type(op) ~= "function" then
		error(('"op" (#1 argument) must be a function, got ("%s": %s) instead'):format(tostring(op), typeof(op)), 2)
	end

	if getmetatable(self) == Ok then
		return self :: Result<T, E>
	end

	local values = table.pack(op(self._v :: E))

	if values.n ~= 1 then
		error(
			('"op" (#1 argument) function must return exactly one value, got (%s) instead'):format(
				valuesOutputHelper(values)
			),
			2
		)
	end

	return table.freeze(setmetatable({ _v = values[1] :: F }, Err)) :: Result<T, F>
end

function Result:inspect<T>(f: (T) -> (), ...)
	if select("#", ...) > 0 then
		error(
			('"inspect" method expects exactly one function, got (%s) as well'):format(
				valuesOutputHelper(table.pack(...))
			),
			2
		)
	elseif type(f) ~= "function" then
		error(('"f" (#1 argument) must be a function, got ("%s": %s) instead'):format(tostring(f), typeof(f)), 2)
	end

	if getmetatable(self) == Ok then
		local values = table.pack(f(self._v :: T))

		if values.n > 0 then
			error(
				('"f" (#1 argument) function must return no values, got (%s) instead'):format(
					valuesOutputHelper(values)
				),
				2
			)
		end
	end

	return self :: Result<T, any>
end

function Result:inspectErr<E>(f: (E) -> (), ...)
	if select("#", ...) > 0 then
		error(
			('"inspectErr" method expects exactly one function, got (%s) as well'):format(
				valuesOutputHelper(table.pack(...))
			),
			2
		)
	elseif type(f) ~= "function" then
		error(('"f" (#1 argument) must be a function, got ("%s": %s) instead'):format(tostring(f), typeof(f)), 2)
	end

	if getmetatable(self) == Err then
		local values = table.pack(f(self._v :: E))

		if values.n > 0 then
			error(
				('"f" (#1 argument) function must return no values, got (%s) instead'):format(
					valuesOutputHelper(values)
				),
				2
			)
		end
	end

	return self :: Result<any, E>
end

function Result:expect(msg: string, ...)
	if select("#", ...) > 0 then
		error(
			('"expect" method expects exactly one string, got (%s) as well'):format(valuesOutputHelper(table.pack(...))),
			2
		)
	elseif type(msg) ~= "string" then
		error(('"msg" (#1 argument) must be a string, got ("%s": %s) instead'):format(tostring(msg), typeof(msg)), 2)
	elseif getmetatable(self) == Err then
		error(msg, 2)
	end

	return self._v
end

function Result:unwrap(...)
	if select("#", ...) > 0 then
		error(('"unwrap" method expects no values, got (%s) instead'):format(valuesOutputHelper(table.pack(...))), 2)
	elseif getmetatable(self) == Err then
		error('attempted to call "unwrap" on Err', 2)
	end

	return self._v
end

function Result:expectErr(msg: string, ...)
	if select("#", ...) > 0 then
		error(
			('"expectErr" method expects exactly one string, got (%s) as well'):format(
				valuesOutputHelper(table.pack(...))
			),
			2
		)
	elseif type(msg) ~= "string" then
		error(('"msg" (#1 argument) must be a string, got ("%s": %s) instead'):format(tostring(msg), typeof(msg)), 2)
	elseif getmetatable(self) == Ok then
		error(msg, 2)
	end

	return self._v
end

function Result:unwrapErr(...)
	if select("#", ...) > 0 then
		error(('"unwrapErr" method expects no values, got (%s) instead'):format(valuesOutputHelper(table.pack(...))), 2)
	elseif getmetatable(self) == Ok then
		error('attempted to call "unwrapErr" on Ok', 2)
	end

	return self._v
end

function Result:andRes<T, E, U>(res: Result<U, E>, ...)
	if select("#", ...) > 0 then
		error(
			('"andRes" method expects exactly one Result, got (%s) as well'):format(valuesOutputHelper(table.pack(...))),
			2
		)
	elseif type(res) ~= "table" or getmetatable(res).__index ~= Result then
		error(('"res" (#1 argument) must be a Result, got ("%s": %s) instead'):format(tostring(res), typeof(res)), 2)
	end

	return if getmetatable(self) == Ok then res else self :: Result<T, E>
end

function Result:andThen<T, E, U>(op: (T) -> Result<U, E>, ...)
	if select("#", ...) > 0 then
		error(
			('"andThen" method expects exactly one function, got (%s) as well'):format(
				valuesOutputHelper(table.pack(...))
			),
			2
		)
	elseif type(op) ~= "function" then
		error(('"op" (#1 argument) must be a function, got ("%s": %s) instead'):format(tostring(op), typeof(op)), 2)
	end

	if getmetatable(self) == Err then
		return self :: Result<T, E>
	end

	local values = table.pack(op(self._v :: T))

	if values.n ~= 1 then
		error(
			('"op" (#1 argument) function must return exactly one Result, got (%s) instead'):format(
				valuesOutputHelper(values)
			),
			2
		)
	elseif type(values[1]) ~= "table" or getmetatable(values[1]).__index ~= Result then
		error(
			('"op" (#1 argument) function must return Result, got ("%s": %s) instead'):format(
				tostring(values[1]),
				typeof(values[1])
			),
			2
		)
	end

	return values[1] :: Result<U, E>
end

function Result:orRes<T, E, F>(res: Result<T, F>, ...)
	if select("#", ...) > 0 then
		error(
			('"orRes" method expects exactly one Result, got (%s) as well'):format(valuesOutputHelper(table.pack(...))),
			2
		)
	elseif type(res) ~= "table" or getmetatable(res).__index ~= Result then
		error(('"res" (#1 argument) must be a Result, got ("%s": %s) instead'):format(tostring(res), typeof(res)), 2)
	end

	return if getmetatable(self) == Err then res else self :: Result<T, E>
end

function Result:orElse<T, E, F>(op: (E) -> Result<T, F>, ...)
	if select("#", ...) > 0 then
		error(
			('"orElse" method expects exatly one function, got (%s) instead'):format(
				valuesOutputHelper(table.pack(...))
			),
			2
		)
	elseif type(op) ~= "function" then
		error(('"op" (#1 argument) must be a function, got ("%s": %s) instead'):format(tostring(op), typeof(op)))
	end

	if getmetatable(self) == Ok then
		return self :: Result<T, E>
	end

	local values = table.pack(op(self._v :: E))

	if values.n ~= 1 then
		error(
			('"op" (#1 argument) function must return exactly one Result, got (%s) instead'):format(
				valuesOutputHelper(values)
			),
			2
		)
	elseif type(values[1]) ~= "table" or getmetatable(values[1]).__index ~= Result then
		error(
			('"op" (#1 argument) function must return Result, got ("%s": %s) instead'):format(
				tostring(values[1]),
				typeof(values[1])
			),
			2
		)
	end

	return values[1] :: Result<T, F>
end

function Result:unwrapOr<T>(...)
	if select("#", ...) ~= 1 then
		error(
			('"unwrapOr" method expects exactly one value, got (%s) as well'):format(
				valuesOutputHelper(table.pack(...))
			),
			2
		)
	end

	return if getmetatable(self) == Ok then self._v :: T else (...) :: T
end

function Result:unwrapOrElse<T, E>(op: (E) -> T, ...)
	if select("#", ...) > 0 then
		error(
			('"unwrapOrElse" method excepts exactly one function, got (%s) as well'):format(
				valuesOutputHelper(table.pack(...))
			),
			2
		)
	elseif type(op) ~= "function" then
		error(('"op" (#1 argument) must be a function, got ("%s": %s) instead'):format(tostring(op), typeof(op)), 2)
	end

	if getmetatable(self) == Ok then
		return self._v :: T
	end

	local values = table.pack(op(self._v :: T))

	if values.n ~= 1 then
		error(
			('"op" (#1 argument) function must return exactly one value, got (%s) instead'):format(
				valuesOutputHelper(values)
			),
			2
		)
	end

	return values[1] :: T
end

function Result:contains(...)
	if select("#", ...) ~= 1 then
		error(
			('"contains" method expects exactly one value, got (%s) instead'):format(
				valuesOutputHelper(table.pack(...))
			),
			2
		)
	end

	return getmetatable(self) == Ok and self._v == (...)
end

function Result:containsErr(...)
	if select("#", ...) ~= 1 then
		error(
			('"containsErr" method expects exactly one value, got (%s) instead'):format(
				valuesOutputHelper(table.pack(...))
			),
			2
		)
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
