--
-- Common tables / functions
--

Dispeller_Common = {}

-- Experimental --
function Dispeller_InitCommonVariables()
    local player = {}
    player.localClass, player.playerClass = UnitClass("player")
    player.id = UnitGUID("player")
    local localizedClass, englishClass, localizedRace, englishRace, gender, name, realm = GetPlayerInfoByGUID(player.id)
    player.realm = realm
    player.race = englishRace
    if (gender == 2) then
        player.gender = "male"
    elseif (gender == 3) then
        player.gender = "female"
    else
        player.gender = "unknown"
    end
    Dispeller_Common.player = player
    local broken_classes = Dispeller_InverseTable({
        "PRIEST", "WARRIOR", "SHAMAN", "HUNTER"
    })
    if (Dispeller_ValueExists(broken_classes, Dispeller_Common.player.playerClass)) then
        Dispeller_Common.broken = true
    end
end

function Dispeller_ValueExists(table, value)
    return table[tostring(value)] ~= nil
end

function Dispeller_InverseTable(table)
    local inverseTable = {}
    for k,v in pairs(table) do
        inverseTable[v] = k
    end
    return inverseTable
end

Dispeller_CommandList = {
    [1] = "---Dispeller command list---",
    [2] = "/dispeller show - Hides or shows the dispeller frame.",
    [3] = "/dispeller debug - Enables Dispeller debug mode",
    [4] = "/dispeller test - Shows a demo Dispeller frame",
    [5] = "/dispeller reset - Resets Dispeller to default configuration"
}
