local peds = {}

function CreateBlip(position)
    local blip = AddBlipForCoord(position.x, position.y, position.z)

	SetBlipSprite(blip, Config.Blipsss.Sprite)
	SetBlipDisplay(blip, Config.Blipsss.Display)
	SetBlipScale(blip, Config.Blipsss.Size)
	SetBlipColour(blip, Config.Blipsss.Color)
    SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName('STRING')
	AddTextComponentSubstringPlayerName(Config.Blipsss.Text)
	EndTextCommandSetBlipName(blip)
end

function GetClosest()
    local closest, index, bestDistance = nil, nil, nil
    local playerPed = PlayerPedId()
    for _, ped in ipairs(peds) do
        local dist = #(GetEntityCoords(playerPed) - GetEntityCoords(ped))
        if closest == nil or distance < bestDistance then
            closest = ped
            index = _
            bestDistance = dist
        end
    end
    return closest, index
end

CreateThread(function()
    exports.ox_inventory:displayMetadata('name', "Name")
    exports.ox_inventory:displayMetadata('dateofbirth', "Date of birth")
    Wait(2000)
    lib.registerContext({
        id = 'job_centre',
        title = "Job center",
        options = {
            {
                title = "Liste des jobs",
                icon = 'fa-solid fa-list',
                arrow = true,
                onSelect = function()
                    lib.showContext('job_centre:jobs')
                end
            },
            {
                title = "Les licenses",
                icon = 'fa-solid fa-id-card',
                arrow = true,
                onSelect = function()
                    lib.showContext('job_centre:licenses')
                end
            }
        }
    })
    lib.callback('om_jobcentre:getJobs', 0, function(jobs)
        --Make sure unemployed is first
        local options = { 
            { 
                title = 'Unemployed',
                icon = Config.JobIcons['unemployed'],
                onSelect = function()
                    local closest, index = GetClosest()
                    TriggerServerEvent('om_jobcentre:hired', index, 'unemployed')
                    ShowNotification("Vous vous êtes retirer de votre job", 'inform')
                end
            } 
        }
        for k,v in pairs(jobs) do
            if not v.whitelisted and k ~= 'unemployed' then
                --[[table.insert(options, {
                    title = v.label,
                    icon = Config.JobIcons[k],
                    onSelect = function()
                        CreateThread(function()
                            local closest, index = GetClosest()
                            lib.requestAnimDict('missfbi3_party_d')
                            TaskPlayAnim(PlayerPedId(), 'missfbi3_party_d', 'stand_talk_loop_a_male2', 2.0, 1.0, 6500, 16)
                            TaskPlayAnim(closest, 'missfbi3_party_d', 'stand_talk_loop_a_male1', 2.0, 1.0, 5500, 16)
                            lib.progressBar({
                                duration = 5000,
                                label = "Vous parler ...",
                                useWhileDead = false,
                                canCancel = false,
                                disable = {
                                    car = true,
                                },
                            })
                            Wait(1000)
                            ShowNotification("Vous avez etez rectuter", 'success')
                            TriggerServerEvent('om_jobcentre:hired', index, k)
                        end)
                    end
                })]]
            end
        end
        lib.registerContext({
            id = 'job_centre:jobs',
            title = "Liste des jobs",
            menu = 'job_centre',
            options = options
        })
    end)
    local options = {}
    for k,v in ipairs(Config.Licenses) do
        table.insert(options, {
            title = v.Label,
            description = "Le prix est de " .. v.Price .. "$",
            icon = v.Icon,
            onSelect = function()
                local closest, index = GetClosest()
                lib.callback('om_jobcentre:buy', 0, function(success, message)
                    if success then
                        lib.requestAnimDict('missfbi3_party_d')
                        TaskPlayAnim(PlayerPedId(), 'missfbi3_party_d', 'stand_talk_loop_a_male2', 2.0, 1.0, 6500, 16)
                        TaskPlayAnim(closest, 'missfbi3_party_d', 'stand_talk_loop_a_male1', 2.0, 1.0, 5500, 16)
                        lib.progressBar({
                            duration = 5000,
                            label = "Vous parler ...",
                            useWhileDead = false,
                            canCancel = false,
                            disable = {
                                car = true,
                            },
                        })
                        TriggerServerEvent('om_jobcentre:buy', index, k)
                        lib.requestAnimDict('mp_common')
                        TaskPlayAnim(PlayerPedId(), 'mp_common', 'givetake1_a', 2.0, 1.0, 2000, 16)
                        Wait(2000)
                        TaskPlayAnim(closest, 'mp_common', 'givetake1_a', 2.0, 1.0, 2000, 16)
                        Wait(1500)
                        ShowNotification("Vous avez acheté une license", 'success')
                    else
                        ShowNotification(message, 'error')
                    end
                end, index, k)
            end
        })
    end
    lib.registerContext({
        id = 'job_centre:licenses',
        title = "Les licenses",
        menu = 'job_centre',
        options = options
    })
    while not ESX.IsPlayerLoaded() do
        Wait(100)
    end
    for k,v in ipairs(Config.Locations) do
        lib.requestModel(v.Ped)
        local ped = CreatePed(4, v.Ped, v.Coords.x, v.Coords.y, v.Coords.z - 1.0, v.Coords.w, false, true)
        table.insert(peds, ped)
        CreateBlip(v.Coords)
        SetEntityInvincible(ped, true)
        FreezeEntityPosition(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        if Config.Target == 'ox_target' then
            exports.ox_target:addLocalEntity(ped, {
                {
                    name = 'job_centre',
                    icon = 'fa-solid fa-id-card-clip',
                    label = "Job center",
                    canInteract = function(entity, distance, coords, name, bone)
                        return distance < 2.0
                    end,
                    onSelect = function()
                        lib.showContext('job_centre')
                    end
                }
            })
        else
            exports.qtarget:AddEntityZone(ped, ped, {
                name = ped,
                debugPoly = false,
                useZ = true
            }, 
            {
                options = {
                    {
                        label = "Job center",
                        icon = 'fa-solid fa-id-card-clip',
                        action = function()
                            lib.showContext('job_centre')
                        end
                    }
                },
                distance = 2.0
            })  
        end
    end
end)