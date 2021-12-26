local Players = game:GetService("Players")

local Promise = require(script.Parent.Promise)

local function promiseUserIdThumbnail(
	userId: number,
	thumbnailType: Enum.ThumbnailType?,
	thumbnailSize: Enum.ThumbnailSize?
)
	if type(userId) ~= "number" then
		error("#1 argument must be int!", 2)
	elseif userId % 1 ~= 0 then
		error("#1 argument must be int!", 2)
	end

	return Promise.new(function(resolve, reject)
		local ok, result, isReady = pcall(function()
			return Players:GetUserThumbnailAsync(
				userId,
				thumbnailType or Enum.ThumbnailType.HeadShot,
				thumbnailSize or Enum.ThumbnailSize.Size100x100
			)
		end)

		if not ok then
			reject(result)
		end

		if not isReady then
			reject("thumbnail is not ready")
		end

		resolve(result)
	end)
end

local function promisePlayerThumbnail(
	player: Player,
	thumbnailType: Enum.ThumbnailType?,
	thumbnailSize: Enum.ThumbnailSize?
)
	if typeof(player) ~= "Instance" or not player:IsA("Player") then
		error("#1 argument must be a Player!", 2)
	end

	return Promise.new(function(resolve, reject)
		local ok, result, isReady = pcall(function()
			return Players:GetUserThumbnailAsync(
				player.UserId,
				thumbnailType or Enum.ThumbnailType.HeadShot,
				thumbnailSize or Enum.ThumbnailSize.Size100x100
			)
		end)

		if not ok then
			reject(result)
		end

		if not isReady then
			reject("thumbnail is not ready")
		end

		resolve(result)
	end)
end

local PlayerThumbnailUtils = {
	promiseUserIdThumbnail = promiseUserIdThumbnail,
	promisePlayerThumbnail = promisePlayerThumbnail,
}

return PlayerThumbnailUtils
