local Promise = require(script.Parent.Parent.Promise)

local function promiseSoundLoaded(sound: Sound)
	if sound == nil then
		error("missing argument #1 to 'promiseSoundLoaded' (Sound expected)")
	elseif typeof(sound) ~= "Instance" or not sound:IsA("Sound") then
		error(("invalid argument #1 to 'promiseSoundLoaded' (Sound expected, got %s)"):format(typeof(sound)))
	end

	if sound.IsLoaded then
		return Promise.resolve()
	end

	local function onSoundLoaded()
		return sound.IsLoaded
	end

	return Promise.fromEvent(sound.Loaded, onSoundLoaded)
end

return promiseSoundLoaded
