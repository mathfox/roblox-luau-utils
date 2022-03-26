local HttpService = game:GetService("HttpService")

local NUMERIC_STRING = "0123456789"

local UUID = {}

function UUID.new(rngOverride: Random?)
	local normalizedGUID = HttpService:GenerateGUID(false):gsub("-", "")
	local random = if rngOverride then rngOverride :: Random else Random.new()
	local uuid = ""

	for index = 1, normalizedGUID:len() do
		local letterOrNumber = normalizedGUID:sub(index, index)
		uuid ..= if NUMERIC_STRING:find(letterOrNumber)
			then letterOrNumber
			else if random:NextInteger(1, 2) == 1 then letterOrNumber:lower() else letterOrNumber
	end

	return uuid
end

return UUID
