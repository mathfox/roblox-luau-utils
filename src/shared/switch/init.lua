local function switch(condition, results: { [any]: any, _: any })
	return if results[condition] ~= nil
		then if type(results[condition]) == "function" then results[condition]() else results[condition]
		elseif type(results._) == "function" then results._()
		else results._
end

return switch
