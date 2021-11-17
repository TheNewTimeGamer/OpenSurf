-- TNTG

OpenSurfDataBase.ActiveRuns = {}

function OpenSurfDataBase:StartPlayerRun(steamID64)
    if(!self.ActiveRuns[steamID64]) then self.ActiveRuns[steamID64] = {} end
    self.ActiveRuns[steamID64].startTime = CurTime()
end

function OpenSurfDataBase:FinishPlayerRun(steamID64)
    local endTime = CurTime()
    local date = util.DateStamp()

    if(!self.ActiveRuns[steamID64]) then
       print("Invalid run: No start time. (" .. steamID64 .. ")")
       return
    end

    if(!OpenSurfDataBase:IsValidRun(self.ActiveRuns[steamID64].startTime, endTime)) then
        print("Invalid run: " .. self.ActiveRuns[steamID64].startTime .. " - " .. endTime .. " (" .. steamID64 .. ")")
        return
    end

    OpenSurfDataBase:CheckNewWorldRecord(steamID64, self.ActiveRuns[steamID64].startTime, endTime, game.GetMap())
    OpenSurfDataBase:InsertRun(0, steamID64, self.ActiveRuns[steamID64].startTime, endTime, game.GetMap(), 0, date)

    return self.ActiveRuns[steamID64].startTime, endTime
end

function OpenSurfDataBase:GetUniqueSignature()
    return "P09" .. (math.random(0,1000)) .. "M0x3" -- Important, Used for db verification.
end

function OpenSurfDataBase:CheckNewWorldRecord(steamID64, startTime, endTime, map)
    local worldRecord = OpenSurfDataBase:GetWorldRecord(map, 0)
    local playerTime = endTime - startTime
    if(worldRecord and !worldRecord[1]) then 
        local worldRecordTime = worldRecord[1].end_time - worldRecord[1].start_time
        if(playerTime >= worldRecordTime) then return end
    end
    networking:BroadcastNewWorldRecord(steamID64, playerTime) -- TODO: Add categories.
end

function OpenSurfDataBase:IsValidRun(startTime, endTime)
    if(!startTime or !endTime) then return false end
    return true -- TODO: Implement
end