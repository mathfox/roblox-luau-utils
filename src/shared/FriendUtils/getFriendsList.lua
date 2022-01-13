export type Friend = {
	Id: number,
	Username: string,
	DisplayName: string,
	IsOnline: boolean,
}

export type FriendsList = { Friend }

local Players = game:GetService("Players")

local function getFriendsList(player: Player): FriendsList
	local friendPages = Players:GetFriendsAsync(player.UserId)

	local friendsList: FriendsList = {}

	while true do
		for _, item in ipairs(friendPages:GetCurrentPage()) do
			table.insert(friendsList, item)
		end

		if friendPages.IsFinished then
			break
		end

		friendPages:AdvanceToNextPageAsync()
	end

	return friendsList
end

return getFriendsList
