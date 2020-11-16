function calculateRunDuration(times)
    return times.runEndTime - times.runStartTime
end

OpenSurfDataBase = {
    worldRecord = {},
    players = {}
}

function OpenSurfDataBase:StartPlayerRun(steamID64)
    if(!self.players[steamID64]) then self.players[steamID64] = {} end
    self.players[steamID64].currentRunStart = CurTime()
end

function OpenSurfDataBase:FinishPlayerRun(steamID64)
    if(!self.players[steamID64]) then self.players[steamID64] = {} end
    if(!self.players[steamID64].Runs) then 
        self.players[steamID64].Runs = {} 
    end

    local endTime = CurTime()
    local dateStamp = util.DateStamp()

    self.players[steamID64].Runs[dateStamp] = {
        runStartTime = self.players[steamID64].currentRunStart,
        runEndTime = endTime
    }
    local times = {runStartTime=self.players[steamID64].currentRunStart, runEndTime=endTime} -- TO-DO: IMplement multiple returns?
    if(self:IsValidRun(self.players[steamID64].Runs[dateStamp])) then
        if(self:CheckIfWorldRecord(steamID64, dateStamp)) then        
            networking:BroadcastNewWorldRecord(steamID64, calculateRunDuration(self.players[steamID64].Runs[dateStamp]))
        end
    end
    return times
end

function OpenSurfDataBase:CheckIfWorldRecord(steamID64, dateStamp)
    if(!self.worldRecord.playerIndex || !self.worldRecord.runIndex) then
        self.worldRecord.playerIndex = steamID64
        self.worldRecord.runIndex = dateStamp
        return true
    else
        local recordHolderRun = self.players[self.worldRecord.playerIndex].Runs[self.worldRecord.runIndex]
        if(!self:IsValidRun(recordHolderRun)) then
            return true
        end
        recordHolderTime = calculateRunDuration(recordHolderRun)
        challengerTime = calculateRunDuration(self.players[steamID64].Runs[dateStamp])

        if(challengerTime < recordHolderTime) then
            return true
        end
    end
    return false
end

function OpenSurfDataBase:IsValidRun(run)
    if(!run.runStartTime || !run.runEndTime) then
        return false
    end
    return true
end

function OpenSurfDataBase:GetPlayerPersonalBest(steamID64)
    if(!self.players[steamID64] || !self.players[steamID64].Runs) then return -1 end
    local shortestTime = -1
    for k, v in pairs(self.players[steamID64].Runs) do
        local startTime = v.runStartTime
        local endTime = v.runEndTime
        if(startTime && endTime) then 
            time = endTime - startTime
            if(shortestTime < 0 || time < shortestTime) then
                shortestTime = time
            end
        end
    end     
    return shortestTime
end

function OpenSurfDataBase:WriteToDisk()
    -- TO-DO: Implement.
end

function OpenSurfDataBase:ReadPlayerDataFromDisk(steamID64)
    -- TO-DO: Implement.
end

function OpenSurfDataBase:ReadMetaDataFromDisk()
    -- TO-DO: Implement.
end