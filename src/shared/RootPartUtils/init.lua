local Promise = require(script.Parent.Promise)
local Maid = require(script.Parent.Maid)

local DEFAULT_TIMEOUT_TIME = 60

local function promiseRootPartFromHumanoid(humanoid: Humanoid, timeout: number?): BasePart?
	if humanoid.RootPart then
		return Promise.resolve(humanoid.RootPart)
	end

	local maid = Maid.new()

	local promise = Promise.fromEvent(humanoid.Parent.ChildAdded, function()
		return humanoid.RootPart ~= nil
	end):timeout(timeout or DEFAULT_TIMEOUT_TIME, "timeout")

	maid:giveTask(humanoid.AncestryChanged:Connect(function()
		if not humanoid:IsDescendantOf(game) then
			promise:now("Humanoid has been removed from the game")
		end
	end))

	maid:giveTask(humanoid.Died:Connect(function()
		promise:now("Humanoid died")
	end))

	promise:finally(function()
		maid:destroy()
	end)

	return promise
end

local function promiseRootPartFromCharacter(character: Model, timeout: number?): BasePart?
	local maid = Maid.new()

	local promise = Promise.new(function(resolve)
		resolve(character:FindFirstChildOfClass("Humanoid") or Promise.fromEvent(character.ChildAdded, function(child)
			return child:IsA("Humanoid")
		end):expect())
	end)
		:andThen(function(humanoid: Humanoid)
			if humanoid.RootPart then
				return Promise.resolve(humanoid.RootPart)
			end

			return Promise.fromEvent(humanoid.Parent.ChildAdded, function()
				return humanoid.RootPart ~= nil
			end):andThen(function()
				return humanoid.RootPart
			end)
		end)
		:timeout(timeout or DEFAULT_TIMEOUT_TIME, "timeout")

	maid:giveTask(character.AncestryChanged:Connect(function()
		if not character:IsDescendantOf(game) then
			promise:now("Character has been removed from the game")
		end
	end))

	promise:finally(function()
		maid:destroy()
	end)

	return promise
end

local function promiseRootPartFromPlayer(player: Player, timeout: number?): BasePart?
	local maid = Maid.new()

	local promise = Promise.new(function(resolve)
		resolve(player.Character or Promise.fromEvent(player.CharacterAdded, function(character)
			return character ~= nil
		end))
	end)
		:andThen(function(character: Model)
			return character:FindFirstChildOfClass("Humanoid")
				or Promise.fromEvent(character.ChildAdded, function(child)
					return child:IsA("Humanoid")
				end)
		end)
		:andThen(function(humanoid: Humanoid)
			if humanoid.RootPart then
				return Promise.resolve(humanoid.RootPart)
			end

			return Promise.fromEvent(humanoid.Parent.ChildAdded, function()
				return humanoid.RootPart ~= nil
			end):andThen(function()
				return humanoid.RootPart
			end)
		end)
		:timeout(timeout or DEFAULT_TIMEOUT_TIME, "timeout")

	maid:giveTask(player.AncestryChanged:Connect(function()
		if not player:IsDescendantOf(game) then
			promise:now("Player has left the game")
		end
	end))

	promise:finally(function()
		maid:destroy()
	end)

	return promise
end

local RootPartUtils = {
	promiseRootPartFromHumanoid = promiseRootPartFromHumanoid,
	promiseRootPartFromCharacter = promiseRootPartFromCharacter,
	promiseRootPartFromPlayer = promiseRootPartFromPlayer,
}

return RootPartUtils
