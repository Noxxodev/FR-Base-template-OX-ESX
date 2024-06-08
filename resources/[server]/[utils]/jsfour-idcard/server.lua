local ESX = nil
-- ESX
ESX = exports['es_extended']:getSharedObject()

-- Citizen ID
ESX.RegisterUsableItem('id_card', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('jsfour-idcard:openuseid', source)
end)

-- DRIVERS LICENSE 
ESX.RegisterUsableItem('license_drive', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('jsfour-idcard:openusedriver', source)
end)

-- WEAPON LICENSE 
ESX.RegisterUsableItem('license_weapon', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('jsfour-idcard:openuseweapon', source)
end)

-- WEAPON LICENSE 
ESX.RegisterUsableItem('license_hunting', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('jsfour-idcard:openuseweapon', source)
end)

-- Open ID card
RegisterServerEvent('jsfour-idcard:open')
AddEventHandler('jsfour-idcard:open', function(ID, targetID, type)
	local identifier = ESX.GetPlayerFromId(ID).identifier
	local _source 	 = ESX.GetPlayerFromId(targetID).source
	local show       = false

	MySQL.Async.fetchAll('SELECT firstname, lastname, dateofbirth, sex, height FROM users WHERE identifier = @identifier', {['@identifier'] = identifier},
	function (user)
		if (user[1] ~= nil) then
			MySQL.Async.fetchAll('SELECT type FROM user_licenses WHERE owner = @identifier', {['@identifier'] = identifier},
			function (licenses)
				if type ~= nil then
					for i=1, #licenses, 1 do
						if type == 'driver' then
							if licenses[i].type == 'drive' or licenses[i].type == 'drive_bike' or licenses[i].type == 'drive_truck' then
								show = true
							end
						elseif type =='weapon' then
							if licenses[i].type == 'weapon' then
								show = true
							end
						end
					end
				else
					show = true
				end

				if show then
					local array = {
						user = user,
						licenses = licenses
					}
					TriggerClientEvent('jsfour-idcard:open', _source, array, type)
				else
					TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'error', text = 'You dont have that type of license.'})
				end
			end)
		end
	end)
end)


RegisterServerEvent('jsfour-idcard:openFake')
AddEventHandler('jsfour-idcard:openFake', function(ID, targetID, type)
	local identifier = ESX.GetPlayerFromId(ID).identifier
	local _source 	 = ESX.GetPlayerFromId(targetID).source
	local show       = false

	MySQL.Async.fetchAll('SELECT firstname, lastname, dateofbirth, sex, height FROM users WHERE identifier = @identifier', {['@identifier'] = identifier},
	function (user)
		if (user[1] ~= nil) then
			MySQL.Async.fetchAll('SELECT type FROM user_licenses WHERE owner = @identifier', {['@identifier'] = identifier},
			function (licenses)
				if type ~= nil then
					for i=1, #licenses, 1 do
						if type == 'driver' then
							if licenses[i].type == 'drive' or licenses[i].type == 'drive_bike' or licenses[i].type == 'drive_truck' then
								show = true
							end
						elseif type =='weapon' then
							if licenses[i].type == 'weapon' then
								show = true
							end
						end
					end
				else
					show = true
				end

				if show then
					local array = {
						user = user,
						licenses = licenses
					}
					TriggerClientEvent('jsfour-idcard:open', _source, array, type)
				else
					TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'error', text = 'You dont have that type of license.'})
				end
			end)
		end
	end)
end)

ESX.RegisterServerCallback('jsfour-idcard:getItemAmount', function(source, cb, item)
	local xPlayer = ESX.GetPlayerFromId(source)
	local quantity = xPlayer.getInventoryItem(item).count

	cb(quantity)
end)