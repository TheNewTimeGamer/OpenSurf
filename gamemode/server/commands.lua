-- TNTG

chatCommands = {}
chatCommands["!r"] = function(ply, strText, bTeam, bDead)
    local startPoint = maps[game.GetMap()].startPoint
    ply:SetPos(startPoint:GetCenterFloor())
    ply:SetVelocity(ply:GetVelocity()*-1)
    ply:SetEyeAngles(Angle(0,startPoint.angle,0))
    return ""
end

chatCommands["!t"] = function(ply, strText, bTeam, bDead)
    local endPoint = maps[game.GetMap()].endPoint
    ply:SetPos(endPoint:GetCenterFloor())
    ply:SetVelocity(ply:GetVelocity()*-1)
    ply:SetEyeAngles(Angle(0,endPoint.angle,0))
    return ""
end

chatCommands["!rtv"] = function(ply, strText, bTeam, bDead)
    ply:ChatPrint("Rock the vote is currently disabled!")
end

chatCommands["!rtz"] = function(ply, strText, bTeam, bDead)
    zones = ents.FindByClass( "trigger_zone" )
    for k, v in pairs(zones) do
        v:Remove()
    end
      
    spawnTriggerZones()
end

chatCommands["!spec"] = function(ply, strText, bTeam, bDead)
    target = ply:GetObserverTarget()
    if(IsValid(target)) then
        ply:UnSpectate()
        ply:Spawn()
    else
        players = ents.FindByClass("player_default")
        target = GetFirstNonMatching(ply, players)
        ply:Spectate(OBS_MODE_IN_EYE)
        ply:SpectateEntity(target)
    end
end

chatCommands["!dump"] = function(ply, strText, bTeam, bDead)
    OpenSurfDataBase:WriteToDisk()
end

function GetFirstNonMatching(entity, entities)
    for k, v in pairs(entities) do
        if(v ~= entity) then
            return v
        end
    end
    return nil
end