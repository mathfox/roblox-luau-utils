local Promise = require(script.Parent.Parent.Promise)

local promiseSoundLoaded = require(script.Parent.promiseSoundLoaded)

export type SoundsList = { Sound }

local function promiseAllSoundsLoaded(sounds: SoundsList)
	local promises = {}

	for _, sound in ipairs(sounds) do
		table.insert(promises, promiseSoundLoaded(sound))
	end

	return Promise.all(promises)
end

return promiseAllSoundsLoaded
