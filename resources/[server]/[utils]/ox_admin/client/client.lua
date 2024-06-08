lib.locale()

local isStaffModeEnabled = false

function openStaffModeMenu()
    lib.registerContext({
        id = 'staff_mode_menu',
        title = locale('titlestaff'),
        onExit = function()
        end,
        options = {
            {
                title = locale('activestaff'),
                description = locale('activestaff_desc'),
                icon = 'fas fa-user-shield',
                iconColor = '#ff0008',
                onSelect = function(args)
                    local playerID = PlayerId()
                    local playerName = GetPlayerName(playerID)
            
                    isStaffModeEnabled = true
                    openAdminMenu()
                    TriggerServerEvent('mizu_admin:enableStaffMode')
                    ShowNotification(playerName .. " vient d'activer le mode staff", 'info')
                    if Config.MessageStaffActived then
                        while isStaffModeEnabled do
                            DrawText2D('['..playerName..'] Staff Mode Activated', 0.89, 0.9, 0.5)
                            Wait(0)
                        end
                    end
                end,
            },
        },
    })
    lib.showContext('staff_mode_menu')
end

DrawText2D = function(text, x, y, size)
	SetTextScale(size, size)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextEntry("STRING")
	SetTextCentre(1)
	SetTextColour(255, 255, 255, 255)
	SetTextOutline()

	AddTextComponentString(text)
	DrawText(x, y)
end

function openAdminMenu()
    if not isStaffModeEnabled then
        openStaffModeMenu()
        return
    end

    lib.registerContext({
        id = 'admin_menu',
        title = locale('titleactivestaff'),
        onExit = function()
        end,
        options = {
            {
                title = locale('activatedstaff'),
                description = locale('activatedstaff_desc'),
                icon = 'fas fa-user-shield',
                iconColor = '#00ff3c',
                onSelect = function(args)
                    local playerID = PlayerId()
                    local playerName = GetPlayerName(playerID)
            
                    isStaffModeEnabled = false
                    openStaffModeMenu()
                    TriggerServerEvent('mizu_admin:disableStaffMode')
                    
                    ShowNotification(playerName .. " vient de désactiver le mode staff", 'info')
            
                end,
            },

            {
                title = 'Gamertags',
                description = 'Activer/Désactiver les noms des joueurs',
                icon = 'user',
                iconColor = '#0032FF',
                onSelect = function(args)
                    
                    ShowNotification("Vous venez d'activer les noms des joueurs", 'info')
            
                    TriggerEvent('esx_adminmenu:toggleIdsAndNames')
                end,
            },
            {
                title = locale('playergestion'),
                description = locale('playergestion_desc'),
                icon = 'fas fa-user-cog',
                iconColor = '#ffaa00',
                onSelect = function(args)
                    TriggerServerEvent('mizu_admin:manageUsers')
                end,
            },
            {
                title = locale('logactivity'),
                description = locale('logactivity_desc'),
                icon = 'fas fa-history',
                onSelect = function(args)
                    lib.registerContext({
                        id = 'activity_log_submenu',
                        title = locale('titlelogactivity'),
                        menu = 'mizu_menu',
                        onBack = function(args)
                            lib.showContext('admin_menu')
                        end,
                        options = {
                            {
                                title = locale('titlejailoption'),
                                description = locale('titlejailoption_desc'),
                                icon = 'fa-gavel',
                                onSelect = function(args)
                                    local input = lib.inputDialog('Entrer l\'ID, le temps et la raison du jail', {'ID du Joueur', 'Temps en minutes', 'Raison'})
                            
                                    if not input then return end
                            
                                    local playerID = tonumber(input[1])
                                    local jailTime = tonumber(input[2])
                                    local reason = input[3]
                            
                                    if playerID and jailTime and reason then
                                        local position = {
                                            x = 1642.28,
                                            y = 2570.56,
                                            z = 45.56
                                        }
                                        TriggerServerEvent('mizu_admin:jailPlayer', playerID, jailTime, reason, position)
                                    else
                                        print("Erreur: ID, Temps ou raison invalide")
                                    end
                                    lib.showContext('activity_log_submenu')
                                end,
                            },
                            {
                                title = locale('titlejailist'),
                                description = locale('titlejaillist_desc'),
                                icon = 'fas fa-user-lock',
                                onSelect = function(args)
                                    TriggerServerEvent('requestJailLog')
                                end,
                            },
                            {
                                title = locale('titlebanlist'),
                                description = locale('titlebanlist_desc'),
                                icon = 'fas fa-user-slash',
                                onSelect = function(args)
                                    TriggerServerEvent('requestBanList')
                                end,
                            },
                        }
                    })
            
                    lib.showContext('activity_log_submenu')
                end,
            },
            {
                title = locale('titlegestionveh'),
                description = locale('titlegestionveh_desc'),
                icon = 'fas fa-car',
                onSelect = function(args)
                    openVehicleManagerMenu()
                end,
            },
            {
                title = locale('titleserversetting'),
                description = locale('titleserversetting_desc'),
                icon = 'fas fa-cogs',
                onSelect = function()
                    if Config.ParametreDuServeur then
                        TriggerEvent('tsettings_menu')
                    else
                        ShowNotification("Le boutton paramètre du serveur est désactivé", 'info')
                    end
                end,
            },

            {
                title = locale('titlereport'),
                description = locale('titlereport_desc'),
                icon = 'fas fa-exclamation-triangle',
                iconColor = '#b50000',
                onSelect = function(args)
                    openReportManagerMenu()
                end,
            },
        },
    })
    lib.showContext('admin_menu')
end

function openVehicleManagerMenu()
    lib.registerContext({
        id = 'vehicle_management_menu',
        title = locale('titlegestionveh'),
        menu = 'mizu_menu',
        onBack = function(args)
            lib.showContext('admin_menu')
        end,
        options = {
            {
                title = locale('vehfix'),
                description = locale('vehfix_desc'),
                icon = 'fas fa-wrench',
                onSelect = function(args)
                    TriggerEvent('mizu_admin:repairVehicle')
                    ShowNotification("Vous avez réparé le véhicule", 'warning')
                    lib.showContext('vehicle_management_menu')
                end,
            },
            {
                title = locale('spawnveh'),
                description = locale('spawnveh_desc'),
                icon = 'fas fa-car-side',
                onSelect = function(args)
                    local input = lib.inputDialog('Nom du Véhicule', {
                        {
                            type = 'select',
                            label = 'Nom du Véhicule',
                            options = {
                                {label = 'Adder', value = 'adder'},
                                {label = 'Zentorno', value = 'zentorno'},
                                {label = 'T20', value = 't20'},
                            },
                            required = true,
                        },
                    })
                    
                    if input then
                        local vehicleName = input[1]
                        
                        if vehicleName then
                            ExecuteCommand('car ' .. vehicleName)
                        else
                            print("Erreur: Nom de véhicule invalide")
                        end
                    end
                    lib.showContext('vehicle_management_menu')
                end,
            },
            {
                title = locale('dvveh'),
                description = locale('dvveh_desc'),
                icon = 'fas fa-paint-roller',
                onSelect = function(args)
                    local input = lib.inputDialog('Nombre de véhicules à supprimer', {
                        {
                            type = 'select',
                            label = 'Nombre de véhicules',
                            options = {
                                {label = '1', value = '1'},
                                {label = '10', value = '10'},
                                {label = '50', value = '50'},
                            },
                        },
                    })
                    
                    if input then
                        local numVehicles = input[1]
                        
                        if numVehicles then
                            for i=1, tonumber(numVehicles) do
                                ExecuteCommand('dv ' .. numVehicles )
                            end
                        else
                            print("Erreur: Nombre de véhicules invalide")
                        end
                    end
                    lib.showContext('vehicle_management_menu')
                end,
            },
        }
    })
    lib.showContext('vehicle_management_menu')
end

RegisterNetEvent('mizu_admin:repairVehicle')
AddEventHandler('mizu_admin:repairVehicle', function()
    local player = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(player, false)
    if vehicle ~= 0 then
        SetVehicleFixed(vehicle)
        SetVehicleDirtLevel(vehicle, 0.0)
        ShowNotification("Le véhicule a été réparé.", 'success')
    else
        ShowNotification("Aucun véhicule à réparer.", 'error')
    end
end)

function openReportManagerMenu()
    TriggerServerEvent('mizu_admin:requestReports')

    RegisterNetEvent('mizu_admin:receiveReports')
    AddEventHandler('mizu_admin:receiveReports', function(reports)
        lib.registerContext({
            id = 'report_manager_submenu',
            title = locale('titlegestionreports'),
            menu = 'mizu_menu',
            onBack = function(args)
                lib.showContext('admin_menu')
            end,
            options = buildReportOptions(reports),
        })

        lib.showContext('report_manager_submenu')
    end)
end

RegisterNetEvent('MizuAdmin:showReportNotification')
AddEventHandler('MizuAdmin:showReportNotification', function(playerName, playerID, reason)
    if isStaffModeEnabled then
        ShowNotification("Nouveau report de " .. playerName .. " (ID: " .. playerID .. "): " .. reason, 'warning')

        PlaySoundFrontend(-1, "Event_Message_Purple", "GTAO_FM_Events_Soundset", 1)
    end
end)

function buildReportOptions(reports)
    local options = {}

    for i, report in ipairs(reports) do
        local description = "Nom : " .. report.player_name .. "\n" .. "ID : " .. report.player_id .. "\n" .. "Raison : " .. report.reason

        local iconColor = report.admin_name and '#00b500' or '#b50000'

        table.insert(options, {
            title = locale('titlereports') .. report.id,
            description = description,
            icon = 'fas fa-exclamation-triangle',
            iconColor = iconColor,
            onSelect = function(args)
                local adminName = GetPlayerName(PlayerId())
                TriggerServerEvent('mizu_admin:takeReport', report.id, adminName)
                buildReportSubMenu(report, adminName)
            end,
            onBack = function(args)
                lib.showContext('admin_menu')
            end,
        })
    end

    return options
end

function buildReportSubMenu(report, adminName)
    lib.registerContext({
        id = 'report_submenu' .. report.id,
        title = locale('titlegestionreportreception') .. report.id,
        menu = 'mizu_menu',
        onBack = function(args)
            lib.showContext('admin_menu')
        end,
        options = {
            {
                title = locale('titleinforeport'),
                description = "Nom : " .. report.player_name .. "\n" .. "ID : " .. report.player_id .. "\n" .. "Raison : " .. report.reason .. "\n" .. "Pris en charge par : " .. (adminName or "Personne"),
                onSelect = function()
                end
            },
            {
                title = locale('titleteleport'),
                description = locale('titleteleport_desc'),
                icon = 'fa-location-arrow',
                onSelect = function(args)
                    lib.registerContext({
                        id = 'teleport_report' .. report.player_id,
                        title = locale('titleteleportof') .. report.player_name,
                        menu = 'mizu_menu',
                        onBack = function(args)
                            lib.showContext('report_submenu' .. report.id)
                        end,
                        options = {
                            {
                                title = locale('titleteleporttoplayer'),
                                description = locale('titleteleporttoplayer_desc') .. report.player_name,
                                icon = 'fa-user',
                                onSelect = function(args)
                                    TriggerServerEvent('mizu_admin:getPlayerPosition', report.player_id)
                                    ShowNotification("Vous vous êtes téléporter à " .. report.player_name, 'info')
                                    lib.showContext('teleport_report' .. report.player_id)
                                end,
                            },
                            {
                                title = locale('titleteleportplayertocentral'),
                                description = locale('titleteleportplatertocentral_desc') .. report.player_name .. locale('titleteleportplatertocentral_desc2'),
                                icon = 'fa-car',
                                onSelect = function(args)
                                    local position = {
                                        x = 221.85,
                                        y = -809.17,
                                        z = 30.64
                                    }
                            
                                    if report.player_id == nil then
                                        print("Error: info.id is nil")
                                        return
                                    end
                            
                                    TriggerServerEvent('mizu_admin:teleportToPosition', report.player_id, position)
                                    ShowNotification("Vous avez téléporté " .. report.player_name .. " au parking central", 'info')
                                    lib.showContext('teleport_report' .. report.player_id)
                                end,
                            },
                            {
                                title = locale('titleteleportplayertoimpound'),
                                description = locale('titleteleportplayertoimpound_desc') .. report.player_name .. locale('titleteleportplayertoimpound_desc2'),
                                icon = 'fa-truck',
                                onSelect = function(args)
                                    local position = {
                                        x = 403.20,
                                        y = -1627.61,
                                        z = 29.29
                                    }
                            
                                    if report.player_id == nil then
                                        print("Error: info.id is nil")
                                        return
                                    end
                            
                                    TriggerServerEvent('mizu_admin:teleportToPosition', report.player_id, position)
                                    ShowNotification("Vous avez téléporté " .. report.player_name .. " à la fourrière", 'info')
                                    lib.showContext('teleport_report' .. report.player_id)
                                end,
                            },
                            {
                                title = locale('titleteleportplayertohospital'),
                                description = locale('titleteleportplayertohospital_desc') .. report.player_name .. locale('titleteleportplayertohospital_desc2'),
                                icon = 'fa-hospital',
                                onSelect = function(args)
                                    local position = {
                                        x = -446.88,
                                        y = -362.27,
                                        z = 33.56
                                    }
                            
                                    if report.player_id == nil then
                                        print("Error: info.id is nil")
                                        return
                                    end
                            
                                    TriggerServerEvent('mizu_admin:teleportToPosition', report.player_id, position)
                                    ShowNotification("Vous avez téléporté " .. report.player_name .. " à l'hopital", 'info')
                                    lib.showContext('teleport_report' .. report.player_id)
                                end,
                            },
                            {
                                title = locale('titleteleportplayertoclothing'),
                                description = locale('titleteleportplayertoclothing_desc') .. report.player_name .. locale('titleteleportplayertoclothing_desc2'),
                                icon = 'fa-tshirt',
                                onSelect = function(args)
                                    local position = {
                                        x = -154.04,
                                        y = -306.00,
                                        z = 37.70
                                    }
                            
                                    if report.player_id == nil then
                                        print("Error: report.player_id is nil")
                                        return
                                    end
                            
                                    TriggerServerEvent('mizu_admin:teleportToPosition', report.player_id, position)
                                    ShowNotification("Vous avez téléporté " .. report.player_name .. " au magasin de vêtement", 'info')
                                    lib.showContext('teleport_report' .. report.player_id)
                                end,
                            },
                        },
                    })
            
                    lib.showContext('teleport_report' .. report.player_id)
                end,
            },
            {
                title = locale('titlehealplayer'),
                description = locale('titlehealplayer_desc') .. report.player_name,
                onSelect = function()
                    ExecuteCommand('heal ' .. report.player_id)
                    lib.showContext('report_submenu' .. report.id)
                end
            },
            {
                title = locale('titlereviveplayer'),
                description = locale('titlereviveplayer_desc') .. report.player_name,
                onSelect = function()
                    ExecuteCommand('revive ' .. report.player_id)
                    lib.showContext('report_submenu' .. report.id)
                end
            },
            {
                title = locale('closereport'),
                description = locale('closereport_desc'),
                onSelect = function()
                    TriggerServerEvent('mizu_admin:closeReport', report.id)
                    lib.showContext('admin_menu')
                end
            }
        },
    })

    lib.showContext('report_submenu' .. report.id)
end

RegisterNetEvent('mizu_admin:showUserManager')
AddEventHandler('mizu_admin:showUserManager', function(playerInfo)
    local options = {}

    for _, info in ipairs(playerInfo) do
        table.insert(options, {
            title = info.name,
            description = "ID : "..info.id..", Groupe : "..info.group,
            icon = 'fa-user',
        })
    end

    lib.registerContext({
        id = 'user_manager_menu',
        title = locale('titlegestionplayer'),
        menu = 'mizu_menu',
        onBack = function(args)
            lib.showContext('admin_menu')
        end,
        options = options,
    })

    lib.showContext('user_manager_menu')
end)

RegisterNetEvent('mizu_admin:showUserManager')
AddEventHandler('mizu_admin:showUserManager', function(playerInfo)
    local options = {}

    for _, info in ipairs(playerInfo) do
        table.insert(options, {
            title = info.name,
            description = "ID : "..info.id..", Groupe : "..info.group,
            icon = 'fa-user',
            onSelect = function()
                lib.registerContext({
                    id = 'manage_user_'..info.id,
                    title = locale('titlegestplayer') .. info.name,
                    menu = 'mizu_menu',
                    onBack = function(args)
                        lib.showContext('user_manager_menu') 
                    end,
                    options = {
                        {
                            title = locale('titleplayerinfo'),
                            description = locale('titleplayerinfo_desc'),
                            icon = 'fa-info',
                            onSelect = function(args)
                                lib.registerContext({
                                    id = 'user_info_' .. info.id,
                                    title = locale('titleinformationof') .. info.name,
                                    menu = 'mizu_menu',
                                    onBack = function(args)
                                        lib.showContext('manage_user_' .. info.id)
                                    end,
                                    options = {
                                        {
                                            title = locale('titlejob'),
                                            description = info.job_label or "Aucun",
                                            icon = 'fa-briefcase',
                                            onSelect = function(args)
                                                ShowNotification("ID : " .. info.id .. " | Joueur : " .. info.name .. " | Group : " .. info.group, 'warning')
                                                lib.showContext('user_info_' .. info.id)
                                            end,
                                        },
                                        {
                                            title = locale('titlerank'),
                                            description = info.grade_label or "Aucun",
                                            icon = 'fa-graduation-cap',
                                            onSelect = function(args)
                                                ShowNotification("ID : " .. info.id .. " | Joueur : " .. info.name .. " | Group : " .. info.group, 'warning')
                                                lib.showContext('user_info_' .. info.id)
                                            end,
                                        },
                                        {
                                            title = locale('titlename'),
                                            description = info.firstname or "Inconnu",
                                            icon = 'fa-user',
                                            onSelect = function(args)
                                                ShowNotification("ID : " .. info.id .. " | Joueur : " .. info.name .. " | Group : " .. info.group, 'warning')
                                                lib.showContext('user_info_' .. info.id)
                                            end,
                                        },
                                        {
                                            title = locale('titleothername'),
                                            description = info.lastname or "Inconnu",
                                            icon = 'fa-user',
                                            onSelect = function(args)
                                                ShowNotification("ID : " .. info.id .. " | Joueur : " .. info.name .. " | Group : " .. info.group, 'warning')
                                                lib.showContext('user_info_' .. info.id)
                                            end,
                                        },
                                        {
                                            title = locale('titlefivemlicense'),
                                            description = info.identifier or "Non disponible",
                                            icon = 'fa-id-card',
                                            onSelect = function(args)
                                                ShowNotification("ID : " .. info.id .. " | Joueur : " .. info.name .. " | Group : " .. info.group, 'warning')
                                                lib.showContext('user_info_' .. info.id)
                                            end,
                                        },
                                    },
                                })
                        
                                lib.showContext('user_info_' .. info.id)
                            end,
                        },
                        {
                            title = locale('titleteleport'),
                            description = locale('titleteleport_desc'),
                            icon = 'fa-location-arrow',
                            onSelect = function(args)
                                lib.registerContext({
                                    id = 'teleport_' .. info.id,
                                    title = locale('titleteleportof') .. info.name,
                                    menu = 'mizu_menu',
                                    onBack = function(args)
                                        lib.showContext('manage_user_' .. info.id)
                                    end,
                                    options = {
                                        {
                                            title = locale('titleteleporttoplayer'),
                                            description = locale('titleteleporttoplayer_desc') .. info.name,
                                            icon = 'fa-user',
                                            onSelect = function(args)
                                                TriggerServerEvent('mizu_admin:getPlayerPosition', info.id)
                                                ShowNotification("Vous vous êtes téléporter à " .. info.name, 'info')
                                                lib.showContext('teleport_' .. info.id)
                                            end,
                                        },

                                        {
                                            title = locale('titleteleportplayertocentral'),
                                            description = locale('titleteleportplatertocentral_desc') .. info.name .. locale('titleteleportplatertocentral_desc2'),
                                            icon = 'fa-car',
                                            onSelect = function(args)
                                                local position = {
                                                    x = 221.85,
                                                    y = -809.17,
                                                    z = 30.64
                                                }
                                        
                                                if info.id == nil then
                                                    print("Error: info.id is nil")
                                                    return
                                                end
                                        
                                                TriggerServerEvent('mizu_admin:teleportToPosition', info.id, position)
                                                ShowNotification("Vous avez téléporté " .. info.name .. " au parking central", 'info')
                                                lib.showContext('teleport_' .. info.id)
                                            end,
                                        },
                                        {
                                            title = locale('titleteleportplayertoimpound'),
                                            description = locale('titleteleportplayertoimpound_desc') .. info.name .. locale('titleteleportplayertoimpound_desc2'),
                                            icon = 'fa-truck',
                                            onSelect = function(args)
                                                local position = {
                                                    x = 403.20,
                                                    y = -1627.61,
                                                    z = 29.29
                                                }
                                        
                                                if info.id == nil then
                                                    print("Error: info.id is nil")
                                                    return
                                                end
                                        
                                                TriggerServerEvent('mizu_admin:teleportToPosition', info.id, position)
                                                ShowNotification("Vous avez téléporté " .. info.name .. " à la fourrière", 'info')
                                                lib.showContext('teleport_' .. info.id)
                                            end,
                                        },
                                        {
                                            title = locale('titleteleportplayertohospital'),
                                            description = locale('titleteleportplayertohospital_desc') .. info.name .. locale('titleteleportplayertohospital_desc2'),
                                            icon = 'fa-hospital',
                                            onSelect = function(args)
                                                local position = {
                                                    x = -446.88,
                                                    y = -362.27,
                                                    z = 33.56
                                                }
                                        
                                                if info.id == nil then
                                                    print("Error: info.id is nil")
                                                    return
                                                end
                                        
                                                TriggerServerEvent('mizu_admin:teleportToPosition', info.id, position)
                                                ShowNotification("Vous avez téléporté " .. info.name .. " à l'hopital", 'info')
                                                lib.showContext('teleport_' .. info.id)
                                            end,
                                        },
                                        {
                                            title = locale('titleteleportplayertoclothing'),
                                            description = locale('titleteleportplayertoclothing_desc') .. info.name .. locale('titleteleportplayertoclothing_desc2'),
                                            icon = 'fa-tshirt',
                                            onSelect = function(args)
                                                local position = {
                                                    x = -154.04,
                                                    y = -306.00,
                                                    z = 37.70
                                                }
                                        
                                                if info.id == nil then
                                                    print("Error: info.id is nil")
                                                    return
                                                end
                                        
                                                TriggerServerEvent('mizu_admin:teleportToPosition', info.id, position)
                                                ShowNotification("Vous avez téléporté " .. info.name .. " au magasin de vêtement", 'info')
                                                lib.showContext('teleport_' .. info.id)
                                            end,
                                        },
                                    },
                                })
                        
                                lib.showContext('teleport_' .. info.id)
                            end,
                        },
                        {
                            title = locale('titleoptiongive'),
                            description = locale('titleoptiongive_desc'),
                            icon = 'fa-gift', 
                            onSelect = function(args)
                                lib.registerContext({
                                    id = 'give_' .. info.id,
                                    title = locale('titlegiveoption') .. info.name,
                                    menu = 'mizu_menu',
                                    onBack = function(args)
                                        lib.showContext('manage_user_' .. info.id)
                                    end,
                                    options = {
                                        {
                                            title = locale('titlegivemoney'),
                                            description = locale('titlegivemoney_desc'),
                                            icon = 'fa-money-bill-wave', 
                                            onSelect = function(args)
                                                local input = lib.inputDialog('Give Money', {
                                                  {
                                                    type = 'number', 
                                                    label = 'Amount', 
                                                    description = 'Enter the amount of money', 
                                                    required = true, 
                                                    min = 1,
                                                    placeholder = '0',
                                                    icon = 'fa-money-bill-wave',
                                                  },
                                                  {
                                                    type = 'select', 
                                                    label = 'Type of Money', 
                                                    options = {
                                                        {value = 'money', label = 'Money'},
                                                        {value = 'bank', label = 'Bank'},
                                                        {value = 'black_money', label = 'Black Money'},
                                                    },
                                                    description = 'Select type of money',
                                                    required = true,
                                                    placeholder = 'Select type of money',
                                                    icon = 'fa-money-check',
                                                  },
                                                })
                                            
                                                if input then
                                                    local amount = input[1]
                                                    local typeOfMoney = input[2]
                                                    
                                                    TriggerServerEvent('mizu_admin:giveMoney', info.id, typeOfMoney, amount)
                                                    ShowNotification("Vous avez give à : " .. info.name .. " | Type : " .. typeOfMoney .. " | Montant : " .. amount, 'warning')
                                                    lib.showContext('manage_user_' .. info.id)
                                                end
                                            end
                                        }
                                    },
                                })
                        
                                lib.showContext('give_' .. info.id)
                            end,
                        },
                        {
                            title = locale('titlejailoption'),
                            description = locale('titlejailoption_desc'),
                            icon = 'fa-gavel',
                            onSelect = function(args)
                                local input = lib.inputDialog('Entrer le temps et la raison du jail', {'Temps en minutes', 'Raison'})
                        
                                if not input then return end
                        
                                local jailTime = tonumber(input[1])
                                local reason = input[2]
                        
                                if jailTime and reason then
                                    local position = {
                                        x = 1642.28,
                                        y = 2570.56,
                                        z = 45.56
                                    }
                                    TriggerServerEvent('mizu_admin:jailPlayer', info.id, jailTime, reason, position)
                                else
                                    print("Erreur: Temps ou raison invalide")
                                end
                                lib.showContext('manage_user_' .. info.id)
                            end,
                        },
                        {
                            title = locale('titlekickplayer'),
                            description = locale('titlekickplayer_desc'),
                            icon = 'fa-door-open',
                            onSelect = function()
                                TriggerServerEvent('mizu_admin:kickPlayer', info.id)
                            end,
                        },
                        {
                            title = locale('titlebanplayer'),
                            description = locale('titlebanplayer_desc'),
                            icon = 'fa-ban',
                            onSelect = function(args)
                                local input = lib.inputDialog('Details du Ban', {
                                    {type = 'input', label = 'Raison du Ban', description = 'Entrez la raison du bannissement', required = true},
                                    {type = 'number', label = 'Durée en heures', description = 'Entrez la durée du bannissement en heures', icon = 'hashtag'},
                                    {type = 'checkbox', label = 'Ban permanent', description = 'Cocher pour un ban permanent'}
                                })
                                
                                if not input then return end
                                
                                local reason = input[1]
                                local hours = tonumber(input[2])
                                local permanent = input[3]
                                
                                if reason and (hours or permanent) then
                                    TriggerServerEvent('mizu_admin:banPlayer', info.id, reason, hours, permanent)
                                else
                                    print("Erreur: Raison ou durée de ban invalide")
                                end
                                lib.showContext('manage_user_' .. info.id)
                            end,
                        },
                    },
                })
                lib.showContext('manage_user_'..info.id) 
            end,
        })
    end

    lib.registerContext({
        id = 'user_manager_menu',
        title = locale('titlegestionplayer'),
        menu = 'mizu_menu',
        onBack = function(args)
            lib.showContext('admin_menu')
        end,
        options = options,
    })

    lib.showContext('user_manager_menu')
end)

RegisterNetEvent('showJailLogMenu')
AddEventHandler('showJailLogMenu', function(jailData)
  local options = {}

  for i=1, #jailData, 1 do
    local row = jailData[i]

    table.insert(options, {
        title = row.name,
        description = locale('jaildatatime_desc') .. row.jailTime .. locale('jaildatatime_desc2') .. row.reason .. locale('jaildatatime_desc3') .. row.jailer,
        icon = 'fas fa-user-lock',
        onSelect = function(args)
            lib.registerContext({
                id = 'unjail_confirmation_menu',
                title = locale('titlejailconfirmation'),
                menu = 'mizu_menu',
                onBack = function(args)
                    lib.showContext('jail_log_menu')
                end,
                options = {
                    {
                        title = locale('titlejailconfirmation2'),
                        description = locale('titlejailconfirmation2_desc'),
                        icon = 'fas fa-check',
                        onSelect = function(args)
                            TriggerServerEvent('unjailPlayer', row.identifier)
                            lib.showContext('activity_log_submenu')
                        end
                    },
                    {
                        title = locale('titlejailconfirmation3'),
                        description = locale('titlejailconfirmation3_desc'),
                        icon = 'fas fa-times',
                        onSelect = function(args)
                            lib.showContext('jail_log_menu')
                        end
                    }
                },
            })

            lib.showContext('unjail_confirmation_menu') 
        end
    })
  end

  lib.registerContext({
    id = 'jail_log_menu',
    title = locale('titlelogjail'),
    menu = 'mizu_menu',
    onBack = function(args)
      lib.showContext('activity_log_submenu')
    end,
    options = options,
  })

  lib.showContext('jail_log_menu')
end)

RegisterNetEvent('showBanLogMenu')
AddEventHandler('showBanLogMenu', function(banData)
    local options = {}

    for i=1, #banData, 1 do
        local row = banData[i]
        local description = string.format(
            "Raison: %s. Par: %s. Date du ban: %s. Date d'expiration: %s.",
            row.reason,
            row.adminName,
            row.banTime,
            row.expireTime
        )

        table.insert(options, {
            title = row.playerName,
            description = description,
            icon = 'fas fa-user-slash',
            onSelect = function(args)
                lib.registerContext({
                    id = 'confirmation_menu',
                    title = locale('titlejailconfirmation'),
                    menu = 'mizu_menu',
                    onBack = function(args)
                        lib.showContext('ban_log_menu')
                    end,
                    options = {
                        {
                            title = locale('titlejailconfirmation2'),
                            description = locale('deban_desc'),
                            icon = 'fas fa-check',
                            onSelect = function(args)
                                TriggerServerEvent('unbanPlayer', row.identifier)
                                lib.showContext('activity_log_submenu')
                            end
                        },
                        {
                            title = locale('titlejailconfirmation3'),
                            description = locale('deban_desc2'),
                            icon = 'fas fa-times',
                            onSelect = function(args)
                                lib.showContext('ban_log_menu')
                            end
                        }
                    },
                })

                lib.showContext('confirmation_menu')
            end
        })
    end

    lib.registerContext({
        id = 'ban_log_menu',
        title = locale('titlelistofban'),
        menu = 'mizu_menu',
        onBack = function(args)
            lib.showContext('activity_log_submenu')
        end,
        options = options,
    })

    lib.showContext('ban_log_menu')
end)

RegisterNetEvent('tsettings_menu', function()

    lib.registerContext({
        id = 'server_maintenance_menu',
        title = locale('titlemaintenanceserver'),
        menu = 'mizu_menu',
        onBack = function(args) 
            lib.showContext('settings_menu')
        end,
        options = {
            {
                title = locale('titlerestartserver'),
                description = locale('titlerestartserver_desc'),
                icon = 'fas fa-sync',
                onSelect = function()
                    lib.registerContext({
                        id = 'confirmation_menu',
                        title = locale('titlejailconfirmation'),
                        menu = 'mizu_menu',
                        onBack = function(args)
                            lib.showContext('server_maintenance_menu')
                        end,
                        options = {
                            {
                                title = locale('titlejailconfirmation2'),
                                description = locale('confirmerrestart_desc'),
                                icon = 'fas fa-check',
                                onSelect = function(args)
                                    TriggerServerEvent('mizu_admin:restartServer')
                                    lib.showContext('server_maintenance_menu')
                                end
                            },
                            {
                                title = locale('titlejailconfirmation3'),
                                description = locale('cancelrestart_desc'),
                                icon = 'fas fa-times',
                                onSelect = function(args)
                                    lib.showContext('server_maintenance_menu')
                                end
                            }
                        },
                    })
            
                    lib.showContext('confirmation_menu')
                end,
            },
            {
                title = locale('titleannonce'),
                description = locale('titleannonce_desc'),
                icon = 'fas fa-tools',
                onSelect = function()
                    local input = lib.inputDialog('Ecrire une annonce', {'Titre de l\'annonce', 'Texte de l\'annonce'})
            
                    if not input then return end
                --    print(json.encode(input), input[1], input[2])
                    TriggerServerEvent('mizu_admin:sendAnnouncement', input[1], input[2])
                end,
            }
        },
    })

    lib.registerContext({
        id = 'settings_menu',
        title = locale('titleparametreserver'),
        menu = 'mizu_menu',
        onBack = function(args) 
            lib.showContext('admin_menu')
        end,
        options = {
            {
                title = locale('titlegestionplayer'),
                description = locale('titlegestionplayer'),
                icon = 'fas fa-users-cog',
                onSelect = function()
                    TriggerServerEvent('mizu_admin:getAllUsers')
                end,
            },
            {
                title = locale('titlegestionresource'),
                description = locale('titlegestionresource_desc'),
                icon = 'fas fa-boxes',
                onSelect = function()
                    TriggerServerEvent('mizu_admin:getResources')
                end,
            },
            {
                title = locale('titlemaintenanceserver'),
                description = locale('titlemaintenanceserver'),
                icon = 'fas fa-tools',
                onSelect = function()
                    lib.showContext('server_maintenance_menu')
                end,
            },
        },
    })

    lib.showContext('settings_menu')
end)

function showAllUsers(users)
    local options = {}

    for _, user in ipairs(users) do
        table.insert(options, {
            title = user.name, 
            description = locale('license_desc').. user.license,
            icon = 'fa-user',
            onSelect = function()
                showUserOptions(user)
            end,
        })
    end

    lib.registerContext({
        id = 'all_users_menu',
        title = locale('titleallplayer'),
        menu = 'mizu_menu',
        onBack = function(args)
            lib.showContext('settings_menu')
        end,
        options = options,
    })

    lib.showContext('all_users_menu')
end

function showUserOptions(user)
    local options = {
        {
            title = locale('titleofflineban'),
            description = locale('titleofflineban_desc'),
            icon = 'fa-ban',
            onSelect = function()
                local input = lib.inputDialog('Details du Ban', {
                    {type = 'input', label = 'Raison du Ban', description = 'Entrez la raison du bannissement', required = true},
                    {type = 'number', label = 'Durée en heures', description = 'Entrez la durée du bannissement en heures', icon = 'hashtag'},
                    {type = 'checkbox', label = 'Ban permanent', description = 'Cocher pour un ban permanent'}
                })
        
                if not input then return end
        
                local reason = input[1]
                local hours = tonumber(input[2])
                local permanent = input[3]
        
                if reason and (hours or permanent) then
                    TriggerServerEvent('mizu_admin:banPlayerOffline', user.license, reason, hours, permanent)
                else
                    print("Erreur: Raison ou durée de ban invalide")
                end
            end,
        },
        {
            title = locale('titlewipeplayer'),
            description = locale('titlewipeplayer_desc'),
            icon = 'fa-eraser',
            onSelect = function()
                local input = lib.inputDialog('Details du Wipe', {
                    {type = 'input', label = 'Raison du Wipe', description = 'Entrez la raison du wipe', required = true},
                    {type = 'checkbox', label = 'Wipe Complet', description = 'Cocher pour un wipe complet'}
                })
        
                if not input then return end
        
                local reason = input[1]
                local fullWipe = input[2]
        
                if reason then
                    if fullWipe then
                        TriggerServerEvent('mizu_admin:fullWipePlayer', user.license, reason)
                    else
                        TriggerServerEvent('mizu_admin:partialWipePlayer', user.license, reason)
                    end
                else
                    print("Erreur: Raison de wipe invalide")
                end
            end,
        }
    }

    lib.registerContext({
        id = 'user_options_menu',
        title = locale('titleoptionfor') .. user.name,
        menu = 'mizu_menu',
        onBack = function(args)
            lib.showContext('all_users_menu')
        end,
        options = options,
    })

    lib.showContext('user_options_menu')
end

RegisterNetEvent('mizu_admin:showAllUsers')
AddEventHandler('mizu_admin:showAllUsers', function(users)
    showAllUsers(users)
end)

RegisterNetEvent('mizu_admin:showResources')
AddEventHandler('mizu_admin:showResources', function(resources)
    local options = {}

    for i, resource in ipairs(resources) do
        table.insert(options, {
            title = resource,
            description = locale('titlegestionsource'),
            onSelect = function()
                lib.registerContext({
                    id = 'resource_management_' .. resource,
                    title = locale('titlegestionof') .. resource,
                    menu = 'mizu_menu',
                    onBack = function(args)
                        lib.showContext('resources_menu')
                    end,
                    options = {
                        {
                            title = locale('titlerestartsource'),
                            description = locale('titlerestartsource_desc') .. resource,
                            icon = 'fa-redo',
                            onSelect = function()
                                ExecuteCommand('restart ' .. resource)
                                lib.showContext('resource_management_' .. resource)
                            end,
                        },
                        {
                            title = locale('titlestartsource'),
                            description = locale('titlestartsource_desc') .. resource,
                            icon = 'fa-play',
                            onSelect = function()
                                ExecuteCommand('start ' .. resource)
                                lib.showContext('resource_management_' .. resource)
                            end,
                        },
                        {
                            title = locale('titlestopsource'),
                            description = locale('titlestopsource_desc') .. resource,
                            icon = 'fa-stop', 
                            onSelect = function()
                                ExecuteCommand('stop ' .. resource)
                                lib.showContext('resource_management_' .. resource)
                            end,
                        },
                    },
                })

                lib.showContext('resource_management_' .. resource)
            end,
        })
    end

    lib.registerContext({
        id = 'resources_menu',
        title = locale('titlesource'),
        menu = 'mizu_menu',
        onBack = function(args)
            lib.showContext('settings_menu')
        end,
        options = options,
    })

    lib.showContext('resources_menu')
end)

RegisterNetEvent('openStaffModeMenu')
AddEventHandler('openStaffModeMenu', openStaffModeMenu)

RegisterNetEvent('openAdminMenu')
AddEventHandler('openAdminMenu', openAdminMenu)

RegisterNetEvent('mizu_admin:teleportToPosition')
AddEventHandler('mizu_admin:teleportToPosition', function(position)
    local ped = PlayerPedId()
    SetEntityCoords(ped, position.x, position.y, position.z)
end)

RegisterCommand('menuadmin', function()
    TriggerServerEvent('CheckIsAdmin')
end)

RegisterNetEvent('efzefzefd')
AddEventHandler('efzefzefd', function()
    TriggerServerEvent('getStaffModeState')
end)

RegisterNetEvent('menustaffnon')
AddEventHandler('menustaffnon', function()
    lib.notify({
        id = 'nostaff',
        title = 'Erreur de permission',
        description = 'Vous n\'avez pas les permissions pour ouvrir le menu staff',
        position = 'top',
        style = {
            backgroundColor = '#141517',
            color = '#C1C2C5',
            ['.description'] = {
              color = '#909296'
            }
        },
        icon = 'ban',
        iconColor = '#C53030'
    })
end)

RegisterNetEvent('receiveStaffModeState')
AddEventHandler('receiveStaffModeState', function(isStaffModeEnabled)
    if isStaffModeEnabled then
        openAdminMenu()
    else
        openStaffModeMenu()
    end
end)

RegisterKeyMapping('menuadmin', 'Ouvrir le menu admin', 'keyboard', 'F10')

-- Fonction Jail

local jailedPlayers = {}

RegisterNetEvent('showJailMessage')
AddEventHandler('showJailMessage', function(jailerName, jailTime, reason)
  local playerId = source
  jailedPlayers[playerId] = true
  local endTime = GetGameTimer() + jailTime * 60000
  local timerId = 'jailTimer'..playerId

  Citizen.CreateThread(function()
    while GetGameTimer() < endTime and jailedPlayers[playerId] do
      Citizen.Wait(1000)

      local remainingTime = (endTime - GetGameTimer()) / 1000
      local remainingMinutes = math.floor(remainingTime / 60)
      local remainingSeconds = math.floor(remainingTime % 60)
      local message = "Vous avez été jail par : " .. jailerName .. ".\nRaison : " .. reason .. "\nTemps restant : " .. remainingMinutes .. " minutes et " .. remainingSeconds .. " secondes."

      DisplayHelpTextThisFrame(timerId, message)
    end
    if not jailedPlayers[playerId] then
      ClearHelp(timerId, false)
    end
  end)
end)

RegisterNetEvent('unjailPlayer')
AddEventHandler('unjailPlayer', function()
  local playerId = source
  Citizen.SetTimeout(1000, function()
    jailedPlayers[playerId] = nil
  end)
end)

function DisplayHelpTextThisFrame(id, text)
  AddTextEntry(id, text)
  BeginTextCommandDisplayHelp(id)
  EndTextCommandDisplayHelp(0, false, true, -1)
end

RegisterNetEvent('showReleaseMessage')
AddEventHandler('showReleaseMessage', function()
    local message = 'Vous avez été libéré de prison. Faites attention à votre comportement la prochaine fois.'

    ESX.ShowNotification(message)
end)

-- Fonction Afficher Nom Joueur + ID

local displayDistance = 800.0
local showIdsAndNames = false
local gamerTags = {}

Citizen.CreateThread(function(staff)
    while true do
        Citizen.Wait(200)

        local myPed = PlayerPedId()
        local myCoords = GetEntityCoords(myPed, false)

        if showIdsAndNames then
            for _, player in ipairs(GetActivePlayers()) do
                local otherPed = GetPlayerPed(player)
                local otherCoords = GetEntityCoords(otherPed, false)
                local distance = #(myCoords - otherCoords)

                if distance < displayDistance then
                    if not gamerTags[player] then
                        local playerName = string.upper(GetPlayerName(player))
                        local serverId = GetPlayerServerId(player)
                        ESX.TriggerServerCallback('esx_adminmenu:getPlayerData', function(data)
                            if data then
                                gamerTags[player] = CreateFakeMpGamerTag(otherPed, ("%s | %s | %s | %s | %s"):format(serverId, playerName, data.job, data.jobGrade, data.group), false, false, '', 0)
                            end
                        end, serverId)
                    end
                    if gamerTags[player] then
                        SetMpGamerTagVisibility(gamerTags[player], 2, 1)
                        SetMpGamerTagAlpha(gamerTags[player], 2, 255)
                        SetMpGamerTagHealthBarColor(gamerTags[player], 129)
                        SetMpGamerTagColour(gamerTags[player], 0, 129)
                    end
                else
                    if gamerTags[player] then
                        RemoveMpGamerTag(gamerTags[player])
                        gamerTags[player] = nil
                    end
                end
            end
        else
            for _, tag in pairs(gamerTags) do
                RemoveMpGamerTag(tag)
            end
            gamerTags = {}
        end
    end
end)

RegisterNetEvent('esx_adminmenu:toggleIdsAndNames')
AddEventHandler('esx_adminmenu:toggleIdsAndNames', function()
    showIdsAndNames = not showIdsAndNames
end)

function GetPlayers()
    local players = {}

    local activePlayers = GetActivePlayers()
    for _, playerId in ipairs(activePlayers) do
        local playerName = GetPlayerName(playerId)
        local serverId = GetPlayerServerId(playerId)
        table.insert(players, {name = playerName, id = serverId})
    end

    return players
end

-- Fonction NoClip

MOVE_UP_KEY = 20
MOVE_DOWN_KEY = 44
CHANGE_SPEED_KEY = 21
MOVE_LEFT_RIGHT = 30
MOVE_UP_DOWN = 31
NOCLIP_TOGGLE_KEY = 289
NO_CLIP_NORMAL_SPEED = 0.5
NO_CLIP_FAST_SPEED = 2.5
ENABLE_TOGGLE_NO_CLIP = true
ENABLE_NO_CLIP_SOUND = true

local eps = 0.01


local isNoClipping = false
local playerPed = PlayerPedId()
local playerId = PlayerId()
local speed = NO_CLIP_NORMAL_SPEED
local input = vector3(0, 0, 0)
local previousVelocity = vector3(0, 0, 0)
local breakSpeed = 10.0;
local offset = vector3(0, 0, 1);

local noClippingEntity = playerPed;

function ToggleNoClipMode()
    return SetNoClip(not isNoClipping)
end

function IsControlAlwaysPressed(inputGroup, control) return IsControlPressed(inputGroup, control) or IsDisabledControlPressed(inputGroup, control) end

function IsControlAlwaysJustPressed(inputGroup, control) return IsControlJustPressed(inputGroup, control) or IsDisabledControlJustPressed(inputGroup, control) end

function Lerp (a, b, t) return a + (b - a) * t end

function IsPedDrivingVehicle(ped, veh)
    return ped == GetPedInVehicleSeat(veh, -1);
end

function SetInvincible(val, id)
    SetEntityInvincible(id, val)
    return SetPlayerInvincible(id, val)
end

function SetNoClip(val)

    if (isNoClipping ~= val) then

        noClippingEntity = playerPed;

        if IsPedInAnyVehicle(playerPed, false) then
            local veh = GetVehiclePedIsIn(playerPed, false);
            if IsPedDrivingVehicle(playerPed, veh) then
                noClippingEntity = veh;
            end
        end

        local isVeh = IsEntityAVehicle(noClippingEntity);

        isNoClipping = val;

        if ENABLE_NO_CLIP_SOUND then

            if isNoClipping then
                PlaySoundFromEntity(-1, "SELECT", playerPed, "HUD_LIQUOR_STORE_SOUNDSET", 0, 0)
            else
                PlaySoundFromEntity(-1, "CANCEL", playerPed, "HUD_LIQUOR_STORE_SOUNDSET", 0, 0)
            end

        end

        TriggerEvent('msgprinter:addMessage', ((isNoClipping and ":airplane: No-clip enabled") or ":rock: No-clip disabled"), "Noclip Ultimate");
        SetUserRadioControlEnabled(not isNoClipping);

        if (isNoClipping) then


            SetEntityAlpha(noClippingEntity, 51, 0)

            Citizen.CreateThread(function()

                local clipped = noClippingEntity
                local pPed = playerPed;
                local isClippedVeh = isVeh;
                SetInvincible(true, clipped);

                if not isClippedVeh then
                    ClearPedTasksImmediately(pPed)
                end

                while isNoClipping do
                    Citizen.Wait(0);

                    FreezeEntityPosition(clipped, true);
                    SetEntityCollision(clipped, false, false);

                    SetEntityVisible(clipped, false, false);
                    SetLocalPlayerVisibleLocally(true);
                    SetEntityAlpha(clipped, 51, false)

                    SetEveryoneIgnorePlayer(pPed, true);
                    SetPoliceIgnorePlayer(pPed, true);

                    input = vector3(GetControlNormal(0, MOVE_LEFT_RIGHT), GetControlNormal(0, MOVE_UP_DOWN), (IsControlAlwaysPressed(1, MOVE_UP_KEY) and 1) or ((IsControlAlwaysPressed(1, MOVE_DOWN_KEY) and -1) or 0))
                    speed = ((IsControlAlwaysPressed(1, CHANGE_SPEED_KEY) and NO_CLIP_FAST_SPEED) or NO_CLIP_NORMAL_SPEED) * ((isClippedVeh and 2.75) or 1)

                    MoveInNoClip();

                    DrawText2D('Noclip Activated', 0.89, 0.87, 0.5)

                end

                Citizen.Wait(0);

                FreezeEntityPosition(clipped, false);
                SetEntityCollision(clipped, true, true);

                SetEntityVisible(clipped, true, false);
                SetLocalPlayerVisibleLocally(true);
                ResetEntityAlpha(clipped);

                SetEveryoneIgnorePlayer(pPed, false);
                SetPoliceIgnorePlayer(pPed, false);
                ResetEntityAlpha(clipped);

                Citizen.Wait(500);

                if isClippedVeh then

                    while (not IsVehicleOnAllWheels(clipped)) and not isNoClipping do
                        Citizen.Wait(0);
                    end

                    while not isNoClipping do

                        Citizen.Wait(0);

                        if IsVehicleOnAllWheels(clipped) then

                            return SetInvincible(false, clipped);

                        end

                    end

                else

                    if (IsPedFalling(clipped) and math.abs(1 - GetEntityHeightAboveGround(clipped)) > eps) then
                        while (IsPedStopped(clipped) or not IsPedFalling(clipped)) and not isNoClipping do
                            Citizen.Wait(0);
                        end
                    end

                    while not isNoClipping do

                        Citizen.Wait(0);

                        if (not IsPedFalling(clipped)) and (not IsPedRagdoll(clipped)) then

                            return SetInvincible(false, clipped);

                        end

                    end

                end

            end)

        else
            ResetEntityAlpha(noClippingEntity)
            TriggerEvent('instructor:flush', "admin");
        end

    end

end

function MoveInNoClip()

    SetEntityRotation(noClippingEntity, GetGameplayCamRot(0), 0, false)
    local forward, right, up, c = GetEntityMatrix(noClippingEntity);
    previousVelocity = Lerp(previousVelocity, (((right * input.x * speed) + (up * -input.z * speed) + (forward * -input.y * speed))), Timestep() * breakSpeed);
    c = c + previousVelocity
    SetEntityCoords(noClippingEntity, c - offset, true, true, true, false)

end

function MoveCarInNoClip()

    SetEntityRotation(noClippingEntity, GetGameplayCamRot(0), 0, false)
    local forward, right, up, c = GetEntityMatrix(noClippingEntity);
    previousVelocity = Lerp(previousVelocity, (((right * input.x * speed) + (up * input.z * speed) + (forward * -input.y * speed))), Timestep() * breakSpeed);
    c = c + previousVelocity
    SetEntityCoords(noClippingEntity, (c - offset) + (vec(0, 0, .3)), true, true, true, false)

end

AddEventHandler('playerSpawned', function()

    playerPed = PlayerPedId()
    playerId = PlayerId()

end)

AddEventHandler('RCC:newPed', function()

    playerPed = PlayerPedId()
    playerId = PlayerId()

end)

Citizen.CreateThread(function()
    SetNoClip(false);
    FreezeEntityPosition(noClippingEntity, false);
    SetEntityCollision(noClippingEntity, true, true);

    SetEntityVisible(noClippingEntity, true, false);
    SetLocalPlayerVisibleLocally(true);
    ResetEntityAlpha(noClippingEntity);

    SetEveryoneIgnorePlayer(playerPed, false);
    SetPoliceIgnorePlayer(playerPed, false);
    ResetEntityAlpha(noClippingEntity);
    SetInvincible(false, noClippingEntity);
end)


RegisterCommand("toggleNoClip", function(source, rawCommand)
    if isStaffModeEnabled then
        ToggleNoClipMode()
    else
        ShowNotification("Vous devez être en mode staff pour utiliser le noclip", 'error')
    end
end)

RegisterKeyMapping("toggleNoClip", "Toggles no-clipping", "keyboard", "F4");


-- annonce

local annonceState = false
local texteAnnonce = ""
local annonceTitle = ""

RegisterNetEvent('mizu_admin:receiveAnnouncement')
AddEventHandler('mizu_admin:receiveAnnouncement', function(title, message)
    annonceState = true
    texteAnnonce = message
    annonceTitle = title

    PlaySoundFrontend(-1, "5s_To_Event_Start_Countdown", "GTAO_FM_Events_Soundset", 1)

    Citizen.CreateThread(function()
        Citizen.Wait(10000)
        annonceState = false
    end)
end)

Citizen.CreateThread(function()
    while true do    
        if annonceState then
            DrawRect(0.494, 0.227, 5.185, 0.118, 0, 0, 0, 150)
            DrawAdvancedTextCNN(0.588, 0.14, 0.005, 0.0028, 0.8, '~r~ ' .. annonceTitle .. ' ~d~', 255, 255, 255, 255, 1, 0)
            DrawAdvancedTextCNN(0.586, 0.199, 0.005, 0.0028, 0.6, texteAnnonce, 255, 255, 255, 255, 7, 0)
            DrawAdvancedTextCNN(0.588, 0.246, 0.005, 0.0028, 0.4, "", 255, 255, 255, 255, 0, 0)
            Citizen.Wait(0)
        else
            Citizen.Wait(1000)
        end
    end
end)

function DrawAdvancedTextCNN(x,y ,w,h,sc, text, r,g,b,a,font,jus)
    SetTextFont(font)
    SetTextProportional(0)
    SetTextScale(sc, sc)
    N_0x4e096588b13ffeca(jus)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - 0.1+w, y - 0.02+h)
end