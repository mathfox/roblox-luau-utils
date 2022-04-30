-- reference: https://doc.rust-lang.org/std/option/enum.Option.html
local Types = require(script.Parent.Types)

export type Option<T> = Types.Option<T>
export type Some<T> = Types.Some<T>
export type None = Types.None

local None = {}
local Some = {}
local Option = {}

function Option:isSome()
	return getmetatable(self) == Some
end

function Option:isSomeWith(f)
	return getmetatable(self) == Some and f(self._v)
end

function Option:isNone()
	return getmetatable(self) == None
end

function Option:expect(msg)
	if getmetatable(self) == None then
		error(msg, 2)
	end
	return self._v
end

function Option:unwrap()
	if getmetatable(self) == None then
		error()
	end
	return self._v
end

function Option:unwrapOr(default)
	return if getmetatable(self) == None then default else self._v
end

function Option:uwrapOrElse(f)
	return if getmetatable(self) == None then f() else self._v
end

function Option:map(f)
	return if getmetatable(self) == None then self else setmetatable({ _v = f(self._v) }, Some)
end

function Option:inspect(f)
	if getmetatable(self) == Some then
		f(self._v)
	end
end

function Option:mapOr(default, f)
	return if getmetatable(self) == None then default else f(self._v)
end

function Option:mapOrElse(default, f)
	return if getmetatable(self) == None then default() else f(self._v)
end

function Option:okOr(err)
	return if getmetatable(self) == None then require(script.Parent.Result).Err(err) else require(script.Parent.Result).Ok(self._v)
end

function Option:okOrElse(err)
	return if getmetatable(self) == None then require(script.Parent.Result).Err(err()) else require(script.Parent.Result).Ok(self._v)
end

Option["and"] = function(self, optb)
	return if getmetatable(self) == None then self else optb
end

function Option:andThen(f)
	return if getmetatable(self) == None then self else f(self._v)
end

function Option:filter(predicate)
	return if getmetatable(self) == None then self else if predicate(self._v) then self else None
end

Option["or"] = function(self, optb)
	return if getmetatable(self) == None then optb else self
end

function Option:orElse(f)
	return if getmetatable(self) == None then f() else self
end

function Option:xor(optb)
	return if getmetatable(self) == None then optb ~= None else optb == None
end

function Option:take()
	local opt = setmetatable({}, None)
	if getmetatable(self) == None then
		return opt
	end

	local v = self._v
	self._v = nil
	setmetatable(self, None)

	return setmetatable({ _v = v }, Some)
end

function Option:replace(value)
	if value == nil then
		error()
	end

	local prev = if getmetatable(self) == None then setmetatable({}, None) else setmetatable({ _v = self._v }, Some)

	self._v = value
	setmetatable(self, Some)

	return prev
end

function Option:contains(x)
	return getmetatable(self) == Some and self._v == x
end

None.__index = Option

function None:__tostring()
	return "Option<_>"
end

function None:__eq(v)
	return type(v) == "table" and getmetatable(v) == None
end

Some.__index = Option

function Some:__tostring()
	return "Option<" .. typeof(self._v) .. ">"
end

function Some:__eq(v)
	return type(v) == "table" and getmetatable(v) == Some and v == self._v
end

local OptionExport = {
	Some = function<T>(v: T): Option<T>
		return table.freeze(setmetatable({ _v = v }, Some))
	end,

	None = table.freeze(setmetatable({}, None)) :: Option<nil>,

	_option = Option,
	_some = Some,
	_none = None,
}

table.freeze(OptionExport)

return OptionExport :: {
	None: None,
	Some: <T>(T) -> Some<T>,
}
