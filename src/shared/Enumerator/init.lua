local Types = require(script.Types)

type EnumeratorItem<V, K> = Types.EnumeratorItem<V, K>
type Enumerator<V, K> = Types.Enumerator<V, K>

local function Enumerator<V, K>(enumName: string, enumValues: { [K]: V }): Enumerator<V, K>
	local enumerator = newproxy(true)
	local internal = {}

	local keysToEnumeratorItems = {}
	local valuesToEnumeratorItems = {}
	local totalEnums = 0

	function internal.fromRawValue(rawValue): EnumeratorItem<V, K>?
		return valuesToEnumeratorItems[rawValue]
	end

	function internal.isEnumValue(value: EnumeratorItem<V, K>)
		if typeof(value) ~= "userdata" then
			return false
		end

		for _, enumValue in pairs(keysToEnumeratorItems) do
			if enumValue == value then
				return true
			end
		end

		return false
	end

	function internal.getEnumeratorItems(): { EnumeratorItem<V, K> }
		local enumeratorItems = table.create(totalEnums)
		local length = 0

		for _, enumeratorItem in pairs(valuesToEnumeratorItems) do
			length += 1
			enumeratorItems[length] = enumeratorItem
		end

		return enumeratorItems
	end

	if next(enumValues) == 1 then
		for _, valueName in ipairs(enumValues) do
			local enumeratorItem = newproxy(true)
			local metatable = getmetatable(enumeratorItem)
			local valueString = string.format("%s.%s", enumName, valueName)

			function metatable:__tostring()
				return valueString
			end

			metatable.__index = {
				name = valueName,
				type = enumerator,
				value = valueName,
			}

			keysToEnumeratorItems[valueName] = enumeratorItem
			valuesToEnumeratorItems[valueName] = enumeratorItem
			totalEnums += 1
		end
	else
		for valueName, rawValue in pairs(enumValues) do
			local enumeratorItem = newproxy(true)
			local metatable = getmetatable(enumeratorItem)
			local valueString = string.format("%s.%s", enumName, valueName)

			function metatable:__tostring()
				return valueString
			end

			metatable.__index = {
				name = valueName,
				type = enumerator,
				value = rawValue,
			}

			keysToEnumeratorItems[valueName] = enumeratorItem
			valuesToEnumeratorItems[rawValue] = enumeratorItem
			totalEnums += 1
		end
	end

	local metatable = getmetatable(enumerator)
	metatable.__index = internal

	function metatable:__tostring()
		return enumName
	end

	return enumerator
end

return Enumerator
