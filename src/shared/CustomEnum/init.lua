local CustomEnum = newproxy(true)
local customEnumMetatable = getmetatable(CustomEnum)
customEnumMetatable.__metatable = "The metatable is locked"

function customEnumMetatable.__tostring()
	return "CustomEnum"
end

function customEnumMetatable:__index(i)
	error(i .. ' is not a valid member of "CustomEnum"', 0)
end

function customEnumMetatable:__newindex(i)
	error(i .. " cannot be assigned to", 0)
end

function customEnumMetatable:__call(tbl)
	if type(tbl) ~= "table" then
		error("#1 argument must be a table!", 2)
	end

	local enumProxy = newproxy(true)
	local enumProxyMetatable = getmetatable(enumProxy)

	local enumItemsList = {}

	local enumProxyAddress = tostring(enumProxy):sub(11)
	enumProxyMetatable.__metatable = "The metatable is locked"

	function enumProxyMetatable.__tostring()
		return "CustomEnum: " .. enumProxyAddress
	end

	function enumProxyMetatable:__index(i)
		return enumItemsList[i]
			or error(i .. string.format(' is not a valid member of "CustomEnum: %s"', enumProxyAddress), 0)
	end

	function enumProxyMetatable:__newindex(i)
		error(i .. " cannot be assigned to", 0)
	end

	do
		local hash = {}

		for i = 1, #tbl do
			local v = tbl[i]
			if v == nil then
				error("invalid syntax for CustomEnum, nil value provided", 0)
			elseif hash[v] == nil then
				hash[v] = i
			else
				error("invalid syntax for CustomEnum, duplicate values provided", 0)
			end
		end
	end

	for key, value in next, tbl do
		do
			local invalidKey = type(key) ~= "number" or key % 1 ~= 0
			local invalidValue = type(value) ~= "string"
			if invalidKey or invalidValue then
				if invalidKey then
					if invalidValue then
						error("invalid syntax for CustomEnum, non-integer key as well as non-string value provided", 0)
					else
						error("invalid syntax for CustomEnum, non-integer key provided", 0)
					end
				else
					error("invalid syntax for CustomEnum, non-string value provided", 0)
				end
			end
		end

		local enumItemProxy = newproxy(true)
		enumItemsList[value] = enumItemProxy

		local enumItemProxyMetatable = getmetatable(enumItemProxy)

		local enumItemProxyAddress = tostring(enumItemProxy):sub(11)
		enumItemProxyMetatable.__metatable = "The metatable is locked"

		function enumItemProxyMetatable.__tostring()
			return value
		end

		function enumItemProxyMetatable:__index(i)
			if i == "EnumType" then
				return enumProxy
			elseif i == "toString" then
				return function()
					return value
				end
			elseif i == "toInt" then
				return function()
					return key - 1
				end
			elseif i == "toHexAddress" then
				return function()
					return enumItemProxyAddress
				end
			end

			error(string.format(i .. ' is not a valid member of "%s"', value), 0)
		end

		function enumItemProxyMetatable:__newindex(i)
			error(i .. " cannot be assigned to", 0)
		end
	end

	return enumProxy
end

return CustomEnum
