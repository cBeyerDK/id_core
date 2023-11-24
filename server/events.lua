RegisterNetEvent('id_core:onPlayerJoined', function()
    local src = source

    if not Core.Players[src] then
        Core:LoadPlayer(src)
    end
end)

AddEventHandler('playerDropped', function(reason)
    local src = source
    local player = Core:GetPlayerFromSource(src)

    if player then
        TriggerEvent('id_core:playerDropped', src, player, reason)

        Core.Players[src] = nil
    end
end)

RegisterServerEvent('id_core:triggerServerCallback', function(name, requestId, ...)
	local playerId = source

	Core.Utils:TriggerServerCallback(name, requestId, playerId, function(...)
		TriggerClientEvent('id_core:serverCallback', playerId, requestId, ...)
	end, ...)
end)

RegisterServerEvent('id_core:logs:sendLog', function(...) Core.Logs:SendLog(...) end)

Core.Started.events = true