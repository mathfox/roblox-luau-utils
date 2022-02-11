local function returnArgs(...: any)
	local args = table.pack(...)

	return function()
		return table.unpack(args, 1, args.n)
	end
end

return returnArgs
