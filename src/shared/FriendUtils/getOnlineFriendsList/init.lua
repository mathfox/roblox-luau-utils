local getOnlineFriendsListFast = require(script.Parent.getOnlineFriendsListFast)

local function getOnlineFriendsList(player: Player)
	if player == nil then
		error("missing argument #1 to 'getOnlineFriendsList' (Player expected)", 2)
	elseif typeof(player) ~= "Instance" then
		error(("invalid argument #1 to 'getOnlineFriendsList' (Player expected, got %s)"):format(typeof(player)), 2)
	elseif not player:IsA("Player") then
		error(("invalid argument #1 to 'getOnlineFriendsList' (Player expected, got %s)"):format(player.ClassName), 2)
	end

	return getOnlineFriendsListFast(player)
end

return getOnlineFriendsList
