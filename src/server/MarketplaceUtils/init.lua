local Unite = require(game:GetService("ReplicatedStorage").Unite)
local MarketplaceService = game:GetService("MarketplaceService")

local MarketplaceUtils = require(Unite.SharedUtils.MarketplaceUtils)
local TableUtils = require(Unite.SharedUtils.TableUtils)

local GamePassesModule = require(Unite.ServerModules.GamePassesModule)
local ProductsModule = require(Unite.ServerModules.ProductsModule)

local function getGamePassInfoTableFromId(id: number): table?
	if type(id) ~= "number" then
		error("#1 argument must be a number!", 2)
	end

	for gamePassId, info in pairs(GamePassesModule) do
		if gamePassId == id then
			return info
		end
	end

	for gamePassId, info in pairs(MarketplaceUtils.gamePasses) do
		if gamePassId == id then
			return info
		end
	end

	return nil
end

local function getGamePassInfoTableFromName(name: string): table?
	if type(name) ~= "string" then
		error("#1 argument must be a string!", 2)
	end

	for _, info in pairs(GamePassesModule) do
		if info.gamePassName == name then
			return info
		end
	end

	for _, info in pairs(MarketplaceUtils.gamePasses) do
		if info.gamePassName == name then
			return info
		end
	end

	return nil
end

local function promptGamePassPurchaseFromId(player: Player, id: number)
	if typeof(player) ~= "Instance" or not player:IsA("Player") then
		error("#1 argument must be a Player!", 2)
	elseif type(id) ~= "number" then
		error("#2 argument must be a number!", 2)
	elseif not MarketplaceUtils.doesGamePassExistFromId(id) then
		error(string.format("gamepass with id {%d} does not exist", id), 2)
	end

	MarketplaceService:PromptGamePassPurchase(player, id)
end

local function promptGamePassPurchaseFromName(player: Player, name: string)
	if type(name) ~= "string" then
		error("#2 argument must be a string!", 2)
	end

	local id = MarketplaceUtils.getGamepassIdFromGamepassName(name)
	if not id then
		error(string.format("gamepass with name {%s} does not exist", name), 2)
	end

	promptGamePassPurchaseFromId(player, id)
end

local function doesOwnGamePassFromId(player: Player, id: number): boolean
	if typeof(player) ~= "Instance" or not player:IsA("Player") then
		error("#1 argument must be a Player!", 2)
	elseif type(id) ~= "number" then
		error("#2 argument must be a number!", 2)
	elseif not MarketplaceUtils.doesGamePassExistFromId(id) then
		error(string.format("gamepass with id {%d} does not exist", id), 2)
	end

	return MarketplaceService:UserOwnsGamePassAsync(player.UserId, id)
end

local function doesOwnGamePassFromName(player: Player, name: string): boolean
	if type(name) ~= "string" then
		error("#2 argument must be a string!", 2)
	end

	local id = MarketplaceUtils.getGamepassIdFromGamepassName(name)
	if not id then
		error(string.format("gamepass with name {%s} does not exist!", name), 2)
	end

	return doesOwnGamePassFromId(player, id)
end

local function doesOwnGamePassIds(player: Player, tbl: { number }): boolean
	if typeof(player) ~= "Instance" or not player:IsA("Player") then
		error("#1 argument must be a Player!", 2)
	elseif type(tbl) ~= "table" then
		error("#2 argument must be a table!", 2)
	end

	for _, id in ipairs(tbl) do
		if not doesOwnGamePassFromId(player, id) then
			return false
		end
	end

	return true
end

local function doesOwnGamePassNames(player: Player, tbl: { string }): boolean
	if typeof(player) ~= "Instance" or not player:IsA("Player") then
		error("#1 argument must be a Player!", 2)
	elseif type(tbl) ~= "table" then
		error("#2 argument must be a table!", 2)
	end

	for _, name in ipairs(tbl) do
		if not doesOwnGamePassFromName(player, name) then
			return false
		end
	end

	return true
end

local function doesOwnAllGamePasses(player: Player): boolean
	for gamePassId in pairs(MarketplaceUtils.gamePasses) do
		if not doesOwnGamePassFromId(player, gamePassId) then
			return false
		end
	end

	return true
end

local function getRandomNotOwnedGamePassId(player: Player): number?
	local gamepasses = {}

	for gamePassId in pairs(MarketplaceUtils.gamePasses) do
		if not doesOwnGamePassFromId(player, gamePassId) then
			table.insert(gamepasses, gamePassId)
		end
	end

	return TableUtils.random(gamepasses)
end

local function getRandomNotOwnedGamePassName(player: Player): string?
	local gamepasses = {}

	for gamePassId, info in ipairs(MarketplaceUtils.gamePasses) do
		if not doesOwnGamePassFromId(player, gamePassId) then
			table.insert(gamepasses, info.gamePassName)
		end
	end

	return TableUtils.random(gamepasses)
end

local function bindOnGamePassPurchase(
	player: Player,
	callback: (id: number, name: string) -> ...any
): RBXScriptConnection
	if typeof(player) ~= "Instance" or not player:IsA("Player") then
		error("#1 argument must be a Player!", 2)
	end

	return MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(plr, gid, isPurchased)
		if isPurchased and plr == player then
			callback(gid, MarketplaceUtils.getGamePassNameFromId(gid))
		end
	end)
end

local function bindOnGamePassIdPurchase(
	player: Player,
	id: number,
	callback: (name: string) -> ...any
): RBXScriptConnection
	if typeof(player) ~= "Instance" or not player:IsA("Player") then
		error("#1 argument must be a Player!", 2)
	elseif type(id) ~= "number" then
		error("#2 argument must be a number!", 2)
	elseif not MarketplaceUtils.doesGamePassExistFromId(id) then
		error(string.format("gamepass with id {%d} does not exist", id), 2)
	end

	return MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(plr, gid, isPurchased)
		if isPurchased and plr == player and gid == id then
			callback(MarketplaceUtils.getGamePassNameFromId(id))
		end
	end)
end

local function bindOnGamePassNamePurchase(
	player: Player,
	name: string,
	callback: (id: number) -> ...any
): RBXScriptConnection
	if typeof(player) ~= "Instance" or not player:IsA("Player") then
		error("#1 argument must be a Player!", 2)
	elseif type(name) ~= "string" then
		error("#2 argument must be a string!", 2)
	end

	local id = MarketplaceUtils.getGamepassIdFromGamepassName(name)
	if not id then
		error(string.format("gamepass with name {%s} does not exist!", name), 2)
	end

	return MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(plr, gid, isPurchased)
		if isPurchased and plr == player and gid == id then
			callback(id)
		end
	end)
end

local function getProductInfoTableFromId(id: number): table?
	if type(id) ~= "number" then
		error("#1 argument must be a number!", 2)
	end

	for productId, info in pairs(ProductsModule) do
		if productId == id then
			return info
		end
	end

	for productId, info in pairs(MarketplaceUtils.products) do
		if productId == id then
			return info
		end
	end

	return nil
end

local function getProductInfoTableFromName(name: string): table?
	if type(name) ~= "string" then
		error("#1 argument must be a string!", 2)
	end

	for _, info in pairs(ProductsModule) do
		if info.productName == name then
			return info
		end
	end

	for _, info in pairs(MarketplaceUtils.products) do
		if info.productName == name then
			return info
		end
	end

	return nil
end

local function promptProductPurchaseFromId(player: Player, id: number)
	if typeof(player) ~= "Instance" or not player:IsA("Player") then
		error("#1 argument must be a Player!", 2)
	elseif type(id) ~= "number" then
		error("#2 argument must be a number!", 2)
	elseif not MarketplaceUtils.doesProductExistFromId(id) then
		error(string.format("product with id {%d} does not exist!", id), 2)
	end

	MarketplaceService:PromptProductPurchase(player, id)
end

local function promptProductPurchaseFromName(player: Player, name: string)
	if type(name) ~= "string" then
		error("#2 argument must be a string!", 2)
	end

	local id = MarketplaceUtils.getProductIdFromName(name)
	if not id then
		error(string.format("product with name {%s} does not exist!", name), 2)
	end

	promptProductPurchaseFromId(player, id)
end

local ServerMarketplaceUtils = TableUtils.assign(MarketplaceUtils, {
	gamePasses = GamePassesModule,
	products = ProductsModule,

	getGamePassInfoTableFromId = getGamePassInfoTableFromId,
	getGamePassInfoTableFromName = getGamePassInfoTableFromName,

	promptGamePassPurchaseFromId = promptGamePassPurchaseFromId,
	promptGamePassPurchaseFromName = promptGamePassPurchaseFromName,

	doesOwnGamePassFromId = doesOwnGamePassFromId,
	doesOwnGamePassFromName = doesOwnGamePassFromName,
	doesOwnGamePassIds = doesOwnGamePassIds,
	doesOwnGamePassNames = doesOwnGamePassNames,
	doesOwnAllGamePasses = doesOwnAllGamePasses,

	getRandomNotOwnedGamePassId = getRandomNotOwnedGamePassId,
	getRandomNotOwnedGamePassName = getRandomNotOwnedGamePassName,

	bindOnGamePassPurchase = bindOnGamePassPurchase,
	bindOnGamePassIdPurchase = bindOnGamePassIdPurchase,
	bindOnGamePassNamePurchase = bindOnGamePassNamePurchase,

	getProductInfoTableFromId = getProductInfoTableFromId,
	getProductInfoTableFromName = getProductInfoTableFromName,

	promptProductPurchaseFromId = promptProductPurchaseFromId,
	promptProductPurchaseFromName = promptProductPurchaseFromName,
})

return ServerMarketplaceUtils
