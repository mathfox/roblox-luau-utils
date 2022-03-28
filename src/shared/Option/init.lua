--[[
	Options are useful for handling nil-value cases. Any time that an
	operation might return nil, it is useful to instead return an
	Option, which will indicate that the value might be nil, and should
	be explicitly checked before using the value. This will help
	prevent common bugs caused by nil values that can fail silently.
--]]

local Types = require(script.Types)

type OptionMatches = Types.OptionMatches
type Option = Types.Option

--[[
	Represents an optional value in Lua. This is useful to avoid `nil` bugs, which can
	go silently undetected within code and cause hidden or hard-to-find bugs.
]]
local Option = {}
Option.prototype = {} :: Option & {
	_v: any,
	_s: boolean,
}
Option.__index = Option.prototype

function Option._new(value): Option
	return setmetatable({
		_v = value,
		_s = value ~= nil,
	}, Option)
end

function Option.is(object)
	return type(object) == "table" and getmetatable(object) == Option
end

-- Creates an `Option` instance with the given `value`. Throws an error if the given value is `nil`.
function Option.some(value)
	if value == nil then
		error("Option.some() value cannot be nil", 2)
	end

	return Option._new(value)
end

-- Safely wraps the given value as an `Option`. If the value is `nil`, returns `Option.none`, otherwise returns a new `Option`.
function Option.wrap(value)
	return if value == nil then Option.none else Option._new(value)
end

-- Throws an error if `object` is not an `Option`.
function Option.assert(object)
	return if Option.is(object) then object :: Option else error("provided object was not an Option", 2)
end

function Option.prototype:match(matches: OptionMatches)
	return if self._s then matches.onSome(self._v) else matches.onNone()
end

-- Returns `true` if the option contains any `value`.
function Option.prototype:isSome()
	return self._s
end

-- Returns `true` if the option is `Option.none`.
function Option.prototype:isNone()
	return not self._s
end

-- Unwraps the `value` of `Option`, otherwise throws an error with a message returned by `createMessage` function.
function Option.prototype:expect(createMessage: () -> string)
	return if self._s then self._v else error(createMessage(), 2)
end

function Option.prototype:expectNone(createMessage: () -> string)
	if self._s then
		error(createMessage(), 2)
	end
end

-- 'default' argument can be either a function or any other value
function Option.prototype:unwrap(default)
	return if default == nil
		then self:expect(function()
			return "cannot unwrap Option.none"
		end)
		else if self._s then self._v elseif type(default) == "function" then default() else default
end

-- Returns `Option` if the calling option has a `value`, otherwise returns `Option.none`.
function Option.prototype:intersect(option: Option)
	return if self._s then option else Option.none
end

-- If caller has a `value`, returns itself. Otherwise, returns `Option`
function Option.prototype:union(option: Option)
	return if self._s then self :: Option else option
end

-- Extending the `Option.none` will always result into returning `Option.none`.
function Option.prototype:extend(modifier: (any) -> Option)
	return if self._s then Option.assert(modifier(self._v)) else Option.none
end

-- Returns `self` if this option has a value and the predicate returns `true`. Otherwise, returns `Option.none`.
function Option.prototype:filter(predicate: (any) -> boolean)
	return if not self._s or not predicate(self._v) then Option.none else self :: Option
end

-- Returns `true` if this option contains `value`.
function Option.prototype:contains(value)
	return if self._s then self._v == value else false
end

function Option:__tostring()
	return if self._s then "Option<" .. typeof(self._v) .. ">" else "Option<None>"
end

function Option:__eq(object)
	return if Option.is(object)
		then if self._s and (object :: Option):isSome()
			then self._v == (object :: Option):unwrap()
			else not self._s and (object :: Option):isNone()
		else false
end

-- Represents no value `Option`.
Option.none = Option._new()

return Option :: {
	is: (object: any) -> boolean,
	some: (value: any) -> Option,
	wrap: (value: any) -> Option,
	assert: (object: any) -> Option,
	none: Option,
}
