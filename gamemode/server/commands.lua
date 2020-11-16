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
