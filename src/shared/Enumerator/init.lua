local Types = require(script.Parent.Types)

type EnumeratorItem<V> = Types.EnumeratorItem<V>
type Enumerator<V> = Types.Enumerator<V>

local function Enumerator<V>(enumName: string, enumValues: { V } | { [string]: V }): Enumerator<V>
	local enumerator = newproxy(true)
	local internal = {}

	local keysToEnumeratorItems = {}
	local valuesToEnumeratorItems = {}
	local totalEnums = 0

	function internal.fromRawValue(rawValue): EnumeratorItem<V>?
		return valuesToEnumeratorItems[rawValue]
	end

	function internal.isEnumeratorItem(value)
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

	function internal.getEnumeratorItems(): { EnumeratorItem<V> }
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

	function metatable:__index(index)
		return internal[index] or keysToEnumeratorItems[index]
	end

	function metatable:__tostring()
		return enumName
	end

	return enumerator
end

return Enumerator
