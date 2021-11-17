-- TNTG

chatCommands = {}
chatCommands["!r"] = function(ply, strText, bTeam, bDead)
    ply:SetPos(OpenSurfMap.trigger_zone_start_center)
    ply:SetVelocity(ply:GetVelocity()*-1)
    ply:SetEyeAngles(Angle(0,OpenSurfMap.trigger_zone_start.angle,0))
    return ""
end

chatCommands["!rtv"] = function(ply, strText, bTeam, bDead)
    ply:ChatPrint("Rock the vote is currently disabled!")
end

chatCommands["!rebuildzones"] = function(ply, strText, bTeam, bDead)
    zones = ents.FindByClass( "trigger_zone" )
    for k, v in pairs(zones) do
        v:Remove()
    end
    OpenSurfMap:spawnTriggerZones()
    ply:ChatPrint("Zones rebuilt!")
end

chatCommands["!setstartpos"] = function(ply, strText, bTeam, bDead)
    local pos = ply:GetEyeTrace()
    OpenSurfMap.start_point.x = pos.HitPos.x
    OpenSurfMap.start_point.y = pos.HitPos.y
    OpenSurfMap.start_point.z = pos.HitPos.z
end

chatCommands["!setendpos"] = function(ply, strText, bTeam, bDead)
    local pos = ply:GetEyeTrace()
    OpenSurfMap.end_point.x = pos.HitPos.x
    OpenSurfMap.end_point.y = pos.HitPos.y
    OpenSurfMap.end_point.z = pos.HitPos.z
end

chatCommands["!setstartwidth"] = function(ply, strText, bTeam, bDead)
    local pos = ply:GetEyeTrace()
    OpenSurfMap.start_point.width = strText[2]
end

chatCommands["!setstartheight"] = function(ply, strText, bTeam, bDead)
    local pos = ply:GetEyeTrace()
    OpenSurfMap.start_point.height = strText[2]
end

chatCommands["!setstartdepth"] = function(ply, strText, bTeam, bDead)
    local pos = ply:GetEyeTrace()
    OpenSurfMap.start_point.depth = strText[2]
end

chatCommands["!setendwidth"] = function(ply, strText, bTeam, bDead)
    local pos = ply:GetEyeTrace()
    OpenSurfMap.end_point.width = strText[2]
end

chatCommands["!setendheight"] = function(ply, strText, bTeam, bDead)
    local pos = ply:GetEyeTrace()
    OpenSurfMap.end_point.height = strText[2]
end

chatCommands["!setenddepth"] = function(ply, strText, bTeam, bDead)
    local pos = ply:GetEyeTrace()
    OpenSurfMap.end_point.depth = strText[2]
end

chatCommands["!savezones"] = function(ply, strText, bTeam, bDead)
    meta_data = util.TableToJSON(OpenSurfMap, true)
    local ret = OpenSurfDataBase:UpdateMap(game.GetMap(), meta_data)
    if(ret == false) then
        ply:ChatPrint("Failed to save zones! (Check console for error)")
        print(sql.LastError())
    else
        ply:ChatPrint("Zones saved!")
    end
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