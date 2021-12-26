local Promise = require(script.Parent.Promise)

type SoundLoadedPromise = typeof(Promise.fromEvent(Instance.new("BindableEvent").Event, function() end))

local function promiseSoundLoaded(sound: Sound): SoundLoadedPromise
	if sound == nil then
		error("missing argument #1 to 'promiseSoundLoaded' (Sound expected)")
	elseif typeof(sound) ~= "Instance" or not sound:IsA("Sound") then
		error(("invalid argument #1 to 'promiseSoundLoaded' (Sound expected, got %s)"):format(typeof(sound)))
	end

	if sound.IsLoaded then
		return Promise.resolve()
	end

	return Promise.fromEvent(sound.Loaded, function()
		return sound.IsLoaded
	end)
end

local function promiseAllSoundsLoaded(sounds: { Sound }): typeof(Promise.all({}))
	local promises: { SoundLoadedPromise } = {}

	for _, sound in ipairs(sounds) do
		table.insert(promises, promiseSoundLoaded(sound))
	end

	return Promise.all(promises)
end

local SoundUtils = {
	promiseSoundLoaded = promiseSoundLoaded,
	promiseAllSoundsLoaded = promiseAllSoundsLoaded,
}

return SoundUtils
