local function scaleHumanoid(humanoid: Humanoid, scale: number)
	for _, valueObjectName in ipairs({ "HeadScale", "BodyDepthScale", "BodyWidthScale", "BodyHeightScale" }) do
		local valueObject = humanoid:FindFirstChild(valueObjectName)
		if valueObject then
			valueObject.Value *= scale
		end
	end
end

return scaleHumanoid
