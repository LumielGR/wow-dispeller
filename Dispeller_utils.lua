
function Dispeller_LogDebug(value)
    --if (DispellerSettings.Debug) then
    ChatFrame3:AddMessage("|Dispeller| Debug: "  .. value)
    --end
end

function Dispeller_LogInfo(value)
    print("|Dispeller| Info:" .. value)
end

function Dispeller_LogError(value)
    print("|Dispeller| Error: " .. value)
end
