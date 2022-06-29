local function loadDescendants(parent: Instance): { any }
	local arr = {}

	for _, descendant in parent:GetDescendants() do
		if descendant:IsA("ModuleScript") then
			table.insert(arr, require(descendant))
		end
	end

	return arr
end

return loadDescendants
