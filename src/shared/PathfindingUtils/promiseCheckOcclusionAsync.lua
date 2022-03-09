local Promise = require(script.Parent.Parent.Promise)

local function promiseCheckOcclusionAsync(path: Path, startIndex: number)
	return Promise.defer(function(resolve)
		resolve(path:CheckOcclusionAsync(startIndex))
	end)
end

return promiseCheckOcclusionAsync
