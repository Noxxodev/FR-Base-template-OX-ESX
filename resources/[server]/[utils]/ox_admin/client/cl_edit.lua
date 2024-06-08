if Config.Framework == "1" then
    ESX = exports['es_extended']:getSharedObject()
elseif Config.Framework == "2" then
    ESX = nil
    CreateThread(function()
        while ESX == nil do
            TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)
            Wait(100)
        end
    end)
elseif Config.Framework == "custom" then
    ESX = exports["osc"]:getSharedObject()
end

function ShowNotification(message, notifyType)
    lib.notify({
        description = message,
        type = notifyType,
        position = 'top'
    })
end

RegisterNetEvent('MizuAdmin:showNotification')
AddEventHandler('MizuAdmin:showNotification', ShowNotification)

function ShowUI(text, icon)
    if icon == 0 then
        lib.showTextUI(text)
    else
        lib.showTextUI(text, {
            icon = icon
        })
    end
end

function HideUI()
    lib.hideTextUI()
end