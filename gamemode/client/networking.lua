-- TNTG
-- Client-Side Networking.

-- State 0 = Enter End Zone.
-- State 1 = Leave Start Zone.
-- State 2 = Enter Start Zone.

net.Receive("LocalPlayerStateSignal", function()
    state = net.ReadInt(8)
    if(state == 1) then
        OpenSurfHud.currentStartTime = CurTime()
        OpenSurfHud.currentEndTime = 0
        OpenSurfHud.runStopped = false
    elseif (state == 2) then
        OpenSurfHud.runStopped = true
    else
        if(!OpenSurfHud.runStopped) then
            startTime = net.ReadDouble(32)
            endTime = net.ReadDouble(32)
            OpenSurfHud.currentStartTime = startTime
            OpenSurfHud.currentEndTime = endTime
            OpenSurfHud.runStopped = true
        end
    end
end )

net.Receive("LocalPlayerFinishTime", function()
    startTime = net.ReadDouble(32)
    endTime = net.ReadDouble(32)
    OpenSurfHud.currentStartTime = startTime
    OpenSurfHud.currentEndTime = endTime
end )

net.Receive("LocalPlayerPersonalBest", function()
    personalBest = net.ReadDouble(32)
    OpenSurfHud.personalBestTime = personalBest
end )

net.Receive("ServerReportWorldRecord", function()
    local messageType = net.ReadInt(8)
    local steamID64 = net.ReadString()
    local runTime = net.ReadDouble()

    if(messageType == 1) then
        
    end

    OpenSurfHud.worldRecordHolderTime = secondsToTimeStamp(runTime)
    steamworks.RequestPlayerInfo(steamID64, function(playerName)
        OpenSurfHud.worldRecordHolderName = playerName
    end )
end )