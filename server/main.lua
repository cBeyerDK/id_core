Core = Core or {}
Core.Settings = {}
Core.Players = {}

-- Setting up Core
Core.Settings.Framework = {
    Name = 'Unknown',
    Version = 0.0,
    Libary = nil
}
Core.Settings.Language = Config.Language

if Config.Framework then
    local _FRAMEWORK, _VER, _LIB = nil, nil, nil

    if GetResourceState('es_extended') ~= 'missing' then
        _FRAMEWORK = 'ESX'
        _VER = GetResourceMetadata('es_extended', 'version'):sub(1,3)
        _VER = tonumber(_VER)
        
        if _VER >= 1.6 then
            _LIB = exports['es_extended']:getSharedObject()
        elseif _VER == 1.1 or _VER == 1.2 then
            while not _LIB do
                TriggerEvent('esx:getSharedObject', function(obj) _LIB = obj end)
            end
        end
    elseif GetResourceState('qb-core') ~= 'missing' then
        _FRAMEWORK = 'QBCORE'
        _VER = GetResourceMetadata('qb-core', 'version'):sub(1,3)
        _VER = tonumber(_VER)

        if _VER == 1.1 then
            _LIB = exports['qb-core']:GetCoreObject()
        end
    end

    if not _FRAMEWORK then
        Core.Utils:Print('warn', 'Du har angivet at serveren kører med ^1"ESX"^7 eller ^1"QBCORE"^7. Men din server har ingen af delene!')
        Core.Utils:Print('^2Stopping resource')
        StopResource(GetCurrentResourceName())
        return
    end

    if not _LIB then
        Core.Utils:Print('warn', ('Vi understøtter desværre ikke version ^1"%s"^7 af ^1"%s"^7. Mener du dette er en fejl, så opret en ticket på vores discord!'):format(_VER, _FRAMEWORK))
        Core.Utils:Print('^2Stopping resource')
        StopResource(GetCurrentResourceName())
        return
    end

    Core.Settings.Framework.Name = _FRAMEWORK
    Core.Settings.Framework.Version = _VER
    Core.Settings.Framework.Libary = _LIB
end

function Core:Ready(cb)
    CreateThread(function()
        repeat
            Wait(50)
        until GetResourceState('oxmysql') == 'started' and GetResourceState('id_core') == 'started'
    
        cb()
    end)
end

function Core:LoadPlayer(src)
    local identifier = Core.Utils:GetIdentifier(src)

    if not identifier then
        DropPlayer(src, _U('main:noIdentifier'))
        return
    end

    if self:GetPlayerFromIdentifier(identifier) then
        DropPlayer(src, _U('main:identifierAlreadyInUse'))
        return
    end

    self.Players[src] = {
        identifier = identifier,
        src = src
    }
    TriggerEvent('id_core:playerLoaded', src, self.Players[src])
    TriggerClientEvent('id_core:playerLoaded', src, self.Players[src])
end

function Core:GetPlayerFromSource(src)
    for k,v in pairs(self.Players) do
        if v.src == src then
            return v
        end
    end

    return nil
end

function Core:GetPlayerFromIdentifier(identifier)
    for k,v in pairs(self.Players) do
        if v.identifier == identifier then
            return v
        end
    end

    return nil
end

exports('GetCoreObject', function()
    return Core, Core.Settings.Framework
end)

function CoreStarted()
    local label =
[[
  ||
  ||        _____    _            _   _ _            _____ _                 
  ||       |_   _|  | |          | | (_) |          / ____| |                
  ||         | |  __| | ___ _ __ | |_ _| |_ _   _  | (___ | |_ ___  _ __ ___ 
  ||         | | / _` |/ _ \ '_ \| __| | __| | | |  \___ \| __/ _ \| '__/ _ \
  ||        _| || (_| |  __/ | | | |_| | |_| |_| |  ____) | || (_) | | |  __/
  ||       |_____\__,_|\___|_| |_|\__|_|\__|\__, | |_____/ \__\___/|_|  \___|
  ||                                         __/ |                           
  ||                                        |___/                                                 
  ||
  ||                     Copyright(c) 2022 All Rights Reserved
  ||]]

  print(label)
end

Core.Started.main = true

CreateThread(function()
    while not Core.Started.READY do
        local num = 0
        for k,v in pairs(Core.Started) do
            if v then num = num + 1 end
        end

        if num == 5 then
            CoreStarted()
            Core.Started.READY = true
        end
        Wait(10)
    end
end)