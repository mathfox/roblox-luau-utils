local TableUtils = {
	length = require(script.length),

	copy = require(script.copy),
	copyShallow = require(script.copyShallow),

	map = require(script.map),
	filter = require(script.filter),

	assign = require(script.assign),
	extend = require(script.extend),
	override = require(script.override),

	reverse = require(script.reverse),
	shuffle = require(script.shuffle),

	keys = require(script.keys),
	values = require(script.values),

	find = require(script.find),
	every = require(script.every),
	some = require(script.some),

	random = require(script.random),

	safeFreeze = require(script.safeFreeze),
	deepSafeFreeze = require(script.deepSafeFreeze),
}

return TableUtils
