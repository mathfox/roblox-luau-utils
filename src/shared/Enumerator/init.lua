-- refactored version of: https://github.com/howmanysmall/enumerator

local Types = require(script.Parent.Types)

export type EnumeratorItem<T = string> = Types.EnumeratorItem<T>
export type Enumerator<T = string> = Types.Enumerator<T>

local function EnumeratorConstructor<T>(enumeratorName: string, enumeratorValues: { string } | { [string]: T }): Enumerator<T>
	local enumerator = {}
	local valuesToEnumeratorItems: { [T]: EnumeratorItem<T> } = {}

	function enumerator.fromRawValue(rawValue): EnumeratorItem<T>?
		return valuesToEnumeratorItems[rawValue]
	end

	function enumerator.isEnumeratorItem(value)
		if typeof(value) ~= "table" then
			return false
		end

		for _, enumeratorItem in valuesToEnumeratorItems do
			if enumeratorItem == value then
				return true
			end
		end

		return false
	end

	function enumerator.getEnumeratorItems(): { EnumeratorItem<T> }
		local enumeratorItems = {}

		for _, enumeratorItem in valuesToEnumeratorItems do
			table.insert(enumeratorItems, enumeratorItem)
		end

		return enumeratorItems
	end

	if #enumeratorValues == 0 then
		local keysToEnumeratorItems: { [string]: EnumeratorItem<T> } = {}

		for key, value in enumeratorValues :: { [string]: T } do
			local enumeratorItem = table.freeze(setmetatable(
				{ name = key, value = value, type = enumerator },
				table.freeze({
					__tostring = function()
						return ("%s.%s"):format(enumeratorName, key)
					end,
				})
			)) :: EnumeratorItem<T>

			keysToEnumeratorItems[key] = enumeratorItem
			valuesToEnumeratorItems[value] = enumeratorItem
		end

		return table.freeze(setmetatable(
			enumerator,
			table.freeze({
				__index = keysToEnumeratorItems,
				__tostring = function()
					return enumeratorName
				end,
			})
		))
	else
		for index, value in enumeratorValues :: { string } do
			valuesToEnumeratorItems[value] = table.freeze(setmetatable(
				{ name = value, value = value, type = enumerator },
				table.freeze({
					__tostring = function()
						return ("%s.%s"):format(enumeratorName, value)
					end,
				})
			)) :: EnumeratorItem
		end

		return table.freeze(setmetatable(
			enumerator,
			table.freeze({
				__index = valuesToEnumeratorItems,
				__tostring = function()
					return enumeratorName
				end,
			})
		))
	end
end

return EnumeratorConstructor
