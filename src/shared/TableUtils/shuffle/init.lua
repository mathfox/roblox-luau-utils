local function shuffle<V>(tbl: { V }, rngOverride: Random?): { V }
	local new, random = table.clone(tbl), if rngOverride then rngOverride :: Random else Random.new()
	for i = #tbl, 2, -1 do
		local j = random:NextInteger(1, i)
		new[i], new[j] = new[j], new[i]
	end
	return new
end

return shuffle
