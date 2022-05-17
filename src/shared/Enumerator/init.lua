-- refactored version of: https://github.com/howmanysmall/enumerator

local Types = require(script.Parent.Types)

type Record<K, V> = Types.Record<K, V>
type Array<T> = Types.Array<T>

export type EnumeratorItem<T> = Types.EnumeratorItem<T>
export type Enumerator<T> = Types.Enumerator<T>

local function outputHelper(...)
	local length = select("#", ...)
	local tbl: Array<string> = table.create(length)

	for index = 1, length do
		local value = select(index, ...)
		table.insert(tbl, ('"%s": %s'):format(tostring(value), typeof(value)))
	end

	return table.concat(tbl, ", ")
end

local function EnumeratorConstructor<T>(enumeratorName: string, enumValues: Array<string> | Record<string, T>, ...)
	if type(enumeratorName) ~= "string" then
		error(('"enumeratorName" (#1 argument) must be a string, got (%s) instead'):format(outputHelper(enumeratorName)), 2)
	elseif enumeratorName == "" then
		error('"enumeratorName" (#1 argument) must be a non-empty string', 2)
	elseif type(enumValues) ~= "table" then
		error(('"enumValues" (#2 argument) must be either an Array<string> or a Record<string, T>, got (%s) instead'):format(outputHelper(enumValues)), 2)
	elseif select("#", ...) > 0 then
		error(('"Enumerator" constructor expects exactly two arguments: (string, Array<string> | Record<string, T>), got (%s) as well'):format(outputHelper(...)), 2)
	end

	-- this variable decides type string other key types will be asserted against
	local firstKeyType = type(next(enumValues))

	if firstKeyType == "nil" then
		error('empty "enumValues" (#2 argument) table provided, expected either an Array<string> or a Record<string, T> with atleast two entries in it', 2)
	elseif firstKeyType ~= "number" and firstKeyType ~= "string" then
		error(
			(
				'invalid key of (%s) type specified in provided "enumValues" (#2 argument) table which should be either an Array<string> or a Record<string, T> (so the key type could only be either a number or a string)'
			):format(typeof(next(enumValues))),
			2
		)
	elseif getmetatable(enumValues) then
		error(
			('"enumValues" (#2 argument) table whose type presumably is %s, should not contain a metatable attached to it'):format(
				if firstKeyType == "number" then "an Array<string>" else ("a Record<string, %s>"):format(typeof(select(2, next(enumValues))))
			)
		)
	end

	local enumerator = {}
	local keysToEnumeratorItems: Record<string, EnumeratorItem<T>> = {}
	local valuesToEnumeratorItems: Record<T, EnumeratorItem<T>> = {}
	local totalEnumeratorItems = 0

	if firstKeyType == "number" then
		local processedValuesMap: Record<string, true> = {}

		for index, value in pairs(enumValues :: Array<string>) do
			if processedValuesMap[value] then
				error(('(%s) value specified twice in "enumValues" (#2 argument) table which presumably should be an Array<string>'):format(value), 2)
			elseif type(index) ~= "number" then
				error(('invalid key specified in "enumValues" (#2 argument) table which presumably should be an Array<string>, expected a number but got (%s) instead'):format(outputHelper(index)), 2)
			end

			totalEnumeratorItems += 1

			if index ~= totalEnumeratorItems then
				local missingIndexes: Array<number> = { totalEnumeratorItems }
				local currentMissingIndex = totalEnumeratorItems

				-- will be used in case there is also an invalid keys provided
				local invalidKeys: Array<any> = nil

				for nextIndex in next, enumValues, index do
					currentMissingIndex += 1

					if type(nextIndex) == "number" then
						local existingIndex = table.find(missingIndexes, nextIndex)
						if existingIndex then
							table.remove(missingIndexes, existingIndex)
						end

						if nextIndex > index then
							for i = index + 1, nextIndex - 1 do
								if i ~= index and not table.find(missingIndexes, i) then
									table.insert(missingIndexes, i)
								end
							end
						else
							for i = index - 1, nextIndex + 1, -1 do
								if not table.find(missingIndexes, i) then
									table.insert(missingIndexes, i)
								end
							end
						end
					elseif not invalidKeys then
						invalidKeys = { nextIndex }
					else
						table.insert(invalidKeys, nextIndex)
					end
				end

				table.sort(missingIndexes)

				error(
					('"enumValues" (#2 argument) table which type presumably should be an Array<string> contains (%s) missing index%s%s'):format(
						table.concat(missingIndexes, ", "),
						if #missingIndexes == 1 then "" else "es",
						if invalidKeys then (" as well as invalid keys (%s)"):format(outputHelper(unpack(invalidKeys, 1, #invalidKeys))) else ""
					),
					2
				)
			end

			if type(value) ~= "string" then
				error(('invalid value provided in "enumValues" (#2 argument) table which presumably should be an Array<string>, expected a string but got (%s) instead'):format(outputHelper(value)), 2)
			elseif value == "" then
				error('empty string provided as a value in "enumValues" (#2 argument) table which presumably should be an Array<string>, expected non-empty string', 2)
			end

			processedValuesMap[value] = true

			local enumeratorItem = table.freeze(setmetatable(
				{ name = value, type = enumerator, value = value },
				table.freeze({
					__tostring = function()
						return ("%s.%s"):format(enumeratorName, value)
					end,
				})
			)) :: EnumeratorItem<string>

			keysToEnumeratorItems[value] = enumeratorItem
			valuesToEnumeratorItems[value] = enumeratorItem
		end
	else
		local firstValueType = typeof(select(2, next(enumValues)))

		for key, value in pairs(enumValues :: Record<string, T>) do
			if type(key) ~= "string" then
				error(
					('invalid key specified in "enumValues" (#2 argument) whose type is presumably is a Record<string, %s>, expected a string but got (%s) instead'):format(
						firstValueType,
						outputHelper(key)
					),
					2
				)
			elseif key == "" then
				error(('empty string provided as a key in "enumValues" (#2 argument) which is presumably should be a Record<string, %s>, expected a non-empty string'):format(firstValueType), 2)
			end

			local valueType = typeof(value)
			if valueType ~= firstValueType then
				error(
					('"enumValues" (#2 argument) table which presumably should be a Record<string, %s> contains invalid value (%s), expected value of (%s) type'):format(
						firstValueType,
						outputHelper(value),
						firstValueType
					),
					2
				)
			end

			local enumeratorItem = table.freeze(setmetatable(
				{ name = key, type = enumerator, value = value },
				table.freeze({
					__tostring = function()
						return ("%s.%s"):format(enumeratorName, key)
					end,
				})
			)) :: EnumeratorItem<T>

			keysToEnumeratorItems[key] = enumeratorItem
			valuesToEnumeratorItems[value] = enumeratorItem
			totalEnumeratorItems += 1
		end
	end

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

	function enumerator.getEnumeratorItems()
		local enumeratorItems = table.create(totalEnumeratorItems) :: Array<EnumeratorItem<T>>
		local length = 0

		for _, enumeratorItem in pairs(keysToEnumeratorItems) do
			length += 1
			enumeratorItems[length] = enumeratorItem
		end

		return enumeratorItems
	end

	return table.freeze(setmetatable(
		enumerator,
		table.freeze({
			__index = keysToEnumeratorItems,
			__tostring = function()
				return enumeratorName
			end,
		})
	)) :: Enumerator<T>
end

return EnumeratorConstructor
