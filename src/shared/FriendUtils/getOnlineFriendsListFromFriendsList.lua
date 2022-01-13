export type Friend = {
	Id: number,
	Username: string,
	DisplayName: string,
	IsOnline: boolean,
}

export type OnlineFriendsList = { Friend }

local function getOnlineFriendsListFromFriendsList(friendsList: { Friend }): OnlineFriendsList
	local onlineFriendsList: OnlineFriendsList = {}

	for _, friend in ipairs(friendsList) do
		if friend.IsOnline then
			table.insert(onlineFriendsList, friend)
		end
	end

	return onlineFriendsList
end

return getOnlineFriendsListFromFriendsList
