local QBCore = exports['qb-core']:GetCoreObject()

local State = {
    register = false,
    glass = {},
    ammo = {},
    armor = {}
}

local function GetCops()
    local cops = 0
    for _, id in pairs(QBCore.Functions.GetPlayers()) do
        local p = QBCore.Functions.GetPlayer(id)
        if p and p.PlayerData.job.name == 'police' then
            cops += 1
        end
    end
    return cops
end

RegisterNetEvent('takenncs-weaponshoprob:tryRegister', function()
    local src = source
    if State.register then return end
    if GetCops() < Config.MinCops then
        QBCore.Functions.Notify(src, 'Tundub et hetkel on liiga vaikne!', 'error')
        return
    end

    State.register = true
    exports.ox_inventory:AddItem(src, 'cash', Config.CashReward)

    exports['kk-dispatch']:sendMessage(
        src, 'Kahtlane tegevus', 'Relvapood',
        { 'police' },
        { { 'fa-solid fa-gun', 'Relvapoe rööv' } },
        'bg-red-900', true, false
    )

    QBCore.Functions.Notify(src, 'Kassa lõhutud! Said sularaha.', 'success')
    TriggerClientEvent('takenncs-weaponshoprob:registerDone', src)
end)

RegisterNetEvent('takenncs-weaponshoprob:glassLoot', function(id)
    if State.glass[id] then
        QBCore.Functions.Notify(source, 'Siit on juba otsitud!', 'error')
        return
    end
    State.glass[id] = true
    exports.ox_inventory:AddItem(source, Config.GlassLoot[math.random(#Config.GlassLoot)], 1)
    QBCore.Functions.Notify(source, 'Leidsid midagi vitriinist!', 'success')
end)

RegisterNetEvent('takenncs-weaponshoprob:searchAmmo', function(id)
    if State.ammo[id] then
        QBCore.Functions.Notify(source, 'Tundub et siit on juba otsitud!', 'error')
        return
    end
    State.ammo[id] = true

    local chance = math.random(100)
    if chance <= Config.AmmoChance then
        local amount = math.random(Config.AmmoMin, Config.AmmoMax)
        exports.ox_inventory:AddItem(source, 'pistol_ammo', amount)
    else
        QBCore.Functions.Notify(source, 'Ei leidnud midagi', 'error')
    end
end)

RegisterNetEvent('takenncs-weaponshoprob:searchArmor', function(id)
    if State.armor[id] then
        QBCore.Functions.Notify(source, 'Tundub et siit on juba otsitud!', 'error')
        return
    end
    State.armor[id] = true
    exports.ox_inventory:AddItem(source, 'armor', 1)
    QBCore.Functions.Notify(source, 'Leidsid midagi', 'success')
end)

CreateThread(function()
    while true do
        Wait(Config.ResetTime * 60000)
        State = { register = false, glass = {}, ammo = {}, armor = {} }
        TriggerClientEvent('takenncs-weaponshoprob:reset', -1)
    end
end)
