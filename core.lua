local addonName, addon = ...
local BetterBags = LibStub("AceAddon-3.0"):GetAddon("BetterBags")
local categories = BetterBags:GetModule('Categories')
local L = BetterBags:GetModule('Localization')

local RaidMapIds = {2460}

local function GetInstanceID(mapId)
    return EJ_GetInstanceForMap(mapId)
end

local function GetLootForBoss(encounterID)
    EJ_SelectEncounter(encounterID)

    local items, i = {}, 1
    while true do
        local itemID = C_EncounterJournal.GetLootInfoByIndex(i)
        if not itemID then break end
        table.insert(items, itemID)
        i = i + 1
    end

    return items
end

local function GetBosses(instanceID)
    local bosses, i = {}, 1
    EJ_SelectInstance(instanceID)
    while true do
        local name, _, encounterID = EJ_GetEncounterInfoByIndex(i, instanceID)
        if not name then break end

        local loot = GetLootForBoss(encounterID)

        table.insert(bosses, {
            name = name,
            id = encounterID,
            loot = loot, 
        })
        i = i + 1
    end
    return bosses
end

local function BuildCategory(instanceID)

    local instanceName = EJ_GetInstanceInfo(instanceID)
    local bosses = GetBosses(instanceID)

    if #bosses == 0 then
        return
    end

    for i, b in ipairs(bosses) do
        for _, itemID in ipairs(b.loot) do
            categories:AddItemToCategory(itemID.itemID, L:G("Manaforge Loot"))
        end
    end
end

for _, mapid in pairs(RaidMapIds) do
    BuildCategory(GetInstanceID(mapid))
end
