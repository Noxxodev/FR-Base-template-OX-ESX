ESX = exports['es_extended']:getSharedObject()

-- POINTER DU DOIGT

local mp_pointing = false
local keyPressed = false

local function startPointing()
    local ped = GetPlayerPed(-1)
    RequestAnimDict("anim@mp_point")
    while not HasAnimDictLoaded("anim@mp_point") do
        Wait(50)
    end
    SetPedCurrentWeaponVisible(ped, 0, 1, 1, 1)
    SetPedConfigFlag(ped, 36, 1)
    Citizen.InvokeNative(0x2D537BA194896636, ped, "task_mp_pointing", 0.5, 0, "anim@mp_point", 24)
    RemoveAnimDict("anim@mp_point")
end

local function stopPointing()
    local ped = GetPlayerPed(-1)
    Citizen.InvokeNative(0xD01015C7316AE176, ped, "Stop")
    if not IsPedInjured(ped) then
        ClearPedSecondaryTask(ped)
    end
    if not IsPedInAnyVehicle(ped, 1) then
        SetPedCurrentWeaponVisible(ped, 1, 1, 1, 1)
    end
    SetPedConfigFlag(ped, 36, 0)
    ClearPedSecondaryTask(PlayerPedId())
end

local once = true
local oldval = false
local oldvalped = false

Citizen.CreateThread(function()
    while true do
        Wait(25)

        if once then
            once = false
        end

        if not keyPressed then
            if IsControlPressed(0, 29) and not mp_pointing and IsPedOnFoot(PlayerPedId()) then
                Wait(200)
                if not IsControlPressed(0, 29) then
                    keyPressed = true
                    startPointing()
                    mp_pointing = true
                else
                    keyPressed = true
                    while IsControlPressed(0, 29) do
                        Wait(75)
                    end
                end
            elseif (IsControlPressed(0, 29) and mp_pointing) or (not IsPedOnFoot(PlayerPedId()) and mp_pointing) then
                Wait(50)
                keyPressed = true
                mp_pointing = false
                stopPointing()
            end
        end

        if keyPressed then
            if not IsControlPressed(0, 29) then
                keyPressed = false
            end
        end
        if Citizen.InvokeNative(0x921CE12C489C4C41, PlayerPedId()) and not mp_pointing then
            stopPointing()
        end
        if Citizen.InvokeNative(0x921CE12C489C4C41, PlayerPedId()) then
            if not IsPedOnFoot(PlayerPedId()) then
                stopPointing()
            else
                local ped = GetPlayerPed(-1)
                local camPitch = GetGameplayCamRelativePitch()
                camPitch = math.clamp(camPitch, -70.0, 42.0)
                camPitch = (camPitch + 70.0) / 112.0

                local camHeading = GetGameplayCamRelativeHeading()
                camHeading = math.clamp(camHeading, -180.0, 180.0)
                camHeading = (camHeading + 180.0) / 360.0

                local cosCamHeading = math.cos(camHeading)
                local sinCamHeading = math.sin(camHeading)

                local blocked, nn
                local coords = GetOffsetFromEntityInWorldCoords(ped, (cosCamHeading * -0.2) - (sinCamHeading * (0.4 * camHeading + 0.3)), (sinCamHeading * -0.2) + (cosCamHeading * (0.4 * camHeading + 0.3)), 0.6)
                local ray = Cast_3dRayPointToPoint(coords.x, coords.y, coords.z - 0.2, coords.x, coords.y, coords.z + 0.2, 0.4, 95, ped, 7)
                nn, blocked, coords, coords = GetRaycastResult(ray)

                Citizen.InvokeNative(0xD5BB4025AE449A4E, ped, "Pitch", camPitch)
                Citizen.InvokeNative(0xD5BB4025AE449A4E, ped, "Heading", camHeading * -1.0 + 1.0)
                Citizen.InvokeNative(0xB0A6CFD2C69C1088, ped, "isBlocked", blocked)
                Citizen.InvokeNative(0xB0A6CFD2C69C1088, ped, "isFirstPerson", Citizen.InvokeNative(0xEE778F8C7E1142E2, Citizen.InvokeNative(0x19CAFA3C87F7C2FF)) == 4)
            end
        end
    end
end)


----- pointer done




-- LEVER MAINS


Citizen.CreateThread(function()
    local dict = "missminuteman_1ig_2"
    
	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		Citizen.Wait(100)
	end
    local handsup = false
	while true do
		Citizen.Wait(0)
		if IsControlJustPressed(1, 323) then --Start holding X
            if not handsup then
                TaskPlayAnim(GetPlayerPed(-1), dict, "handsup_enter", 8.0, 8.0, -1, 50, 0, false, false, false)
                handsup = true
            else
                handsup = false
                ClearPedTasks(GetPlayerPed(-1))
            end
        end
    end
end)



-- RICH PRESENCE DISCORD
Citizen.CreateThread(function()
    SetDiscordAppId(1203320086723698739)
    SetDiscordRichPresenceAsset('noxxo_logo')

    while true do
        local players = {}
        for i = 0, 255 do
            if NetworkIsPlayerActive(i) then
                table.insert(players, i)
            end
        end

        SetDiscordRichPresenceAction(1, "Discord", "https://discord.gg/7SBn6ygS87")
        --SetDiscordRichPresenceAction(0, "Se Connecter", "fivem://connect/ip")
        SetRichPresence("Nom: " ..GetPlayerName(PlayerId()) .. " | ID: " ..GetPlayerServerId(PlayerId()) .. "")

        Citizen.Wait(60000)
    end
end)

---- MENU PAUSE

local config = {
    ["UN"] = "Wind studio",
    ["DEUX"] = "Base template",
    ["TROIS"] = "By Noxxo"
}

-- Menu pause
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        
        -- Côté gauche
        N_0xb9449845f73f5e9c("SHIFT_CORONA_DESC")
        PushScaleformMovieFunctionParameterBool(true)
        PopScaleformMovieFunction()

        -- Côté droit
        BeginScaleformMovieMethodOnFrontendHeader("SET_HEADING_DETAILS")
        PushScaleformMovieFunctionParameterString(config["UN"])
        PushScaleformMovieFunctionParameterString(config["DEUX"])
        PushScaleformMovieFunctionParameterString(config["TROIS"])
        ScaleformMovieMethodAddParamBool(false)
        ScaleformMovieMethodAddParamBool(isScripted)
        EndScaleformMovieMethod() 
    end
end)

-- Boutons de l'interface
Citizen.CreateThread(function()
    local name = GetPlayerName(PlayerId())
    local id = GetPlayerServerId(PlayerId())
    
    AddTextEntry('FE_THDR_GTAO', 'Base Template - ~b~Wind Studio~s~ | ID : ' .. id .. ' | Nom : ' .. name )
    AddTextEntry('PM_PANE_LEAVE', 'Se déconnecter et retourner à l\'accueil 🐌')
    AddTextEntry('PM_PANE_QUIT', 'Quitter FiveM 🐌')
    AddTextEntry('PM_SCR_MAP', '🗺️')
    AddTextEntry('PM_SCR_GAM', '🐌')
    AddTextEntry('PM_SCR_INF', '📝')
    AddTextEntry('PM_SCR_SET', '⚙️')
    AddTextEntry('PM_SCR_STA', '📊')
    AddTextEntry('PM_SCR_RPL', 'Éditeur ∑')
    AddTextEntry('PM_SCR_GAL', '📷')
end)

-- ENLEVER ROULADE (REALISME)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        if IsControlPressed(0, 25)
            then DisableControlAction(0, 22, true)
        end
    end
end)

-- ENLEVER TAPER AVEC R
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        DisableControlAction(0, 140, true)
    end
end)
    
-- Argent gta online retiré

Citizen.CreateThread(function()
    RemoveMultiplayerHudCash(0x968F270E39141ECA)
    RemoveMultiplayerBankCash(0xC7C6789AA1CFEDD0)
end)
    
-- Coup de crosse désactivé

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
    local ped = PlayerPedId()
        if IsPedArmed(ped, 6) then
           DisableControlAction(1, 140, true)
              DisableControlAction(1, 141, true)
           DisableControlAction(1, 142, true)
        end
    end
end)

-- ID

RegisterCommand('id', function()
    lib.notify({
        title = 'Votre ID est le ' .. GetPlayerServerId(PlayerId()),
        description = 'Notification',
        position = 'top',
        duration = 5000,
        style = {
            backgroundColor = '#001D32',
            borderRadius = 30,
            color = '#C4E5FF',
            ['.description'] = {
              color = '#909296'
            }
        },
        icon = 'circle-info',
        iconColor = '#C4E5FF'
    })
end, false)
