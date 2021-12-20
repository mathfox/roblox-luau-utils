local OrderedDataStore3Prototype = require(script.OrderedDataStore3Prototype)
local GlobalDataStore3Prototype = require(script.GlobalDataStore3Prototype)
local DataStore3Prototype = require(script.DataStore3Prototype)

local DataStore3 = {
	DataStore3 = setmetatable({}, DataStore3Prototype),
	OrderedDataStore3 = setmetatable({}, OrderedDataStore3Prototype),
	GlobalDataStore3 = setmetatable({}, GlobalDataStore3Prototype),
}

return DataStore3
