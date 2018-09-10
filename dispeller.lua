--
-- Dispeller addon for World of Warcraft
-- Main developer: LumielGR
--

local version = GetAddOnMetadata("Dispeller", "Version")

function Dispeller(self)
    print("Loaded: " .. version)
    local _, playerClass = UnitClass("player")

    self:RegisterEvent("ADDON_LOADED")
    self:RegisterEvent("UNIT_AURA")
    self:RegisterForDrag("button")
    self.Locked = false
    self:Show()
    SLASH_DISPELLER1 = "/dispeller"
    SlashCmdList["DISPELLER"] = Dispeller_cmdHandle
end

function Dispeller_handleEvent(self, event, ...)
    local args = {...}
    if (event == "UNIT_AURA") then
        if (args[1] == "player" and DispellerSettings.Debug == false) then do return end end
        logdebug(event .. " on " .. args[1])
        local stealable = {}
        for i = 1,40 do
            local name, icon, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge = UnitAura("target", i, "HELPFUL")
            if (name == nil) then break else
                if (canStealOrPurge) then
                    table.insert(stealable, name)
                    logdebug(name .. " stealable: " .. tostring(canStealOrPurge))
                end
            end
        end
        if (DispellerSettings.Debug) then
            stealable = {"Buff", "Aura", "Spell" }
        end

        if (#stealable < 1) then
            if not DispellerSettings.Debug then
                self:Hide()
            end
        else
            local height = 10* #stealable
            stealable = table.concat(stealable, "\n")
            DispellerBuffs:SetHeight(height)
            DispellerBuffs.DisplayText:SetText(stealable)
            DispellerBuffs:Show()
            self:Show()
        end
    elseif (event == "ADDON_LOADED") then
        if (args[1] == "Dispeller") then
            if (type(DispellerSettings) ~= "table") then
                DispellerSettings =  {
                    Debug = false,
                    positionX = 0,
                    positionY = 0
                } end
--            if (DispellerSettings.positionX == nil) then DispellerSettings.positionX = 0 end
--            if (DispellerSettings.positionY == nil) then DispellerSettings.positionY = 0 end
            self:ClearAllPoints()
            self:SetPoint("CENTER", 0, 0)
            self:SetPoint("BOTTOMLEFT", DispellerSettings.positionX, DispellerSettings.positionY)
        end
    end
end

function Dispeller_mouseDown(self, button)
    if (button == "MiddleButton") then
--        TODO REMOVE
--        self.Debug = not self.Debug
        DispellerSettings.Debug = not DispellerSettings.Debug
        if (DispellerSettings.Debug) then
            DispellerBuffs.DisplayText:SetText("")
        else
            loginfo(button)
            loginfo("Debug: " .. tostring(DispellerSettings.Debug))
            loginfo("Locked: " .. tostring(self.Locked))
        end
    end
    logdebug(button)
    logdebug("Debug: " .. tostring(DispellerSettings.Debug))
    logdebug("Locked: " .. tostring(self.Locked))
    if (self.Locked == false) then
        self:StartMoving()
        self.IsMoving = true
    end
end

function Dispeller_mouseUp(self, button)
    if (self.Locked == false) then
        self:StopMovingOrSizing()
        self.IsMoving = false
        DispellerSettings.positionX = self:GetLeft()
        DispellerSettings.positionY = self:GetBottom()
        logdebug("Dispeller Position X: " .. self:GetLeft() .. " Y: " .. self:GetBottom())
        logdebug("Global Position X: " .. DispellerSettings.positionX .. " Y: " .. DispellerSettings.positionY)
    end
end

function Dispeller_cmdHandle(command, ...)
    if (command == "debug") then
        DispellerSettings.Debug = not DispellerSettings.Debug
    end
end