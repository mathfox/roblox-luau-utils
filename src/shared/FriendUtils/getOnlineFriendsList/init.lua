local Players = game:GetService("Players")

local Types = require(script.Parent.Parent.Types)

type Friend = Types.Friend

local function getOnlineFriendsList(userId: number): { Friend }
	local friendPages = Players:GetFriendsAsync(userId)
	local friendsList = {}

	while true do
		for _, item in friendPages:GetCurrentPage() do
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

return getOnlineFriendsList
