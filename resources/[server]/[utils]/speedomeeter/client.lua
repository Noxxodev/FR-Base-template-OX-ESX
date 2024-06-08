local ind = {l = false, r = false}

CreateThread(function()
	while true do
		local Ped = PlayerPedId()
		if(IsPedInAnyVehicle(Ped)) then
			Wait(1)
			local PedCar = GetVehiclePedIsIn(Ped, false)
			if PedCar and GetPedInVehicleSeat(PedCar, -1) == Ped then

				-- Speed
				carSpeed = math.ceil(GetEntitySpeed(PedCar) * 3.6)
				SendNUIMessage({
					showhud = true,
					speed = carSpeed
				})

				-- Lights
				_,feuPosition,feuRoute = GetVehicleLightsState(PedCar)
				if(feuPosition == 1 and feuRoute == 0) then
					SendNUIMessage({
						feuPosition = true
					})
				else
					SendNUIMessage({
						feuPosition = false
					})
				end
				if(feuPosition == 1 and feuRoute == 1) then
					SendNUIMessage({
						feuRoute = true
					})
				else
					SendNUIMessage({
						feuRoute = false
					})
				end

				-- Turn signal
				-- SetVehicleIndicatorLights (1 left -- 0 right)
				local VehIndicatorLight = GetVehicleIndicatorLights(GetVehiclePedIsUsing(PlayerPedId()))
				if IsControlJustPressed(1, 57) then -- F9 is pressed
					ind.l = not ind.l
					SetVehicleIndicatorLights(GetVehiclePedIsUsing(PlayerPedId()), 0, ind.l)
				end
				if IsControlJustPressed(1, 56) then -- F10 is pressed
					ind.r = not ind.r
					SetVehicleIndicatorLights(GetVehiclePedIsUsing(PlayerPedId()), 1, ind.r)
				end

				if(VehIndicatorLight == 0) then
					SendNUIMessage({
						clignotantGauche = false,
						clignotantDroite = false,
					})
				elseif(VehIndicatorLight == 1) then
					SendNUIMessage({
						clignotantGauche = true,
						clignotantDroite = false,
					})
				elseif(VehIndicatorLight == 2) then
					SendNUIMessage({
						clignotantGauche = false,
						clignotantDroite = true,
					})
				elseif(VehIndicatorLight == 3) then
					SendNUIMessage({
						clignotantGauche = true,
						clignotantDroite = true,
					})
				end
			else
				SendNUIMessage({
					showhud = false
				})
			end
		else
			SendNUIMessage({showhud = false })
			Wait(2000)
		end
		Wait(1)
	end
end)

Citizen.CreateThread(function()
	while true do
		local Ped = PlayerPedId()
		if(IsPedInAnyVehicle(Ped)) then
			Wait(1)
			local PedCar = GetVehiclePedIsIn(Ped, false)
			if PedCar and GetPedInVehicleSeat(PedCar, -1) == Ped then
				carSpeed = math.ceil(GetEntitySpeed(PedCar) * 3.6)
				fuel = GetVehicleFuelLevel(PedCar)
				rpm = GetVehicleCurrentRpm(PedCar)
				rpmfuel = 0

				if rpm > 10 then
					rpmfuel = fuel - rpm / 1.0
					Citizen.Wait(2000)
				elseif rpm > 20 then
					rpmfuel = fuel - rpm / 1.5
					Citizen.Wait(2500)
				elseif rpm > 30 then
					rpmfuel = fuel - rpm / 2.0
					Citizen.Wait(3000)
				elseif rpm > 40 then
					rpmfuel = fuel - rpm / 2.5
					Citizen.Wait(3500)
				elseif rpm > 50 then
					rpmfuel = fuel - rpm / 3.0
					Citizen.Wait(6000)
				elseif rpm > 60 then
					rpmfuel = fuel - rpm / 3.5
					Citizen.Wait(6500)
				elseif rpm > 70 then
					rpmfuel = fuel - rpm / 4.0
					Citizen.Wait(7000)
				elseif rpm > 80 then
					rpmfuel = fuel - rpm / 4.5
					Citizen.Wait(7500)
				else
					rpmfuel = fuel - rpm / 5.0
					Citizen.Wait(15000)
				end

				carFuel = SetVehicleFuelLevel(PedCar, rpmfuel)

				SendNUIMessage({ showfuel = true, fuel = fuel })
			end
		else
			Wait(2000)
		end
	end
end)

AddEventHandler("PlayerSpawned", function()
	SendNUIMessage({showhud = false })
end)

AddEventHandler("onResourceStart", function()
	SendNUIMessage({showhud = false })
end)