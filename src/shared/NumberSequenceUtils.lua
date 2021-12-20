local function scaleNumberSequence(sequence: NumberSequence, scale: number): NumberSequence
	if typeof(sequence) ~= "NumberSequence" then
		error("#1 argument must be a NumberSequence!", 2)
	elseif type(scale) ~= "number" then
		error("#2 argument must be a number!", 2)
	end

	local waypoints, keypoints = {}, sequence.Keypoints
	for _, keypoint in pairs(keypoints) do
		table.insert(
			waypoints,
			NumberSequenceKeypoint.new(keypoint.Time, keypoint.Value * scale, keypoint.Envelope * scale)
		)
	end
	return NumberSequence.new(waypoints)
end

local NumberSequenceUtils = {
	scaleNumberSequence = scaleNumberSequence,
}

return NumberSequenceUtils
