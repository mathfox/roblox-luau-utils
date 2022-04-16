local TimeUtilsExport = {
	sync = function(syncTime: number)
		if math.abs(syncTime) == math.huge then
			error("expected positive number, infinity provided", 2)
		elseif syncTime == 0 then
			error("expected positive number, zero provided", 2)
		end

		local currentTime = (DateTime.now().UnixTimestampMillis % (syncTime * 1000) / 1000)
		return task.wait(if currentTime > syncTime then syncTime * 2 - currentTime else syncTime - currentTime)
	end,
}

table.freeze(TimeUtilsExport)

return TimeUtilsExport :: {
	sync: (syncTime: number) -> number,
}
