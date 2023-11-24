Core.Logs = {}
Core.Logs.Data = {}

local function ExtractIdentifiers(src)
    local identifiers = {}

    for i = 0, GetNumPlayerIdentifiers(src) - 1 do
        local id = GetPlayerIdentifier(src, i)

        if string.find(id, "license:") then
            identifiers.license = id
        elseif string.find(id, "license2") then
            identifiers.license2 = id
        elseif string.find(id, "steam") then
            identifiers.steam = id
        elseif string.find(id, "xbl") then
            identifiers.xbl = id
        elseif string.find(id, "ip") then
            identifiers.ip = id
        elseif string.find(id, "discord") then
            identifiers.discord = id
        elseif string.find(id, "live") then
            identifiers.live = id
        end
    end

    return identifiers
end

local function GetPlayerDetails(src, showIP)
    local cfg = Config.Logs.PlayerDetails
	local ids = ExtractIdentifiers(src)
    local display = {'\n**Player ID:** '..src}

    if cfg.license.enabled then
        if ids.license then
            if cfg.license.hide then
                table.insert(display, '\n**License:** ||'..ids.license..'||')
                table.insert(display, '\n**License2:** ||'..ids.license2..'||')
            else
                table.insert(display, '\n**License:** '..ids.license)
                table.insert(display, '\n**License2:** '..ids.license2)
            end
        end
    end

    if cfg.steam.enabled then
        if ids.steam then
            if cfg.steam.hide then
                table.insert(display, '\n**Steam ID:** ||'..ids.steam..'||')
                table.insert(display, '\n||https://steamcommunity.com/profiles/'..tonumber(ids.steam:gsub("steam:", ""),16)..'||')
            else
                table.insert(display, '\n**Steam ID:** '..ids.steam)
                table.insert(display, '\nhttps://steamcommunity.com/profiles/'..tonumber(ids.steam:gsub("steam:", ""),16))
            end
        end
    end

    if cfg.xbl.enabled then
        if ids.xbl then
            if cfg.xbl.hide then
                table.insert(display, '\n**XBL:** ||'..ids.xbl..'||')
            else
                table.insert(display, '\n**XBL:** '..ids.xbl)
            end
        end
    end

    if cfg.ip.enabled or showIP then
        if ids.ip then
            table.insert(display, '\n**IP:** ||'..ids.ip..'||')
        end
    end

    if cfg.discord.enabled then
        if ids.discord then
            if cfg.discord.hide then
                table.insert(display, '\n**Discord ID:** ||'..ids.discord..'||')
                table.insert(display, '\n*||<@'..ids.discord:gsub("discord:", "")..'>||')
            else
                table.insert(display, '\n**Discord ID:** '..ids.discord)
                table.insert(display, '\n<@'..ids.discord:gsub("discord:", "")..'>')
            end
        end
    end

    if cfg.live.enabled then
        if ids.live then
            if cfg.live.hide then
                table.insert(display, '\n**Live:** ||'..ids.live..'||')
            else
                table.insert(display, '\n**Live:** '..ids.live)
            end
        end
    end

    return table.concat(display,'')
end

local function GetNameOfPlayer(src)
    if Config.Framework then
        if Core.Settings.Framework.Name == 'ESX' then
            local ESX = Core.Settings.Framework.Libary
            local xPlayer = ESX.GetPlayerFromId(src)
            if xPlayer then
                return string.format('%s (%s)', xPlayer.get('firstName')..' '..xPlayer.get('lastName'), GetPlayerName(src))
            end
        elseif Core.Settings.Framework.Name == 'QBCORE' then
            local QBCore = Core.Settings.Framework.Libary
            local ply = QBCore.Functions.GetPlayer(src)
            if ply then
                return string.format('%s (%s)', ply.PlayerData.charinfo.firstname..' '..ply.PlayerData.charinfo.lastname, GetPlayerName(src))
            end
        end
    end

    return string.format('%s', GetPlayerName(src))
end

local function getEmbedColor(color)
    if string.find(color,"#") then _color = tonumber(color:gsub("#",""),16) else _color = color end
    return _color
end

function Core.Logs:CreateLog(name, data)
    if not data.webhook or not data.webhook:find('https://discord.com/api/webhooks/') then
        Core.Utils:Print('err', 'Prøvede at oprette log ^2"'..name..'"^7 uden webhook.')
        return
    end

    Core.Logs.Data[name] = {
        title = data.title or 'New Log',
        webhook = data.webhook,
        color = data.color or '#ffffff'
    }
    Core.Utils:Print('Oprettet log ^2"'..name..'"^7')
end

function Core.Logs:SendLog(name, msg, plys, showIP)
    local logData = Core.Logs.Data[name]
    
    if logData then
        local plyFields = {}
        if type(plys) == 'table' then
            for _,v in pairs(plys) do
                table.insert(plyFields, {
                    name = 'Player Details: '..GetNameOfPlayer(v),
                    value = GetPlayerDetails(v, showIP),
                    inline = Config.Logs.PlyDetailsInline
                })
            end
        elseif plys then
            plyFields = {{
                name = 'Player Details: '..GetNameOfPlayer(plys),
                value = GetPlayerDetails(plys, showIP),
                inline = Config.Logs.PlyDetailsInline
            }}
        end

        PerformHttpRequest(logData.webhook, function(err, text, headers) end, 'POST', json.encode({
            username = Config.Logs.BotUserName, 
            embeds = {{
                ["color"] = getEmbedColor(logData.color),
                ["title"] = logData.title,
                ["description"] = tostring(msg),
                ["footer"] = {
                    ["text"] = Config.Logs.FooterText.." • "..os.date("%x %X %p"),
                    ["icon_url"] = Config.Logs.FooterIcon,
                },
                ["fields"] = plyFields
            }}, 
            avatar_url = Config.Logs.BotAvatar
        }), { 
            ['Content-Type'] = 'application/json' 
        })
    else
        Core.Utils:Print('err', 'Prøver og sende en log, der ikke er oprettet. (^2"'..name..'"^7)')
    end
end

if Config.Logs.LogPlayerIP then
    local JsonFile = LoadResourceFile(GetCurrentResourceName(), 'data/IPLog.json')
    if JsonFile == nil or not JsonFile then JsonFile = {} else JsonFile = json.decode(JsonFile) end

    AddEventHandler('playerJoining', function()
        local src = source
        local identifiers = ExtractIdentifiers(src)

        if JsonFile[identifiers.license] then
            local v = JsonFile[identifiers.license]

            if v.ip ~= identifiers.ip then
                Core.Utils:Print('^6IPLog^7 - '.._('logs:ipLog:newIP', GetPlayerName(src), identifiers.license))
                v.ip = identifiers.ip
            end
            if v.license2 ~= identifiers.license2 then v.license2 = identifiers.license2 end
            if v.steamid ~= identifiers.steam then v.steamid = identifiers.steam end
            if v.discord ~= identifiers.discord then v.discord = identifiers.discord end
        else
            JsonFile[identifiers.license] = {
                ip = identifiers.ip or 'IP not found',
                license2 = identifiers.license2 or '',
                steamid = identifiers.steam or '',
                discord = identifiers.discord or ''
            }
            Core.Utils:Print('^6IPLog^7 - '.._('logs:ipLog:fistJoin', GetPlayerName(src)))
        end

        SaveResourceFile(GetCurrentResourceName(), 'data/IPLog.json', json.encode(JsonFile), -1)
    end)
end


Core.Started.logs = true