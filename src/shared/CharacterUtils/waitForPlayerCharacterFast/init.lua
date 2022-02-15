local function waitForPlayerCharacterFast(player: Player): Model
	return player.Character or player.CharacterAdded:Wait()
end

return waitForPlayerCharacterFast
