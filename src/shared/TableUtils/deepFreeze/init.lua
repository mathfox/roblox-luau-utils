local function deepFreeze(target: { [any]: any })
	table.freeze(target)

	for _, source in pairs(target) do
		if type(source) == "table" then
			deepFreeze(source)
		end
	end
end

return deepFreeze
