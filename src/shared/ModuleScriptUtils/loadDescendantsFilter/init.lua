local function loadDescendantsFilter(parent: Instance, predicate: (ModuleScript) -> boolean): { any }
	local arr = {}

	for _, descendant in parent:GetDescendants() do
		if descendant:IsA("ModuleScript") and predicate(descendant) then
			table.insert(arr, require(descendant))
		end
	end

	return arr
end

return loadDescendantsFilter
