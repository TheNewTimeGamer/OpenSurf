-- TNTG

chatCommands = {}
chatCommands["!r"] = function(ply, strText, bTeam, bDead)
    PrintTable(OpenSurfMap)
    ply:SetPos(OpenSurfMap.trigger_zone_start:GetPos())
    ply:SetVelocity(ply:GetVelocity()*-1)
    ply:SetEyeAngles(Angle(0,OpenSurfMap.trigger_zone_start.angle,0))
    return ""
end

chatCommands["!t"] = function(ply, strText, bTeam, bDead)
    ply:SetPos(OpenSurfMap.trigger_zone_end:GetPos())
    ply:SetVelocity(ply:GetVelocity()*-1)
    ply:SetEyeAngles(Angle(0,OpenSurfMap.trigger_zone_end.angle,0))
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
      
    OpenSurfMap:spawnTriggerZones()
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

function GetFirstNonMatching(entity, entities)
    for k, v in pairs(entities) do
        if(v ~= entity) then
            return v
        end
    end
    return nil
end