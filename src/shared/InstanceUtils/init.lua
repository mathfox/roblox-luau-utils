local Promise = require(script.Parent.Promise)

local function findFirstDescendantOfClass(parent: Instance, className: string): Instance?
	local children = parent:GetChildren()

	for _, child in ipairs(children) do
		if child.ClassName == className then
			return child
		end
	end

	for _, child in ipairs(children) do
		local descendant = findFirstDescendantOfClass(child, className)
		if descendant then
			return descendant
		end
	end

	return nil
end

local function findFirstDescendantWhichIsA(parent: Instance, className: string): Instance?
	local children = parent:GetChildren()

	for _, child in ipairs(children) do
		if child:IsA(className) then
			return child
		end
	end

	for _, child in ipairs(children) do
		local descendant = findFirstDescendantWhichIsA(child, className)
		if descendant then
			return descendant
		end
	end

	return nil
end

local function getChildrenOfClass(parent: Instance, className: string): { Instance }
	local tbl = {}
	for _, child in ipairs(parent:GetChildren()) do
		if child.ClassName == className then
			table.insert(tbl, child)
		end
	end
	return tbl
end

local function getChildrenWhichIsA(parent: Instance, className: string): { Instance }
	local tbl = {}
	for _, child in ipairs(parent:GetChildren()) do
		if child:IsA(className) then
			table.insert(tbl, child)
		end
	end
	return tbl
end

local function getDescendantsOfClass(parent: Instance, className: string): { Instance }
	local tbl = {}
	for _, descendant in ipairs(parent:GetDescendants()) do
		if descendant.ClassName == className then
			table.insert(tbl, descendant)
		end
	end
	return tbl
end

local function getDescendantsWhichIsA(parent: Instance, className: string): { Instance }
	local tbl = {}
	for _, descendant in ipairs(parent:GetDescendants()) do
		if descendant:IsA(className) then
			table.insert(tbl, descendant)
		end
	end
	return tbl
end

local function waitForChildOfClass(parent: Instance, className: string, timeOut: number?): Instance?
	if not timeOut then
		local child = parent:FindFirstChildOfClass(className)
		while not child or child.ClassName ~= className do
			child = parent.ChildAdded:Wait()
		end
		return child
	end

	return parent:FindFirstChildOfClass(className)
		or Promise.fromEvent(parent.ChildAdded, function(child)
			return child.ClassName == className, child
		end)
			:timeout(timeOut)
			:catch(function()
				return nil
			end)
			:expect()
end

local function waitForChildWhichIsA(parent: Instance, className: string, timeOut: number?): Instance?
	if not timeOut then
		local child = parent:FindFirstChildWhichIsA(className)
		while not child or not child:IsA(className) do
			child = parent.ChildAdded:Wait()
		end
		return child
	end

	return parent:FindFirstChildWhichIsA(className)
		or Promise.fromEvent(parent.ChildAdded, function(child)
			return child.ClassName == className, child
		end)
			:timeout(timeOut)
			:catch(function()
				return nil
			end)
			:expect()
end

local function waitForDescendantOfClass(parent: Instance, className: string, timeOut: number?): Instance?
	if not timeOut then
		local descendant = findFirstDescendantOfClass(parent, className)
		while not descendant or descendant.ClassName ~= className do
			descendant = parent.DescendantAdded:Wait()
		end
		return descendant
	end

	return findFirstDescendantOfClass(parent, className)
		or Promise.fromEvent(parent.DescendantAdded, function(descendant)
			return descendant.ClassName == className, descendant
		end)
			:timeout(timeOut)
			:catch(function()
				return nil
			end)
			:expect()
end

local function waitForDescendantWhichIsA(parent: Instance, className: string, timeOut: number?): Instance?
	if not timeOut then
		local descendant = findFirstDescendantWhichIsA(parent, className)
		while not descendant or not descendant:IsA(className) do
			descendant = parent.DescendantAdded:Wait()
		end
		return descendant
	end

	return findFirstDescendantWhichIsA(parent, className)
		or Promise.fromEvent(parent.DescendantAdded, function(descendant)
			return descendant.ClassName == className, descendant
		end)
			:timeout(timeOut)
			:catch(function()
				return nil
			end)
			:expect()
end

local function clearAllChildrenOfClass(parent: Instance, className: string)
	for _, child in ipairs(getChildrenOfClass(parent, className)) do
		child:Destroy()
	end
end

local function clearAllChildrenWhichIsA(parent: Instance, className: string)
	for _, child in ipairs(getChildrenWhichIsA(parent, className)) do
		child:Destroy()
	end
end

local function clearAllDescendantsOfClass(parent: Instance, className: string)
	for _, descendant in ipairs(getDescendantsOfClass(parent, className)) do
		descendant:Destroy()
	end
end

local function clearAllDescendantsWhichIsA(parent: Instance, className: string)
	for _, descendant in ipairs(getDescendantsWhichIsA(parent, className)) do
		descendant:Destroy()
	end
end

local function getInstanceMass(instance: BasePart | Model): number
	if instance:IsA("BasePart") then
		return instance:GetMass()
	end

	local totalMass = 0
	for _, descendant in ipairs(instance:GetDescendants()) do
		if descendant:IsA("BasePart") then
			totalMass += descendant:GetMass()
		end
	end
	return totalMass
end

local InstanceUtils = {
	findFirstDescendantOfClass = findFirstDescendantOfClass,
	findFirstDescendantWhichIsA = findFirstDescendantWhichIsA,
	FindFirstDescendantOfClass = findFirstDescendantOfClass,
	FindFirstDescendantWhichIsA = findFirstDescendantWhichIsA,

	getChildrenOfClass = getChildrenOfClass,
	getChildrenWhichIsA = getChildrenWhichIsA,
	GetChildrenOfClass = getChildrenOfClass,
	GetChildrenWhichIsA = getChildrenWhichIsA,

	getDescendantsOfClass = getDescendantsOfClass,
	getDescendantsWhichIsA = getDescendantsWhichIsA,
	GetDescendantsOfClass = getDescendantsOfClass,
	GetDescendantsWhichIsA = getDescendantsWhichIsA,

	waitForChildOfClass = waitForChildOfClass,
	waitForChildWhichIsA = waitForChildWhichIsA,
	WaitForChildOfClass = waitForChildOfClass,
	WaitForChildWhichIsA = waitForChildWhichIsA,

	waitForDescendantOfClass = waitForDescendantOfClass,
	waitForDescendantWhichIsA = waitForDescendantWhichIsA,
	WaitForDescendantOfClass = waitForDescendantOfClass,
	WaitForDescendantWhichIsA = waitForDescendantWhichIsA,

	clearAllChildrenOfClass = clearAllChildrenOfClass,
	clearAllChildrenWhichIsA = clearAllChildrenWhichIsA,
	ClearAllChildrenOfClass = clearAllChildrenOfClass,
	ClearAllChildrenWhichIsA = clearAllChildrenWhichIsA,

	clearAllDescendantsOfClass = clearAllDescendantsOfClass,
	clearAllDescendantsWhichIsA = clearAllDescendantsWhichIsA,
	ClearAllDescendantsOfClass = clearAllDescendantsOfClass,
	ClearAllDescendantsWhichIsA = clearAllDescendantsWhichIsA,

	getInstanceMass = getInstanceMass,
	GetInstanceMass = getInstanceMass,
}

return InstanceUtils
