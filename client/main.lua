Core = Core or {}
Core.Settings = {}

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
            AddEventHandler('esx:setPlayerData', function(key, val, last)
                if GetInvokingResource() == 'es_extended' then
                    _LIB.PlayerData[key] = val
                    if OnPlayerData ~= nil then OnPlayerData(key, val, last) end
                end
            end)
        elseif _VER == 1.1 or _VER == 1.2 then
            CreateThread(function()
                while _LIB == nil do
                    TriggerEvent('esx:getSharedObject', function(obj) _LIB = obj end)
                    Wait(0)
                end
            
                while _LIB.GetPlayerData().job == nil do
                    Wait(10)
                end
            
                _LIB.PlayerData = _LIB.GetPlayerData()
            end)
            RegisterNetEvent('esx:setJob', function(job)
                _LIB.PlayerData.job = job
            end)
        end
    elseif GetResourceState('qb-core') ~= 'missing' then
        _FRAMEWORK = 'QBCORE'
        _VER = GetResourceMetadata('qb-core', 'version'):sub(1,3)
        _VER = tonumber(_VER)

        if _VER == 1.1 then
            _LIB = exports['qb-core']:GetCoreObject()
        end
    end

    Core.Settings.Framework.Name = _FRAMEWORK
    Core.Settings.Framework.Version = _VER
    Core.Settings.Framework.Libary = _LIB
end

CreateThread(function()
    while true do
        Wait(0)
		if NetworkIsPlayerActive(PlayerId()) then
			Wait(500)
			TriggerServerEvent('id_core:onPlayerJoined')
			break
		end
    end
end)

-- SetTimeout
CreateThread(function()
	while true do
		local sleep = 100
		if #Core.TimeoutCallbacks > 0 then
			local currTime = GetGameTimer()
			sleep = 0
			for i=1, #Core.TimeoutCallbacks, 1 do
				if currTime >= Core.TimeoutCallbacks[i].time then
					Core.TimeoutCallbacks[i].cb()
					Core.TimeoutCallbacks[i] = nil
				end
			end
		end
		Wait(sleep)
	end
end)

exports('GetCoreObject', function()
	return Core, Core.Settings.Framework
end)