local QBCore = exports['qb-core']:GetCoreObject()
local registerDone = false
local glassState = {}

local function hasCrowbar()
    local c = exports.ox_inventory:Search('count', 'weapon_crowbar')
    if type(c) == 'table' then c = c.count or 0 end
    return c > 0 or GetSelectedPedWeapon(PlayerPedId()) == `WEAPON_CROWBAR`
end

RegisterNetEvent('takenncs-weaponshoprob:notify', function(type, msg)
    lib.notify({ type = type, description = msg })
end)

CreateThread(function()
    exports.ox_target:addSphereZone({
        name = 'takenncs-weaponshoprob_register',
        coords = vec3(Config.Register.x, Config.Register.y, Config.Register.z),
        radius = 1.5,
        options = {
            {
                label = 'Lõhu kassa',
                icon = 'fa-solid fa-cash-register',
                onSelect = function(data)
                    if not hasCrowbar() then
                        QBCore.Functions.Notify('Sul on midagi puudu!', 'error')
                        return
                    end
                    exports.ox_target:removeZone('takenncs-weaponshoprob_register')
                    local playerPed = PlayerPedId()
                    RequestAnimDict("missheist_jewel")
                    while not HasAnimDictLoaded("missheist_jewel") do
                        Wait(10)
                    end

                    TaskPlayAnim(playerPed, "missheist_jewel", "smash_case", 8.0, -8.0, -1, 1, 0, false, false, false)
                    if lib.progressBar({ duration = Config.RegisterTime, label = 'Lõhud kassat...' }) then
                        ClearPedTasks(playerPed)
                        TriggerServerEvent('takenncs-weaponshoprob:tryRegister')
                    else
                        ClearPedTasks(playerPed)
                        QBCore.Functions.Notify('Sa ei saanud kassa lõhkumisega hakkama!', 'error')
                    end
                end
            }
        }
    })
end)

RegisterNetEvent('takenncs-weaponshoprob:registerDone', function()
    if registerDone then return end
    registerDone = true

    for i, v in ipairs(Config.GlassCases) do
        glassState[i] = false

        exports.ox_target:addSphereZone({
            name = 'takenncs-weaponshoprob_glass_' .. i,
            coords = v.xyz,
            radius = 1.0,
            options = {
                {
                    label = 'Võta esemed',
                    icon = 'fa-solid fa-hand',
                    canInteract = function() return glassState[i] == false end,
                    onSelect = function(data)
                        exports.ox_target:removeZone(data.zone)
                        TaskStartScenarioInPlace(PlayerPedId(), 'PROP_HUMAN_BUM_BIN', 0, true)
                        if lib.progressBar({ duration = 4000, label = 'Võtad esemeid...' }) then
                            ClearPedTasks(PlayerPedId())
                            glassState[i] = true
                            TriggerServerEvent('takenncs-weaponshoprob:glassLoot', i)
                        else
                            ClearPedTasks(PlayerPedId())
                            lib.notify({ type = 'error', description = 'Katkestasid klaasi võtmisprotsessi' })
                        end
                    end
                }
            }
        })
    end

    for i, v in ipairs(Config.AmmoSearch) do
    local zoneName = 'takenncs-weaponshoprob_ammo_' .. i
    local used = false 

    exports.ox_target:addSphereZone({
        name = zoneName,
        coords = v,
        radius = 1.0,
        options = {
            {
                label = 'Otsi',
                icon = 'fa-solid fa-magnifying-glass',
                canInteract = function() return not used end,
                onSelect = function(data)
                    if used then return end
                    used = true
                    exports.ox_target:removeZone(data.zone)

                    TaskStartScenarioInPlace(PlayerPedId(), 'PROP_HUMAN_BUM_BIN', 0, true)
                    if lib.progressBar({ duration = 3500, label = 'Otsid...' }) then
                        ClearPedTasks(PlayerPedId())
                        TriggerServerEvent('takenncs-weaponshoprob:searchAmmo', i)
                    else
                        ClearPedTasks(PlayerPedId())
                        QBCore.Functions.Notify('Sa ei saanud otsimisega hakkama!', 'error')
                    end
                end
            }
        }
    })
end

for i, v in ipairs(Config.ArmorSearch) do
    local zoneName = 'takenncs-weaponshoprob_armor_' .. i
    local used = false

    exports.ox_target:addSphereZone({
        name = zoneName,
        coords = v,
        radius = 1.0,
        options = {
            {
                label = 'Otsi',
                icon = 'fa-solid fa-shield',
                canInteract = function() return not used end,
                onSelect = function(data)
                    if used then return end
                    used = true
                    exports.ox_target:removeZone(data.zone)

                    TaskStartScenarioInPlace(PlayerPedId(), 'PROP_HUMAN_BUM_BIN', 0, true)
                    if lib.progressBar({ duration = 3500, label = 'Otsid...' }) then
                        ClearPedTasks(PlayerPedId())
                        TriggerServerEvent('takenncs-weaponshoprob:searchArmor', i)
                    else
                        ClearPedTasks(PlayerPedId())
                        QBCore.Functions.Notify('Sa ei saanud otsimisega hakkama!', 'error')
                    end
                end
            }
        }
    })
  end
end)

RegisterNetEvent('takenncs-weaponshoprob:reset', function()
    registerDone = false
    glassState = {}
end)

