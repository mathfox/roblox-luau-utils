local Promise = require(script.Parent.Parent.Promise)
local Types = require(script.Parent.Parent.Types)

type Promise<T...> = Types.Promise<T...>

local function promiseSoundLoaded(sound: Sound): Promise<Sound>
	return if sound.IsLoaded
		then Promise.resolve(sound)
		else Promise.fromEvent(sound.Loaded, function()
			return sound.IsLoaded
		end):andThenReturn(sound)
end

return promiseSoundLoaded
