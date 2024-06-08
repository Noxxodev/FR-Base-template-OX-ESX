ESX = exports["es_extended"]:getSharedObject()
local PlayerData = nil
local hp


  local armor
  local health
  local HunVal = 0
  local ThiVal = 0
  local source = xPlayer
  Citizen.CreateThread(function()
	  while(true) do
		  Citizen.Wait(500)
		  TriggerEvent('esx_status:getStatus', 'hunger', function(status)
			  HunVal = status.val/1000000*100
		  end)
		  TriggerEvent('esx_status:getStatus', 'thirst', function(status)
			  ThiVal = status.val/1000000*100
		  end)
	  end
  end)
  
  Citizen.CreateThread(function()
   while true do
		  Citizen.Wait(500)
		  playerPed = PlayerPedId()
		  hp = GetEntityHealth(playerPed)
		  if hp == 175 then
			hp = 200
			SetEntityHealth(playerPed, 200)
		  end
		  SendNUIMessage({
			  hp = hp - 100,
			  ar = GetPedArmour(playerPed),
			  hg =  HunVal,
			  th =  ThiVal,
			  pcount = #GetActivePlayers()
		  })
	  end
  end)

