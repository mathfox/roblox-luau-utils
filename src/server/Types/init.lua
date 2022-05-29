-- reference: https://developer.roblox.com/en-us/api-reference/callback/MarketplaceService/ProcessReceipt
export type ReceiptInfo = {
	PlayerId: number,
	PlaceIdWherePurchased: number,
	PurchaseId: string,
	ProductId: number,
	-- deprecated
	CurrencyType: Enum.CurrencyType,
	CurrencySpent: number,
}

return nil
