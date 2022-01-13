export type Friend = {
	Id: number,
	Username: string,
	DisplayName: string,
	IsOnline: boolean,
}

export type OnlineFriendsList = { Friend }

local Players = game:GetService("Players")

local function getOnlineFriendsList(player: Player): OnlineFriendsList
	local friendPages = Players:GetFriendsAsync(player.UserId)

	local friendsList: OnlineFriendsList = {}

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

return getOnlineFriendsList
