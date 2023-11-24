AC = {}
AC.Bans = {}
AC.Utils = {}

AC.Reasons = {
    ['triggerserverevent'] = 'Triggering server events with 3rd party software',
}

Core:Ready(function()
    exports.oxmysql:query('SELECT * FROM id_bans', {}, function(data)
        if data and data[1] then
            for k,v in pairs(data) do
                table.insert(AC.Bans, {
                    identifier = v.identifier,
                    name = v.name,
                    reason = v.reason,
                    time = v.time
                })
            end
        end
    end)
end)

function AC.Utils:PermBan(src, identifier, reason, resource)

    if AC.Reasons[reason:lower()] then reason = AC.Reasons[reason:lower()] end
    if not reason then reason = 'CHEATING' end

    if not identifier and src and GetPlayerName(src) then
        identifier = Core.Utils:GetIdentifier(src)
    end

    table.insert(AC.Bans, {
        identifier = identifier,
        name = GetPlayerName(src),
        reason = reason,
        time = 0
    })
    exports.oxmysql:insert('INSERT INTO id_bans (identifier, name, reason, time) VALUES (?,?,?,?)', {identifier, GetPlayerName(src), reason, 0})

    if resource then
        DropPlayer(src, '\n⛔ YOU HAVE BEEN BANNED ⛔\n🔵 Reason: '..reason..'\n🔵 Admin: Identity Store AC\n🔵 Until: Permanent\n\nResource: '..resource)
    else
        DropPlayer(src, '\n⛔ YOU HAVE BEEN BANNED ⛔\n🔵 Reason: '..reason..'\n🔵 Admin: Identity Store AC\n🔵 Until: Permanent')
    end
end

function AC.Utils:TempBan(src, identifier, time, reason, resource)
    time = os.time() + time

    if AC.Reasons[reason:lower()] then reason = AC.Reasons[reason:lower()] end
    if not reason then reason = 'CHEATING' end

    if not identifier and src and GetPlayerName(src) then
        identifier = Core.Utils:GetIdentifier(src)
    end

    table.insert(AC.Bans, {
        identifier = identifier,
        name = GetPlayerName(src),
        reason = reason,
        time = time,
        resource = resource
    })
    exports.oxmysql:insert('INSERT INTO id_bans (identifier, name, reason, time) VALUES (?,?,?,?)', {identifier, GetPlayerName(src), reason, time})

    local date = os.date('%d/%m-%Y - %H:%M:%S', time)

    if resource then
        DropPlayer(src, '\n⛔ YOU HAVE BEEN BANNED ⛔\n🔵 Reason: '..reason..'\n🔵 Admin: Identity Store AC\n🔵 Until: '..date..'\n\nResource: '..resource)
    else
        DropPlayer(src, '\n⛔ YOU HAVE BEEN BANNED ⛔\n🔵 Reason: '..reason..'\n🔵 Admin: Identity Store AC\n🔵 Until: '..date)
    end
end

function AC.Utils:UnBan(identifier)
    for k,v in pairs(AC.Bans) do
        if v.identifier == identifier then
            exports.oxmysql:query('DELETE FROM id_bans WHERE identifier = ?', {identifier})
            table.remove(AC.Bans, k)
            break
        end
    end
end

function AC.Utils:IsPlayerBanned(identifier)
    for k,v in pairs(AC.Bans) do
        if v.identifier == identifier then
            return v
        end
    end

    return false
end

exports('getACUtils', function()
    return AC.Utils
end)

AddEventHandler('playerConnecting', function(name, setCallback, deferrals)
    local src = source
    local identifier = Core.Utils:GetIdentifier(src)

    deferrals.defer()
    Wait(500)

    deferrals.update('[AC]: Checking if you are banned from the server.')
    Wait(10)
    
    local playerBan = AC.Utils:IsPlayerBanned(identifier)

    if playerBan then
        local time = os.time()

        if playerBan.time == 0 or time < playerBan.time then
            local date = os.date('%d/%m-%Y - %H:%M:%S', playerBan.time)
            if playerBan.time == 0 then date = 'Permanent' end

            local txt = '\n⛔ YOU ARE BANNED FROM THE SERVER ⛔\n🔵 Reason: '..playerBan.reason..'\n🔵 Admin: Identity Store AC\n🔵 Until: '..date
            if playerBan.resource then
                txt = '\n⛔ YOU ARE BANNED FROM THE SERVER ⛔\n🔵 Reason: '..playerBan.reason..'\n🔵 Admin: Identity Store AC\n🔵 Until: '..date..'\n\nResource: '..playerBan.resource
            end

            deferrals.done(txt)
            return
        end

        AC.Utils:UnBan(identifier)
    end

    deferrals.done()
end)

Core.Started.anticheat = true