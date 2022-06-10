local Promise = require(script.Parent.Parent.Promise)
local Types = require(script.Parent.Parent.Types)

local promiseSoundLoaded = require(script.Parent.promiseSoundLoaded)

type Promise<T...> = Types.Promise<T...>
type Array<T> = Types.Array<T>

local function promiseAllSoundsLoaded(sounds: Array<Sound>): Promise<Array<Sound>>
	local promises = {}

	for _, sound in sounds do
		table.insert(promises, promiseSoundLoaded(sound))
	end

	return Promise.all(promises)
end

return promiseAllSoundsLoaded
