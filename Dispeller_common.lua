--
-- Common tables / functions
--

Dispeller_Common = {}

-- Experimental --
function Dispeller_InitCommonVariables()
    local player = {}
    player.localClass, player.playerClass, player.classId = UnitClass("player")
    Dispeller_Common.player = player
    Dispeller_Common.player.id = UnitGUID("player")
    local _, _, raceName, _, gender, name, realm = GetPlayerInfoByGUID(Dispeller_Common.player.id)
    Dispeller_Common.player.race = raceName
    if (gender == 2) then
        Dispeller_Common.player.gender = "male"
    elseif (gender == 3) then
        Dispeller_Common.player.gender = "female"
    else
        Dispeller_Common.player.gender = "unknown"
    end

    Dispeller_Common.player.realm = realm
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