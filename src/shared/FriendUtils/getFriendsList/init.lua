local Players = game:GetService("Players")

local Types = require(script.Parent.Types)

local function getFriendsList(player: Player)
	local friendPages = Players:GetFriendsAsync(player.UserId)
	local friendsList: Types.FriendsList = {}

	while true do
		local page = friendPages:GetCurrentPage()
		table.move(page, 1, #page, #friendsList + 1, friendsList)

		if friendPages.IsFinished then
			break
		end

		friendPages:AdvanceToNextPageAsync()
	end

	return friendsList
end

return getFriendsList
