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

    OpenSurfDataBase:InsertRun(steamID64, self.ActiveRuns[steamID64].startTime, endTime, 0, date)
    return self.ActiveRuns[steamID64].startTime, endTime
end

function OpenSurfDataBase:GetUniqueSignature()
    return "P09" .. (math.random(0,1000)) .. "M0x3" -- Important, Used for db verification.
end

function OpenSurfDataBase:IsValidRun(startTime, endTime)
    if(!startTime or !endTime) then return false end
    return true -- TODO: Implement
end