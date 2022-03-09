local function waitForPlayerCharacterFast(player: Player)
	return player.Character or player.CharacterAdded:Wait()
end

return waitForPlayerCharacterFast
