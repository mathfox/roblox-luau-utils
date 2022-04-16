local TableUtils = {
	assign = require(script.assign),
	copy = require(script.copy),
	deepSafeFreeze = require(script.deepSafeFreeze),
	every = require(script.every),
	extend = require(script.extend),
	filter = require(script.filter),
	find = require(script.find),
	keys = require(script.keys),
	length = require(script.length),
	map = require(script.map),
	override = require(script.override),
	random = require(script.random),
	reverse = require(script.reverse),
	safeFreeze = require(script.safeFreeze),
	shuffle = require(script.shuffle),
	some = require(script.some),
	values = require(script.values),
}

table.freeze(TableUtils)

return TableUtils
