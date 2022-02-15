local waitForPlayerCharacterFast = require(script.Parent.waitForPlayerCharacterFast)

local function waitForPlayerCharacter(player: Player): Model
	if player == nil then
		error("missing argument #1 to 'waitForPlayerCharacter' (Player expected)", 2)
	elseif typeof(player) ~= "Instance" or not player:IsA("Player") then
		error(("invalid argument #1 to 'waitForPlayerCharacter' (Player expected, got %s)"):format(typeof(player)), 2)
	end

	return waitForPlayerCharacterFast(player)
end

return waitForPlayerCharacter
