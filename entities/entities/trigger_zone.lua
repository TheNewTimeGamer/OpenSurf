AddCSLuaFile()

ENT.Base = "trigger_zone"
ENT.Type = "anim"
ENT.PrintName = "OpenSurf Trigger Zone"
ENT.Material = Material("effects/blueblacklargebeam.vmt")
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

function ENT:SetupDataTables()
    self:NetworkVar("Bool", 0, "StartZone")
    self:NetworkVar("Bool", 1, "ShouldDrawBeams")
    self:NetworkVar("Bool", 2, "ShouldDrawLines")
    self:NetworkVar("Vector", 0, "MinBounds")
    self:NetworkVar("Vector", 1, "MaxBounds")
end

function ENT:Initialize()
    self:AddEFlags( EFL_FORCE_CHECK_TRANSMIT )
    local minBounds = self:GetMinBounds()
    local maxBounds = self:GetMaxBounds()
    
    self:SetSolid(SOLID_BBOX)
    if(SERVER) then
        self:SetTrigger(true)
    else
        self:SetRenderBoundsWS(Vector(minBounds.x, minBounds.y, minBounds.z), Vector(maxBounds.x, maxBounds.y, maxBounds.z))
    end
    self:SetNotSolid(true)
    self:SetCollisionBoundsWS(Vector(minBounds.x, minBounds.y, minBounds.z), Vector(maxBounds.x, maxBounds.y, maxBounds.z))
end

function ENT:StartTouch(entity)
    if(!self:GetStartZone()) then
        times = OpenSurfDataBase:FinishPlayerRun(entity:SteamID64())
        if(OpenSurfDataBase:IsValidRun(times)) then
            networking:SendLocalPlayerStateSignal(entity, 0, times.runStartTime, times.runEndTime)
            networking:SendLocalPLayerPersonalBest(entity)
        end
    else
        networking:SendLocalPlayerStateSignal(entity, 2)
    end
end

function ENT:EndTouch(entity)
    if(self:GetStartZone()) then
        local velocityVector = entity:GetVelocity()
        local totalVelocity = math.abs(velocityVector.x) + math.abs(velocityVector.y) + math.abs(velocityVector.z)
        if(totalVelocity > 500) then
            entity:SetPos(self:GetPos())
        end

        networking:SendLocalPlayerStateSignal(entity, 1)
        OpenSurfDataBase:StartPlayerRun(entity:SteamID64())
    end
end

function ENT:UpdateTransmitState()	
	return TRANSMIT_ALWAYS 
end

function ENT:Draw(flags)
    -- Not Necessary For This Element.
end

function ENT:DrawTranslucent(flags)
    self:Draw(flags)
    
    groundOne = self:GetMinBounds()
    groundOne = Vector(groundOne.x, groundOne.y, groundOne.z)

    groundThree = self:GetMaxBounds()
    groundThree = Vector(groundThree.x, groundThree.y, groundOne.z)

    groundTwo = Vector(groundThree.x, groundOne.y, groundOne.z)
    groundFour = Vector(groundOne.x, groundThree.y, groundOne.z)

    local borderColor = Color(0,255,0,255)

    if(self:GetShouldDrawLines()) then
        local heightOffset = Vector(0,0,self:GetMaxBounds().z - groundOne.z)
        -- TO-DO: Make less instense
        render.DrawLine(groundOne + heightOffset, groundTwo + heightOffset, borderColor, true)
        render.DrawLine(groundTwo + heightOffset, groundThree + heightOffset, borderColor, true)
        render.DrawLine(groundThree + heightOffset, groundFour + heightOffset, borderColor, true)
        render.DrawLine(groundFour + heightOffset, groundOne + heightOffset, borderColor, true)

        render.DrawLine(groundOne, groundOne + heightOffset, borderColor, true)
        render.DrawLine(groundTwo, groundTwo + heightOffset, borderColor, true)
        render.DrawLine(groundThree, groundThree + heightOffset, borderColor, true)
        render.DrawLine(groundFour, groundFour + heightOffset, borderColor, true)

        render.DrawLine(groundOne, groundTwo, borderColor, true)
        render.DrawLine(groundTwo, groundThree, borderColor, true)
        render.DrawLine(groundThree, groundFour, borderColor, true)
        render.DrawLine(groundFour, groundOne, borderColor, true)
    end

    if(self.Material && self:GetShouldDrawBeams()) then
        render.SetMaterial(self.Material)
        render.StartBeam(5)
        render.AddBeam(groundOne, 32, CurTime(), borderColor)
        render.AddBeam(groundTwo, 32, CurTime(), borderColor)
        render.AddBeam(groundThree, 32, CurTime(), borderColor)
        render.AddBeam(groundFour, 32, CurTime(), borderColor)
        render.AddBeam(groundOne, 32, CurTime(), borderColor)
        render.EndBeam()
    end
end