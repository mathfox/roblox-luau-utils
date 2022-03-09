local function evaluateNumberSequence(numberSequence: NumberSequence, t: number)
	if t == 0 then
		return numberSequence.Keypoints[1].Value
	elseif t == 1 then
		return numberSequence.Keypoints[#numberSequence.Keypoints].Value
	end

	for i = 1, #numberSequence.Keypoints - 1 do
		local this = numberSequence.Keypoints[i]
		local next = numberSequence.Keypoints[i + 1]
		if t >= this.Time and t < next.Time then
			-- calculate how far alpha lies between the points
			local alpha = (t - this.Time) / (next.Time - this.Time)

			return (next.Value - this.Value) * alpha + this.Value
		end
	end
end

return evaluateNumberSequence
