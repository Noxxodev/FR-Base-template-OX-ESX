Config = {}

Config.EnableESXIdentity = true
Config.MaxSalary = 3500

Config.BossGrades = {
    ['boss'] = true
}
Config.webhook = "Ton webhook"

Config.DoubleJob = ESX.GetConfig().DoubleJob.enable == true and ESX.GetConfig().DoubleJob or false

if Config.DoubleJob then
    Config.EventName = {
        set = Config.DoubleJob.set,
		get = Config.DoubleJob.get,
		setLabel = 'setJob2Label',
		setSalary = 'setJob2Salary',
    }
end

Config.Notify = function(key, source, ...)
    local service = IsDuplicityVersion()
    local description, data
    if ... then
         description = (Config.Notifications[key].description):format(...)
         data = {
            id = Config.Notifications[key].id,
            title = Config.Notifications[key].title,
            description = description,
            position = Config.Notifications[key].position,
            style = Config.Notifications[key].style,
            icon = Config.Notifications[key].icon,
            type = Config.Notifications[key].type,
            iconColor = Config.Notifications[key].iconColor
         }
    end
    lib.notify(service and source or (data or Config.Notifications[key]), service and (data or Config.Notifications[key]))
end