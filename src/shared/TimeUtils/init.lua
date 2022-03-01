local function getUnixTime(): number
	return DateTime.now().UnixTimestamp
end

local function sync(syncTime: number): number
	if type(syncTime) ~= "number" then
		error("#1 argument must be a number!", 2)
	elseif math.abs(syncTime) == math.huge then
		error("expected positive number, infinity provided", 2)
	elseif syncTime == 0 then
		error("expected positive number, zero provided", 2)
	end

	local currentTime = (DateTime.now().UnixTimestampMillis % (syncTime * 1000) / 1000)
	return task.wait(if currentTime > syncTime then syncTime * 2 - currentTime else syncTime - currentTime)
end

local TimeUtilsMetatable = {}

function TimeUtilsMetatable:__index(index): DateTime | number | nil
	if index == "unix" or index == "unixTime" then
		return getUnixTime()
	elseif index == "now" then
		return DateTime.now()
	end
end

local TimeUtils = setmetatable({
	getUnixTime = getUnixTime,
	getTimeNow = DateTime.now,
	sync = sync,
}, TimeUtilsMetatable)

return TimeUtils
