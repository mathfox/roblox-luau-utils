local SECONDS_IN_MINUTE = 60
local SECONDS_IN_HOUR = 3600
local SECONDS_IN_DAY = 86400

local TIMER_STRING_CACHE = {}
local TIME_STRING_CACHE = {}
local SHORT_NUMBER_CACHE = {}
local LONG_NUMBER_CACHE = {}

local ABBREVIATIONS = { "K", "M", "B", "T", "Qa", "Qi", "Sx", "Sp", "O", "N", "D" }

local function timerString(number: number): string
	if type(number) ~= "number" then
		error("#1 argument must be a number!", 2)
	end

	local cachedString = TIMER_STRING_CACHE[number]
	if cachedString then
		return cachedString
	end

	local resultString
	if number < SECONDS_IN_MINUTE then
		resultString = tostring(number)
	elseif number < SECONDS_IN_HOUR then
		resultString = string.format("%02i:%02i", number / 60 % 60, number % 60)
	elseif number < SECONDS_IN_DAY then
		resultString = string.format("%02i:%02i:%02i", number / SECONDS_IN_HOUR % 24, number / 60 % 60, number % 60)
	else
		resultString = string.format(
			"%02i:%02i:%02i:%02i",
			(number / SECONDS_IN_DAY) % 30,
			number / SECONDS_IN_HOUR % 24,
			number / 60 % 60,
			number % 60
		)
	end

	TIMER_STRING_CACHE[number] = resultString
	return resultString
end

local function timeString(number: number): string
	if type(number) ~= "number" then
		error("#1 argument must be a number!", 2)
	end

	local cachedString = TIME_STRING_CACHE[number]
	if cachedString then
		return cachedString
	end

	local absolute, resultString = math.abs(number), nil
	if absolute < SECONDS_IN_MINUTE then
		resultString = number .. " second"
		if absolute > 1 then
			resultString ..= "s"
		end
	elseif absolute < SECONDS_IN_HOUR then
		resultString = string.format("%d", number / 60 % 60) .. " minute"
		if absolute >= 120 then
			resultString ..= "s"
		end
	elseif absolute < SECONDS_IN_DAY then
		resultString = string.format("%d", number / 60 ^ 2) .. " hour"
		if absolute >= 7200 then
			resultString ..= "s"
		end
	else
		resultString = string.format("%d", number / (60 ^ 2 * 24) % 24) .. " day"
		if absolute >= SECONDS_IN_DAY then
			resultString ..= "s"
		end
	end

	TIME_STRING_CACHE[number] = resultString
	return resultString
end

local function longNumber(number: number): string
	if type(number) ~= "number" then
		error("#1 argument must be a number!", 2)
	end

	local cachedString = LONG_NUMBER_CACHE[number]
	if cachedString then
		return cachedString
	end

	local absolute, numberString, resultString = math.abs(number), tostring(number), nil
	if absolute < 1000 then
		resultString = numberString
	else
		local floored = math.floor(number)
		local resultString = (number < 0 and "-" or "")
			.. tostring(math.abs(floored)):reverse():gsub("%d%d%d", "%1,"):gsub(",$", ""):reverse()
		if number ~= floored then
			resultString ..= "." .. tostring(numberString:match("%d+.$"))
		end
	end

	LONG_NUMBER_CACHE[number] = resultString
	return resultString
end

local function shortNumber(number: number): string
	if type(number) ~= "number" then
		error("#1 argument must be a number!", 2)
	end

	local cachedString = SHORT_NUMBER_CACHE[number]
	if cachedString then
		return cachedString
	end

	local absolute, resultString = math.abs(number), nil
	if absolute < 1000 then
		resultString = tostring(number)
	else
		for numberPower, abbreviation in ipairs(ABBREVIATIONS) do
			local lowerNumber = 10 ^ (3 * numberPower)
			if absolute >= lowerNumber and absolute < lowerNumber ^ 2 then
				resultString = (number < 0 and "-" or "")
					.. tostring(math.floor((absolute / lowerNumber) * 10) / 10)
					.. abbreviation
			end
		end
	end

	if not resultString then
		return longNumber(number)
	end

	SHORT_NUMBER_CACHE[number] = resultString
	return resultString
end

local function ms(second: number): number
	return math.round(second * 1000)
end

local FormatUtils = {
	timerString = timerString,
	timeString = timeString,

	shortNumber = shortNumber,
	longNumber = longNumber,

	ms = ms,
}

return FormatUtils
