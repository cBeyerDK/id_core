Core = Core or {}
Core.Utils = Core.Utils or {}
Core.Started = {
    utils = false,
    events = false,
    anticheat = false,
	logs = false,
    main = false,
    READY = false
}

function Core.Utils:GetIdentifier(src)
    for k,v in ipairs(GetPlayerIdentifiers(src)) do
        local prefix = Config.Identifier

		if string.match(v, prefix..':') then
			local identifier = string.gsub(v, prefix..':', '')
			return identifier
		end
	end
end

--[[
    Timeout function from ESX
    Thx for the code :)
]]
Core.TimeoutCount = -1
Core.CancelledTimeouts = {}

function Core.Utils:SetTimeout(msec, cb)
	local id = Core.TimeoutCount + 1

	SetTimeout(msec, function()
		if Core.CancelledTimeouts[id] then
			Core.CancelledTimeouts[id] = nil
		else
			cb()
		end
	end)

	Core.TimeoutCount = id

	return id
end

function Core.Utils:ClearTimeout(id)
	Core.CancelledTimeouts[id] = true
end

--[[
    Server callback system from ESX
    Thx for the code :)
]]
Core.ServerCallbacks = {}

function Core.Utils:RegisterServerCallback(name, cb)
	Core.ServerCallbacks[name] = cb
end

function Core.Utils:TriggerServerCallback(name, requestId, source, cb, ...)
	if Core.ServerCallbacks[name] then
		Core.ServerCallbacks[name](source, cb, ...)
	else
		print(('[^3WARNING^7] Server callback ^5"%s"^0 does not exist. ^1Please Check The Server File for Errors!^7'):format(name))
	end
end

Core.Started.utils = true