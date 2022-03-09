local Promise = require(script.Parent.Parent.Promise)

local function promiseSoundLoaded(sound: Sound)
	return if sound.IsLoaded
		then Promise.resolve()
		else Promise.fromEvent(sound.Loaded, function()
			return sound.IsLoaded
		end)
end

return promiseSoundLoaded
