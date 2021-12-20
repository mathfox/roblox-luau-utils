local Players = game:GetService("Players")

local function getPlayerHumanoid(player: Player): Humanoid?
	local character = player.Character
	if character then
		return character:FindFirstChildOfClass("Humanoid")
	end

	return nil
end

local function getAlivePlayerHumanoid(player: Player): Humanoid?
	local humanoid = getPlayerHumanoid(player)
	if humanoid and humanoid.Health > 0 then
		return humanoid
	end

	return nil
end

local function getPlayerRootPart(player: Player): BasePart?
	local humanoid = getPlayerHumanoid(player)
	if humanoid then
		return humanoid.RootPart
	end

	return nil
end

local function getAlivePlayerRootPart(player: Player): BasePart?
	local humanoid = getPlayerHumanoid(player)
	if humanoid and humanoid.Health > 0 then
		return humanoid.RootPart
	end

	return nil
end

local function getPlayerFromCharacterDescendant(descendant: Instance?): Player?
	local character = descendant

	while character do
		local player: Player? = Players:GetPlayerFromCharacter(character)
		if player then
			return player
		end

		character = character.Parent
	end

	return nil
end

local function unequipTools(player: Player)
	local humanoid = getPlayerHumanoid(player)
	if humanoid then
		humanoid:UnequipTools()
	end
end

local function waitForPlayerCharacter(player: Player): Model
	return player.Character or player.CharacterAdded:Wait()
end

local CharacterUtils = {
	getPlayerHumanoid = getPlayerHumanoid,
	GetPlayerHumanoid = getPlayerHumanoid,

	getAlivePlayerHumanoid = getAlivePlayerHumanoid,
	GetAlivePlayerHumanoid = getAlivePlayerHumanoid,

	getPlayerRootPart = getPlayerRootPart,
	GetPlayerRootPart = getPlayerRootPart,

	getAlivePlayerRootPart = getAlivePlayerRootPart,
	GetAlivePlayerRootPart = getAlivePlayerRootPart,

	unequipTools = unequipTools,
	UnequipTools = unequipTools,

	getPlayerFromCharacterDescendant = getPlayerFromCharacterDescendant,
	GetPlayerFromCharacterDescendant = getPlayerFromCharacterDescendant,

	waitForPlayerCharacter = waitForPlayerCharacter,
	WaitForPlayerCharacter = waitForPlayerCharacter,
}

return CharacterUtils
