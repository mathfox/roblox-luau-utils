local function extend<V>(tbl: { V }, extension: { V }): { V }
	return table.move(extension, 1, #extension, #tbl + 1, table.clone(tbl))
end

return extend
