Config = {}

--===================
--==    General    ==
--===================
-- Den sprog fil alle resources fra Identity Store vil bruge
Config.Language = 'da'

--[[
    Den type identifier alle resources fra Identity Store vil bruge
    Identifiers kan være:
        license
        steam
        xbl
        ip
        discord
        live
    
    OBS: Bruger du ESX, skal den være på `license` - da ESX bruger license som identifier.
]]
Config.Identifier = 'license'

--[[
    Hvis du bruger et af vores understøttede framework. skal den stå på `true`.
    Kører du standalone eller bruger et ikke understøttet framework, skal den stå på `false`
    Framework vi understøtter:
        ESX (Legacy, v1.1 & v1.2)
        QBCore (v1.1)
]]
Config.Framework = true

--================
--==    Logs    ==
--================
Config.Logs = {}

-- Navnet på botten
Config.Logs.BotUserName = 'ID-Store - Server Logs'

-- Bottens avatar
Config.Logs.BotAvatar = 'https://i.imgur.com/7QgYKCh.png'

-- Teksten der står i bunden af loggen
Config.Logs.FooterText = '© 2022-2030 ID-Store Logs'

-- Billede der vil være i bunden af loggen
Config.Logs.FooterIcon = 'https://i.imgur.com/7QgYKCh.png'

-- Om spiller detaljerne skal være ved siden af hinanden
Config.Logs.PlyDetailsInline = true

-- Log en hver spillers IP når de joiner serveren.
-- OBS: Slåes dette til skal det informeres tydeligt til jeres spillere at i logger deres IP, ellers er det ulovligt!
Config.Logs.LogPlayerIP = false

--[[
    De typer af identifiers der skal vises i logsne.
    [enabled]: Skal identifieren vises
    [hide]: Skal identifieren skjules med spoiler
]]
Config.Logs.PlayerDetails = {
    ['license'] = {
        enabled = true,
        hide = false,
    },
    ['steam'] = {
        enabled = true,
        hide = false
    },  
    ['xbl'] = {
        enabled = false,
        hide = false
    },
    ['ip'] = {
        enabled = false
    },
    ['discord'] = {
        enabled = true,
        hide = false
    },
    ['live'] = {
        enabled = false,
        hide = false
    }
}