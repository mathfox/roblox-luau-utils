local function random<K, V>(tbl: { [K]: V }, rngOverride: Random?)
	return tbl[(rngOverride or Random.new()):NextInteger(1, #tbl)]
end

return random
