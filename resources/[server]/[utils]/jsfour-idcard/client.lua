local Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
  ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local open = false
local ESX	 = nil

-- ESX
Citizen.CreateThread(function()
	while ESX == nil do
		ESX = exports['es_extended']:getSharedObject()		
		Citizen.Wait(0)
	end
end)

-- Open ID card
RegisterNetEvent('jsfour-idcard:open')
AddEventHandler('jsfour-idcard:open', function( data, type )
	open = true
	SendNUIMessage({
		action = "open",
		array  = data,
		type   = type
	})
end)

-- Key events
Citizen.CreateThread(function()
	while true do
		Wait(0)
		if IsControlJustReleased(0, 322) and open or IsControlJustReleased(0, 177) and open then
			SendNUIMessage({
				action = "close"
			})
			open = false
		end
	end
end)

RegisterNetEvent('jsfour-idcard:openuseid')
AddEventHandler('jsfour-idcard:openuseid', function()
local playerPed = PlayerPedId()

	ESX.TriggerServerCallback('jsfour-idcard:getItemAmount', function(quantity)
		if quantity > 0 then
			local player, distance = ESX.Game.GetClosestPlayer()
			TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()))
			if distance ~= -1 and distance <= 1.5 then
			TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(player))
			end
		else
			ESX.ShowNotification('You dont have Citizen ID.')
		end
	end, 'id_card')
end)

RegisterNetEvent('jsfour-idcard:openusedriver')
AddEventHandler('jsfour-idcard:openusedriver', function()
local playerPed = PlayerPedId()

	ESX.TriggerServerCallback('jsfour-idcard:getItemAmount', function(quantity)
		if quantity > 0 then
			local player, distance = ESX.Game.GetClosestPlayer()
			TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'driver')
			if distance ~= -1 and distance <= 1.5 then
			TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(player), 'driver')
			end
		else
			ESX.ShowNotification('You dont have Driver License Card.')
		end
	end, 'license_drive')
end)

RegisterNetEvent('jsfour-idcard:openusehunting')
AddEventHandler('jsfour-idcard:openusehunting', function()
local playerPed = PlayerPedId()

	ESX.TriggerServerCallback('jsfour-idcard:getItemAmount', function(quantity)
		if quantity > 0 then
			local player, distance = ESX.Game.GetClosestPlayer()
			TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'hunting')
			if distance ~= -1 and distance <= 1.5 then
			TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(player), 'hunting')
			end
		else
			ESX.ShowNotification('You dont have Hunting License Card.')
		end
	end, 'license_hunting')
end)

RegisterNetEvent('jsfour-idcard:openuseweapon')
AddEventHandler('jsfour-idcard:openuseweapon', function()
local playerPed = PlayerPedId()

	ESX.TriggerServerCallback('jsfour-idcard:getItemAmount', function(quantity)
		if quantity > 0 then
			local player, distance = ESX.Game.GetClosestPlayer()
			TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'weapon')
			if distance ~= -1 and distance <= 1.5 then
			TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(player), 'weapon')
			end
		else
			ESX.ShowNotification('You dont have Weapon License Card.')
		end
	end, 'license_weapon')
end)


