local TableUtils = {
	assign = require(script.assign),
	copy = require(script.copy),
	deepFreeze = require(script.deepFreeze),
	deepSafeFreeze = require(script.deepSafeFreeze),
	every = require(script.every),
	extend = require(script.extend),
	filter = require(script.filter),
	filterArray = require(script.filterArray),
	find = require(script.find),
	join = require(script.join),
	joinArray = require(script.joinArray),
	keys = require(script.keys),
	length = require(script.length),
	map = require(script.map),
	random = require(script.random),
	reverse = require(script.reverse),
	safeFreeze = require(script.safeFreeze),
	shuffle = require(script.shuffle),
	some = require(script.some),
	values = require(script.values),
}

table.freeze(TableUtils)

return TableUtils
