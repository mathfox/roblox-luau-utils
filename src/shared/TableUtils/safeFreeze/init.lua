local function safeFreeze(source: { [any]: any })
	if not table.isfrozen(source) then
		table.freeze(source)
	end
end

return safeFreeze
