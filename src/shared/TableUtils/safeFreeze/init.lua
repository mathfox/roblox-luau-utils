local function safeFreeze(tbl: { [any]: any })
	if not table.isfrozen(tbl) then
		table.freeze(tbl)
	end
end

return safeFreeze
