local function scaleHumanoid(humanoid: Humanoid, scaleNumber: number)
	if typeof(humanoid) ~= "Instance" or not humanoid:IsA("Humanoid") then
		error("#1 argument must be a Humanoid!", 2)
	elseif type(scaleNumber) ~= "number" then
		error("#2 argument must be a number!", 2)
	end

	local headScale = humanoid:FindFirstChild("HeadScale")
	if headScale then
		headScale.Value *= scaleNumber
	end

	local bodyDepthScale = humanoid:FindFirstChild("BodyDepthScale")
	if bodyDepthScale then
		bodyDepthScale.Value *= scaleNumber
	end

	local bodyWidthScale = humanoid:FindFirstChild("BodyWidthScale")
	if bodyWidthScale then
		bodyWidthScale.Value *= scaleNumber
	end

	local bodyHeightScale = humanoid:FindFirstChild("BodyHeightScale")
	if bodyHeightScale then
		bodyHeightScale.Value *= scaleNumber
	end
end

local function getAliveHumanoidFromModel(model: Model): Humanoid?
	if typeof(model) ~= "Instance" or not model:IsA("Model") then
		error("#1 argument must be a Model!", 2)
	end

	local humanoid = model:FindFirstChildOfClass("Humanoid")
	if humanoid and humanoid.Health > 0 then
		return humanoid
	end
end

local function getAliveHumanoidFromDescendant(descendant: Instance): Humanoid?
	if typeof(descendant) ~= "Instance" then
		error("#1 argument must be an Instance!", 2)
	end

	local model = descendant:FindFirstAncestorWhichIsA("Model")
	if model then
		return getAliveHumanoidFromModel(model)
	end
end

local function getAliveRootPartFromModel(model: Model): BasePart?
	if typeof(model) ~= "Instance" or not model:IsA("Model") then
		error("#1 argument must be a Model!", 2)
	end

	local humanoid = getAliveHumanoidFromModel(model)
	if humanoid then
		return humanoid.RootPart
	end
end

local function getAliveRootPartFromDescendant(descendant: Instance): BasePart?
	if typeof(descendant) ~= "Instance" then
		error("#1 argument must be an Instance!", 2)
	end

	local humanoid = getAliveHumanoidFromDescendant(descendant)
	if humanoid then
		return humanoid.RootPart
	end
end

local HumanoidUtils = {
	healHumanoid = require(script.healHumanoid),
	scaleHumanoid = scaleHumanoid,

	getAliveHumanoidFromModel = getAliveHumanoidFromModel,
	getAliveHumanoidFromDescendant = getAliveHumanoidFromDescendant,

	getAliveRootPartFromModel = getAliveRootPartFromModel,
	getAliveRootPartFromDescendant = getAliveRootPartFromDescendant,
}

return HumanoidUtils
