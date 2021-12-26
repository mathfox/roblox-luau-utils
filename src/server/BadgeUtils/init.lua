local Unite = require(game:GetService("ReplicatedStorage").Unite)
local BadgeService = game:GetService("BadgeService")

local Promise = Unite.getSharedUtil("Promise")

local BadgeUtils = {}

function BadgeUtils.promiseAwardBadge(player: Player, badgeId: number)
	if typeof(player) ~= "Instance" or not player:IsA("Player") then
		error("#1 argument must be a Player!", 2)
	elseif type(badgeId) ~= "number" then
		error("#2 argument must be a number!", 2)
	end

	return Promise.new(function(resolve, reject)
		local awardSuccess, errorObject = pcall(function()
			return BadgeService:AwardBadge(player.UserId, badgeId)
		end)

		if not awardSuccess then
			return reject(errorObject)
		end

		return resolve(true)
	end)
end

return BadgeUtils
