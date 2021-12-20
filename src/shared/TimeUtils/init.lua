local dateTimeNow = DateTime.now

local function getUnixTime(): number
	return dateTimeNow().UnixTimestamp
end

local function sync(syncTime: number): number
	if type(syncTime) ~= "number" then
		error("#1 argument must be a number!", 2)
	elseif math.abs(syncTime) == math.huge then
		error("expected positive number, infinity provided", 2)
	elseif syncTime == 0 then
		error("expected positive number, zero provided", 2)
	end

	local currentTime = (dateTimeNow().UnixTimestampMillis % (syncTime * 1000) / 1000)
	if currentTime > syncTime then
		return task.wait(syncTime * 2 - currentTime)
	end

	return task.wait(syncTime - currentTime)
end

local TimeUtilsMetatable = {}

function TimeUtilsMetatable:__index(index): (DateTime | number)?
	if index == "unix" or index == "unixTime" then
		return getUnixTime()
	elseif index == "now" then
		return dateTimeNow()
	end
end

local TimeUtils = setmetatable({
	getUnixTime = getUnixTime,
	getTimeNow = dateTimeNow,
	sync = sync,
}, TimeUtilsMetatable)

return TimeUtils
