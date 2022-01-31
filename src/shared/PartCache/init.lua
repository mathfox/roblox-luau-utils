export type PartCache = {
	parent: Instance,
	expansionSize: number,
}

local CFRAME_MATH_HUGE = CFrame.new(0, math.huge, 0)

local function cloneFromTemplate(template: BasePart, currentCacheParent: Instance): BasePart
	local part = template:Clone()
	part.CFrame = CFRAME_MATH_HUGE
	part.Anchored = true
	part.Parent = currentCacheParent
	return part
end

local PartCache = {}
PartCache.__index = PartCache

function PartCache.new(template: BasePart, numPrecreatedParts: number, cacheParent: Instance?): PartCache
	assert(numPrecreatedParts > 0, "numPrecreatedParts can not be negative or equal to 0!")

	local self = setmetatable({
		_available = {},
		_availableAmount = numPrecreatedParts,
		_inUse = {},
		parent = cacheParent,
		_template = template,
		expansionSize = 10,
	}, PartCache)

	self:expand(numPrecreatedParts)

	return self
end

function PartCache:getPart(): BasePart
	local availableBaseParts = self._available

	if self._availableAmount == 0 then
		self:expand()

		self._availableAmount = self.expansionSize
	end

	local basePart: BasePart = availableBaseParts[self._availableAmount]
	basePart.Anchored = self._template.Anchored

	table.remove(availableBaseParts, self._availableAmount)
	self._availableAmount -= 1

	table.insert(self._inUse, basePart)

	return basePart
end

-- Returns a part to the cache.
function PartCache:returnPart(basePart: BasePart)
	local inUseBaseParts = self._inUse

	local partIndex: number? = table.find(inUseBaseParts, basePart)
	assert(partIndex, "attempted to return part which was never used")

	table.remove(inUseBaseParts, partIndex)
	table.insert(self._available, basePart)
	self._availableAmount += 1

	basePart.Anchored = true
	basePart.CFrame = CFRAME_MATH_HUGE
end

function PartCache:setCacheParent(cacheParent: Instance)
	self.parent = cacheParent

	for _, basePart in ipairs(self._available) do
		basePart.Parent = cacheParent
	end

	for _, basePart in ipairs(self._inUse) do
		basePart.Parent = cacheParent
	end
end

function PartCache:expand(numParts: number)
	for _ = 1, numParts or self.expansionSize do
		table.insert(self._available, cloneFromTemplate(self._template, self.parent))
	end
end

-- Destroys this cache entirely. Use this when you don't need this cache object anymore.
function PartCache:destroy()
	for _, basePart in ipairs(self._available) do
		basePart:Destroy()
	end

	for _, basePart in ipairs(self._inUse) do
		basePart:Destroy()
	end

	setmetatable(self, nil)
end

return PartCache
