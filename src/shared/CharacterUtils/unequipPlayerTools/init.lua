local function unequipPlayerTools(player: Player)
	local character = player.Character
	if character then
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid:UnequipTools()
		end
	end
end

return unequipPlayerTools
