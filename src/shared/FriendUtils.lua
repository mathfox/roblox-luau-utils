local Players = game:GetService("Players")

type Friend = { { Id: number, Username: string, DisplayName: string, IsOnline: boolean, [any]: any } }

local function getFriends(player: Player): { Friend }
	local pages = Players:GetFriendsAsync(player.UserId)
	local friends = {}
	while true do
		for _, item in ipairs(pages:GetCurrentPage()) do
			table.insert(friends, item)
		end
		if pages.IsFinished then
			break
		end
		pages:AdvanceToNextPageAsync()
	end
	return friends
end

local function getOnlineFriends(friends: { Friend }): { Friend }
	local onlineFriends = {}
	for _, friend in ipairs(friends) do
		if friend.IsOnline then
			table.insert(onlineFriends, friend)
		end
	end
	return onlineFriends
end

local function getFriendsNotInGame(friends: { Friend }): { Friend }
	local userIdsInGame = {}
	for _, player in pairs(Players:GetPlayers()) do
		userIdsInGame[player.UserId] = true
	end

	local onlineFriends = {}
	for _, friend in pairs(friends) do
		if not userIdsInGame[friend.Id] then
			table.insert(onlineFriends, friend)
		end
	end
	return onlineFriends
end

local FriendUtils = {
	getFriends = getFriends,
	getOnlineFriends = getOnlineFriends,
	getFriendsNotInGame = getFriendsNotInGame,
}

return FriendUtils
