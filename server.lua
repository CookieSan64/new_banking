--================================================================================================
--==                                VARIABLES - DO NOT EDIT                                     ==
--================================================================================================
ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('bank:deposit')
AddEventHandler('bank:deposit', function(amount)
	local _source = source
	
	local xPlayer = ESX.GetPlayerFromId(_source)
	if amount == nil or amount <= 0 or amount > xPlayer.getMoney() then
		TriggerClientEvent('bank:result', _source, "error", "Montant invalide.")
	else
		xPlayer.removeMoney(amount)
		xPlayer.addAccountMoney('bank', tonumber(amount))
		TriggerClientEvent('bank:result', _source, "success", "Dépot effectué.")
	end
end)


RegisterServerEvent('bank:withdraw')
AddEventHandler('bank:withdraw', function(amount)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local base = 0
	amount = tonumber(amount)
	base = xPlayer.getAccount('bank').money
	if amount == nil or amount <= 0 or amount > base then
		TriggerClientEvent('bank:result', _source, "error", "Montant invalide.")
	else
		xPlayer.removeAccountMoney('bank', amount)
		xPlayer.addMoney(amount)
		TriggerClientEvent('bank:result', _source, "success", "Retrait effectué.")
	end
end)

RegisterServerEvent('bank:balance')
AddEventHandler('bank:balance', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	balance = xPlayer.getAccount('bank').money
	TriggerClientEvent('currentbalance1', _source, balance)
end)


RegisterServerEvent('bank:transfer')
AddEventHandler('bank:transfer', function(to, amount)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local zPlayer = ESX.GetPlayerFromId(to)
	local balance = 0

	if zPlayer == nil or zPlayer == -1 then
		TriggerClientEvent('bank:result', _source, "error", "Destinataire introuvable.")
	else
		balance = xPlayer.getAccount('bank').money
		
		if tonumber(_source) == tonumber(to) then
			TriggerClientEvent('bank:result', _source, "error", "Vous ne pouvez pas faire de transfert à vous-même.")
		else
			if balance <= 0 or balance < tonumber(amount) or tonumber(amount) <= 0 then
				TriggerClientEvent('bank:result', _source, "error", "Vous n'avez pas assez d'argent en banque.")
			else
				xPlayer.removeAccountMoney('bank', tonumber(amount))
				zPlayer.addAccountMoney('bank', tonumber(amount))
				TriggerClientEvent('bank:result', _source, "success", "Transfert effectué.")
			end
		end
	end	
end)

--ESX = nil

Players = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

AddEventHandler('playerConnecting', function(playerName, setKickReason)
local identifier = GetPlayerIdentifiers(source)[1]

	Players[source] = {
		identifier = identifier,
		name = playerName
	}
end)

AddEventHandler('playerDropped', function(reason)
	Players[source] = nil
end)

RegisterServerEvent('bank:transfer')
AddEventHandler('bank:transfer', function(to, amount)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local zPlayer
	local balance = 0

	for i, player in pairs(Players) do
		if player.name == to then
			zPlayer = ESX.GetPlayerFromId(i)
			break
		end
	end

	if zPlayer == nil then
		TriggerClientEvent('bank:result', _source, "error", "Destinataire introuvable.")
	else
		balance = xPlayer.getAccount('bank').money
	
		if tonumber(_source) == tonumber(zPlayer.source) then
			TriggerClientEvent('bank:result', _source, "error", "Vous ne pouvez pas faire de transfert à vous-même.")
		else
			if balance <= 0 or balance < tonumber(amount) or tonumber(amount) <= 0 then
				TriggerClientEvent('bank:result', _source, "error", "Vous n'avez pas assez d'argent en banque.")
			else
				xPlayer.removeAccountMoney('bank', tonumber(amount))
				zPlayer.addAccountMoney('bank', tonumber(amount))
				TriggerClientEvent('bank:result', _source, "success", "Transfert effectué.")
			end
		end
	end	
end)



