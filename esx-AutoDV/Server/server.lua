-- Auto DV - ESX + ox_lib notify (server)

local ESX

CreateThread(function()
    if GetResourceState('es_extended') == 'started' then
        if exports and exports['es_extended'] and exports['es_extended'].getSharedObject then
            ESX = exports['es_extended']:getSharedObject()
        else
            -- compat legacy
            TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        end
    end
end)

local function notifyAll(title, message, ntype, duration)
    -- Enviamos a todos un evento para que el cliente use ox_lib (lib.notify)
    TriggerClientEvent('autodv:notify', -1, title or 'Auto DV', message or '', ntype or 'inform', duration or 3000)
end

local function countdownAlert(minutes)
    for i = minutes, 1, -1 do
        local msg = ('🚗 Se limpiarán TODOS los vehículos en %d minuto%s...'):format(i, i > 1 and 's' or '')
        notifyAll('Pasa Grua', msg, 'warning', 3000)
        Citizen.Wait(60000)
    end
end

local function clearAllVehicles()
    local hora = os.date('%H:%M:%S')
    notifyAll('Auto DV', ('¡Todos los vehículos fueron eliminados a las %s!'):format(hora), 'success', 4000)
    -- Evento nuevo + compat con el evento original
    TriggerClientEvent('autodv:clearVehicles', -1)
    TriggerClientEvent('clearallvehicles', -1)
end

-- Autolimpieza cada 45 min (2700000 ms)
CreateThread(function()
    while true do
        Citizen.Wait(2700000)
        countdownAlert(5)
        clearAllVehicles()
    end
end)

-- Comando manual
RegisterCommand('autodv', function(src)
    -- OPCIONAL: limitá permisos con grupos ESX descomentando el bloque siguiente

    if src ~= 0 and ESX and ESX.GetPlayerFromId then
        local xPlayer = ESX.GetPlayerFromId(src)
        if not xPlayer or (xPlayer.getGroup() ~= 'admin' and xPlayer.getGroup() ~= 'mod') then
            TriggerClientEvent('autodv:notify', src, 'Auto DV', 'No tenés permisos para usar /autodv.', 'error', 3000)
            return
        end
    end

    countdownAlert(5)
    clearAllVehicles()
end, false)
