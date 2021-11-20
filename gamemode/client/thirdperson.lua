hook.Add( "CalcView", "ThirdPersonView", function( ply, pos, angles, fov )
	if OpenSurfHud.isThirdperson and ply:Alive() then
		local view = {}
		view.origin = pos - ( angles:Forward() * 90 ) + (angles:Right() * 3) + ( angles:Up() * 10 )
		--view.origin = pos - ( angles:Forward() * 70 )
		view.angles = ply:EyeAngles() + Angle( 1, 1, 0 )
		view.fov = fov
		return GAMEMODE:CalcView( ply, view.origin, view.angles, view.fov )
	end
end )

hook.Add( "ShouldDrawLocalPlayer", "ThirdPersonDrawPlayer", function()
	if (OpenSurfHud.isThirdperson) and LocalPlayer():Alive() then
		return true
	end
end )

function GM:ShowHelp(ply)
    -- TODO: Implement.
    return false
end

function GM:KeyPress(ply, key)
    if(key == IN_RELOAD) then
        if(OpenSurfHud.isSpectating) then
            if(OpenSurfHud.isSpectatingThirdPerson) then
                ply:SetObserverMode(OBS_MODE_IN_EYE)
                OpenSurfHud.isSpectatingThirdPerson = false
            else
                ply:SetObserverMode(OBS_MODE_CHASE)
                OpenSurfHud.isSpectatingThirdPerson = true
            end
        else
            OpenSurfHud.isThirdperson = !OpenSurfHud.isThirdperson
        end
    end
    if(key == IN_ATTACK) then
        if(OpenSurfHud.isSpectating) then
            cycleSpectate(ply)
            OpenSurfHud.spectateIndex = OpenSurfHud.spectateIndex + 1
        end
    end
    if(key == IN_ATTACK2) then
        if(OpenSurfHud.isSpectating) then
            cycleSpectate(ply)
            OpenSurfHud.spectateIndex = OpenSurfHud.spectateIndex - 1
        end
    end
end

function cycleSpectate(ply)
    players = ents.FindByClass("player_default")
    target = GetFirstNonMatching(ply, players, OpenSurfHud.spectateIndex)
    ply:SpectateEntity(target)
end