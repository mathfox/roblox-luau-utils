-- reference: https://doc.rust-lang.org/std/option/enum.Option.html

local Types = require(script.Parent.Types)

export type Option<T> = Types.Option<T>
export type Some<T> = Types.Some<T>
export type None = Types.None

local Option = {}
local None = {}
local Some = {}

function Option:isSome()
	return self ~= None
end

function Option:isSomeWith<T>(f: (T) -> boolean)
	return self ~= None and f(self._v :: T)
end

function Option:isNone()
	return self == None
end

function Option:expect<T>(msg: string)
	if self == None then
		error(msg, 2)
	end

	return self._v :: T
end

function Option:unwrap<T>()
	if self == None then
		error(nil, 2)
	end

	return self._v :: T
end

function Option:unwrapOr<T>(default: T)
	return if self == None then default else self._v :: T
end

function Option:uwrapOrElse<T>(f: () -> T)
	return if self == None then f() else self._v :: T
end

function Option:map<T, U>(f: (T) -> U)
	return if self == None then self :: None else table.freeze(setmetatable({ _v = f(self._v) }, Some)) :: Some<U>
end

function Option:inspect<T>(f: (T) -> ())
	if self ~= None then
		f(self._v :: T)
	end
end

function Option:mapOr<T, U>(default: U, f: (T) -> U)
	return if self == None then default else f(self._v :: T)
end

function Option:mapOrElse<T, U>(default: () -> U, f: (T) -> U)
	return if self == None then default() else f(self._v :: T)
end

function Option:okOr(err)
	return if self == None then require(script.Parent.Result).Err(err) else require(script.Parent.Result).Ok(self._v)
end

function Option:okOrElse(err)
	return if self == None then require(script.Parent.Result).Err(err()) else require(script.Parent.Result).Ok(self._v)
end

-- reference: https://doc.rust-lang.org/std/option/enum.Option.html#method.and
function Option:andRes<U>(optb: Option<U>)
	return if self == None then self :: None else optb
end

function Option:andThen<T, U>(f: (T) -> Option<U>)
	return if self == None then self :: None else f(self._v :: T)
end

function Option:filter<T>(predicate: (T) -> boolean)
	return if self == None then self :: None else if predicate(self._v :: T) then self else None :: None
end

-- reference: https://doc.rust-lang.org/std/option/enum.Option.html#method.or
function Option:orRes<T>(optb: Option<T>)
	return if self == None then optb else self :: None
end

function Option:orElse<T>(f: () -> Option<T>)
	return if self == None then f() else self :: None
end

function Option:xor<T>(optb: Option<T>)
	return if self == None then optb ~= None else optb == None
end

function Option:contains(x)
	return self ~= None and self._v == x
end

function Option:match<T, U...>(onSome: (T) -> U..., onNone: () -> U...)
	return if self == None then onNone() else onSome(self._v)
end

table.freeze(Option)

table.freeze(setmetatable(
	None,
	table.freeze({
		__index = Option,
		__tostring = function()
			return "Option<_>"
		end,
	})
))

Some.__index = Option

function Some:__tostring()
	return "Option<" .. typeof(self._v) .. ">"
end

function Some:__eq(v)
	return type(v) == "table" and getmetatable(v) == Some and v == self._v
end

table.freeze(Some)

local OptionExport = {
	Some = function<T>(v: T): Some<T>
		return table.freeze(setmetatable({ _v = v }, Some))
	end,

	None = None,
}

table.freeze(OptionExport)

return OptionExport :: {
	None: None,
	Some: <T>(T) -> Some<T>,
}
