local Unite = require(game:GetService("ReplicatedStorage").Unite)
local BadgeService = game:GetService("BadgeService")

local Promise = require(Unite.SharedUtils.Promise)

local function promiseAwardBadge(player: Player, badgeId: number)
	if player == nil then
		error("missing argument #1 to 'promiseAwardBadge' (Player expected)", 2)
	elseif typeof(player) ~= "Instance" or not player:IsA("Player") then
		error(("invalid argument #1 to 'promiseAwardBadge' (Player expected, got %s)"):format(typeof(player)), 2)
	elseif badgeId == nil then
		error("missing argument #2 to 'promiseAwardBadge' (integer expected)", 2)
	elseif type(badgeId) ~= "number" or badgeId % 1 ~= 0 or math.abs(badgeId) == math.huge then
		error(("invalid argument #2 to 'promiseAwardBadge' (integer expected, got %s)"):format(type(badgeId)), 2)
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

local BadgeUtils = {
	promiseAwardBadge = promiseAwardBadge,
}

return BadgeUtils
