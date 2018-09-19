--
-- Dispeller addon for World of Warcraft
-- Main developer: LumielGR
--

local version = GetAddOnMetadata("Dispeller", "Version")
DispellerFrame = nil

local combatLogEventTableInverse = {
    "SWING_DAMAGE","SWING_MISSED","SWING_HEAL","SWING_ENERGIZE","SWING_DRAIN","SWING_LEECH","SWING_INTERRUPT","SWING_DISPEL","SWING_DISPEL_FAILED","SWING_STOLEN","SWING_EXTRA_ATTACKS","SWING_AURA_APPLIED","SWING_AURA_REMOVED","SWING_AURA_APPLIED_DOSE","SWING_AURA_REMOVED_DOSE","SWING_AURA_REFRESH","SWING_AURA_BROKEN","SWING_AURA_BROKEN_SPELL","SWING_CAST_START","SWING_CAST_SUCCESS","SWING_CAST_FAILED","SWING_INSTAKILL","SWING_DURABILITY_DAMAGE","SWING_DURABILITY_DAMAGE_ALL","SWING_CREATE","SWING_SUMMON","SWING_RESURRECT",
    "RANGE_DAMAGE","RANGE_MISSED","RANGE_HEAL","RANGE_ENERGIZE","RANGE_DRAIN","RANGE_LEECH","RANGE_INTERRUPT","RANGE_DISPEL","RANGE_DISPEL_FAILED","RANGE_STOLEN","RANGE_EXTRA_ATTACKS","RANGE_AURA_APPLIED","RANGE_AURA_REMOVED","RANGE_AURA_APPLIED_DOSE","RANGE_AURA_REMOVED_DOSE","RANGE_AURA_REFRESH","RANGE_AURA_BROKEN","RANGE_AURA_BROKEN_SPELL","RANGE_CAST_START","RANGE_CAST_SUCCESS","RANGE_CAST_FAILED","RANGE_INSTAKILL","RANGE_DURABILITY_DAMAGE","RANGE_DURABILITY_DAMAGE_ALL","RANGE_CREATE","RANGE_SUMMON","RANGE_RESURRECT",
    "SPELL_DAMAGE","SPELL_MISSED","SPELL_HEAL","SPELL_ENERGIZE","SPELL_DRAIN","SPELL_LEECH","SPELL_INTERRUPT","SPELL_DISPEL","SPELL_DISPEL_FAILED","SPELL_STOLEN","SPELL_EXTRA_ATTACKS","SPELL_AURA_APPLIED","SPELL_AURA_REMOVED","SPELL_AURA_APPLIED_DOSE","SPELL_AURA_REMOVED_DOSE","SPELL_AURA_REFRESH","SPELL_AURA_BROKEN","SPELL_AURA_BROKEN_SPELL","SPELL_CAST_START","SPELL_CAST_SUCCESS","SPELL_CAST_FAILED","SPELL_INSTAKILL","SPELL_DURABILITY_DAMAGE","SPELL_DURABILITY_DAMAGE_ALL","SPELL_CREATE","SPELL_SUMMON","SPELL_RESURRECT","SPELL_PERIODIC_DAMAGE","SPELL_PERIODIC_MISSED","SPELL_PERIODIC_HEAL","SPELL_PERIODIC_ENERGIZE","SPELL_PERIODIC_DRAIN","SPELL_PERIODIC_LEECH","SPELL_PERIODIC_INTERRUPT","SPELL_PERIODIC_DISPEL","SPELL_PERIODIC_DISPEL_FAILED","SPELL_PERIODIC_STOLEN","SPELL_PERIODIC_EXTRA_ATTACKS","SPELL_PERIODIC_AURA_APPLIED","SPELL_PERIODIC_AURA_REMOVED","SPELL_PERIODIC_AURA_APPLIED_DOSE","SPELL_PERIODIC_AURA_REMOVED_DOSE","SPELL_PERIODIC_AURA_REFRESH","SPELL_PERIODIC_AURA_BROKEN","SPELL_PERIODIC_AURA_BROKEN_SPELL","SPELL_PERIODIC_CAST_START","SPELL_PERIODIC_CAST_SUCCESS","SPELL_PERIODIC_CAST_FAILED","SPELL_PERIODIC_INSTAKILL","SPELL_PERIODIC_DURABILITY_DAMAGE","SPELL_PERIODIC_DURABILITY_DAMAGE_ALL","SPELL_PERIODIC_CREATE","SPELL_PERIODIC_SUMMON","SPELL_PERIODIC_RESURRECT","SPELL_BUILDING_DAMAGE","SPELL_BUILDING_MISSED","SPELL_BUILDING_HEAL","SPELL_BUILDING_ENERGIZE","SPELL_BUILDING_DRAIN","SPELL_BUILDING_LEECH","SPELL_BUILDING_INTERRUPT","SPELL_BUILDING_DISPEL","SPELL_BUILDING_DISPEL_FAILED","SPELL_BUILDING_STOLEN","SPELL_BUILDING_EXTRA_ATTACKS","SPELL_BUILDING_AURA_APPLIED","SPELL_BUILDING_AURA_REMOVED","SPELL_BUILDING_AURA_APPLIED_DOSE","SPELL_BUILDING_AURA_REMOVED_DOSE","SPELL_BUILDING_AURA_REFRESH","SPELL_BUILDING_AURA_BROKEN","SPELL_BUILDING_AURA_BROKEN_SPELL","SPELL_BUILDING_CAST_START","SPELL_BUILDING_CAST_SUCCESS","SPELL_BUILDING_CAST_FAILED","SPELL_BUILDING_INSTAKILL","SPELL_BUILDING_DURABILITY_DAMAGE","SPELL_BUILDING_DURABILITY_DAMAGE_ALL","SPELL_BUILDING_CREATE","SPELL_BUILDING_SUMMON","SPELL_BUILDING_RESURRECT",
    "ENVIRONMENTAL_DAMAGE","ENVIRONMENTAL_MISSED","ENVIRONMENTAL_HEAL","ENVIRONMENTAL_ENERGIZE","ENVIRONMENTAL_DRAIN","ENVIRONMENTAL_LEECH","ENVIRONMENTAL_INTERRUPT","ENVIRONMENTAL_DISPEL","ENVIRONMENTAL_DISPEL_FAILED","ENVIRONMENTAL_STOLEN","ENVIRONMENTAL_EXTRA_ATTACKS","ENVIRONMENTAL_AURA_APPLIED","ENVIRONMENTAL_AURA_REMOVED","ENVIRONMENTAL_AURA_APPLIED_DOSE","ENVIRONMENTAL_AURA_REMOVED_DOSE","ENVIRONMENTAL_AURA_REFRESH","ENVIRONMENTAL_AURA_BROKEN","ENVIRONMENTAL_AURA_BROKEN_SPELL","ENVIRONMENTAL_CAST_START","ENVIRONMENTAL_CAST_SUCCESS","ENVIRONMENTAL_CAST_FAILED","ENVIRONMENTAL_INSTAKILL","ENVIRONMENTAL_DURABILITY_DAMAGE","ENVIRONMENTAL_DURABILITY_DAMAGE_ALL","ENVIRONMENTAL_CREATE","ENVIRONMENTAL_SUMMON","ENVIRONMENTAL_RESURRECT",
    "DAMAGE_SHIELD","DAMAGE_SPLIT","DAMAGE_SHIELD_MISSED","ENCHANT_APPLIED","ENCHANT_REMOVED","PARTY_KILL","UNIT_DIED","UNIT_DESTROYED","UNIT_DISSIPATES",
    "SPELL_ABSORBED"
}

local combatLogEventTable = {}

function Dispeller_Load(self)

    DispellerFrame = self
    self:RegisterEvent("ADDON_LOADED")
    self:RegisterEvent("UNIT_AURA")
    self:RegisterEvent("PLAYER_DEAD")
    self:RegisterEvent("UNIT_TARGET")
    self:RegisterEvent("PLAYER_TARGET_CHANGED")
    self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
    self.Locked = true
    self:Hide()
    SLASH_DISPELLER1 = "/dispeller"
    SlashCmdList["DISPELLER"] = Dispeller_cmdHandle
    DispellerTitle.Text:SetText("Dispeller v" .. version)
end

function Dispeller_handleEvent(self, event, ...)
    local args = {... }
    if (event == "ADDON_LOADED") then
        if (args[1] == "Dispeller") then
            combatLogEventTable = Dispeller_InverseTable(combatLogEventTableInverse)
            Dispeller_SetPlayer()
            -- Todo: Future global options
            if (type(DispellerSettings) ~= "table") then
                DispellerSettings =  { }
            end
            DispellerSettings.Debug = false
        end
    elseif (event == "PLAYER_TARGET_CHANGED")  then
        Dispeller_Update()
    elseif (event == "UNIT_TARGET" and args[1] == "player") then
        Dispeller_Update()
    elseif (event == "PLAYER_DEAD") then
        Dispeller_Update()
    elseif (event == "UNIT_AURA") then
        if (args[1] ~= "target" and DispellerSettings.Debug == false) then do return end end
        Dispeller_LogDebug(event .. " on " .. args[1])
        Dispeller_Update()
    elseif (event == "COMBAT_LOG_EVENT_UNFILTERED") then
        local timestamp, logEvent, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags,
            spellId, spellName, spellSchool, spellId, extraSpellId, extraSpellName, extraSchool, auraType = CombatLogGetCurrentEventInfo()

        if (not(Dispeller_ValueExists(combatLogEventTable, logEvent))) then
            Dispeller_LogError("Event missing: " .. logEvent)
        elseif (event == "SPELL_STOLEN" and sourceGUID == UnitGUID("player")) then
            Dispeller_LogInfo("Stole: " .. GetSpellLink(spellId) .. " from " .. destName)
        elseif (event == "SPELL_DISPEL" and sourceGUID == UnitGUID("player")) then
            Dispeller_LogInfo("Dispelled: " .. GetSpellLink(spellId) .. " from " .. destName)
        elseif (event == "SPELL_DISPEL_FAILED" and sourceGUID == UnitGUID("player")) then
            Dispeller_LogInfo("Failed to dispell: " .. GetSpellLink(spellId) .. " from " .. destName)
        else
            --Dispeller_LogInfo(event .. " : " .. sourceName .. " : " .. destName .. " : " .. spellName)
        end
    end
end

function Dispeller_Update()
    local stealable = {}
    for i = 1,40 do
        local name, icon, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge = UnitAura("target", i, "HELPFUL")
        if (name == nil) then break else
            if (canStealOrPurge) then
                table.insert(stealable, name)
                Dispeller_LogDebug(name .. " stealable: " .. tostring(canStealOrPurge))
            end
        end
    end
    if (DispellerSettings.Debug) then
        stealable = {"Buff1", "Buff2", "Buff3", "Buff4", "Buff5", "Buff6", "Buff7", "Buff8", "Buff9" }
    end

    if (#stealable < 1) then
        if not DispellerSettings.Debug then
            DispellerFrame:Hide()
        end
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

function Dispeller_cmdHandle(command, ...)
    if (command == "debug") then
        DispellerSettings.Debug = not DispellerSettings.Debug
        Dispeller_LogInfo("Debug: " .. tostring(DispellerSettings.Debug))
        if (DispellerSettings.Debug) then
            DispellerBuffs.Text:SetText("")
        end
    end
end