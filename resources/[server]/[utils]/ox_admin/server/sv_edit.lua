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