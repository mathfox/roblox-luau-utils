local TableUtils = {
	length = require(script.length),
	lengthFast = require(script.lengthFast),

	copy = require(script.copy),
	copyFast = require(script.copyFast),
	copyShallow = require(script.copyShallow),
	copyShallowFast = require(script.copyShallowFast),

	map = require(script.map),
	mapFast = require(script.mapFast),
	filter = require(script.filter),
	filterFast = require(script.filterFast),

	assign = require(script.assign),
	assignFast = require(script.assignFast),
	extend = require(script.extend),
	extendFast = require(script.extendFast),

	reverse = require(script.reverse),
	reverseFast = require(script.reverseFast),
	shuffle = require(script.shuffle),
	shuffleFast = require(script.shuffleFast),

	keys = require(script.keys),
	keysFast = require(script.keysFast),
	values = require(script.values),
	valuesFast = require(script.valuesFast),

	find = require(script.find),
	findFast = require(script.findFast),
	every = require(script.every),
	everyFast = require(script.everyFast),
	some = require(script.some),
	someFast = require(script.someFast),

	random = require(script.random),
	randomFast = require(script.randomFast),

	safeFreeze = require(script.safeFreeze),
	safeFreezeFast = require(script.safeFreezeFast),
	deepSafeFreeze = require(script.deepSafeFreeze),
	deepSafeFreezeFast = require(script.deepSafeFreezeFast),
}

return TableUtils
