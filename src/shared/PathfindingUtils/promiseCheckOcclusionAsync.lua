local Promise = require(script.Parent.Parent.Promise)

local function promiseCheckOcclusionAsync(path: Path, startIndex: number)
	if typeof(path) ~= "Instance" or not path:IsA("Path") then
		error("#1 argument must be a Path!", 2)
	elseif type(startIndex) ~= "number" then
		error("#2 argument must be a number!", 2)
	end

	return Promise.defer(function(resolve)
		resolve(path:CheckOcclusionAsync(startIndex))
	end)
end

return promiseCheckOcclusionAsync