local function getDescendantsWhichIsA(parent: Instance, className: string): { Instance }
	local descendants = parent:GetDescendants()
	local arr = table.create(#descendants)

	for _, descendant in descendants do
		if descendant:IsA(className) then
			table.insert(arr, descendant)
		end
	end

	return arr
end

return getDescendantsWhichIsA
