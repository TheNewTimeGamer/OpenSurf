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
end )

hook.Add( "PlayerSay", "OpenSurf.ChatCommands", function( ply, strText, bTeam, bDead ) 
    if(chatCommands[strText]) then
        return chatCommands[strText](ply, strText, bTeam, bDead)
    end
end )

function GM:InitPostEntity()
    print("Initializing OpenSurf Entities..")
	OpenSurfMap:spawnTriggerZones()
end

function GM:GetFallDamage(ply, speed)
    return false
end

function GM:PlayerNoClip(ply, desiredState)
    return true
end