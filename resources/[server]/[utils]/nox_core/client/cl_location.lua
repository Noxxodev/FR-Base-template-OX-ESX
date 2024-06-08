ESX = exports["es_extended"]:getSharedObject()

local nombremenu

Citizen.CreateThread(function()
    for k, v in pairs(Config.localisation) do
        local hash = GetHashKey(v.name)
        while not HasModelLoaded(hash) do
            RequestModel(hash)
            Wait(1000)
        end
        local ped = CreatePed(4, hash, v.pos.x, v.pos.y, v.pos.z - 1.0, v.pos.h, false, true)
        SetBlockingOfNonTemporaryEvents(ped, v.blocking)
        SetEntityInvincible(ped, v.invincible)
        FreezeEntityPosition(ped, v.freeze)

        exports.qtarget:AddBoxZone("location_"..k, vector3(v.pos.x, v.pos.y, v.pos.z - 0.9), 1.0, 1.5, {
            name = "location_"..k,
            heading = 35,
            debugPoly = false,
            minZ = v.pos.z - 1.0,
            maxZ = v.pos.z + 1.0,
        }, {
            options = {
                {
                    icon = v.icon,
                    label = v.titre,
                    action = function()
                        nombremenu = v.menu
                        lib.showContext('location')
                    end
                },
            },
            distance = v.distance
        })

        local blip = AddBlipForCoord(v.pos.x, v.pos.y, v.pos.z)
        SetBlipSprite(blip, v.blip.sprite)
        SetBlipScale(blip, v.blip.scale)
        SetBlipColour(blip, v.blip.colour)
        SetBlipAsShortRange(blip, true)

        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString(v.blip.name)
        EndTextCommandSetBlipName(blip)
    end
end)

Citizen.CreateThread(function()
    local options = {}
    for k, v in pairs(Config.vehicule) do
        table.insert(options, {
            title = v.label,
            description = v.description,
            image = v.image,
            onSelect = function()
                local car = v.vehicule
                local prix = v.prix
                TriggerEvent('nox_location:spawncar', car, prix, nombremenu)
            end
        })
    end

    lib.registerContext({
        id = 'location',
        title = 'Location de voiture',
        options = options
    })
end)

RegisterNetEvent('nox_location:spawncar')
AddEventHandler('nox_location:spawncar', function(car, prix, menuId)
    local argent = exports.ox_inventory:Search('count', 'money')
    if argent >= prix then
        for k, v in pairs(Config.posvehicule) do
            if v.nombre == menuId then
                local carHash = GetHashKey(car)
                RequestModel(carHash)
                while not HasModelLoaded(carHash) do
                    RequestModel(carHash)
                    Citizen.Wait(0)
                end
                local vehicle = CreateVehicle(carHash, v.posspawn.x, v.posspawn.y, v.posspawn.z, v.posspawn.h, true, false)
                TriggerServerEvent('nox_location:prix', prix)
                SetEntityAsMissionEntity(vehicle, true, true)
                SetVehicleNumberPlateText(vehicle, "LOCATION")
                SetPedIntoVehicle(GetPlayerPed(-1), vehicle, -1)

                local time = v.tempslocation
                while time > 0 do
                    Wait(1000)
                    time = time - 1
                    if time == v.tempsfinlocation then
                        DeleteVehicle(vehicle)
                        if Config.notif == 1 then
                            ESX.ShowNotification('Le temps de location est fini.')
                        end
                        if Config.notif == 2 then
                            lib.notify({
                                title = 'Location',
                                description = "Le temps de location est fini.",
                                type = 'inform',
                                duration = 10000,
                            })
                        end
                        
                    end
                end
                break
            end
        end
    else
        if Config.notif == 1 then
            ESX.ShowNotification("Vous n'avez pas assez d'argent.")
        end
        if Config.notif == 2 then
            lib.notify({
                title = 'Location',
                description = "Vous n'avez pas assez d'argent.",
                type = 'inform',
                duration = 10000,
            })
        end
        
    end
end)
