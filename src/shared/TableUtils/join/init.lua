local function join<K, V>(...: { [K]: V }?): { [K]: V }
	local result = {}

	for index = 1, select("#", ...) do
		local source = select(index, ...)
		if source ~= nil then
			for key, value in source do
				result[key] = value
			end
		end
	end

	return result
end

return join
