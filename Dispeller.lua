--
-- Dispeller addon for World of Warcraft
-- Main developer: LumielGR
--

local version = GetAddOnMetadata("Dispeller", "Version")
DispellerFrame = nil

function Dispeller_Load(self)
    print("Loaded: " .. version)
    local _, playerClass = UnitClass("player")

    DispellerFrame = self
    self:RegisterEvent("ADDON_LOADED")
    self:RegisterEvent("UNIT_AURA")
    self:RegisterEvent("PLAYER_DEAD")
    self:RegisterEvent("UNIT_TARGET")
    self:RegisterEvent("PLAYER_TARGET_CHANGED")
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
        logdebug(event .. " on " .. args[1])
        Dispeller_Update()
    end
end

function Dispeller_Update()
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
        loginfo("Locked: " .. tostring(self.Locked))
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
        DispellerSettings.positionX = self:GetLeft()
        DispellerSettings.positionY = self:GetBottom()
        logdebug("Dispeller Position X: " .. self:GetLeft() .. " Y: " .. self:GetBottom())
        logdebug("Global Position X: " .. DispellerSettings.positionX .. " Y: " .. DispellerSettings.positionY)
    end
end

function Dispeller_cmdHandle(command, ...)
    if (command == "debug") then
        DispellerSettings.Debug = not DispellerSettings.Debug
        loginfo("Debug: " .. tostring(DispellerSettings.Debug))
        if (DispellerSettings.Debug) then
            DispellerBuffs.Text:SetText("")
        end
    end
end