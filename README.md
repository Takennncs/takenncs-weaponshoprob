# takenncs-weaponshoprob

A QBCore-based weapon shop robbery script for FiveM.  
Players can smash registers, loot display cases, search for ammo, and find armor.  
Supports `ox_inventory`, `ox_target`, `qb-core`.

---

## Features

- **Register Robbery**
  - Requires a crowbar in inventory or in hand.
  - Uses realistic smash animation (`missheist_jewel -> smash_case`).
  - Gives cash reward and sends a dispatch alert to police.

- **Glass Case Looting**
  - Take items from display cases.
  - Each glass can only be looted **once per reset**.

- **Ammo Searching**
  - Each search location can only be used **once**.
  - Chance-based loot (`Config.AmmoChance`) for finding ammo.

- **Armor Searching**
  - Can only find armor **once per location**.

- **Automatic Reset**
  - All robbery targets reset after `Config.ResetTime` minutes.

- **QBCore Notifications**
  - Success, error, and info messages use `QBCore.Functions.Notify`.

---

## Requirements

- [QBCore Framework](https://github.com/qbcore-framework/qb-core)  
- [ox_inventory](https://github.com/overextended/ox_inventory)  
- [ox_target](https://github.com/overextended/ox_target)  
---

## Configuration (`config.lua`)

```lua
Config.MinCops      = 0                           -- Minimum police required to rob
Config.ResetTime    = 30                          -- Minutes until all robbery targets reset
Config.CashReward   = 200                         -- Cash given for robbing register
Config.Register     = vector4(18.7908, -1109.0399, 29.7970, 78.2627)  -- Register coordinates
Config.RegisterTime = 6000                        -- Time in ms for smashing the register

Config.GlassCases   = {                            -- List of Vector4 positions for display cases
    vector4(20.4934, -1106.1467, 29.7970, 9.0669),
    vector4(21.8028, -1106.6631, 29.7970, 316.2802),
    vector4(22.6206, -1109.7898, 29.7970, 291.0815)
}

Config.GlassLoot    = {                            -- Items available in display cases
    'weapon_knuckle',
    'weapon_switchblade',
    'weapon_bat'
}

Config.AmmoSearch   = {                            -- Vector3 positions for ammo searches
    vec3(4.2042, -1105.5928, 29.7970),
    vec3(4.3178, -1109.3694, 29.7970),
    vec3(6.7724, -1110.3307, 29.7970)
}

Config.ArmorSearch  = {                            -- Vector3 positions for armor searches
    vec3(17.0846, -1109.3737, 29.7970)
}

Config.AmmoChance   = 10                           -- Chance (0-100) to find ammo
Config.AmmoMin      = 10                           -- Minimum ammo given
Config.AmmoMax      = 15                           -- Maximum ammo given
