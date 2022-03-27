local Types = require(script.Types)

type InstanceCacheParams<I> = Types.InstanceCacheParams<I>
type InstanceCache<I> = Types.InstanceCache<I>

local InstanceCache = {}
InstanceCache.prototype = {} :: InstanceCache<Instance> & {
	_available: { Instance },
	_inUse: { Instance },
	_params: InstanceCacheParams<Instance>,
	parent: Instance?,
}
InstanceCache.__index = InstanceCache.prototype

function InstanceCache.is(object)
	return type(object) == "table" and getmetatable(object) == InstanceCache
end

function InstanceCache.new<I>(params: InstanceCacheParams<I>): InstanceCache<I>
	local self = setmetatable({
		_available = {},
		_inUse = {},
		_params = params,
		parent = params.parent,
	}, InstanceCache)

	self:expand(params.amount.initial)

	return self
end

function InstanceCache.prototype:getInstance()
	if #self._available == 0 then
		self:expand(self._params.amount.expansion)
	end

	local instance: Instance = table.remove(self._available, #self._available)
	table.insert(self._inUse, instance)
	return instance
end

function InstanceCache.prototype:returnInstance(instance: Instance)
	table.insert(
		self._available,
		table.remove(
			self._inUse,
			table.find(self._inUse, instance)
				or error("attempted to return Instance which was not retrieved using 'getInstance'", 2)
		)
	)
end

function InstanceCache.prototype:setParent(parent: Instance?)
	self.parent = parent

	for _, instance in ipairs(self._available) do
		instance.Parent = parent
	end
end

function InstanceCache.prototype:expand(amount: number)
	for _ = 1, amount do
		local clone = self._params.instance:Clone()
		clone.Parent = self.parent
		table.insert(self._available, clone)
	end
end

function InstanceCache.prototype:destroy()
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

return InstanceCache :: {
	is: (object: any) -> boolean,
	new: <I>(InstanceCacheParams<I>) -> InstanceCache<I>,
}
