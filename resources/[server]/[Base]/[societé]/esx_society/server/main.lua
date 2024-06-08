lib.locale()

local Jobs = setmetatable({}, {__index = function(_, key)
	return ESX.GetJobs()[key]
end
})

local Factions = nil

if Config.DoubleJob then
	Factions = setmetatable({}, {
		__index = function(_, key)
			return ESX[Config.DoubleJob.all]()[key]
		end
	})
end

local RegisteredSocieties = {}
local SocietiesByName = {}

function GetSociety(name)
	return SocietiesByName[name]
end
exports("GetSociety", GetSociety)

function registerSociety(name, label, account, datastore, inventory, data)
	if SocietiesByName[name] then
		print(('[^3WARNING^7] society already registered, name: ^5%s^7'):format(name))
		return
	end
	local society = {
		name = name,
		label = label,
		account = account,
		datastore = datastore,
		inventory = inventory,
		data = data
	}
	SocietiesByName[name] = society
	table.insert(RegisteredSocieties, society)
end
AddEventHandler('esx_society:registerSociety', registerSociety)
exports("registerSociety", registerSociety)

AddEventHandler('esx_society:getSocieties', function(cb)
	cb(RegisteredSocieties)
end)

AddEventHandler('esx_society:getSociety', function(name, cb)
	cb(GetSociety(name))
end)

lib.callback.register('esx_society:getmoney', function(source, name)
    local society, money
    TriggerEvent('esx_society:getSociety', name, function(sname)
        society = sname
    end)
    TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function(account)
        money = account.money or 0
    end)
    return money
end)

RegisterServerEvent('esx_society:withdrawMoney')
AddEventHandler('esx_society:withdrawMoney', function(societyName, amount)
	local source = source
	local selected = Jobs[societyName] and 'job' or Config.DoubleJob and Factions[societyName] and Config.DoubleJob.name
	local society = GetSociety(societyName)
	if not society then
		print(('[^3WARNING^7] Player ^5%s^7 attempted to withdraw from non-existing society - ^5%s^7!'):format(source, societyName))
		return
	end

	if not selected then return end

	local xPlayer = ESX.GetPlayerFromId(source)
	amount = ESX.Math.Round(tonumber(amount))
	if (xPlayer[selected].name ~= society.name)then
		return print(('[^3WARNING^7] Player ^5%s^7 attempted to withdraw from society - ^5%s^7!'):format(source, society.name))
	end

	TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function(account)
		if amount > 0 and account.money >= amount then
			account.removeMoney(amount)
			xPlayer.addMoney(amount, "Society Withdraw")
			Config.Notify('have_withdrawn', xPlayer.source, ESX.Math.GroupDigits(amount))
		else
			xPlayer.showNotification(TranslateCap('invalid_amount'))
			Config.Notify('invalid_amount')
		end
	end)
end)

RegisterServerEvent('esx_society:depositMoney')
AddEventHandler('esx_society:depositMoney', function(societyName, amount)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local selected = Jobs[societyName] and 'job' or Config.DoubleJob and Factions[societyName] and Config.DoubleJob.name
	local society = GetSociety(societyName)
	if not society then
		print(('[^3WARNING^7] Player ^5%s^7 attempted to deposit to non-existing society - ^5%s^7!'):format(source, societyName))
		return
	end

	if not selected then return end

	amount = ESX.Math.Round(tonumber(amount))

	if (xPlayer[selected].name ~= society.name) then
		return print(('[^3WARNING^7] Player ^5%s^7 attempted to deposit to society - ^5%s^7!'):format(source, society.name))
	end
	if amount > 0 and xPlayer.getMoney() >= amount then
		TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function(account)
			xPlayer.removeMoney(amount, "Society Deposit")
			Config.Notify('have_deposited', xPlayer.source, ESX.Math.GroupDigits(amount))
			account.addMoney(amount)
		end)
	else
		Config.Notify('invalid_amount')
	end
end)

RegisterServerEvent('esx_society:putVehicleInGarage')
AddEventHandler('esx_society:putVehicleInGarage', function(societyName, vehicle)
	local source = source
	local society = GetSociety(societyName)
	if not society then
		print(('[^3WARNING^7] Player ^5%s^7 attempted to put vehicle in non-existing society garage - ^5%s^7!'):format(source, societyName))
		return
	end
	TriggerEvent('esx_datastore:getSharedDataStore', society.datastore, function(store)
		local garage = store.get('garage') or {}
		table.insert(garage, vehicle)
		store.set('garage', garage)
	end)
end)

RegisterServerEvent('esx_society:removeVehicleFromGarage')
AddEventHandler('esx_society:removeVehicleFromGarage', function(societyName, vehicle)
	local source = source
	local society = GetSociety(societyName)
	if not society then
		print(('[^3WARNING^7] Player ^5%s^7 attempted to remove vehicle from non-existing society garage - ^5%s^7!'):format(source, societyName))
		return
	end
	TriggerEvent('esx_datastore:getSharedDataStore', society.datastore, function(store)
		local garage = store.get('garage') or {}
		for i=1, #garage, 1 do
			if garage[i].plate == vehicle.plate then
				table.remove(garage, i)
				break
			end
		end
		store.set('garage', garage)
	end)
end)

lib.callback.register('esx_society:getEmployees', function(source, society)
	local employees, selected = {}, Jobs[society] and 'job' or Factions[society] and Config.DoubleJob.name or 'job'
	local xPlayers = ESX.GetExtendedPlayers(selected, society)
	local query = selected == 'job' and "SELECT identifier, job_grade FROM `users` WHERE `job`= ? ORDER BY job_grade DESC" or selected == Config.DoubleJob.name and ("SELECT identifier, %s, firstname, lastname FROM `users` WHERE `%s`= ? ORDER BY %s DESC"):format(Config.DoubleJob.database.users_dj_grade, Config.DoubleJob.database.users_dj_name, Config.DoubleJob.database.users_dj_grade)

	local response = MySQL.query.await(query, {society})
	for i = 1, #response do
		local row = response[i]
				local Selected = selected == Config.DoubleJob.name and Factions or selected == 'job' and Jobs
				local gradeSelected = selected == Config.DoubleJob.name and Config.DoubleJob.database.users_dj_grade or selected == 'job' and 'job_grade'

				for u=1, #(xPlayers) do 
					local xPlayer = xPlayers[u]
			
					local name = xPlayer.name
					if Config.EnableESXIdentity and name == GetPlayerName(xPlayer.source) then
						name = xPlayer.get('firstName') .. ' ' .. xPlayer.get('lastName')
					end

				    employees[#employees+1] = {
				    	name = name,
				    	identifier = xPlayer.identifier,
				    	[selected] = {
				    		name = society,
				    		label = Selected[society].label,
				    		grade = row[gradeSelected],
				    		grade_name = Selected[society].grades[tostring(row[gradeSelected])].name,
				    		grade_label = Selected[society].grades[tostring(row[gradeSelected])].label
				    	}
				    }
			end
	end
	return employees
end)

lib.callback.register('esx_society:getJob', function(source, society)
	if not Jobs[society] then
		return false
	end
	local job = json.decode(json.encode(Jobs[society]))
	local grades = {}
	for k,v in pairs(job.grades) do
		table.insert(grades, v)
	end
	table.sort(grades, function(a, b)
		return a.grade < b.grade
	end)
	job.grades = grades
	return job
end)

lib.callback.register('esx_society:setJob', function(source, identifier, job, grade, actionType)
	local xPlayer = ESX.GetPlayerFromId(source)
	local isBoss = Config.BossGrades[xPlayer.job.grade_name]
	local xTarget = ESX.GetPlayerFromIdentifier(identifier)
	if not isBoss then
		print(('[^3WARNING^7] Player ^5%s^7 attempted to setJob for Player ^5%s^7!'):format(source, xTarget.source))
		return false
	end
	if not xTarget then
		MySQL.update('UPDATE users SET job = ?, job_grade = ? WHERE identifier = ?', {job, grade, identifier},
		function()
			return false
		end)
		return
	end
	xTarget.setJob(job, grade)
	if actionType == 'hire' then
		Config.Notify('you_have_been_hired', xTarget.source, job)
		Config.Notify('you_have_hired', xPlayer.source, xTarget.getName())
	elseif actionType == 'promote' then
		Config.Notify('you_have_been_promoted', xTarget.source)
		Config.Notify('you_have_promoted', xPlayer.source, xTarget.getName(), xTarget.getJob().grade_label)
	elseif actionType == 'demote' then
		Config.Notify('you_have_been_demoted', xTarget.source)
		Config.Notify('you_have_demoted', xPlayer.source, xTarget.getName(), xTarget.getJob().grade_label)
	elseif actionType == 'fire' then
		Config.Notify('you_have_been_fired', xTarget.source, xPlayer.getJob().label)
		Config.Notify('you_have_fired', xPlayer.source, xTarget.getName())
	end
	return true
end)

lib.callback.register('esx_society:setJobSalary', function(source, job, grade, salary, gradeLabel)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.job.name == job and Config.BossGrades[xPlayer.job.grade_name] then
		if salary <= Config.MaxSalary then
			MySQL.update('UPDATE job_grades SET salary = ? WHERE job_name = ? AND grade = ?', {salary, job, grade},
			function(rowsChanged)
				Jobs[job].grades[tostring(grade)].salary = salary
				ESX.RefreshJobs()
				Wait(1)
				local xPlayers = ESX.GetExtendedPlayers('job', job)
				for _, xTarget in pairs(xPlayers) do
					if xTarget.job.grade == grade then
						xTarget.setJob(job, grade)
					end
				end
				Config.Notify('salary_change', xPlayer.source, salary, gradeLabel)
				return true
			end)
		else
			print(('[^3WARNING^7] Player ^5%s^7 attempted to setJobSalary over the config limit for ^5%s^7!'):format(source, job))
			return false
		end
	else
		print(('[^3WARNING^7] Player ^5%s^7 attempted to setJobSalary for ^5%s^7!'):format(source, job))
		return true
	end
end)

lib.callback.register('esx_society:setJobLabel', function(source, job, grade, label)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.job.name == job and Config.BossGrades[xPlayer.job.grade_name] then
        MySQL.update('UPDATE job_grades SET label = ? WHERE job_name = ? AND grade = ?', {label, job, grade},
        function(rowsChanged)
            Jobs[job].grades[tostring(grade)].label = label
            ESX.RefreshJobs()
            Wait(1)
            local xPlayers = ESX.GetExtendedPlayers('job', job)
            for _, xTarget in pairs(xPlayers) do
                if xTarget.job.grade == grade then
                    xTarget.setJob(job, grade)
                end
            end
			Config.Notify('grade_change', xPlayer.source, label)
			return true
        end)
    else
        print(('[^3WARNING^7] Player ^5%s^7 attempted to setJobLabel for ^5%s^7!'):format(source, job))
		return false
    end
end)

lib.callback.register('esx_society:getOnlinePlayers', function(source)
	local onlinePlayers = {}
	local xPlayers = ESX.GetExtendedPlayers()
	for i=1, #(xPlayers) do 
		local xPlayer = xPlayers[i]
		table.insert(onlinePlayers, {
			source = xPlayer.source,
			identifier = xPlayer.identifier,
			name = xPlayer.name,
			job = xPlayer.job,
		})
		if Config.DoubleJob then
			onlinePlayers[i][Config.DoubleJob.name] = xPlayer[Config.DoubleJob.name]
		end
	end
return onlinePlayers
end)
ESX.RegisterServerCallback('esx_society:getVehiclesInGarage', function(source, cb, societyName)
	local society = GetSociety(societyName)
	if not society then
		print(('[^3WARNING^7] Attempting To get a non-existing society - %s!'):format(societyName))
		return
	end
	TriggerEvent('esx_datastore:getSharedDataStore', society.datastore, function(store)
		local garage = store.get('garage') or {}
		cb(garage)
	end)
end)

lib.callback.register('esx_society:isBoss', function(source, job)
	return isPlayerBoss(source, job)
end)

function isPlayerBoss(playerId, society)
	local xPlayer = ESX.GetPlayerFromId(playerId)
	local selected = Jobs[society] and 'job' or Config.DoubleJob and Factions[society] and Config.DoubleJob.name
	if selected and (xPlayer[selected].name == society and Config.BossGrades[xPlayer[selected].grade_name]) then
		return true, selected
    else
		print(('esx_society: %s attempted open a society boss menu!'):format(xPlayer.identifier))
		return false
	end
end

if not Config.DoubleJob then return end

-- Double job 
lib.callback.register(('esx_society:%s'):format(Config.EventName.get), function(source, society)
	if not Factions[society] then
		return false
	end
	local faction = json.decode(json.encode(Factions[society]))
	local grades = {}
	for k,v in pairs(faction.grades) do
		table.insert(grades, v)
	end
	table.sort(grades, function(a, b)
		return a.grade < b.grade
	end)
	faction.grades = grades
	return faction
end)

lib.callback.register(('esx_society:%s'):format(Config.EventName.set), function(source, identifier, faction, grade, actionType)
	local xPlayer = ESX.GetPlayerFromId(source)
	local isBoss = Config.BossGrades[xPlayer.faction.grade_name]  
	local xTarget = ESX.GetPlayerFromIdentifier(identifier)
	if not xPlayer[Config.DoubleJob.name].grade_name == Config.BossGrades then
		print(('[^3WARNING^7] Player ^5%s^7 attempted to %s for Player ^5%s^7!'):format(source, Config.EventName.set, xTarget.source))
		return false
	end
	if not xTarget then
		MySQL.update(('UPDATE users SET %s = ?, %s = ? WHERE identifier = ?'):format(Config.DoubleJob.database.users_dj_name, Config.DoubleJob.database.users_dj_grade), {faction, grade, identifier},
		function()
			return false
		end)
		return
	end
	xTarget[Config.DoubleJob.set](faction, grade)
	if actionType == 'hire' then
		Config.Notify('you_have_been_hired', xTarget.source, faction)
		Config.Notify('you_have_hired', xPlayer.source, xTarget.getName())
	elseif actionType == 'promote' then
		Config.Notify('you_have_been_promoted', xTarget.source)
		Config.Notify('you_have_promoted', xPlayer.source, xTarget.getName(), xTarget[Config.DoubleJob.get]().grade_label)
	elseif actionType == 'demote' then
		Config.Notify('you_have_been_demoted', xTarget.source)
		Config.Notify('you_have_demoted', xPlayer.source, xTarget.getName(), xTarget[Config.DoubleJob.get]().label)
	elseif actionType == 'fire' then
		Config.Notify('you_have_been_fired', xTarget.source, xPlayer[Config.DoubleJob.get]().label)
		Config.Notify('you_have_fired', xPlayer.source, xTarget.getName())
	end
	return true
end)

lib.callback.register(('esx_society:%s'):format(Config.EventName.setSalary), function(source, faction, grade, salary, gradeLabel)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer[Config.DoubleJob.name].name == faction and Config.BossGrades[xPlayer[Config.DoubleJob.name].grade_name] then
		if salary <= Config.MaxSalary then
			MySQL.update(('UPDATE %s SET salary = ? WHERE %s = ? AND grade = ?'):format(Config.DoubleJob.database.list_grade, Config.DoubleJob.database.list_grade_name), {salary, faction, grade},
			function(rowsChanged)
				Factions[faction].grades[tostring(grade)].salary = salary
				ESX[Config.DoubleJob.refresh]()
				Wait(1)
				local xPlayers = ESX.GetExtendedPlayers(Config.DoubleJob.name, faction)
				for _, xTarget in pairs(xPlayers) do
					if xTarget[Config.DoubleJob.name].grade == grade then
						xTarget[Config.DoubleJob.set](faction, grade)
					end
				end
				Config.Notify('salary_change', xPlayer.source, salary, gradeLabel)
				return true
			end)
		else
			print(('[^3WARNING^7] Player ^5%s^7 attempted to %s over the config limit for ^5%s^7!'):format(source, Config.EventName.setSalary, faction))
			return false
		end
	else
		print(('[^3WARNING^7] Player ^5%s^7 attempted to %s for ^5%s^7!'):format(source, Config.EventName.setSalary, faction))
		return true
	end
end)

lib.callback.register(('esx_society:%s'):format(Config.EventName.setLabel), function(source, faction, grade, label)
    local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer[Config.DoubleJob.name].name == faction and Config.BossGrades[xPlayer[Config.DoubleJob.name].grade_name] then
		MySQL.update(('UPDATE %s SET label = ? WHERE %s = ? AND grade = ?'):format(Config.DoubleJob.database.list_grade, Config.DoubleJob.database.list_grade_name), {label, faction, grade},
        function(rowsChanged)
            Factions[faction].grades[tostring(grade)].label = label
            ESX[Config.DoubleJob.refresh]()
            Wait(1)
			local xPlayers = ESX.GetExtendedPlayers(Config.DoubleJob.name, faction)
            for _, xTarget in pairs(xPlayers) do
				if xTarget[Config.DoubleJob.name].grade == grade then
					xTarget[Config.DoubleJob.set](faction, grade)
				end
            end
			Config.Notify('grade_change', xPlayer.source, label)
			return true
        end)
    else
        print(('[^3WARNING^7] Player ^5%s^7 attempted to %s for ^5%s^7!'):format(source, Config.EventName.setLabel, faction))
		return false
    end
end)

--Log Discord
function sendToDiscord1(name, message)
    if message == nil or message == '' then return FALSE end
    PerformHttpRequest(Config.webhook, function(err, text, headers) end, 'POST', json.encode({username = name, content = message}), { ['Content-Type'] = 'application/json' })
end

AddEventHandler('esx_society:depositMoney', function(societyName, amount)
	local date = os.date('*t')
	if date.day < 10 then date.day = '0' .. tostring(date.day) end
	if date.month < 10 then date.month = '0' .. tostring(date.month) end
	if date.hour < 10 then date.hour = '0' .. tostring(date.hour) end
	if date.min < 10 then date.min = '0' .. tostring(date.min) end
	if date.sec < 10 then date.sec = '0' .. tostring(date.sec) end
    sendToDiscord1('Logs Dépose D\'argent','**Menu Patron Dépose Argent** \n```diff\nJoueurs: '.. GetPlayerName(source) ..' \n \n- A déposé ' .. amount .. ' €  \n \n- Dans la société '.. societyName ..' \n \n+ Date: '.. date.day ..'/'.. date.month ..'/'.. date.year ..' - '.. date.hour ..':'.. date.min ..':'.. date.sec ..'. ```')
end)

AddEventHandler('esx_society:withdrawMoney', function(societyName, amount)
	local date = os.date('*t')
	if date.day < 10 then date.day = '0' .. tostring(date.day) end
	if date.month < 10 then date.month = '0' .. tostring(date.month) end
	if date.hour < 10 then date.hour = '0' .. tostring(date.hour) end
	if date.min < 10 then date.min = '0' .. tostring(date.min) end
	if date.sec < 10 then date.sec = '0' .. tostring(date.sec) end
	sendToDiscord1('Logs retire D\'argent', '**Menu Patron Retire Argent ** \n```diff\nJoueurs: '.. GetPlayerName(source) ..' \n \n- A retiré ' .. amount .. ' €  \n \n- Dans la société '.. societyName ..' \n \n+ Date: '.. date.day ..'/'.. date.month ..'/'.. date.year ..' - '.. date.hour ..':'.. date.min ..':'.. date.sec ..'. ```')
end)