--
-- Dispeller addon for World of Warcraft
-- Main developer: LumielGR
--

local version = GetAddOnMetadata("Dispeller", "Version")
DispellerFrame = nil

local combatLogEventTableInverse = {
    "SWING_DAMAGE", "SWING_MISSED", "SWING_HEAL", "SWING_ENERGIZE", "SWING_DRAIN", "SWING_LEECH", "SWING_INTERRUPT", "SWING_DISPEL", "SWING_DISPEL_FAILED", "SWING_STOLEN", "SWING_EXTRA_ATTACKS", "SWING_AURA_APPLIED", "SWING_AURA_REMOVED", "SWING_AURA_APPLIED_DOSE", "SWING_AURA_REMOVED_DOSE", "SWING_AURA_REFRESH", "SWING_AURA_BROKEN", "SWING_AURA_BROKEN_SPELL", "SWING_CAST_START", "SWING_CAST_SUCCESS", "SWING_CAST_FAILED", "SWING_INSTAKILL", "SWING_DURABILITY_DAMAGE", "SWING_DURABILITY_DAMAGE_ALL", "SWING_CREATE", "SWING_SUMMON", "SWING_RESURRECT",
    "RANGE_DAMAGE", "RANGE_MISSED", "RANGE_HEAL", "RANGE_ENERGIZE", "RANGE_DRAIN", "RANGE_LEECH", "RANGE_INTERRUPT", "RANGE_DISPEL", "RANGE_DISPEL_FAILED", "RANGE_STOLEN", "RANGE_EXTRA_ATTACKS", "RANGE_AURA_APPLIED", "RANGE_AURA_REMOVED", "RANGE_AURA_APPLIED_DOSE", "RANGE_AURA_REMOVED_DOSE", "RANGE_AURA_REFRESH", "RANGE_AURA_BROKEN", "RANGE_AURA_BROKEN_SPELL", "RANGE_CAST_START", "RANGE_CAST_SUCCESS", "RANGE_CAST_FAILED", "RANGE_INSTAKILL", "RANGE_DURABILITY_DAMAGE", "RANGE_DURABILITY_DAMAGE_ALL", "RANGE_CREATE", "RANGE_SUMMON", "RANGE_RESURRECT",
    "SPELL_DAMAGE", "SPELL_MISSED", "SPELL_HEAL", "SPELL_ENERGIZE", "SPELL_DRAIN", "SPELL_LEECH", "SPELL_INTERRUPT", "SPELL_DISPEL", "SPELL_DISPEL_FAILED", "SPELL_STOLEN", "SPELL_EXTRA_ATTACKS", "SPELL_AURA_APPLIED", "SPELL_AURA_REMOVED", "SPELL_AURA_APPLIED_DOSE", "SPELL_AURA_REMOVED_DOSE", "SPELL_AURA_REFRESH", "SPELL_AURA_BROKEN", "SPELL_AURA_BROKEN_SPELL", "SPELL_CAST_START", "SPELL_CAST_SUCCESS", "SPELL_CAST_FAILED", "SPELL_INSTAKILL", "SPELL_DURABILITY_DAMAGE", "SPELL_DURABILITY_DAMAGE_ALL", "SPELL_CREATE", "SPELL_SUMMON", "SPELL_RESURRECT", "SPELL_PERIODIC_DAMAGE", "SPELL_PERIODIC_MISSED", "SPELL_PERIODIC_HEAL", "SPELL_PERIODIC_ENERGIZE", "SPELL_PERIODIC_DRAIN", "SPELL_PERIODIC_LEECH", "SPELL_PERIODIC_INTERRUPT", "SPELL_PERIODIC_DISPEL", "SPELL_PERIODIC_DISPEL_FAILED", "SPELL_PERIODIC_STOLEN", "SPELL_PERIODIC_EXTRA_ATTACKS", "SPELL_PERIODIC_AURA_APPLIED", "SPELL_PERIODIC_AURA_REMOVED", "SPELL_PERIODIC_AURA_APPLIED_DOSE", "SPELL_PERIODIC_AURA_REMOVED_DOSE", "SPELL_PERIODIC_AURA_REFRESH", "SPELL_PERIODIC_AURA_BROKEN", "SPELL_PERIODIC_AURA_BROKEN_SPELL", "SPELL_PERIODIC_CAST_START", "SPELL_PERIODIC_CAST_SUCCESS", "SPELL_PERIODIC_CAST_FAILED", "SPELL_PERIODIC_INSTAKILL", "SPELL_PERIODIC_DURABILITY_DAMAGE", "SPELL_PERIODIC_DURABILITY_DAMAGE_ALL", "SPELL_PERIODIC_CREATE", "SPELL_PERIODIC_SUMMON", "SPELL_PERIODIC_RESURRECT", "SPELL_BUILDING_DAMAGE", "SPELL_BUILDING_MISSED", "SPELL_BUILDING_HEAL", "SPELL_BUILDING_ENERGIZE", "SPELL_BUILDING_DRAIN", "SPELL_BUILDING_LEECH", "SPELL_BUILDING_INTERRUPT", "SPELL_BUILDING_DISPEL", "SPELL_BUILDING_DISPEL_FAILED", "SPELL_BUILDING_STOLEN", "SPELL_BUILDING_EXTRA_ATTACKS", "SPELL_BUILDING_AURA_APPLIED", "SPELL_BUILDING_AURA_REMOVED", "SPELL_BUILDING_AURA_APPLIED_DOSE", "SPELL_BUILDING_AURA_REMOVED_DOSE", "SPELL_BUILDING_AURA_REFRESH", "SPELL_BUILDING_AURA_BROKEN", "SPELL_BUILDING_AURA_BROKEN_SPELL", "SPELL_BUILDING_CAST_START", "SPELL_BUILDING_CAST_SUCCESS", "SPELL_BUILDING_CAST_FAILED", "SPELL_BUILDING_INSTAKILL", "SPELL_BUILDING_DURABILITY_DAMAGE", "SPELL_BUILDING_DURABILITY_DAMAGE_ALL", "SPELL_BUILDING_CREATE", "SPELL_BUILDING_SUMMON", "SPELL_BUILDING_RESURRECT",
    "ENVIRONMENTAL_DAMAGE", "ENVIRONMENTAL_MISSED", "ENVIRONMENTAL_HEAL", "ENVIRONMENTAL_ENERGIZE", "ENVIRONMENTAL_DRAIN", "ENVIRONMENTAL_LEECH", "ENVIRONMENTAL_INTERRUPT", "ENVIRONMENTAL_DISPEL", "ENVIRONMENTAL_DISPEL_FAILED", "ENVIRONMENTAL_STOLEN", "ENVIRONMENTAL_EXTRA_ATTACKS", "ENVIRONMENTAL_AURA_APPLIED", "ENVIRONMENTAL_AURA_REMOVED", "ENVIRONMENTAL_AURA_APPLIED_DOSE", "ENVIRONMENTAL_AURA_REMOVED_DOSE", "ENVIRONMENTAL_AURA_REFRESH", "ENVIRONMENTAL_AURA_BROKEN", "ENVIRONMENTAL_AURA_BROKEN_SPELL", "ENVIRONMENTAL_CAST_START", "ENVIRONMENTAL_CAST_SUCCESS", "ENVIRONMENTAL_CAST_FAILED", "ENVIRONMENTAL_INSTAKILL", "ENVIRONMENTAL_DURABILITY_DAMAGE", "ENVIRONMENTAL_DURABILITY_DAMAGE_ALL", "ENVIRONMENTAL_CREATE", "ENVIRONMENTAL_SUMMON", "ENVIRONMENTAL_RESURRECT",
    "DAMAGE_SHIELD", "DAMAGE_SPLIT", "DAMAGE_SHIELD_MISSED", "ENCHANT_APPLIED", "ENCHANT_REMOVED", "PARTY_KILL", "UNIT_DIED", "UNIT_DESTROYED", "UNIT_DISSIPATES",
    "SPELL_ABSORBED", "SPELL_HEAL_ABSORBED"
}
local combatLogEventTable = {}

-- Spell names are irrelevant --
local dispelExclusions = {
    PRIEST = {

    },
    MAGE = {
        [642] = "Divine Shield"
    },
    SHAMAN = {

    },
    WARLOCK = {

    },
    WARRIOR = {

    }
}

local log = {
    info = Dispeller_LogInfo,
    debug = Dispeller_LogDebug,
    error = Dispeller_LogError
}

local DispellerSettings_Default =  {
    Debug = false,
    Test = false
}

function Dispeller_Load(self)

    DispellerFrame = self
    self:RegisterEvent("ADDON_LOADED")
    self:RegisterEvent("UNIT_AURA")
    self:RegisterEvent("PLAYER_DEAD")
    self:RegisterEvent("PLAYER_LOGIN")
    self:RegisterEvent("UNIT_TARGET")
    self:RegisterEvent("PLAYER_TARGET_CHANGED")
    self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
    self.Locked = true
    self:Hide()
    SLASH_DISPELLER1 = "/dispeller"
    SlashCmdList["DISPELLER"] = Dispeller_cmdHandle
    DispellerTitle.Text:SetText("Dispeller v" .. version)
end

--local update = Dispeller_Update

function Dispeller_handleEvent(self, event, ...)
    local args = { ... }
    --Dispeller_LogDebug(event .. " on " .. args[1])
    if (event == "ADDON_LOADED" and args[1] == "Dispeller") then
        if DispellerSettings == nil then
            DispellerSettings = {
                Debug = false,
                Test = false
            }
        end
        DispellerSettings.Test = false
        combatLogEventTable = Dispeller_InverseTable(combatLogEventTableInverse)
        Dispeller_Common.loaded = true
    elseif (event == "PLAYER_LOGIN") then
        Dispeller_InitCommonVariables()
    elseif (event == "PLAYER_TARGET_CHANGED") then
        Dispeller_LogDebug(event)
        Dispeller_Update(args[1])
    elseif (event == "UNIT_TARGET" and args[1] == "player") then
        --Dispeller_LogDebug(event .. " on " .. args[1])
        Dispeller_Update(args[1])
    elseif (event == "PLAYER_DEAD") then
        --Dispeller_LogDebug(event .. " on " .. args[1])
        --Dispeller_Update()
    elseif (event == "UNIT_AURA") then
        Dispeller_LogDebug(event .. " on " .. args[1])
        if (args[1] ~= "target" and DispellerSettings.Test == false) then
            do
                return
            end
        end
        Dispeller_Update(args[1])
--[[    elseif (event == "COMBAT_LOG_EVENT_UNFILTERED") then
        for i,k in args do
            Dispeller_LogDebug("arg"..i.. ": "..k)
        end
        --local timestamp, logEvent, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags,
        --spellId, spellName, spellSchool, param15, param16, param17, param18, param19 = ...
        local timestamp, logEvent, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags = ...

        if (not (Dispeller_ValueExists(combatLogEventTable, logEvent))) then
            Dispeller_LogDebug("Event missing: " .. logEvent)
        elseif (logEvent == "SPELL_STOLEN" and sourceGUID == Dispeller_Common.player.id) then
            Dispeller_LogInfo("Stole: " .. GetSpellLink(param15) .. " from " .. destName)
        elseif (logEvent == "SPELL_DISPEL" and sourceGUID == Dispeller_Common.player.id) then
            Dispeller_LogInfo("Dispelled: " .. GetSpellLink(param15) .. " from " .. destName)
        elseif (logEvent == "SPELL_DISPEL_FAILED" and sourceGUID == Dispeller_Common.player.id) then
            Dispeller_LogInfo("Failed to dispell: " .. GetSpellLink(param15) .. " from " .. destName)
        elseif (Dispeller_Common.player.playerClass == "MAGE" and logEvent == "SPELL_MISSED" and sourceGUID == Dispeller_Common.player.id) then
            Dispeller_LogInfo("SPELL Missed: " .. "missType: " .. tostring(param15) .. " isOffhand: " .. tostring(param16) .. " amount: " .. tostring(param17) .. " from " .. destName)
        else
            ChatFrame3:AddMessage(logEvent .. " : " .. tostring(sourceName) .. " : " .. tostring(destName) .. " : " .. tostring(spellName))
            Dispeller_LogInfo(event .. " : " .. sourceName .. " : " .. destName .. " : " .. spellName)
        end]]
    end
end

function Dispeller_Update(unit)
    --Dispeller_LogDebug("Unit is: "..tostring(unit))
    local stealable = {}
    for i = 1, 40 do
        --local name, rank, icon, count, debuffType, duration, expirationTime, caster, isStealable = UnitBuff("target", i)
        local name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, _, spellId = UnitAura("target", i, "HELPFUL")
        if (Dispeller_Common.broken and UnitIsEnemy("player", "target")) then
            isStealable = debuffType == "Magic"
        end
        if (name == nil) then
            break
        else
            --Dispeller_LogDebug("name: " .. tostring(name) .. " isStealable " .. tostring(isStealable))
            --Dispeller_LogDebug("name: " .. tostring(name) .. " rank " .. tostring(rank))
            --Dispeller_LogDebug("icon: " .. tostring(icon))
            --Dispeller_LogDebug("count: " .. tostring(count) .. " debuffType " .. tostring(debuffType))
            --Dispeller_LogDebug("duration: " .. tostring(duration) .. " expirationTime " .. tostring(expirationTime))
            --Dispeller_LogDebug("caster: " .. tostring(unitCaster) .. " canStealOrPurge " .. tostring(isStealable))
            if (DispellerSettings.Test) then
                isStealable = true
            end
            if (isStealable) then
                stealable[#stealable + 1] = name
                --[[                if (Dispeller_Common.player.playerClass == "MAGE" and dispelExclusions.MAGE[spellId] ~= nil) then
                                    -- do nothing
                                else
                                    stealable[#stealable + 1] = name
                                end]]
            end
        end
    end

    if (#stealable < 1) then
        DispellerFrame:Hide()
    else
        local height = 12 * #stealable
        stealable = table.concat(stealable, "\n")
        DispellerBuffs.Text:SetText(stealable)
        DispellerBuffs:SetHeight(height + 50)
        DispellerBuffs:Show()
        DispellerFrame:Show()
    end
end

function Dispeller_mouseDown(self, button)
    if (button == "MiddleButton") then
        self.Locked = not self.Locked
        Dispeller_LogInfo("Locked: " .. tostring(self.Locked))
    end
    if (button == "LeftButton") then
        if (self.Locked == false) then
            self:StartMoving()
            self.IsMoving = true
        end
    end
end

function Dispeller_mouseUp(self, button)
    if (self.Locked == false) then
        self:StopMovingOrSizing()
        self.IsMoving = false
        Dispeller_LogDebug("Dispeller Position X: " .. self:GetLeft() .. " Y: " .. self:GetBottom())
    end
end

function Dispeller_cmdHandle(command)
    if (strlower(command) == "") or (strlower(command) == "help") then
        for i, v in ipairs(Dispeller_CommandList) do
            print(v);
        end ;
        return
    end
    if (command == "debug") then
        DispellerSettings.Debug = not DispellerSettings.Debug
        Dispeller_LogInfo("Debug: " .. tostring(DispellerSettings.Debug))
        if (DispellerSettings.Debug) then
            ChatFrame3:AddMessage("ChatFrame3 initialized")
        end
    elseif (command == "test") then
        DispellerSettings.Test = not DispellerSettings.Test
        Dispeller_LogInfo("Test: " .. tostring(DispellerSettings.Test))
        if (DispellerSettings.Test) then
            DispellerBuffs.Text:SetText("")
        end
    elseif (command == "show") then
        if (Dispeller_Options:IsVisible()) then
            Dispeller_LogDebug("Dispeller: Hiding Options Frame")
            Dispeller_Options:Hide()
        else
            Dispeller_LogDebug("Dispeller: Opening Options Frame")
            Dispeller_Options:Show()
        end
    else
        print("Unknown Command. Type '/dispeller' for a list of options")
    end
end
