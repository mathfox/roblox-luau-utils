--[[
	A ref is nothing more than a binding with a special field 'current'
	that maps to the getValue method of the binding
]]

local Binding = require(script.Parent.Binding)

local function createRef()
	local binding = Binding.create(nil)

	-- A ref is just redirected to a binding via its metatable
	return table.freeze(setmetatable(
		{},
		table.freeze({
			__index = function(_, key)
				return if key == "current" then binding:getValue() else binding[key]
			end,

			__newindex = function(_, key, value)
				if key == "current" then
					error("Cannot assign to the 'current' property of refs", 2)
				end

				binding[key] = value
			end,

			__tostring = function()
				return ("RoactRef(%s)"):format(tostring(binding:getValue()))
			end,
		})
	))
end

return createRef
