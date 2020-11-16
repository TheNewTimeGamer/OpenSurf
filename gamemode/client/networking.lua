-- Client-Side Networking.

-- State 0 = Enter End Zone.
-- State 1 = Leave Start Zone.
-- State 2 = Enter Start Zone.

net.Receive("LocalPlayerStateSignal", function()
    state = net.ReadInt(8)
    if(state == 1) then
        openSurfHud.currentStartTime = CurTime()
        openSurfHud.currentEndTime = 0
        openSurfHud.runStopped = false
    elseif (state == 2) then
        openSurfHud.runStopped = true
    else
        if(!openSurfHud.runStopped) then
            startTime = net.ReadDouble(32)
            endTime = net.ReadDouble(32)
            openSurfHud.currentStartTime = startTime
            openSurfHud.currentEndTime = endTime
            openSurfHud.runStopped = true
        end
    end
end )

net.Receive("LocalPlayerFinishTime", function()
    startTime = net.ReadDouble(32)
    endTime = net.ReadDouble(32)
    openSurfHud.currentStartTime = startTime
    openSurfHud.currentEndTime = endTime
end )

net.Receive("LocalPlayerPersonalBest", function()
    personalBest = net.ReadDouble(32)
    openSurfHud.personalBestTime = personalBest
end )

net.Receive("ServerReportWorldRecord", function()
    local messageType = net.ReadInt(8)
    local steamID64 = net.ReadString()
    local runTime = net.ReadDouble()

    if(messageType == 1) then
        
    end

    openSurfHud.worldRecordHolderTime = secondsToTimeStamp(runTime)
    steamworks.RequestPlayerInfo(steamID64, function(playerName)
        openSurfHud.worldRecordHolderName = playerName
    end )
end )