--
-- Common tables / functions
--

Dispeller_Common = {}

-- Experimental --
function Dispeller_SetPlayer()
    local self = {}
    self.localClass, self.playerClass, self.classId = UnitClass("player")
    Dispeller_Common.player = self
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