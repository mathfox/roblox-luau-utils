local getFriendsListFast = require(script.Parent.getFriendsListFast)

local function getFriendsList(player: Player)
	if player == nil then
		error("missing argument #1 to 'getFriendsList' (Player expected)", 2)
	elseif typeof(player) ~= "Instance" then
		error(("invalid argument #1 to 'getFriendsList' (Player expected, got %s)"):format(typeof(player)), 2)
	elseif not player:IsA("Player") then
		error(("invalid argument #1 to 'getFriendsList' (Player expected, got %s)"):format(player.ClassName), 2)
	end

	return getFriendsListFast(player)
end

return getFriendsList
