
function Dispeller_LogDebug(value)
    if (DispellerSettings.Debug) then
        print(value)
    end
end

function Dispeller_LogInfo(value)
    print(value)
end

function Dispeller_LogError(value)
    print("Error: " .. value)
end

function Dispeller_LogDebug(value)
    if (DispellerSettings.Debug) then
        print(value)
    end
end