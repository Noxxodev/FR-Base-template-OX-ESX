ESX = exports["es_extended"]:getSharedObject()

RegisterNetEvent('nox_location:prix')
AddEventHandler('nox_location:prix', function(prix)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeMoney(prix)
end)

AddEventHandler('onResourceStart', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then
		return
	end
	print("-----------------------------------------------------------------------------------")
	print("                                     Wind Studio                                   ")
	print("                                 Location de voiture                               ")
	print("-----------------------------------------------------------------------------------")
end)