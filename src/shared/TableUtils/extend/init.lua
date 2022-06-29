local function extend<V>(target: { V }, ...: { V }?): { V }
	for index = 1, select("#", ...) do
		local source = select(index, ...)
		if source ~= nil then
			table.move(source, 1, #source, #target + 1, target)
		end
	end

	return target
end

return extend
