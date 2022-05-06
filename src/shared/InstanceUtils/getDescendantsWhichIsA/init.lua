local Types = require(script.Parent.Parent.Types)

type Array<T> = Types.Array<T>

local function getDescendantsWhichIsA(parent: Instance, className: string)
	local descendants = parent:GetDescendants()
	local arr: Array<Instance> = table.create(#descendants)

	for _, descendant in ipairs(descendants) do
		if descendant:IsA(className) then
			table.insert(arr, descendant)
		end
	end

	return arr
end

return getDescendantsWhichIsA
