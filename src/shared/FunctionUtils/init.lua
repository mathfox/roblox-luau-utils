--[[
    Returns a new bound function.
    Whenever this function is be called
    it will receive provided varargs as its arguments.
]]
local function bindArgs(func: (...any) -> ...any, ...)
	local args = table.pack(...)

	return function()
		return func(table.unpack(args, 1, args.n))
	end
end

local FunctionUtils = {
	bindArgs = bindArgs,
	BindArgs = bindArgs,
}

return FunctionUtils
