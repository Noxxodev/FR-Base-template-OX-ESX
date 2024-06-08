
local eventName = {
	job = {
		set = 'setJob',
		get = 'getJob',
		setLabel = 'setJobLabel',
		setSalary = 'setJobSalary',
	},
}

if Config.DoubleJob.enable then
	eventName[Config.DoubleJob.name] = Config.EventName
end

lib.locale()

function OpenBossMenu(society, close, options)
	local societyMoney = lib.callback.await('esx_society:getmoney', false, society)
	options = options or {}
	local elements = {}
	lib.callback('esx_society:isBoss', false, function(isBoss, selected)
	
	    if isBoss then
	    	local defaultOptions = {
	    		checkBal = true,
	    		withdraw = true,
	    		deposit = true,
	    		employees = true,
	    		salary = true,
	    		grades = true
	    	}
	    	for k,v in pairs(defaultOptions) do
	    		if options[k] == nil then
	    			options[k] = v
	    		end
	    	end
    
	    	if options.checkBal then
	    		elements[#elements+1] = {
	    			title = locale('check_society_balance', societyMoney),
	    			icon = "fas fa-wallet"
	    		}
	    	end
	    	if options.withdraw then
	    		elements[#elements+1] = {
	    			title = locale('withdraw_society_money'),
	    			description = locale('withdraw_description'),
	    			icon = "fas fa-wallet",
	    			onSelect = function()
	    				local amount = lib.inputDialog(locale('withdraw_amount'), {
	    					{type = 'number', label = locale('amount_title'), description = locale('withdraw_amount_placeholder'), required = true, min = 1, max = 250000}
	    					})
	    					if not amount then return end
	    					TriggerServerEvent('esx_society:withdrawMoney', society, amount[1])
	    					OpenBossMenu(society, nil, options, selected)
	    			end,
	    		}
	    	end
	    	if options.deposit then
	    		elements[#elements+1] = {
	    			title = locale('deposit_society_money'),
	    			description = locale('deposit_description'),
	    			icon = "fas fa-wallet",
	    			onSelect = function()
	    				local amount = lib.inputDialog(locale('deposit_amount'), {
	    					{type = 'number', label = locale('amount_title'), description = locale('deposit_amount_placeholder'), required = true, min = 1, max = 250000}
	    					})
	    					if not amount then return end
	    					TriggerServerEvent('esx_society:depositMoney', society, amount[1])
	    					OpenBossMenu(society, nil, options, selected)
	    			end,
	    		}
	    	end
    
	    	if options.employees then
	    		elements[#elements+1] = {
	    			title = locale('employee_management'),
	    			icon = "fas fa-users",
	    			onSelect = function()
	    				OpenManageEmployeesMenu(society, options, selected)
	    			end,
	    		}
	    	end
    
	    	if options.salary then
	    		elements[#elements+1] = {
	    			title = locale('salary_management'),
	    			icon = "fas fa-wallet",
	    			onSelect = function()
	    				OpenManageSalaryMenu(society, options, selected)
	    			end,
	    		}
	    	end
	    	if options.grades then
	    		elements[#elements+1] = {
	    			title = locale('grade_management'),
	    			icon = "fas fa-wallet",
	    			onSelect = function()
	    				OpenManageGradesMenu(society, options, selected)
	    			end,
	    		}
	    	end
    
	    	lib.registerContext({
	    		id = 'OpenBossMenu',
	    		title = locale('boss_menu'),
	    		options = elements
	    	})
	    	lib.showContext('OpenBossMenu')
	    end
	end, society)
end

function OpenManageEmployeesMenu(society, options, selected)
	lib.registerContext({
		id = 'OpenManageEmployeesMenu',
		title = locale('employee_management'),
		menu = 'OpenBossMenu',
		options = {
			{
				title = locale('employee_list'),
				icon = "fas fa-users",
				onSelect = function()
					OpenEmployeeList(society, options, selected)
				end,
			},
			{
				title = locale('recruit'),
				icon = "fas fa-users",
				onSelect = function()
					OpenRecruitMenu(society, options, selected)
				end,
			}
		}
	})
	lib.showContext('OpenManageEmployeesMenu')
end

function OpenEmployeeList(society, options, selected)
	lib.callback('esx_society:getEmployees', false, function(employees)
		local elements = {}
	    for i=1, #employees, 1 do
	    	local gradeLabel = (employees[i][selected].grade_label == '' and employees[i][selected].label or employees[i][selected].grade_label)
	    	elements[#elements+1] = {
	    		title = employees[i].name .. " | "..employees[i][selected].name.." | " ..gradeLabel, gradeLabel = gradeLabel,
	    		icon = "fas fa-user",
	    		onSelect = function()
	    			OpenSelectedEmploye(society, options, employees[i], selected)
	    		end,
	    	}
	    end
	    lib.registerContext({
	    	id = 'OpenEmployeeList',
	    	title = locale('employees_title'),
	    	menu = 'OpenManageEmployeesMenu',
	    	options = elements
    
	    })
	    lib.showContext('OpenEmployeeList')
	end, society)
end

function OpenSelectedEmploye(society, options, data, selected)
	lib.registerContext({
		id = 'OpenSelectedEmploye',
		title = locale('employee_management'),
		menu = 'OpenEmployeeList',
		options = {
			{
				title = locale('promote'),
				icon = "fas fa-users",
				onSelect = function()
					lib.callback.await(('esx_society:%s'):format(eventName[selected].set), false, data.identifier, society, data[selected].grade+1, 'promote')
				end,
			},
			{
				title = locale('demote'),
				icon = "fas fa-users",
				onSelect = function()
					lib.callback.await(('esx_society:%s'):format(eventName[selected].set), false, data.identifier, society, data[selected].grade-1, 'demote')
				end,
			},
			{
				title = locale('fire'),
				icon = "fas fa-users",
				onSelect = function()
					lib.callback.await(('esx_society:%s'):format(eventName[selected].set), false, data.identifier, selected == 'job' and 'unemployed' or Config.DoubleJob.default.list.name, 0, 'fire')
				end,
			}
		}
	})
	lib.showContext('OpenSelectedEmploye')
end

function OpenRecruitMenu(society, options, selected)
	lib.callback('esx_society:getOnlinePlayers', false, function(players)
		local elements = {}
	    for i=1, #players, 1 do
	    	if players[i].name ~= society then
	    		elements[#elements+1] = {
	    			icon = "fas fa-user",
	    			title = players[i].name,
	    			onSelect = function()
	    				lib.callback.await(('esx_society:%s'):format(eventName[selected].set), false, players[i].identifier, society, 0, 'hire')
	    			end
	    		}
	    	else
	    		elements[#elements+1] = {
	    			icon = "fas fa-user",
	    			title = locale('no_player')
	    		}
	    	end
	    end
	    lib.registerContext({
	    	id = 'OpenRecruitMenu',
	    	title = locale('recruiting'),
	    	options = elements
	    })
	    lib.showContext('OpenRecruitMenu')
	end)
end

function OpenManageSalaryMenu(society, options, selected)
	lib.callback(('esx_society:%s'):format(eventName[selected].get), false, function(data)
		
		if not data then
			return
		end

		local elements = {}

	    for i=1, #data.grades, 1 do
	    	local gradeLabel = (data.grades[i].label == '' and data.label or data.grades[i].label)

	    	elements[#elements+1] = {
	    		icon = "fas fa-wallet",
	    		title = locale('money_generic', gradeLabel, ESX.Math.GroupDigits(data.grades[i].salary)),
	    		onSelect = function()
	    			local amount = lib.inputDialog(locale('change_salary_description'), {
	    				{type = 'number', label = locale('amount_title'), description = locale('change_salary_placeholder'), required = true, min = 0, max = Config.MaxSalary}
	    			  })
	    			if not amount then return end
	    			lib.callback.await(('esx_society:%s'):format(eventName[selected].setSalary), false, society, data.grades[i].grade, amount[1], gradeLabel)
	    			OpenManageSalaryMenu(society, options, selected)
	    		end,
	    	}
	    end
	    lib.registerContext({
	    	id = 'OpenManageSalaryMenu',
	    	title = locale('salary_management'),
	    	menu = 'OpenBossMenu',
	    	options = elements
	    })
	    lib.showContext('OpenManageSalaryMenu')
    end, society)
end

function OpenManageGradesMenu(society, options, selected)
	lib.callback(('esx_society:%s'):format(eventName[selected].get), false, function(data)
	local elements = {}
	for i=1, #data.grades, 1 do
		local gradeLabel = (data.grades[i].label == '' and data.label or data.grades[i].label)
		elements[#elements+1] = {
			icon = "fas fa-wallet",
			title = ('%s'):format(gradeLabel),
			onSelect = function()
				local text = lib.inputDialog(locale('change_label_description'), {
					{type = 'input', label = locale('change_label_title'), description = locale('change_label_placeholder'), required = true}
				  })
				local label = tostring(text[1])
				lib.callback.await(('esx_society:%s'):format(eventName[selected].setLabel), false, society, data.grades[i].grade, label)
				OpenManageGradesMenu(society, options, selected)
			end,
		}
	end
	lib.registerContext({
		id = 'OpenManageGradesMenu',
		title = locale('grade_management'),
		menu = 'OpenBossMenu',
		options = elements
	})
	lib.showContext('OpenManageGradesMenu')
end, society)
end

AddEventHandler('esx_society:openBossMenu', function(society, close, options)
	OpenBossMenu(society, close, options)
end)