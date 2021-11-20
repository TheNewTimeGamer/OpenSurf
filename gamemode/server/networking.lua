-- TNTG
-- Server-Side Networking.

networking = {}

util.AddNetworkString("LocalPlayerStateSignal")
util.AddNetworkString("LocalPlayerFinishTime")
util.AddNetworkString("LocalPlayerPersonalBest")

util.AddNetworkString("ServerReportWorldRecord")

util.AddNetworkString("ToggleLocalPlayerScreenClicker")

function networking:SendLocalPlayerStateSignal(ply, state, startTime, endTime)
    net.Start("LocalPlayerStateSignal")
    net.WriteInt(state, 8)
    if(state == 0) then
        net.WriteDouble(startTime, 32)
        net.WriteDouble(endTime, 32)
    end
    net.Send(ply)
end

function networking:SendLocalPlayerPersonalBest(ply)
    local personalBest = OpenSurfDataBase:GetPersonalBest(ply:SteamID64(), game.GetMap(), 0)
    if(!personalBest or !personalBest[1]) then
        return
    end
    net.Start("LocalPlayerPersonalBest")
    net.WriteDouble(personalBest[1].end_time - personalBest[1].start_time, 32)
    net.Send(ply)
end

function networking:SendLocalPlayerCurrentWorldRecord(ply)
    local worldRecord = OpenSurfDataBase:GetWorldRecord(game.GetMap(), 0)
    if(!worldRecord or !worldRecord[1]) then
        return
    end
    net.Start("ServerReportWorldRecord")
    net.WriteInt(2, 8) -- 2 = Silent. Just update hud display.
    net.WriteString(worldRecord[1].steam_id)
    net.WriteDouble(worldRecord[1].end_time - worldRecord[1].start_time)
    net.Send(ply)
end

function networking:BroadcastNewWorldRecord(steamID64, runTime)
    net.Start("ServerReportWorldRecord")
    net.WriteInt(1, 8) -- 1 = Broadcast Message. Show Middle of screen.
    net.WriteString(steamID64)
    net.WriteDouble(runTime)
    net.Broadcast()
end

function networking:BroadcastRockTheVote()
    -- TODO: Implement.
end

-- Used when rock the vote has already been broadcasted but a new player joins.
function networking:SendLocalPlayerRockTheVote()
    -- TODO: Implement.
end

function networking:ToggleLocalPlayerScreenClicker(ply)
    net.Start("ToggleLocalPlayerScreenClicker")
    net.WriteInt(1, 8)
    net.Send(ply)
end