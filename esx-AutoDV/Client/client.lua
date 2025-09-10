-- Auto DV - ESX + ox_lib notify (client)
-- Port & edit by sweet21 (for ESX + ox_lib)

-- =========================
-- Config rápido (podés tocar estos valores)
-- =========================
local DELETE_NEAR_PLAYER_RADIUS = 0.0   -- no borrar autos si hay un jugador a menos de 8m
local SKIP_VEHICLES_WITH_DRIVER = true  -- no borrar vehículos con conductor (player o NPC)
local USE_AGGRESSIVE_DELETE = true -- Si querés volver al método original ClearAreaOfVehicles, poné esto en false

-- =========================
-- Notificación con ox_lib
-- =========================
RegisterNetEvent('autodv:notify', function(title, message, ntype, duration)
    if lib and lib.notify then
        lib.notify({
            title = title or 'Grua',
            description = message or '',
            type = ntype or 'inform',         -- 'success' | 'error' | 'warning' | 'inform'
            position = 'right-center',
            duration = duration or 3000
        })
    else
        print(('[Pasa Grua] %s'):format(message or ''))
    end
end)

-- =========================
-- Helpers
-- =========================
local function hasNearbyPlayer(veh, radius)
    local vehPos = GetEntityCoords(veh)
    for _, pid in ipairs(GetActivePlayers()) do
        local ped = GetPlayerPed(pid)
        if #(GetEntityCoords(ped) - vehPos) < (radius or 8.0) then
            return true
        end
    end
    return false
end

-- Si tu framework marca autos "propios" o protegidos con statebags/decors, filtralos acá.
-- De fábrica devuelve false para no saltarse nada.
local function isProtectedVehicle(veh)
    -- Ejemplos (descomentá/ajustá a tu servidor):
    -- local ent = Entity(veh)
    -- if ent and ent.state and (ent.state.playerOwned or ent.state.protected or ent.state.garageStored) then
    --     return true
    -- end
    -- if DecorExistOn(veh, 'vehOwner') then return true end
    return false
end

local function tryDeleteVehicle(veh)
    if not DoesEntityExist(veh) then return end

    if SKIP_VEHICLES_WITH_DRIVER and not IsVehicleSeatFree(veh, -1) then
        return
    end

    if hasNearbyPlayer(veh, DELETE_NEAR_PLAYER_RADIUS) then
        return
    end

    if isProtectedVehicle(veh) then
        return
    end

    -- Pedir control de red (si es networked)
    local attempts = 0
    if NetworkGetEntityIsNetworked(veh) then
        NetworkRequestControlOfEntity(veh)
        while not NetworkHasControlOfEntity(veh) and attempts < 10 do
            Wait(50)
            NetworkRequestControlOfEntity(veh)
            attempts = attempts + 1
        end
    end

    SetEntityAsMissionEntity(veh, true, true)
    DeleteVehicle(veh)
    if DoesEntityExist(veh) then
        DeleteEntity(veh)
    end
end

-- =========================
-- Limpieza global de vehículos
-- =========================
RegisterNetEvent('autodv:clearVehicles', function()
    if USE_AGGRESSIVE_DELETE then
        local pool = GetGamePool('CVehicle') -- más rápido que iteradores manuales
        for i = 1, #pool do
            tryDeleteVehicle(pool[i])
        end
    else
        -- Método original: rápido pero menos efectivo con autos "mission/owned"
        ClearAreaOfVehicles(0.0, 0.0, 0.0, 500000.0, false, false, false, false, false)
    end
end)

-- Compatibilidad con el evento original (si algún recurso viejo lo dispara)
RegisterNetEvent('clearallvehicles', function()
    TriggerEvent('autodv:clearVehicles')
end)

-- =========================
-- Hilo para "liberar" vehículos vacíos del jugador (comportamiento original)
-- =========================
CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local veh = GetVehiclePedIsIn(ped, true)

        if DoesEntityExist(veh) then
            if IsVehicleSeatFree(veh, -1) and IsVehicleSeatFree(veh, -2)
            and IsVehicleSeatFree(veh, -3) and IsVehicleSeatFree(veh, -4) then
                SetEntityAsNoLongerNeeded(veh)
            end
        end

        Wait(3000)
    end
end)
