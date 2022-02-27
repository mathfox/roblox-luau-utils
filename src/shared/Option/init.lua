--[[
	Options are useful for handling nil-value cases. Any time that an
	operation might return nil, it is useful to instead return an
	Option, which will indicate that the value might be nil, and should
	be explicitly checked before using the value. This will help
	prevent common bugs caused by nil values that can fail silently.
--]]

--[[
	Represents an optional value in Lua. This is useful to avoid `nil` bugs, which can
	go silently undetected within code and cause hidden or hard-to-find bugs.
]]
local Option = {}
Option.prototype = {}
Option.__index = Option.prototype

function Option._new(value): Option
	return setmetatable({
		_v = value,
		_s = value ~= nil,
	}, Option)
end

--[[
	creates an Option instance with the given value.
   throws an error if the given value is `nil`.
]]
function Option.some(value: any): Option
	assert(value ~= nil, "Option.some() value cannot be nil")

	return Option._new(value)
end

--[[
	Safely wraps the given value as an `Option`. If the value is `nil`,
   returns `Option.none`, otherwise returns a new `Option`.
]]
function Option.wrap(value: any): Option
	return if value == nil then Option.none else Option._new(value)
end

function Option.is(object: any): boolean
	return type(object) == "table" and getmetatable(object) == Option
end

-- Throws an error if `object` is not an `Option`.
function Option.assert(object: any): Option
	return if Option.is(object) then object else error("result was not an Option", 2)
end

function Option.prototype:match(matches: { onSome: (v: any) -> (), onNone: () -> () }): any
	local onSome = matches.some
	local onNone = matches.none

	assert(type(onSome) == "function", "Missing 'some' match")
	assert(type(onNone) == "function", "Missing 'none' match")

	return if self._s then onSome(self._v) else onNone()
end

-- Returns `true` if the option contains any `value`.
function Option.prototype:isSome(): boolean
	return self._s
end

-- Returns `true` if the option is `Option.none`.
function Option.prototype:isNone(): boolean
	return not self._s
end

-- Unwraps the `value` of `Option`, otherwise throws an error with a message returned by `createMessage` function.
function Option.prototype:expect(createMessage: () -> string): any
	return if self._s then self._v else error(createMessage(), 2)
end

function Option.prototype:expectNone(createMessage: () -> string)
	if self._s then
		error(createMessage(), 2)
	end
end

-- 'default' argument can be either a function or any other value
function Option.prototype:unwrap(default): any
	return if default == nil
		then self:expect(function()
			return "can't unwrap Option.none"
		end)
		else if self._s then self._v elseif type(default) == "function" then default() else default
end

-- Returns `Option` if the calling option has a `value`, otherwise returns `Option.none`.
function Option.prototype:intersect(option: Option): Option
	return if self._s then option else Option.none
end

-- If caller has a `value`, returns itself. Otherwise, returns `Option`
function Option.prototype:union(option: Option): Option
	return if self._s then self else option
end

-- Extending the `Option.none` will always result into returning `Option.none`.
function Option.prototype:extend(modifier: (any) -> Option): Option
	return if self._s then Option.assert(modifier(self._v)) else Option.none
end

-- Returns `self` if this option has a value and the predicate returns `true`. Otherwise, returns `Option.none`.
function Option.prototype:filter(predicate: (any) -> boolean): Option
	return if not self._s or not predicate(self._v) then Option.none else self
end

-- Returns `true` if this option contains `value`.
function Option.prototype:contains(value: any)
	return if self._s then self._v == value else false
end

function Option:__tostring(): string
	return if self._s then "Option<" .. typeof(self._v) .. ">" else "Option<None>"
end

function Option:__eq(object: Option | any): boolean
	return if Option.is(object)
		then if self._s and object:isSome() then self._v == object:unwrap() else not self._s and object:isNone()
		else false
end

-- Represents no value `Option`.
Option.none = Option._new()

export type Option = {
	match: (self: Option, matches: { onSome: (v: any) -> (), onNone: () -> () }) -> any,
	isSome: (self: Option) -> boolean,
	isNone: (self: Option) -> boolean,
	expect: (self: Option, createMessage: () -> string) -> any,
	expectNone: (self: Option, createMessage: () -> string) -> (),
	unwrap: (self: Option, default: any | () -> any) -> any,
	intersect: (self: Option, option: Option) -> Option,
	union: (self: Option, option: Option) -> Option,
	extend: (self: Option, modifier: (any) -> Option) -> Option,
	filter: (self: Option, predicate: (any) -> boolean) -> Option,
	contains: (self: Option, value: any) -> boolean,
}

return Option
