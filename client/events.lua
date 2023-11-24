RegisterNetEvent('id_core:playerLoaded', function(data)
    Core.PlayerData = data
end)

RegisterNetEvent('id_core:serverCallback')
AddEventHandler('id_core:serverCallback', function(requestId, ...)
	Core.ServerCallbacks[requestId](...)
	Core.ServerCallbacks[requestId] = nil
end)

RegisterNetEvent('id_core::Utils:ShowNotification', function(...)
    Core.Utils:ShowNotification(...)
end)