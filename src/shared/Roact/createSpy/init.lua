--[[
	A utility used to create a function spy that can be used to robustly test
	that functions are invoked the correct number of times and with the correct
	number of arguments.

	This should only be used in tests.
]]

local assertDeepEqual = require(script.Parent.Parent.assertDeepEqual)

local function createSpy(inner)
	local self = {}
	self.callCount = 0
	self.values = {}
	self.valuesLength = 0
	self.value = function(...)
		self.callCount = self.callCount + 1
		self.values = { ... }
		self.valuesLength = select("#", ...)

		return if inner ~= nil then inner(...) else nil
	end

	self.assertCalledWith = function(_, ...)
		local len = select("#", ...)

		if self.valuesLength ~= len then
			error(("Expected %d arguments, but was called with %d arguments"):format(self.valuesLength, len), 2)
		end

		for i = 1, len do
			if self.values[i] ~= select(i, ...) then
				error("value differs", 2)
			end
		end
	end

	self.assertCalledWithDeepEqual = function(_, ...)
		local len = select("#", ...)

		if self.valuesLength ~= len then
			error(("Expected %d arguments, but was called with %d arguments"):format(self.valuesLength, len), 2)
		end

		for i = 1, len do
			assertDeepEqual(self.values[i], select(i, ...))
		end
	end

	self.captureValues = function(_, ...)
		local len = select("#", ...)
		local result = {}

		if self.valuesLength ~= len then
			error("length of expected values differs from stored values", 2)
		end

		for i = 1, len do
			local key = select(i, ...)
			result[key] = self.values[i]
		end

		return result
	end

	setmetatable(self, {
		__index = function(_, key)
			error(("%q is not a valid member of spy"):format(key))
		end,
	})

	return self
end

return createSpy
