type Table = { [any]: any }

local function length(tbl: Table): number
	if type(tbl) ~= "table" then
		error("#1 argument must be a table!", 2)
	end

	local length = 0
	for _ in pairs(tbl) do
		length += 1
	end
	return length
end

local function copy(tbl: Table): Table
	if type(tbl) ~= "table" then
		error("#1 argument must be a table!", 2)
	end

	local new = table.create(#tbl)
	for k, v in pairs(tbl) do
		if type(v) == "table" then
			new[k] = copy(v)
		else
			new[k] = v
		end
	end
	return new
end

local function copyShallow(tbl: Table): Table
	if type(tbl) ~= "table" then
		error("#1 argument must be a table!", 2)
	end

	local new = table.create(#tbl)
	if #tbl > 0 then
		table.move(tbl, 1, #tbl, 1, new)
	else
		for k, v in pairs(tbl) do
			new[k] = v
		end
	end
	return new
end

local function map(tbl: Table, func: (v: any, k: any, tbl: Table) -> any): Table
	if type(tbl) ~= "table" then
		error("#1 argument must be a table!", 2)
	elseif type(func) ~= "function" then
		error("#2 argument must be a function!", 2)
	end

	local new = table.create(#tbl)
	for k, v in pairs(tbl) do
		new[k] = func(v, k, tbl)
	end
	return new
end

local function filter(tbl: Table, predicate: (v: any, k: any, tbl: Table) -> boolean): Table
	if type(tbl) ~= "table" then
		error("#1 argument must be a table!", 2)
	elseif type(predicate) ~= "function" then
		error("#2 argument must be a function!", 2)
	end

	local new = table.create(#tbl)
	if #tbl > 0 then
		for i, v in ipairs(tbl) do
			if predicate(v, i, tbl) then
				table.insert(new, v)
			end
		end
	else
		for k, v in pairs(tbl) do
			if predicate(v, k, tbl) then
				new[k] = v
			end
		end
	end
	return new
end

local function assign(tbl: Table, ...: Table): Table
	if type(tbl) ~= "table" then
		error("#1 argument must be a table!", 2)
	end

	local new = copyShallow(tbl)
	for _, t in ipairs({ ... }) do
		for k, v in pairs(t) do
			new[k] = v
		end
	end
	return new
end

local function extend(tbl: Table, extension: Table): Table
	if type(tbl) ~= "table" then
		error("#1 argument must be a table!", 2)
	end

	local new = copyShallow(tbl)
	for _, v in ipairs(extension) do
		table.insert(new, v)
	end
	return new
end

local function reverse(tbl: Table): Table
	if type(tbl) ~= "table" then
		error("#1 argument must be a table!", 2)
	end

	local n = #tbl
	local new = table.create(n)
	for i = 1, n do
		new[i] = tbl[n - i + 1]
	end
	return new
end

local function shuffle(tbl: Table, randomOverride: Random?): Table
	if type(tbl) ~= "table" then
		error("#1 argument must be a table!", 2)
	end

	local new = copyShallow(tbl)
	local random = randomOverride or Random.new()
	for i = #tbl, 2, -1 do
		local j = random:NextInteger(1, i)
		new[i], new[j] = new[j], new[i]
	end
	return new
end

local function keys(tbl: Table): Table
	if type(tbl) ~= "table" then
		error("#1 argument must be a table!", 2)
	end

	local new = table.create(#tbl)
	for k in pairs(tbl) do
		table.insert(new, k)
	end
	return new
end

local function find(tbl: Table, predicate: (v: any, k: any, tbl: Table) -> boolean): (any, any)
	if type(tbl) ~= "table" then
		error("#1 argument must be a table!", 2)
	elseif type(predicate) ~= "function" then
		error("#2 argument must be a function!", 2)
	end

	for k, v in pairs(tbl) do
		if predicate(v, k, tbl) then
			return v, k
		end
	end
	return nil, nil
end

local function every(tbl: Table, predicate: (v: any, k: any, tbl: Table) -> boolean): boolean
	if type(tbl) ~= "table" then
		error("#1 argument must be a table!", 2)
	elseif type(predicate) ~= "function" then
		error("#2 argument must be a function!", 2)
	end

	for k, v in pairs(tbl) do
		if not predicate(v, k, tbl) then
			return false
		end
	end
	return true
end

local function some(tbl: Table, predicate: (v: any, k: any, tbl: Table) -> boolean): boolean
	if type(tbl) ~= "table" then
		error("#1 argument must be a table!", 2)
	elseif type(predicate) ~= "function" then
		error("#2 argument must be a function!", 2)
	end

	for k, v in pairs(tbl) do
		if predicate(v, k, tbl) then
			return true
		end
	end
	return false
end

local function isEmpty(tbl: Table): boolean
	if type(tbl) ~= "table" then
		error("#1 argument must be a table!", 2)
	end

	return next(tbl) == nil
end

local function random(tbl: Table, randomOverride: Random?): any
	if type(tbl) ~= "table" then
		error("#1 argument must be a table!", 2)
	end

	return tbl[(randomOverride or Random.new()):NextInteger(1, #tbl)]
end

local function _safeFreeze(tbl: Table)
	if not table.isfrozen(tbl) then
		table.freeze(tbl)
	end
end

local function safeFreeze(tbl: Table)
	if type(tbl) ~= "table" then
		error("#1 argument must be a table!", 2)
	end
	_safeFreeze(tbl)
end

local function _deepSafeFreeze(tbl: Table)
	_safeFreeze(tbl)
	for itbl, vtbl in pairs(tbl) do
		if type(itbl) == "table" then
			_deepSafeFreeze(itbl)
		end
		if type(vtbl) == "table" then
			_deepSafeFreeze(vtbl)
		end
	end
end

local function deepSafeFreeze(tbl: Table)
	if type(tbl) ~= "table" then
		error("#1 argument must be a table!", 2)
	end
	_deepSafeFreeze(tbl)
end

local TableUtils = {
	length = length,
	copy = copy,
	copyShallow = copyShallow,
	map = map,
	filter = filter,
	assign = assign,
	extend = extend,
	reverse = reverse,
	shuffle = shuffle,
	keys = keys,
	find = find,
	every = every,
	some = some,
	isEmpty = isEmpty,
	random = random,
	safeFreeze = safeFreeze,
	deepSafeFreeze = deepSafeFreeze,
}

return TableUtils
