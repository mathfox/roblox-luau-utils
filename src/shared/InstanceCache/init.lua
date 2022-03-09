local Types = require(script.Types)

local InstanceCache = {}
InstanceCache.prototype = {}
InstanceCache.__index = InstanceCache.prototype

function InstanceCache.new(params: Types.InstanceCacheParams): Types.InstanceCache
	local self = setmetatable({
		_available = {},
		_inUse = {},
		_params = params,
		parent = params.parent,
	}, InstanceCache)

	self:Expand(params.amount.initial)

	return self
end

function InstanceCache.prototype:GetInstance()
	local available = self._available

	if #available == 0 then
		self:Expand()
	end

	local instance: Instance = available[#available]

	table.remove(available, #available)
	table.insert(self._inUse, instance)

	return instance
end

function InstanceCache.prototype:ReturnInstance(instance: Instance)
	local inUse = self._inUse

	local index = table.find(inUse, instance)
	if not index then
		error("Attempted to return Instance which was never used.", 2)
	end

	table.remove(inUse, index)
	table.insert(self._available, instance)
end

function InstanceCache.prototype:SetParent(parent: Instance?)
	self.parent = parent

	for _, instance in ipairs(self._available) do
		instance.Parent = parent
	end
end

function InstanceCache.prototype:Expand(amount: number)
	local parent = self.parent

	for _ = 1, amount or self._params.amount.expansion do
		local clone = self._params.template:Clone()
		clone.Parent = parent

		table.insert(self._available, clone)
	end
end

function InstanceCache.prototype:Destroy()
	for _, field in ipairs({ "_inUse", "_available" }) do
		for _, instance in ipairs(self[field]) do
			instance:Destroy()
		end

		table.clear(self[field])
	end
end

InstanceCache.prototype.getInstance = InstanceCache.prototype.GetInstance
InstanceCache.prototype.returnInstance = InstanceCache.prototype.ReturnInstance
InstanceCache.prototype.setParent = InstanceCache.prototype.SetParent
InstanceCache.prototype.expand = InstanceCache.prototype.Expand
InstanceCache.prototype.destroy = InstanceCache.prototype.Destroy

return InstanceCache
