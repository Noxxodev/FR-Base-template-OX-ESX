local p, Await <const> = nil, Citizen.Await

local function ConvertUnix(unixTime, format_date)

    if type(unixTime) ~= 'number' then return end
    if p then return end

    SendNUIMessage({
        action = 'setVisible',
        data = true
    })

    SendNUIMessage({
        action = 'convertUnix',
        data = {
            unix = unixTime,
            format_date = format_date or 'DD/MM/YYYY'
        }
    })

    p = promise.new()
    return Await(p)
end

RegisterNUICallback('returnConvert', function(data, cb)
    if p then p:resolve(data) end
    p = nil
    cb({})
end)

exports('ConvertUnixTime', ConvertUnix)