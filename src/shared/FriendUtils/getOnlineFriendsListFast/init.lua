local Players = game:GetService("Players")

local Types = require(script.Parent.Types)

local function getOnlineFriendsListFast(player: Player)
	local friendPages = Players:GetFriendsAsync(player.UserId)
	local friendsList: Types.FriendsList = {}

	while true do
		for _, item in ipairs(friendPages:GetCurrentPage()) do
			if item.IsOnline then
				table.insert(friendsList, item)
			end
		end

		if friendPages.IsFinished then
			break
		end

		friendPages:AdvanceToNextPageAsync()
	end

	return friendsList
end

return getOnlineFriendsListFast
