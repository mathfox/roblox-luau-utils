local function scaleHumanoid(humanoid: Humanoid, scale: number)
	for _, child in humanoid:GetChildren() do
		if child:IsA("NumberValue") then
			child.Value *= scale
		end
	end
end

return scaleHumanoid
