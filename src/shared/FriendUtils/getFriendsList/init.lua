local Players = game:GetService("Players")

local Types = require(script.Parent.Parent.Types)

type Friend = Types.Friend

local function getFriendsList(userId: number): { Friend }
	local friendPages = Players:GetFriendsAsync(userId)
	local friendsList = {}

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
