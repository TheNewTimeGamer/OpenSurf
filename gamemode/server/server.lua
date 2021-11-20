-- TNTG

RunConsoleCommand("sv_gravity", "600")
RunConsoleCommand("sv_airaccelerate", "1000")
RunConsoleCommand("sv_sticktoground", "0")

hook.Add( "PlayerSetModel", "OpenSurf.SetPlayerModel", function(ply)
    ply:SetModel("models/player/odessa.mdl")
    ply:SetTeam(1)
    ply:SetWalkSpeed(250)
    ply:SetRunSpeed(ply:GetWalkSpeed())
    ply:SetJumpPower(200)
    ply:SetNoCollideWithTeammates(true)

    networking:SendLocalPlayerPersonalBest(ply)
    networking:SendLocalPlayerCurrentWorldRecord(ply)

    if(OpenSurfMap.trigger_zone_start_center) then
        ply:SetPos(OpenSurfMap.trigger_zone_start_center)
        ply:SetEyeAngles((OpenSurfMap.trigger_zone_start_angles))
    end
end )

hook.Add( "PlayerSay", "OpenSurf.ChatCommands", function( ply, strText, bTeam, bDead )
    local args = string.Split(strText, " ")
    if(chatCommands[args[1]]) then
        return chatCommands[args[1]](ply, args, bTeam, bDead)
    end
end )

function GM:InitPostEntity()
	OpenSurfMap:spawnTriggerZones()
end

function GM:GetFallDamage(ply, speed)
    return false
end

function GM:PlayerNoClip(ply, desiredState)
    return true
end

function GM:ShowSpare1(ply)
    networking:ToggleLocalPlayerScreenClicker(ply)
end