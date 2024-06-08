lib.locale()

local staffModeStates = {}

RegisterServerEvent('CheckIsAdmin')
AddEventHandler('CheckIsAdmin', function()
    local playerSRC = source
    local xPlayer = ESX.GetPlayerFromId(playerSRC)
    local rank = xPlayer.getGroup()

    if rank == 'admin' then
        TriggerClientEvent('efzefzefd', playerSRC)
    else
        TriggerClientEvent('menustaffnon', playerSRC)
    end
end)

ESX.RegisterCommand('menuadmin', Config.GroupsOpenMenu, function(xPlayer, args, showError)
    local isStaffModeEnabled = staffModeStates[xPlayer.source] or false

    if isStaffModeEnabled then
        TriggerClientEvent('openAdminMenu', xPlayer.source)
    else
        TriggerClientEvent('openStaffModeMenu', xPlayer.source)
    end
end, true, {help = "Ouvre le menu admin. Usage: /menuadmin", validate = false})

RegisterServerEvent('mizu_admin:enableStaffMode')
AddEventHandler('mizu_admin:enableStaffMode', function()
    local __source = source
    staffModeStates[__source] = true
    local name = GetPlayerName(__source)
    local license = GetPlayerIdentifier(__source)
    local embed = {
        {
            ["color"] = 16711680,
            ["title"] = "__**Une personne vient de ce mettre en mode staff**__",
            ["description"] = "steam:"..name.."\n"..license.."\n ",
            ["footer"] = {
                ["text"] = "ATO Logs",
            },
        }
    }

    
    PerformHttpRequest(Config.Webhook, function(err, text, headers) end, 'POST', json.encode({username = "Ato Logs", embeds = embed}), { ['Content-Type'] = 'application/json' })
end)

RegisterServerEvent('mizu_admin:disableStaffMode')
AddEventHandler('mizu_admin:disableStaffMode', function()
    local source = source
    staffModeStates[source] = false
end)

RegisterServerEvent('getStaffModeState')
AddEventHandler('getStaffModeState', function()
    local source = source
    local isStaffModeEnabled = staffModeStates[source] or false
    TriggerClientEvent('receiveStaffModeState', source, isStaffModeEnabled)
end)

ESX.RegisterServerCallback('esx_adminmenu:getPlayerData', function(source, cb, target)
    local xPlayer = ESX.GetPlayerFromId(target)

    if xPlayer then
        local data = {
            job = xPlayer.job.name,
            jobGrade = xPlayer.job.grade_label,
            group = xPlayer.getGroup(),
        }
        cb(data)
    else
        cb(nil)
    end
end)

RegisterNetEvent('mizu_admin:manageUsers')
AddEventHandler('mizu_admin:manageUsers', function()
    local source = source
    local players = GetPlayers()
    local playerInfo = {}

    for _, playerID in ipairs(players) do
        local playerName = GetPlayerName(playerID)
        
        local esxPlayer = ESX.GetPlayerFromId(playerID)
        local playerGroup, job, job_grade, job_label, grade_label, firstname, lastname, identifier
        if esxPlayer then
            playerGroup = esxPlayer.getGroup()
            job = esxPlayer.job.name
            job_grade = esxPlayer.job.grade
            identifier = esxPlayer.identifier
            
            local jobResult = MySQL.Sync.fetchAll("SELECT label FROM jobs WHERE name = @name", {['@name'] = job})
            if jobResult[1] then
                job_label = jobResult[1].label
            end

            local gradeResult = MySQL.Sync.fetchAll("SELECT label FROM job_grades WHERE job_name = @job_name AND grade = @grade", {['@job_name'] = job, ['@grade'] = job_grade})
            if gradeResult[1] then
                grade_label = gradeResult[1].label
            end

            local nameResult = MySQL.Sync.fetchAll("SELECT firstname, lastname FROM users WHERE identifier = @identifier", {['@identifier'] = identifier})
            if nameResult[1] then
                firstname = nameResult[1].firstname
                lastname = nameResult[1].lastname
            end
        else
            playerGroup = "unknown"
            job = "unknown"
            job_label = "unknown"
            job_grade = "unknown"
            grade_label = "unknown"
            firstname = "unknown"
            lastname = "unknown"
            identifier = "unknown"
        end

        table.insert(playerInfo, {id = playerID, name = playerName, group = playerGroup, job = job, job_label = job_label, job_grade = job_grade, grade_label = grade_label, firstname = firstname, lastname = lastname, identifier = identifier})
    end

    TriggerClientEvent('mizu_admin:showUserManager', source, playerInfo)
end)

RegisterNetEvent('mizu_admin:teleportToPosition')
AddEventHandler('mizu_admin:teleportToPosition', function(playerID, position)
    local xPlayer = ESX.GetPlayerFromId(playerID)

    if xPlayer then
        xPlayer.setCoords(position)
    else
        print('Player not found: ', playerID)
    end
end)

RegisterNetEvent('mizu_admin:getPlayerPosition')
AddEventHandler('mizu_admin:getPlayerPosition', function(targetPlayerID)
    local xPlayer = ESX.GetPlayerFromId(targetPlayerID)

    if xPlayer then
        local targetPlayerPosition = xPlayer.getCoords(true)
        local sourcePlayerID = source

        TriggerClientEvent('mizu_admin:teleportToPosition', sourcePlayerID, targetPlayerPosition)
    else
        print('Player not found: ', targetPlayerID)
    end
end)

function isValidJobAndGrade(job, grade)
    local jobResult = MySQL.Sync.fetchAll("SELECT * FROM jobs WHERE name = @name", {['@name'] = job})
    local gradeResult = MySQL.Sync.fetchAll("SELECT * FROM job_grades WHERE job_name = @job_name AND grade = @grade", {['@job_name'] = job, ['@grade'] = grade})

    if jobResult[1] and gradeResult[1] then
        return true
    else
        return false
    end
end

RegisterServerEvent('mizu_admin:validateAndSetJobAndGrade')
AddEventHandler('mizu_admin:validateAndSetJobAndGrade', function(playerId, job, grade)
    if isValidJobAndGrade(job, grade) then
        local xPlayer = ESX.GetPlayerFromId(playerId)

        if not ESX.DoesJobExist(job, tonumber(grade)) then
            print("Job or grade is invalid")
            return
        end

        xPlayer.setJob(job, tonumber(grade))
        print("Successfully set job and grade for player")
    else
        print("Job or grade is invalid")
    end
end)

RegisterServerEvent('mizu_admin:giveMoney')
AddEventHandler('mizu_admin:giveMoney', function(targetId, account, amount)
    local xPlayer = ESX.GetPlayerFromId(targetId)
    if xPlayer then
        if not xPlayer.getAccount(account) then
            print('Invalid account')
            return
        end
        xPlayer.addAccountMoney(account, amount, "Government Grant")
        if Config.AdminLogging then
            ESX.DiscordLogFields("UserActions", "Give Account Money /giveaccountmoney Triggered!", "pink", {
                { name = "Player",  value = xPlayer.name,       inline = true },
                { name = "ID",      value = xPlayer.source,     inline = true },
                { name = "Target",  value = xPlayer.name, inline = true },
                { name = "Account", value = account,       inline = true },
                { name = "Amount",  value = amount,        inline = true },
            })
        end
    else
        print('Player not found')
    end
end)

RegisterNetEvent('mizu_admin:openWeaponShop')
AddEventHandler('mizu_admin:openWeaponShop', function(targetPlayerId)
    local source = source
    local targetPlayer = ESX.GetPlayerFromId(targetPlayerId)
    TriggerClientEvent('ox_inventory:openInventory', targetPlayer, 'shop', { type = 'WeaponsShopAdmin' })
end)

RegisterNetEvent('mizu_admin:openAmmoShop')
AddEventHandler('mizu_admin:openAmmoShop', function()
    local source = source
    TriggerClientEvent('ox_inventory:openInventory', source, 'shop', { type = 'AmmoShopAdmin' })
end)

RegisterNetEvent('mizu_admin:openItemShop')
AddEventHandler('mizu_admin:openItemShop', function()
    local source = source
    TriggerClientEvent('ox_inventory:openInventory', source, 'shop', { type = 'ItemShopAdmin' })
end)

RegisterServerEvent('mizu_admin:validateAndSetGroup')
AddEventHandler('mizu_admin:validateAndSetGroup', function(targetId, groupName)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local targetPlayer = ESX.GetPlayerFromId(targetId)

    if xPlayer.getGroup() == 'admin' or xPlayer.getGroup() == 'superadmin' then
        if targetPlayer then
            targetPlayer.setGroup(groupName)
            xPlayer.showNotification('Vous avez défini le groupe de ' .. targetPlayer.getName() .. ' à ' .. groupName)
        else
            xPlayer.showNotification('Aucun joueur avec cet ID trouvé')
        end
    else
        xPlayer.showNotification('Vous n\'avez pas la permission pour faire ça')
    end
end)

local jailedPlayers = {}

local function jailPlayer(source, targetId, jailTime, reason, position)
    local xPlayer = ESX.GetPlayerFromId(source)
    local targetPlayer = ESX.GetPlayerFromId(targetId)

    local targetName = GetPlayerName(targetId)
    local jailerName = GetPlayerName(source)

    MySQL.Async.execute('INSERT INTO jail (identifier, name, jailTime, reason, jailer) VALUES (@identifier, @name, @jailTime, @reason, @jailer)', {
        ['@identifier'] = targetPlayer.getIdentifier(),
        ['@name'] = targetName,
        ['@jailTime'] = jailTime,
        ['@reason'] = reason,
        ['@jailer'] = jailerName
    })

    targetPlayer.setCoords(position)

    jailedPlayers[targetId] = {releaseTime = os.time() + jailTime * 60, isJailed = true, manualUnjail = false}

    xPlayer.showNotification('Vous avez emprisonné ' .. targetName .. ' pour ' .. jailTime .. ' minutes pour la raison suivante : ' .. reason)
    
    TriggerClientEvent('showJailMessage', targetId, jailerName, jailTime, reason)
end

local function unjailPlayer(identifier)
    local xPlayer = ESX.GetPlayerFromIdentifier(identifier)

    if xPlayer then
        if jailedPlayers[xPlayer.source] then
            jailedPlayers[xPlayer.source].manualUnjail = true
        end

        local position = {
            x = 1847.9,
            y = 2586.2,
            z = 45.7
        }

        xPlayer.setCoords(position)

        MySQL.Async.execute('DELETE FROM jail WHERE identifier = @identifier', {
            ['@identifier'] = identifier
        })

        TriggerClientEvent('unjailPlayer', xPlayer.source)
        
        TriggerClientEvent('showReleaseMessage', xPlayer.source)
    end
end

RegisterServerEvent('mizu_admin:jailPlayer')
AddEventHandler('mizu_admin:jailPlayer', function(playerID, jailTime, reason, position)
    local source = source
    local targetPlayer = ESX.GetPlayerFromId(playerID)

    if targetPlayer and jailTime and reason then
        jailPlayer(source, playerID, jailTime, reason, position)
    else
        print("Erreur: ID de joueur, Temps ou raison invalide")
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)

        for playerId, data in pairs(jailedPlayers) do
            if data.manualUnjail == false and os.time() >= data.releaseTime then
                local xPlayer = ESX.GetPlayerFromId(playerId)

                if xPlayer then
                    MySQL.Async.fetchScalar('SELECT identifier FROM jail WHERE identifier = @identifier', {
                        ['@identifier'] = xPlayer.getIdentifier()
                    }, function(result)
                        if result then
                            local position = {
                                x = 1847.9,
                                y = 2586.2,
                                z = 45.7
                            }

                            xPlayer.setCoords(position)

                            MySQL.Async.execute('DELETE FROM jail WHERE identifier = @identifier', {
                                ['@identifier'] = xPlayer.getIdentifier()
                            })

                            jailedPlayers[playerId] = nil

                            TriggerClientEvent('showReleaseMessage', playerId)
                        end
                    end)
                end
            end
        end
    end
end)

RegisterNetEvent('requestJailLog')
AddEventHandler('requestJailLog', function()
  local source = source 
  MySQL.Async.fetchAll('SELECT * FROM jail', {}, function(result)
    TriggerClientEvent('showJailLogMenu', source, result)
  end)
end)

RegisterNetEvent('unjailPlayer')
AddEventHandler('unjailPlayer', function(identifier)
    unjailPlayer(identifier)
end)

RegisterServerEvent('mizu_admin:kickPlayer')
AddEventHandler('mizu_admin:kickPlayer', function(playerIdToKick)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if xPlayer and (xPlayer.getGroup() == 'admin' or xPlayer.getGroup() == 'superadmin') then
        local adminName = GetPlayerName(source)
        DropPlayer(playerIdToKick, "Vous avez été kické par " .. adminName .. ".")
    else
        print("Tentative de kick sans permission de : " .. GetPlayerName(source))
    end
end)

RegisterServerEvent('mizu_admin:banPlayer')
AddEventHandler('mizu_admin:banPlayer', function(playerIdToBan, reason, hours, permanent)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if xPlayer and (xPlayer.getGroup() == 'admin' or xPlayer.getGroup() == 'superadmin') then
        local identifier, char1, ip = '', '', GetPlayerEP(playerIdToBan)
        local playerName = GetPlayerName(playerIdToBan)
        local adminName = GetPlayerName(source)
        local banTime = os.time()
        local expireTime = permanent and -1 or (banTime + hours * 60 * 60)
        local guid = GetPlayerGuid(playerIdToBan)
        local xbl, discord, live, fivem = '', '', '', ''

        for k, v in pairs(GetPlayerIdentifiers(playerIdToBan)) do
            if string.sub(v, 1, string.len('xbl:')) == 'xbl:' then
                xbl = v
            elseif string.sub(v, 1, string.len('discord:')) == 'discord:' then
                discord = v
            elseif string.sub(v, 1, string.len('live:')) == 'live:' then
                live = v
            elseif string.sub(v, 1, string.len('fivem:')) == 'fivem:' then
                fivem = v
            elseif string.sub(v, 1, string.len('license:')) == 'license:' then
                char1 = string.gsub(v, 'license:', '')
            elseif string.sub(v, 1, string.len('steam:')) == 'steam:' then
                identifier = string.gsub(v, 'steam:', '')
            end
        end

        local banId = identifier ~= '' and identifier or (char1 ~= '' and char1 or ip)

        MySQL.Async.execute('INSERT INTO banlist (identifier, playerName, reason, banTime, expireTime, adminName, xbl, discord, live, fivem, char1, ip, guid) VALUES (@identifier, @playerName, @reason, @banTime, @expireTime, @adminName, @xbl, @discord, @live, @fivem, @char1, @ip, @guid)', {
            ['@identifier'] = banId,
            ['@playerName'] = playerName,
            ['@reason'] = reason,
            ['@banTime'] = banTime,
            ['@expireTime'] = expireTime,
            ['@adminName'] = adminName,
            ['@xbl'] = xbl,
            ['@discord'] = discord,
            ['@live'] = live,
            ['@fivem'] = fivem,
            ['@char1'] = char1,
            ['@ip'] = ip,
            ['@guid'] = guid
        }, function(rowsChanged)
            if permanent then
                DropPlayer(playerIdToBan, "Vous avez été banni par " .. adminName .. " pour la raison : " .. reason .. ". Le bannissement est permanent.")
            else
                DropPlayer(playerIdToBan, "Vous avez été banni par " .. adminName .. " pour la raison : " .. reason .. ". Le bannissement expirera dans " .. hours .. " heures.")
            end
        end)
    else
        print("Tentative de ban sans permission de : " .. GetPlayerName(source))
    end
end)

AddEventHandler('playerConnecting', function(playerName, setKickReason, deferrals)
    deferrals.defer()

    local identifier, xbl, discord, live, fivem, ip, guid, char1 = '', '', '', '', '', '', '', ''

    for k, v in pairs(GetPlayerIdentifiers(source)) do
        if string.sub(v, 1, string.len('steam:')) == 'steam:' then
            identifier = v
        elseif string.sub(v, 1, string.len('xbl:')) == 'xbl:' then
            xbl = v
        elseif string.sub(v, 1, string.len('discord:')) == 'discord:' then
            discord = v
        elseif string.sub(v, 1, string.len('live:')) == 'live:' then
            live = v
        elseif string.sub(v, 1, string.len('fivem:')) == 'fivem:' then
            fivem = v
        elseif string.sub(v, 1, string.len('license:')) == 'license:' then
            char1 = string.gsub(v, 'license:', '')
        end
    end

    ip = GetPlayerEP(source)
    guid = GetPlayerGuid(source)

    MySQL.Async.fetchAll('SELECT * FROM banlist WHERE identifier = @identifier OR xbl = @xbl OR discord = @discord OR live = @live OR fivem = @fivem OR char1 = @char1 OR ip = @ip OR guid = @guid', {
        ['@identifier'] = identifier,
        ['@xbl'] = xbl,
        ['@discord'] = discord,
        ['@live'] = live,
        ['@fivem'] = fivem,
        ['@char1'] = char1,
        ['@ip'] = ip,
        ['@guid'] = guid
    }, function(result)
        if result[1] then
            if result[1].expireTime == -1 then
                deferrals.done("Vous avez été banni pour la raison : " .. result[1].reason .. ". Le bannissement est permanent.")
            elseif result[1].expireTime > os.time() then
                local timeLeft = os.difftime(result[1].expireTime, os.time())
                local hoursLeft = math.floor(timeLeft / 3600)
                local minutesLeft = math.floor((timeLeft % 3600) / 60)
                deferrals.done("Vous avez été banni pour la raison : " .. result[1].reason .. ". Le bannissement expirera dans " .. hoursLeft .. " heures et " .. minutesLeft .. " minutes.")
            else
                MySQL.Async.execute('DELETE FROM banlist WHERE identifier = @identifier', {
                    ['@identifier'] = identifier
                }, function(rowsChanged)
                    deferrals.done()
                end)
            end
        else
            deferrals.done()
        end
    end)
end)

RegisterServerEvent('requestBanList')
AddEventHandler('requestBanList', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    if xPlayer and (xPlayer.getGroup() == 'admin' or xPlayer.getGroup() == 'superadmin') then
        MySQL.Async.fetchAll('SELECT * FROM banlist', {}, function(result)
            if result then
                for i=1, #result, 1 do
                    result[i].banTime = os.date('%Y-%m-%d %H:%M:%S', result[i].banTime)
                    result[i].expireTime = result[i].expireTime == -1 and "Permanent" or os.date('%Y-%m-%d %H:%M:%S', result[i].expireTime)
                end

                TriggerClientEvent('showBanLogMenu', _source, result)
            else
                print("Aucun ban enregistré.")
            end
        end)
    else
        print("Tentative de consultation de la liste des bans sans permission de : " .. GetPlayerName(_source))
    end
end)

RegisterServerEvent('unbanPlayer')
AddEventHandler('unbanPlayer', function(identifier)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    if xPlayer and (xPlayer.getGroup() == 'admin' or xPlayer.getGroup() == 'superadmin') then
        MySQL.Async.execute('DELETE FROM banlist WHERE identifier = @identifier OR discord = @identifier OR char1 = @identifier', 
            { ['@identifier'] = identifier }, 
            function(rowsChanged)
                if rowsChanged > 0 then
                    print("Le joueur a été débanni.")
                else
                    print("Erreur lors du débanissement du joueur.")
                end
            end
        )
    else
        print("Tentative de débanissement sans permission de : " .. GetPlayerName(_source))
    end
end)

RegisterCommand('report', function(source, args, rawCommand)
    local reason = table.concat(args, ' ')

    local identifiers = GetPlayerIdentifiers(source)
    
    local license = nil
    for i = 1, #identifiers do
        if string.sub(identifiers[i], 1, 8) == 'license:' then
            license = identifiers[i]
            break
        end
    end

    local playerName = GetPlayerName(source)

    MySQL.Async.execute('INSERT INTO reports (player_id, player_name, license, reason) VALUES (@player_id, @player_name, @license, @reason)', {
        ['@player_id'] = source,
        ['@player_name'] = playerName,
        ['@license'] = license,
        ['@reason'] = reason
    }, function(rowsChanged)
        TriggerClientEvent('MizuAdmin:showReportNotification', -1, playerName, source, reason)
    end)
end, false)

RegisterServerEvent('mizu_admin:requestReports')
AddEventHandler('mizu_admin:requestReports', function()
    local source = source

    MySQL.Async.fetchAll('SELECT * FROM reports', {}, function(reports)
        TriggerClientEvent('mizu_admin:receiveReports', source, reports)
    end)
end)

RegisterServerEvent('mizu_admin:takeReport')
AddEventHandler('mizu_admin:takeReport', function(reportId, adminName)
    MySQL.Async.execute('UPDATE reports SET admin_name = @admin_name WHERE id = @id', {
        ['@id'] = reportId,
        ['@admin_name'] = adminName
    }, function(rowsChanged)
        if rowsChanged > 0 then
            print("Report #" .. reportId .. " has been taken by " .. adminName)

            local embeds = {
                {
                    ["color"] = 3145609,
                    ["title"] = "__**Nouveau report pris**__",
                    ["description"] = "Admin: "..adminName.."\n Report: #"..reportId,
                    ["footer"] = {
                        ["text"] = "ATO Logs",
                    },
                }
            }
        
            
            PerformHttpRequest(Config.Webhook, function(err, text, headers) end, 'POST', json.encode({username = "Ato Logs", embeds = embeds}), { ['Content-Type'] = 'application/json' })
            TriggerClientEvent('mizu_admin:reportUpdated', -1, reportId, adminName)
        else
            print("No report found with id: " .. reportId)
        end
    end)
end)

RegisterServerEvent('mizu_admin:closeReport')
AddEventHandler('mizu_admin:closeReport', function(reportId)
    MySQL.Async.execute('DELETE FROM reports WHERE id = @id', {
        ['@id'] = reportId
    }, function(rowsChanged)
        if rowsChanged > 0 then
            print("Report #" .. reportId .. " has been closed.")
        else
            print("No report found with id: " .. reportId)
        end
    end)
end)


RegisterServerEvent('mizu_admin:getResources')
AddEventHandler('mizu_admin:getResources', function()
    local source = source

    local resources = {}

    local numResources = GetNumResources()

    for i = 0, numResources - 1 do
        local resourceName = GetResourceByFindIndex(i)
        table.insert(resources, resourceName)
    end

    TriggerClientEvent('mizu_admin:showResources', source, resources)
end)

RegisterServerEvent('mizu_admin:banPlayerOffline')
AddEventHandler('mizu_admin:banPlayerOffline', function(playerNameToBan, reason, hours, permanent)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if xPlayer and (xPlayer.getGroup() == 'admin' or xPlayer.getGroup() == 'superadmin') then
        local identifiers = searchForPlayerIdentifiers(playerNameToBan)
        if identifiers then
            local identifier, char1, ip, xbl, discord, live, fivem = identifiers.identifier, identifiers.char1, identifiers.ip, identifiers.xbl, identifiers.discord, identifiers.live, identifiers.fivem
            local adminName = GetPlayerName(source)
            local banTime = os.time()
            local expireTime = permanent and -1 or (banTime + hours * 60 * 60)
            local guid = identifiers.guid

            local banId = identifier ~= '' and identifier or (char1 ~= '' and char1 or ip)

            MySQL.Async.execute('INSERT INTO banlist (identifier, playerName, reason, banTime, expireTime, adminName, xbl, discord, live, fivem, char1, ip, guid) VALUES (@identifier, @playerName, @reason, @banTime, @expireTime, @adminName, @xbl, @discord, @live, @fivem, @char1, @ip, @guid)', {
                ['@identifier'] = banId,
                ['@playerName'] = identifiers.name, 
                ['@reason'] = reason,
                ['@banTime'] = banTime,
                ['@expireTime'] = expireTime,
                ['@adminName'] = adminName,
                ['@xbl'] = xbl,
                ['@discord'] = discord,
                ['@live'] = live,
                ['@fivem'] = fivem,
                ['@char1'] = char1,
                ['@ip'] = ip,
                ['@guid'] = guid
            }, function(rowsChanged)
                print(playerNameToBan .. " a été banni hors ligne par " .. adminName .. " pour " .. reason .. ". Temps " .. (permanent and "permanent." or "expirer dans " .. hours .. " heures."))
            end)
        else
            print("Failed to ban player offline: " .. playerNameToBan .. " not found.")
        end
    else
        print("Attempt to ban without permission from: " .. GetPlayerName(source))
    end
end)

function searchForPlayerIdentifiers(license)
    local identifiers = nil

    MySQL.Async.fetchAll('SELECT * FROM account_info WHERE license = @license', {
        ['@license'] = license
    }, function(users)
        if #users > 0 then
            identifiers = {
                identifier = users[1].license:gsub("license:", ""),
                steam = users[1].steam,
                xbl = users[1].xbl,
                discord = users[1].discord,
                live = users[1].live,
                fivem = users[1].fivem,
                name = users[1].name,
                ip = users[1].ip,
                guid = users[1].guid
            }
        end
    end)
    
    while identifiers == nil do
        Citizen.Wait(0)
    end

    return identifiers
end

RegisterServerEvent('mizu_admin:getAllUsers')
AddEventHandler('mizu_admin:getAllUsers', function()
    local source = source

    MySQL.Async.fetchAll('SELECT * FROM account_info', {}, function(users)
        TriggerClientEvent('mizu_admin:showAllUsers', source, users)
    end)
end)

RegisterServerEvent('mizu_admin:partialWipePlayer')
AddEventHandler('mizu_admin:partialWipePlayer', function(playerId, license, reason)
    local identifier = string.gsub(license, "license:", "char1:")
    MySQL.Async.execute('DELETE FROM users WHERE identifier = @identifier', {
        ['@identifier'] = identifier
    }, function(rowsChanged)
        print("L'utilisateur avec l'identifiant " .. identifier .. " a été partiellement wipe pour la raison suivante : " .. reason)
        
        DropPlayer(playerId, "Vous avez été déconnecté du serveur pour la raison suivante : " .. reason)
    end)
end)

RegisterServerEvent('mizu_admin:fullWipePlayer')
AddEventHandler('mizu_admin:fullWipePlayer', function(playerId, license, reason)
    
    local char1Identifier = string.gsub(license, "license:", "char1:")
    local rawIdentifier = string.gsub(license, "license:", "")

    MySQL.Async.execute('DELETE FROM users WHERE identifier IN (@char1Identifier, @license, @rawIdentifier)', {
        ['@char1Identifier'] = char1Identifier,
        ['@license'] = license,
        ['@rawIdentifier'] = rawIdentifier
    }, function(rowsChanged)
        print("L'utilisateur avec l'identifiant " .. char1Identifier .. " a été partiellement wipe pour la raison suivante : " .. reason)
    end)

    MySQL.Async.execute('DELETE FROM owned_vehicles WHERE owner IN (@char1Identifier, @license, @rawIdentifier)', {
        ['@char1Identifier'] = char1Identifier,
        ['@license'] = license,
        ['@rawIdentifier'] = rawIdentifier
    }, function(rowsChanged)
        print("L'utilisateur avec la license " .. license .. " a été wipe de la table `owned_vehicles` pour la raison suivante : " .. reason)
    end)

    MySQL.Async.execute('DELETE FROM user_licenses WHERE owner IN (@char1Identifier, @license, @rawIdentifier)', {
        ['@char1Identifier'] = char1Identifier,
        ['@license'] = license,
        ['@rawIdentifier'] = rawIdentifier
    }, function(rowsChanged)
        print("L'utilisateur avec la license " .. license .. " a été wipe de la table `user_licenses` pour la raison suivante : " .. reason)

        DropPlayer(playerId, "Vous avez été déconnecté du serveur pour la raison suivante : " .. reason)
    end)
end)

sqlReady = false

MySQL.ready(function()
	sqlReady = true
end)

AddEventHandler('playerConnecting', function()
	local _source = source
	local license, steam, xbl, discord, live, fivem = '', '', '', '', '', ''
	local name, ip, guid = GetPlayerName(_source), GetPlayerEP(_source), GetPlayerGuid(_source)

	while not sqlReady do
		Citizen.Wait(100)
	end

	for k, v in pairs(GetPlayerIdentifiers(_source)) do
		if string.sub(v, 1, string.len('license:')) == 'license:' then
			license = v
		elseif string.sub(v, 1, string.len('steam:')) == 'steam:' then
			steam = v
		elseif string.sub(v, 1, string.len('xbl:')) == 'xbl:' then
			xbl = v
		elseif string.sub(v, 1, string.len('discord:')) == 'discord:' then
			discord = v
		elseif string.sub(v, 1, string.len('live:')) == 'live:' then
			live = v
		elseif string.sub(v, 1, string.len('fivem:')) == 'fivem:' then
			fivem = v
		end
	end

	if license ~= nil then
		MySQL.Async.fetchAll('SELECT * FROM account_info WHERE license = @license', {
			['@license'] = license
		}, function(result)
			if result[1] ~= nil then
				MySQL.Async.execute('UPDATE account_info SET steam = @steam, xbl = @xbl, discord = @discord, live = @live, fivem = @fivem, `name` = @name, ip = @ip, guid = @guid WHERE license = @license', {
					['@license'] = license,
					['@steam'] = steam,
					['@xbl'] = xbl,
					['@discord'] = discord,
					['@live'] = live,
					['@fivem'] = fivem,
					['@name'] = name,
					['@ip'] = ip,
					['@guid'] = guid
				})
			else
				MySQL.Async.execute('INSERT INTO account_info (license, steam, xbl, discord, live, fivem, `name`, ip, guid) VALUES (@license, @steam, @xbl, @discord, @live, @fivem, @name, @ip, @guid)', {
					['@license'] = license,
					['@steam'] = steam,
					['@xbl'] = xbl,
					['@discord'] = discord,
					['@live'] = live,
					['@fivem'] = fivem,
					['@name'] = name,
					['@ip'] = ip,
					['@guid'] = guid
				})
			end
		end)
	end
end)

RegisterNetEvent('mizu_admin:sendAnnouncement')
AddEventHandler('mizu_admin:sendAnnouncement', function(title, message)
    TriggerClientEvent('mizu_admin:receiveAnnouncement', -1, title, message)
end)



