export type Friend = {
	Id: number,
	Username: string,
	DisplayName: string,
	IsOnline: boolean,
}

export type OnlineOnOtherServerFriendsList = { Friend }

local Players = game:GetService("Players")

local function getOnlineFriendsListExcludeThisServer(player: Player): OnlineOnOtherServerFriendsList
	local friendPages = Players:GetFriendsAsync(player.UserId)

	local friendsList: OnlineOnOtherServerFriendsList = {}

	while true do
		for _, item in ipairs(friendPages:GetCurrentPage()) do
			if item.IsOnline and not Players:GetPlayerByUserId(item.Id) then
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

return getOnlineFriendsListExcludeThisServer
