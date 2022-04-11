local Types = require(script.Parent.Types)

type InstanceCacheParams<T> = Types.InstanceCacheParams<T>
type InstanceCache<T> = Types.InstanceCache<T>

local InstanceCache = {}
InstanceCache.__index = InstanceCache

function InstanceCache:getInstance()
	if #self._available == 0 then
		self:expand(self.params.amount.expansion)
	end

	local instance = table.remove(self._available, #self._available)
	table.insert(self._inUse, instance)
	return instance
end

function InstanceCache:returnInstance(instance: Instance)
	table.insert(
		self._available,
		table.remove(
			self._inUse,
			table.find(self._inUse, instance)
				or error("attempted to return Instance which was not retrieved using 'getInstance'", 2)
		)
	)
end

function InstanceCache:setParent(parent: Instance?)
	self.parent = parent

	for _, instance in ipairs(self._available) do
		instance.Parent = parent
	end
end

function InstanceCache:expand(amount: number)
	for _ = 1, amount do
		local clone = self.params.instance:Clone()
		clone.Parent = self.parent
		table.insert(self._available, clone)
	end
end

function InstanceCache:destroy()
	for _, instance in ipairs(self._available) do
		instance:Destroy()
	end

	for _, instance in ipairs(self._inUse) do
		instance:Destroy()
	end

	setmetatable(self, nil)

	-- allow gc
	table.clear(self)
end

return {
	is = function(v)
		return type(v) == "table" and getmetatable(v) == InstanceCache
	end,
	new = function(params)
		local self = setmetatable({
			params = params,
			parent = params.parent,
			_available = {},
			_inUse = {},
		}, InstanceCache)

		self:expand(params.amount.initial)

		return self
	end,
} :: {
	is: (v: any) -> boolean,
	new: <I>(params: InstanceCacheParams<I>) -> InstanceCache<I>,
}
