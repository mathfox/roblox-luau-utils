local Promise = require(script.Parent.Parent.Promise)

local function promiseComputeAsync(path: Path, startVec3: Vector3, finishVec3: Vector3)
	return Promise.defer(function(resolve)
		path:ComputeAsync(startVec3, finishVec3)
		resolve(path)
	end)
end

return promiseComputeAsync
