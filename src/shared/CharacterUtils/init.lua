local CharacterUtils = {
	getPlayerFromCharacterDescendant = require(script.getPlayerFromCharacterDescendant),
	getAlivePlayerRootPart = require(script.getAlivePlayerRootPart),
	getAlivePlayerHumanoid = require(script.getAlivePlayerHumanoid),
	unequipPlayerTools = require(script.unequipPlayerTools),
	getPlayerHumanoid = require(script.getPlayerHumanoid),
	getPlayerRootPart = require(script.getPlayerRootPart),
}

table.freeze(CharacterUtils)

return CharacterUtils
