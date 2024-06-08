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



-- ENLEVER LA POLICE PNJ DEVANT LE COMICO

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(375)
        local myCoords = GetEntityCoords(GetPlayerPed(-1))
        ClearAreaOfCops(myCoords.x, myCoords.y, myCoords.z, 100.0, 0)
    end
end)

Citizen.CreateThread(function()
    for i = 1, 12 do
        Citizen.InvokeNative(0xDC0F817884CDD856, i, false)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(300)
       
        if GetPlayerWantedLevel(PlayerId()) ~= 0 then
            SetPlayerWantedLevel(PlayerId(), 0, false)
            SetPlayerWantedLevelNow(PlayerId(), false)
        end
    end
end)




-- RETIER DROP ARMES PNJ A TERRE

Citizen.CreateThread(function()
    while true do
      Citizen.Wait(1)
      -- List of pickup hashes (https://pastebin.com/8EuSv2r1)
      RemoveAllPickupsOfType(0xDF711959) -- carbine rifle
      RemoveAllPickupsOfType(0xF9AFB48F) -- pistol
      RemoveAllPickupsOfType(0xA9355DCD) -- pumpshotgun
    end
  end)

  

-- RAGDOLL

local ragdoll = false
local shownHelp = false


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustPressed(2, 82) and not IsPedInAnyVehicle(GetPlayerPed(-1), false) then
            ragdoll = not ragdoll
            if not ragdoll then
                shownHelp = false
            end
        end
        if IsPedBeingStunned(GetPlayerPed(-1)) then
            ragdoll = true
        end

      
        -- Don't ragdoll if player is dead
        if IsPlayerDead(PlayerId()) and ragdoll == true then
            ragdoll = false
            shownHelp = false
        end
        if ragdoll == true and not shownHelp then

            lib.showTextUI('Se relever [ ; ]', {
                position = "top-center",
                icon = 'heart-pulse',
                style = {
                    borderRadius = 50,
                    backgroundColor = '#007BD0',
                    color = 'white'
                }
            })

            shownHelp = true


            Wait(1200)
            

        Wait(4000)

        lib.hideTextUI()


        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if ragdoll then
            SetPedToRagdoll(GetPlayerPed(-1), 1000, 1000, 0, 0, 0, 0)
        end
    end
end)

RegisterNetEvent('epic_ragdoll:toggle')
AddEventHandler('epic_ragdoll:toggle', function()
    ragdoll = not ragdoll
    if not ragdoll then
        shownHelp = false
    end
end)

RegisterNetEvent('epic_ragdoll:set')
AddEventHandler('epic_ragdoll:set', function(value)
    ragdoll = value
    if not ragdoll then
        shownHelp = false
    end
end)



-- VOL DE VEHICULE DE FONCTITON
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)
        local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
        local ped = GetPlayerPed(-1)
        local vehicleClass = GetVehicleClass(vehicle)
        PlayerData = ESX.GetPlayerData()

        if vehicleClass == 18 and GetPedInVehicleSeat(vehicle, -1) == ped then
            if IsPedInAnyPoliceVehicle(GetPlayerPed(PlayerId())) then
                local playerGroup = PlayerData.group
                if PlayerData.job.name ~= 'police' and PlayerData.job.name ~= 'ambulance' and PlayerData.job.name ~= 'mechanic' and PlayerData.job.name ~= 'avocat' and playerGroup ~= 'user' then
                    local vehicle = GetVehiclePedIsUsing(GetPlayerPed(PlayerId()), false)
                    local chance_kick = math.random()
                    local time = 9000
                    if chance_kick < 0.7 then
                        ClearPedTasksImmediately(ped)
                        TaskLeaveVehicle(ped, vehicle, 0)
                        print("Le joueur ^1" .. GetPlayerName(PlayerId()) .. "^0 a tenté de ^1voler un véhicule de fonction ^0(LSPD) !")   
                        ESX.ShowNotification("Le vol de véhicule de fonction est interdit !", "error", 3000)
                        
                        ClearPedTasksImmediately(ped)
                        TaskLeaveVehicle(ped, vehicle, 0)
                    end
                end
            end
        end
    end
end)





-- TOMBER QUAND ON SE FAIT TOUCHER DANS LA JAMBE
local BONES = {
	--[[Pelvis]][11816] = true,
	--[[SKEL_L_Thigh]][58271] = true,
	--[[SKEL_L_Calf]][63931] = true,
	--[[SKEL_L_Foot]][14201] = true,
	--[[SKEL_L_Toe0]][2108] = true,
	--[[IK_L_Foot]][65245] = true,
	--[[PH_L_Foot]][57717] = true,
	--[[MH_L_Knee]][46078] = true,
	--[[SKEL_R_Thigh]][51826] = true,
	--[[SKEL_R_Calf]][36864] = true,
	--[[SKEL_R_Foot]][52301] = true,
	--[[SKEL_R_Toe0]][20781] = true,
	--[[IK_R_Foot]][35502] = true,
	--[[PH_R_Foot]][24806] = true,
	--[[MH_R_Knee]][16335] = true,
	--[[RB_L_ThighRoll]][23639] = true,
	--[[RB_R_ThighRoll]][6442] = true,
}


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local ped = GetPlayerPed(-1)
			--if IsShockingEventInSphere(102, 235.497,2894.511,43.339,999999.0) then
			if HasEntityBeenDamagedByAnyPed(ped) then
			--if GetPedLastDamageBone(ped) = 
					Disarm(ped)
			end
			ClearEntityLastDamageEntity(ped)
	 end
end)



function Bool (num) return num == 1 or num == true end

-- WEAPON DROP OFFSETS
local function GetDisarmOffsetsForPed (ped)
	local v

	if IsPedWalking(ped) then v = { 0.6, 4.7, -0.1 }
	elseif IsPedSprinting(ped) then v = { 0.6, 5.7, -0.1 }
	elseif IsPedRunning(ped) then v = { 0.6, 4.7, -0.1 }
	else v = { 0.4, 4.7, -0.1 } end

	return v
end

function Disarm (ped)
	if IsEntityDead(ped) then return false end

	local boneCoords
	local hit, bone = GetPedLastDamageBone(ped)

	hit = Bool(hit)

	if hit then
		if BONES[bone] then
			

			boneCoords = GetWorldPositionOfEntityBone(ped, GetPedBoneIndex(ped, bone))
			SetPedToRagdoll(GetPlayerPed(-1), 5000, 5000, 0, 0, 0, 0)
			

			return true
		end
	end

	return false
end

-- Désactiver les sons ambiants - Scanner Police, Bruits de tir à l'ammunation

Citizen.CreateThread(function()
    StartAudioScene('CHARACTER_CHANGE_IN_SKY_SCENE')
    SetAudioFlag("PoliceScannerDisabled", true)
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