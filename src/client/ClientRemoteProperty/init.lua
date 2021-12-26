local ReplicatedStorage = game:GetService("ReplicatedStorage")

local UniteConfiguration = require(ReplicatedStorage.Unite.UniteConfiguration)

local Signal = require(ReplicatedStorage[UniteConfiguration.SharedUtils].Signal)

local ClientRemoteProperty = {}
ClientRemoteProperty.__index = ClientRemoteProperty

function ClientRemoteProperty.new(object)
	local self = setmetatable({
		_object = object,
		_value = nil,
		_isTable = object:IsA("RemoteEvent"),
	}, ClientRemoteProperty)

	local function SetValue(v)
		self._value = v
	end

	if self._isTable then
		self.Changed = Signal.new()
		self._change = object.OnClientEvent:Connect(function(tbl)
			SetValue(tbl)
			self.Changed:Fire(tbl)
		end)
		SetValue(object.TableRequest:InvokeServer())
	else
		SetValue(object.Value)
		self.Changed = object.Changed
		self._change = object.Changed:Connect(SetValue)
	end

	return self
end

function ClientRemoteProperty:Get()
	return self._value
end

function ClientRemoteProperty:Destroy()
	self._change:Disconnect()
	if self._isTable then
		self.Changed:Destroy()
	end
end

return ClientRemoteProperty
