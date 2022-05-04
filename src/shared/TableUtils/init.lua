local TableUtils = {
	assign = require(script.assign),
	copy = require(script.copy),
	deepSafeFreeze = require(script.deepSafeFreeze),
	every = require(script.every),
	everyArray = require(script.everyArray),
	extend = require(script.extend),
	filter = require(script.filter),
	filterArray = require(script.filterArray),
	find = require(script.find),
	findArray = require(script.findArray),
	join = require(script.join),
	joinArray = require(script.joinArray),
	keys = require(script.keys),
	length = require(script.length),
	map = require(script.map),
	override = require(script.override),
	random = require(script.random),
	reverse = require(script.reverse),
	safeFreeze = require(script.safeFreeze),
	shuffle = require(script.shuffle),
	some = require(script.some),
   someArray = require(script.someArray),
	values = require(script.values),
}

table.freeze(TableUtils)

return TableUtils
