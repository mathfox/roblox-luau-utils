local SocialService = game:GetService("SocialService")

local Promise = require(script.Parent.Promise)

local function promiseCanSendGameInviteAsync(player: Player)
	if typeof(player) ~= "Instance" or not player:IsA("Player") then
		error("#1 argument must be a Player!", 2)
	end

	return Promise.defer(function(resolve, reject)
		local ok, result = pcall(function()
			return SocialService:CanSendGameInviteAsync(player)
		end)

		if not ok then
			reject()
		else
			resolve(result)
		end
	end)
end

local function promisePromptGameInvite(player: Player)
	if typeof(player) ~= "Instance" or not player:IsA("Player") then
		error("#1 argument must be a Player!", 2)
	end

	return Promise.defer(function(resolve, reject)
		local ok, err = pcall(function()
			SocialService:PromptGameInvite(player)
		end)

		if ok then
			resolve(Promise.fromEvent(SocialService.GameInvitePromptClosed, function(closingPlayer)
				return closingPlayer == player
			end):catch(warn))
		else
			reject(err)
		end
	end):timeout(30, "timeout")
end

local SocialServiceUtils = {
	promiseCanSendGameInviteAsync = promiseCanSendGameInviteAsync,
	promisePromptGameInvite = promisePromptGameInvite,
}

return SocialServiceUtils
