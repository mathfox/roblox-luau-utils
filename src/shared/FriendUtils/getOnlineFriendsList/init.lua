local Players = game:GetService("Players")

local Types = require(script.Parent.Parent.Types)

type Array<T> = Types.Array<T>
type Friend = Types.Friend

local function getOnlineFriendsList(userId: number)
	local friendPages = Players:GetFriendsAsync(userId)
	local friendsList: Array<Friend> = {}

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
