local function waitForPlayerCharacter(player: Player)
	return player.Character or player.CharacterAdded:Wait()
end

return waitForPlayerCharacter
