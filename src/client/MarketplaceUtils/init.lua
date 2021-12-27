local Unite = require(game:GetService("ReplicatedStorage").Unite)
local MarketplaceService = game:GetService("MarketplaceService")

local MarketplaceUtils = require(Unite.SharedUtils.MarketplaceUtils)
local TableUtils = require(Unite.SharedUtils.TableUtils)

local GamePassesModule = require(Unite.ClientModules.GamePassesModule)
local ProductsModule = require(Unite.ClientModules.ProductsModule)

local function getGamePassInfoTableFromId(id: number): GamePassesModule.GamePassInfoTable?
	if id == nil then
		error("missing argument #1 to 'getGamePassInfoTableFromId' (number expected)", 2)
	elseif type(id) ~= "number" then
		error(("invalid argument #1 to 'getGamePassInfoTableFromId' (number expected, got %s)"):format(type(id)), 2)
	end

	-- first check server module
	for _, info in pairs(GamePassesModule) do
		if info.gamePassId == id then
			return info
		end
	end

	for _, info in pairs(MarketplaceUtils.gamePasses) do
		if info.gamePassId == id then
			return info
		end
	end

	return nil
end

local function getGamePassInfoTableFromName(name: string): GamePassesModule.GamePassInfoTable?
	if name == nil then
		error("missing argument #1 to 'getGamePassInfoTableFromName' (string expected)", 2)
	elseif type(name) ~= "string" then
		error(("invalid argument #1 to 'getGamePassInfoTableFromName' (string expected, got %s)"):format(type(name)), 2)
	end

	-- first check server module
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

local function promptGamePassPurchaseFromId(id: number)
	if type(id) ~= "number" then
		error("#1 argument must be a number!", 2)
	elseif not MarketplaceUtils.doesGamePassExistFromId(id) then
		error(("gamepass with id {%d} does not exist!"):format(id), 2)
	end

	MarketplaceService:PromptGamePassPurchase(Unite.localPlayer, id)
end

local function promptGamePassPurchaseFromName(name: string)
	if type(name) ~= "string" then
		error("#1 argument must be a string!", 2)
	end

	local id = MarketplaceUtils.getGamePassIdFromName(name)
	if not id then
		error(("gamepass with name {%s} does not exist!"):format(name), 2)
	end

	promptGamePassPurchaseFromId(id)
end

local function doesOwnGamePassFromId(id: number): boolean
	if type(id) ~= "number" then
		error("#1 argument must be a number!", 2)
	elseif not MarketplaceUtils.doesGamePassExistFromId(id) then
		error(("gamepass with id {%d} does not exist!"):format(id), 2)
	end

	return MarketplaceService:UserOwnsGamePassAsync(Unite.userId, id)
end

local function doesOwnGamePassFromName(name: string): boolean?
	if type(name) ~= "string" then
		error("#1 argument must be a string!", 2)
	end

	local id = MarketplaceUtils.getGamePassIdFromName(name)
	if not id then
		error(("gamepass with name {%s} does not exist!"):format(name), 2)
	end

	return doesOwnGamePassFromId(id)
end

local function doesOwnGamePassIds(tbl: { number }): boolean
	for _, id in ipairs(tbl) do
		if not doesOwnGamePassFromId(id) then
			return false
		end
	end

	return true
end

local function doesOwnGamePassNames(tbl: { string }): boolean
	for _, name in ipairs(tbl) do
		if not doesOwnGamePassFromName(name) then
			return false
		end
	end

	return true
end

local function doesOwnAllGamePasses(): boolean
	for _, info in pairs(MarketplaceUtils.gamePasses) do
		if not doesOwnGamePassFromId(info.gamePassId) then
			return false
		end
	end

	return true
end

local function getRandomNotOwnedGamepassId(): number?
	local gamepasses = {}

	for _, info in pairs(MarketplaceUtils.gamePasses) do
		if not doesOwnGamePassFromId(info.gamePassId) then
			table.insert(gamepasses, info.gamePassId)
		end
	end

	return TableUtils.random(gamepasses)
end

local function getRandomNotOwnedGamepassName(): string?
	local gamepasses = {}

	for _, info in pairs(MarketplaceUtils.gamePasses) do
		if not doesOwnGamePassFromId(info.gamePassId) then
			table.insert(gamepasses, info.gamePassName)
		end
	end

	return TableUtils.random(gamepasses)
end

local function bindOnGamePassPurchase(callback: (id: number, name: string) -> ...any): RBXScriptConnection
	return MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(plr, gamepassId, isPurchased)
		if isPurchased and plr == Unite.localPlayer then
			callback(gamepassId, MarketplaceUtils.getGamePassNameFromId(gamepassId))
		end
	end)
end

local function bindOnGamePassIdPurchase(id: number, callback: (name: string) -> ...any): RBXScriptConnection
	if type(id) ~= "number" then
		error("#1 argument must be a number!", 2)
	elseif not MarketplaceUtils.doesGamePassExistFromId(id) then
		error(("gamepass with id {%d} does not exist"):format(id), 2)
	end

	return MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(plr, gamepassId, isPurchased)
		if isPurchased and plr == Unite.localPlayer and gamepassId == id then
			callback(MarketplaceUtils.getGamePassNameFromId(id))
		end
	end)
end

local function bindOnGamePassNamePurchase(name: string, callback: (id: number) -> ...any): RBXScriptConnection
	if type(name) ~= "string" then
		error("#1 argument must be a string!", 2)
	end

	local id = MarketplaceUtils.getGamepassIdFromGamepassName(name)
	if not id then
		error(("gamepass with name {%s} does not exist!"):format(name), 2)
	end

	return MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(plr, gamepassId, isPurchased)
		if isPurchased and plr == Unite.localPlayer and gamepassId == id then
			callback(id)
		end
	end)
end

local function getProductInfoTableFromId(id: number): ProductsModule.ProductInfoTable?
	if type(id) ~= "number" then
		error("#1 argument must be a number!", 2)
	end

	for _, info in pairs(ProductsModule) do
		if info.productId == id then
			return info
		end
	end

	for _, info in pairs(MarketplaceUtils.products) do
		if info.productId == id then
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

local function promptProductPurchaseFromId(id: number)
	if type(id) ~= "number" then
		error("#1 argument must be a number!", 2)
	elseif not MarketplaceUtils.doesProductExistFromId(id) then
		error(("product with id {%d} does not exist!"):format(id), 2)
	end

	MarketplaceService:PromptProductPurchase(Unite.localPlayer, id)
end

local function promptProductPurchaseFromName(name: string)
	if type(name) ~= "string" then
		error("#1 argument must be a string!", 2)
	end

	local id = MarketplaceUtils.getProductIdFromName(name)
	if not id then
		error(("product with name {%s} does not exist!"):format(name), 2)
	end

	promptProductPurchaseFromId(id)
end

local ClientMarketplaceUtils = {
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

	getRandomNotOwnedGamepassId = getRandomNotOwnedGamepassId,
	getRandomNotOwnedGamepassName = getRandomNotOwnedGamepassName,

	bindOnGamePassPurchase = bindOnGamePassPurchase,
	bindOnGamePassIdPurchase = bindOnGamePassIdPurchase,
	bindOnGamePassNamePurchase = bindOnGamePassNamePurchase,

	getProductInfoTableFromId = getProductInfoTableFromId,
	getProductInfoTableFromName = getProductInfoTableFromName,

	promptProductPurchaseFromId = promptProductPurchaseFromId,
	promptProductPurchaseFromName = promptProductPurchaseFromName,
}

setmetatable(ClientMarketplaceUtils, {
	__index = MarketplaceUtils,
})

return ClientMarketplaceUtils
