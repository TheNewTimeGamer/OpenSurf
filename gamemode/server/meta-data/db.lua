function calculateRunDuration(times)
    if(!times || !times.runEndTime || !times.runStartTime) then
        return nil
    end
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
            self.worldRecord.playerIndex = steamID64
            self.worldRecord.runIndex = dateStamp
            OpenSurfDataBase:WriteWorldRecordToDisk()
            networking:BroadcastNewWorldRecord(steamID64, calculateRunDuration(self.players[steamID64].Runs[dateStamp]))
        end
    end
    if(self:IsValidRun(times)) then
        OpenSurfDataBase:WritePlayerDataToDisk(steamID64)
    end
    return times
end

function OpenSurfDataBase:GetCurrentWorldRecord()
    local playerData = self.players[self.worldRecord.playerIndex]
    if(!playerData) then
        return nil
    end
    return playerData.Runs[self.worldRecord.runIndex]
end

function OpenSurfDataBase:CheckIfWorldRecord(steamID64, dateStamp)
    if(!self.worldRecord.playerIndex || !self.worldRecord.runIndex) then        
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
    if(!file.IsDir("open_surf", "DATA")) then
        file.CreateDir("open_surf")
    end
    
    local map = game.GetMap()
    if(!file.IsDir("open_surf/" .. map, "DATA")) then
        file.CreateDir("open_surf/" .. map, "DATA")
    end

    if(!file.IsDir("open_surf/" .. map .."/players", "DATA")) then
        file.CreateDir("open_surf/" .. map .. "/players")
    end

    OpenSurfDataBase:WriteWorldRecordToDisk()

    for k, v in pairs(OpenSurfDataBase.players) do
        print("Writing: " .. "open_surf/" .. map .. "/players/" .. k .. ".json")
        content = util.TableToJSON(v, true)
        file.Write("open_surf/" .. map .. "/players/" .. k .. ".json", content)
    end

end

function OpenSurfDataBase:WriteWorldRecordToDisk()
    content = util.TableToJSON(OpenSurfDataBase.worldRecord, true)
    if(!file.IsDir("open_surf/" .. game.GetMap(), "DATA")) then
        file.CreateDir("open_surf/" .. game.GetMap())
    end
    file.Write("open_surf/" .. game.GetMap() .. "/world_record.json", content)
end

function OpenSurfDataBase:WritePlayerDataToDisk(steamID64)
    content = util.TableToJSON(OpenSurfDataBase.players[steamID64], true)
    if(!file.IsDir("open_surf/" .. game.GetMap() .. "/players", "DATA")) then
        file.CreateDir("open_surf/" .. game.GetMap() .. "/players")
    end
    file.Write("open_surf/" .. game.GetMap() .. "/players/" .. steamID64 .. ".json", content)
end

function OpenSurfDataBase:ReadPlayerDataFromDisk(steamID64)
    print("Loading " .. steamID64 .. " From disk..")
    local content = file.Read("open_surf/" .. game.GetMap() .. "/players/" .. steamID64 .. ".json", "DATA")
    if(!content) then
        return nil
    end
    local playerData = util.JSONToTable(content)
    OpenSurfDataBase.players[steamID64] = playerData
    print(OpenSurfDataBase.players[steamID64])
    return playerData
end

function OpenSurfDataBase:ReadMetaDataFromDisk()
    print("open_surf: loading meta data from disk..")
    local content = file.Read("open_surf/" .. game.GetMap() .. "/world_record.json", "DATA")
    if(!content) then
        return nil
    end
    local worldRecordData = util.JSONToTable(content)
    OpenSurfDataBase.worldRecord = worldRecordData
    print(OpenSurfDataBase.worldRecord)
    return worldRecordData
end
