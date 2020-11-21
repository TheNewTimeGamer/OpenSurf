-- Server-Side Networking.

networking = {}

util.AddNetworkString("LocalPlayerStateSignal")
util.AddNetworkString("LocalPlayerFinishTime")
util.AddNetworkString("LocalPlayerPersonalBest")

util.AddNetworkString("ServerReportWorldRecord")

function networking:SendLocalPlayerStateSignal(ply, state, startTime, endTime)
    net.Start("LocalPlayerStateSignal")
    net.WriteInt(state, 8)
    if(state == 0) then
        net.WriteDouble(startTime, 32)
        net.WriteDouble(endTime, 32)
    end
    net.Send(ply)
end

function networking:SendLocalPLayerPersonalBest(ply)
    print("Sending pb!")
    net.Start("LocalPlayerPersonalBest")
    net.WriteDouble(OpenSurfDataBase:GetPlayerPersonalBest(ply:SteamID64()), 32)
    net.Send(ply)
end

function networking:SendLocalPlayerCurrentWorldRecord(ply, steamID64, runTime)
    net.Start("ServerReportWorldRecord")
    net.WriteInt(2, 8) -- 2 = Silent. Just update hud display.
    net.WriteString(steamID64)
    net.WriteDouble(runTime)
    net.Send(ply)
end

function networking:BroadcastNewWorldRecord(steamID64, runTime)
    net.Start("ServerReportWorldRecord")
    net.WriteInt(1, 8) -- 1 = Broadcast Message. Show Middle of screen.
    net.WriteString(steamID64)
    net.WriteDouble(runTime)
    net.Broadcast()
end