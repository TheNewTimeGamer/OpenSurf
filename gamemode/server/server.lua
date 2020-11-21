-- TNTG

print("Server.lua")

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

    local localPlayerData = OpenSurfDataBase:ReadPlayerDataFromDisk(ply:SteamID64())
    networking:SendLocalPLayerPersonalBest(ply)

    local worldRecord = OpenSurfDataBase.worldRecord
    local runTime = calculateRunDuration(OpenSurfDataBase:GetCurrentWorldRecord())
    if(runTime) then
        networking:SendLocalPlayerCurrentWorldRecord(ply, worldRecord.playerIndex, runTime)
    end

end )

hook.Add( "PlayerSay", "OpenSurf.ChatCommands", function( ply, strText, bTeam, bDead ) 
    if(chatCommands[strText]) then
        return chatCommands[strText](ply, strText, bTeam, bDead)
    end
end )

function GM:InitPostEntity()
    print("Initializing OpenSurf Entities..")
    OpenSurfDataBase:ReadMetaDataFromDisk()
	spawnTriggerZones()
end

function GM:GetFallDamage(ply, speed)
    return false
end