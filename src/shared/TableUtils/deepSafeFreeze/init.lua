local function deepSafeFreeze(source: { [any]: any })
	if not table.isfrozen(source) then
		table.freeze(source)
	end

	for _, value in source do
		if type(value) == "table" then
			deepSafeFreeze(value)
		end
	end
end

return deepSafeFreeze
