local Promise = require(script.Parent.Parent.Promise)

local promiseSoundLoaded = require(script.Parent.promiseSoundLoaded)

local function promiseAllSoundsLoaded(sounds: { Sound })
	local promises = {}

	for _, sound in ipairs(sounds) do
		table.insert(promises, promiseSoundLoaded(sound))
	end

	return Promise.all(promises)
end

return promiseAllSoundsLoaded
