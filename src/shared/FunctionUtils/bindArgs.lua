--[[
    Returns a function which will receive provided varargs as the first arguments
        and lastly the arguments provided when it was called
]]
local function bindArgs(func: (...any) -> ...any, ...: any)
	local args = table.pack(...)

	return function(...: any)
		return func(table.unpack(args, 1, args.n), ...)
	end
end

return bindArgs
