local function scaleHumanoid(humanoid: Humanoid, scale: number)
	local headScale = humanoid:FindFirstChild("HeadScale")
	if headScale then
		headScale.Value *= scale
	end

	local bodyDepthScale = humanoid:FindFirstChild("BodyDepthScale")
	if bodyDepthScale then
		bodyDepthScale.Value *= scale
	end

	local bodyWidthScale = humanoid:FindFirstChild("BodyWidthScale")
	if bodyWidthScale then
		bodyWidthScale.Value *= scale
	end

	local bodyHeightScale = humanoid:FindFirstChild("BodyHeightScale")
	if bodyHeightScale then
		bodyHeightScale.Value *= scale
	end
end

return scaleHumanoid
