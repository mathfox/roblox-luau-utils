local Unite = require(game:GetService("ReplicatedStorage").Unite)
local MarketplaceService = game:GetService("MarketplaceService")

local GamePassesModule = require(Unite.SharedModules.GamePassesModule)
local ProductsModule = require(Unite.SharedModules.ProductsModule)

local function getGamePassNameFromId(id: number): string?
	if type(id) ~= "number" then
		error("#1 argument must be a number!", 2)
	end

	for gamePassId, info in pairs(GamePassesModule) do
		if gamePassId == id then
			return info.gamePassName
		end
	end

	return nil
end

local function getGamePassIdFromName(name: string): number?
	if type(name) ~= "string" then
		error("#1 argument must be a string!", 2)
	end

	for id, info in pairs(GamePassesModule) do
		if info.gamePassName == name then
			return id
		end
	end

	return nil
end

local function getGamePassInfoTableFromId(id: number): table?
	if type(id) ~= "number" then
		error("#1 argument must be a number!", 2)
	end

	for gamePassId, info in pairs(GamePassesModule) do
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

	return nil
end

local function doesGamePassExistFromId(id: number): boolean
	return getGamePassInfoTableFromId(id) ~= nil
end

local function doesGamePassExistFromName(name: string): boolean
	return getGamePassInfoTableFromName(name) ~= nil
end

local function getProductNameFromId(id: number): string?
	if type(id) ~= "number" then
		error("#1 argument must be a number!", 2)
	end

	for productId, info in pairs(ProductsModule) do
		if productId == id then
			return info.productName
		end
	end

	return nil
end

local function getProductIdFromName(name: string): number?
	if type(name) ~= "string" then
		error("#1 argument must be a string!", 2)
	end

	for productId, info in pairs(ProductsModule) do
		if info.productName == name then
			return productId
		end
	end

	return nil
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

	return nil
end

local function doesProductExistFromId(id: number): boolean
	return getProductInfoTableFromId(id) ~= nil
end

local function doesProductExistFromName(name: string): boolean
	return getProductInfoTableFromName(name) ~= nil
end

local function getMarketObjectInfo(id: number, infoType: Enum.InfoType)
	if type(id) ~= "number" then
		error("#1 argument must be a number!", 2)
	elseif typeof(infoType) ~= "Enum" then
		error("#2 argument must be Enum.InfoType!", 2)
	end

	return MarketplaceService:GetProductInfo(id, infoType)
end

local MarketplaceUtils = {
	gamePasses = GamePassesModule,
	products = ProductsModule,

	getGamePassNameFromId = getGamePassNameFromId,
	getGamePassIdFromName = getGamePassIdFromName,
	getGamePassInfoTableFromId = getGamePassInfoTableFromId,
	getGamePassInfoTableFromName = getGamePassInfoTableFromName,
	doesGamePassExistFromId = doesGamePassExistFromId,
	doesGamePassExistFromName = doesGamePassExistFromName,

	getProductNameFromId = getProductNameFromId,
	getProductIdFromName = getProductIdFromName,
	getProductInfoTableFromId = getProductInfoTableFromId,
	getProductInfoTableFromName = getProductInfoTableFromName,
	doesProductExistFromId = doesProductExistFromId,
	doesProductExistFromName = doesProductExistFromName,

	getMarketObjectInfo = getMarketObjectInfo,
}

return MarketplaceUtils
