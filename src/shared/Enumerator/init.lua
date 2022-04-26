-- source: https://github.com/howmanysmall/enumerator

local Types = require(script.Parent.Types)

export type EnumeratorItem<T> = Types.EnumeratorItem<T>
export type Enumerator<T> = Types.Enumerator<T>
type Record<K, V> = Types.Record<K, V>
type Array<T> = Types.Array<T>

local VALUE_TO_TYPE_STRING = '"%s": %s'

local function outputHelper(...)
	local tbl: Array<string> = {}

	for index = 1, select("#", ...) do
		local value = select(index, ...)
		table.insert(tbl, VALUE_TO_TYPE_STRING:format(tostring(value), typeof(value)))
	end

	return table.concat(tbl, ", ")
end

local function Enumerator<T>(enumeratorName: string, enumValues: Array<string> | Record<string, T>, ...): Enumerator<T>
	if type(enumeratorName) ~= "string" then
		error(
			('"enumeratorName" (#1 argument) must be a string, got (%s) instead'):format(outputHelper(enumeratorName)),
			2
		)
	elseif enumeratorName == "" then
		error('"enumeratorName" (#1 argument) must be a non-empty string', 2)
	elseif type(enumValues) ~= "table" then
		error(
			('"enumValues" (#2 argument) must be either an Array<string> or Record<string, T>, got (%s) instead'):format(
				outputHelper(enumValues)
			),
			2
		)
	elseif select("#", ...) > 0 then
		error(
			(
				'"Enumerator" constructor expects exactly two arguments: (string, Array<string> | Record<string, T>), got (%s) as well'
			):format(outputHelper(...)),
			2
		)
	end

	-- first look which decides the table type other values will be asserted against
	-- we are only interested in assigning Array, as otherwise we suppose it must be a Dictionary
	local firstKeyType = type(next(enumValues))

	if firstKeyType == nil then
		error('empty "enumValues" (#2 argument) table provided, expected either Array<string> or Record<string, T>', 2)
	elseif firstKeyType ~= "number" and firstKeyType ~= "string" then
		error(
			(
				'invalid "enumValues" (#2 argument) provided, expected either Array<string> or Record<string, T> but got key of (%s) type instead'
			):format(firstKeyType),
			2
		)
	end

	local tblType = if firstKeyType == "number" then "Array" else nil

	for key, value in pairs(enumValues) do
		local keyType = type(key)

		if tblType == "Array" then
			if keyType ~= "number" then
				error(
					(
						'invalid key provided in "enumValues": Array<string> (#2 argument), expected number but got (%s) instead'
					):format(outputHelper(keyType)),
					2
				)
			end

			local valueType = type(value)
			if valueType ~= "string" then
				error(
					(
						'invalid value provided in "enumValues": Array<string> (#2 argument), expected a string but got (%s) instead'
					):format(outputHelper(valueType)),
					2
				)
			elseif value == "" then
				error(
					'empty string provided as a value in "enumValues": Array<string> (#2 argument), expected non-empty string',
					2
				)
			end
		else
			if keyType == "number" then
				error(
					(
						'invalid key "%d" provided in "enumValues": Record<string, T> (#2 argument), expected string but got ("%s": number) instead'
					):format(key),
					2
				)
			elseif key == "" then
				error(
					'empty string provided as a key in "enumValues": Record<string, T> (#2 argument), expected non-empty string',
					2
				)
			end
		end
	end

	local enumerator = {}
	local keysToEnumeratorItems: Record<string, EnumeratorItem<T>> = {}
	local valuesToEnumeratorItems: Record<T, EnumeratorItem<T>> = {}
	local totalEnums = 0

	function enumerator.fromRawValue(rawValue): EnumeratorItem<T>?
		return valuesToEnumeratorItems[rawValue]
	end

	function enumerator.isEnumeratorItem(value)
		if typeof(value) ~= "userdata" then
			return false
		end

		for _, enumeratorItem in pairs(keysToEnumeratorItems) do
			if enumeratorItem == value then
				return true
			end
		end

		return false
	end

	function enumerator.getEnumeratorItems(): { EnumeratorItem<T> }
		local enumeratorItems = table.create(totalEnums)
		local length = 0

		for _, enumeratorItem in pairs(keysToEnumeratorItems) do
			length += 1
			enumeratorItems[length] = enumeratorItem
		end

		return enumeratorItems
	end

	if tblType == "Array" then
		for _, valueName in ipairs(enumValues :: Array<string>) do
			local enumeratorItem = table.freeze(setmetatable(
				{
					name = valueName,
					type = enumerator,
					value = valueName,
				},
				table.freeze({
					__tostring = function()
						return ("%s.%s"):format(enumeratorName, valueName)
					end,
				})
			))

			keysToEnumeratorItems[valueName] = enumeratorItem
			valuesToEnumeratorItems[valueName] = enumeratorItem
			totalEnums += 1
		end
	else
		for valueName, rawValue in pairs(enumValues :: Record<string, T>) do
			local enumeratorItem = table.freeze(setmetatable(
				{
					name = valueName,
					type = enumerator,
					value = rawValue,
				},
				table.freeze({
					__tostring = function()
						return ("%s.%s"):format(enumeratorName, valueName)
					end,
				})
			))

			keysToEnumeratorItems[valueName] = enumeratorItem
			valuesToEnumeratorItems[rawValue] = enumeratorItem
			totalEnums += 1
		end
	end

	table.freeze(setmetatable(
		enumerator,
		table.freeze({
			__index = keysToEnumeratorItems,
			__tostring = function()
				return enumeratorName
			end,
		})
	))

	return enumerator
end

return Enumerator
