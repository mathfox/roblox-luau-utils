--[[
	A utility used to assert that two objects are value-equal recursively. It
	outputs fairly nicely formatted messages to help diagnose why two objects
	would be different.
]]

local function deepEqual(a, b)
	if typeof(a) ~= typeof(b) then
		return false, ("{1} is of type %s, but {2} is of type %s"):format(typeof(a), typeof(b))
	end

	if typeof(a) == "table" then
		local visitedKeys = {}

		for key, value in a do
			visitedKeys[key] = true

			local success, innerMessage = deepEqual(value, b[key])
			if not success then
				local message = innerMessage:gsub("{1}", ("{1}[%s]"):format(tostring(key))):gsub("{2}", ("{2}[%s]"):format(tostring(key)))

				return false, message
			end
		end

		for key, value in b do
			if not visitedKeys[key] then
				local success, innerMessage = deepEqual(value, a[key])

				if not success then
					local message = innerMessage:gsub("{1}", ("{1}[%s]"):format(tostring(key))):gsub("{2}", ("{2}[%s]"):format(tostring(key)))

					return false, message
				end
			end
		end

		return true
	end

	if a == b then
		return true
	end

	return false, "{1} ~= {2}"
end

local function assertDeepEqual(a, b)
	local success, innerMessageTemplate = deepEqual(a, b)

	if not success then
		local innerMessage = innerMessageTemplate:gsub("{1}", "first"):gsub("{2}", "second")

		error(("Values were not deep-equal.\n%s"):format(innerMessage), 2)
	end
end

return assertDeepEqual
