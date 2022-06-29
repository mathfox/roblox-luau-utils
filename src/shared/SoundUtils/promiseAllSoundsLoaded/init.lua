local Promise = require(script.Parent.Parent.Promise)
local Types = require(script.Parent.Parent.Types)

local promiseSoundLoaded = require(script.Parent.promiseSoundLoaded)

type Promise<T...> = Types.Promise<T...>

local function promiseAllSoundsLoaded(sounds: { Sound }): Promise<{ Sound }>
	local promises = {}

	for _, sound in sounds do
		table.insert(promises, promiseSoundLoaded(sound))
	end

	return Promise.all(promises)
end

return promiseAllSoundsLoaded
