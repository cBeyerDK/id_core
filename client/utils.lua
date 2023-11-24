Core = Core or {}
Core.Utils = Core.Utils or {}

function Core.Utils:DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=GetScreenCoordFromWorldCoord(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 0, 0, 0, 120)
end

function Core.Utils:DrawText3D(coords, text, size, font)
    local vector = type(coords) == "vector3" and coords or vec(coords.x, coords.y, coords.z)

    local camCoords = GetFinalRenderedCamCoord()
    local distance = #(vector - camCoords)

    if not size then
        size = 1
    end
    if not font then
        font = 0
    end

    local scale = (size / distance) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    scale = scale * fov

    SetTextScale(0.0 * scale, 0.55 * scale)
    SetTextFont(font)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    BeginTextCommandDisplayText('STRING')
    SetTextCentre(true)
    AddTextComponentSubstringPlayerName(text)
    SetDrawOrigin(vector.xyz, 0)
    EndTextCommandDisplayText(0.0, 0.0)
    ClearDrawOrigin()
end

function Core.Utils:ShowNotification(msg, flash, saveToBrief, hudColorIndex)
	if saveToBrief == nil then saveToBrief = true end
	AddTextEntry('esxNotification', msg)
	BeginTextCommandThefeedPost('esxNotification')
	if hudColorIndex then ThefeedNextPostBackgroundColor(hudColorIndex) end
	EndTextCommandThefeedPostTicker(flash or false, saveToBrief)
end

function Core.Utils:RandomChange(percent)
    if percent < 0 then percent = 0 elseif percent > 100 then percent = 100 end
    return percent >= math.random(1, 100)
end	

--[[
    Timeout function from ESX
    Thx for the code :)
]]
Core.TimeoutCallbacks = {}

function Core.Utils:SetTimeout(msec, cb)
	table.insert(Core.TimeoutCallbacks, {
		time = GetGameTimer() + msec,
		cb   = cb
	})
	return #Core.TimeoutCallbacks
end

function Core.Utils:ClearTimeout(i)
	Core.TimeoutCallbacks[i] = nil
end

--[[
    Server callback system from ESX
    Thx for the code :)
]]
Core.CurrentRequestId = 0
Core.ServerCallbacks = {}

function Core.Utils:TriggerServerCallback(name, cb, ...)
	Core.ServerCallbacks[Core.CurrentRequestId] = cb

	TriggerServerEvent('id_core:triggerServerCallback', name, Core.CurrentRequestId, ...)

	if Core.CurrentRequestId < 65535 then
		Core.CurrentRequestId = Core.CurrentRequestId + 1
	else
		Core.CurrentRequestId = 0
	end
end