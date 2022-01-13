local Promise = require(script.Parent.Parent.Promise)

local function promiseComputeAsync(path: Path, startVector3: Vector3, finishVector3: Vector3)
	if typeof(path) ~= "Instance" or not path:IsA("Path") then
		error("#1 argument must be a Path!", 2)
	elseif typeof(startVector3) ~= "Vector3" then
		error("#2 argument must be a Vector3!", 2)
	elseif typeof(finishVector3) ~= "Vector3" then
		error("#3 argument must be a Vector3!", 2)
	end

	return Promise.defer(function(resolve)
		path:ComputeAsync(startVector3, finishVector3)
		resolve(path)
	end)
end

return promiseComputeAsync