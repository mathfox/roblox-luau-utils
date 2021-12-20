local PlayerStorageCachePrototype = require(script.PlayerStorageCachePrototype)

local PlayerStorageCache = {}

function PlayerStorageCache.new(onStorageSetup, initialVerifier)
	return setmetatable({
		_onSetup = onStorageSetup,
		_onVerify = initialVerifier,
		_cache = {},
	}, PlayerStorageCachePrototype)
end

return PlayerStorageCache
