local function multiplyNumberSequence(numberSequence: NumberSequence, value: number)
	local newKeypoints = table.create(#numberSequence.Keypoints)

	for _, keypoint in numberSequence.Keypoints do
		table.insert(newKeypoints, NumberSequenceKeypoint.new(keypoint.Time, keypoint.Value * value, keypoint.Envelope * value))
	end

	return NumberSequence.new(newKeypoints)
end

return multiplyNumberSequence
