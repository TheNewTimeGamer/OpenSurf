-- TNTG

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
    self:NetworkVar("Vector", 0, "Position")
    self:NetworkVar("Vector", 1, "Dimensions")
end

function ENT:Initialize()
    self:AddEFlags( EFL_FORCE_CHECK_TRANSMIT )
    local Position = self:GetPosition()
    local Dimensions = self:GetDimensions()
    
    self:SetSolid(SOLID_BBOX)
    if(SERVER) then
        self:SetTrigger(true)
    else
        self:SetRenderBoundsWS(Vector(Position.x, Position.y, Position.z), Position + Dimensions)
    end
    self:SetNotSolid(true)
    self:SetCollisionBoundsWS(Vector(Position.x, Position.y, Position.z), Position + Dimensions)
end

function ENT:StartTouch(entity)
    if(!self:GetStartZone()) then
        local startTime, endTime = OpenSurfDataBase:FinishPlayerRun(entity:SteamID64())
        if(OpenSurfDataBase:IsValidRun(startTime, endTime)) then
            networking:SendLocalPlayerStateSignal(entity, 0, startTime, endTime)
            networking:SendLocalPlayerPersonalBest(entity)
        end
    else
        networking:SendLocalPlayerStateSignal(entity, 2)
    end
end

function ENT:EndTouch(entity)
    if(self:GetStartZone()) then
        local velocityVector = entity:GetVelocity()
        local velocityX = math.abs(velocityVector.x)
        local velocityY = math.abs(velocityVector.y)
        local velocity = math.sqrt(math.pow(velocityX, 2) + math.pow(velocityY, 2))
        if(velocity > 500) then
            velocityVector.z = 0
            local normalized = velocityVector:GetNormalized()
            entity:SetVelocity((entity:GetVelocity() * -1) + (normalized * 500))
        end

        networking:SendLocalPlayerStateSignal(entity, 1)
        OpenSurfDataBase:StartPlayerRun(entity:SteamID64())
    end
end

function ENT:UpdateTransmitState()	
	return TRANSMIT_ALWAYS 
end

function ENT:DrawTranslucent(flags)
    local position = self:GetPosition()
    local dimensions = self:GetDimensions()

    local groundOne     = Vector(position.x, position.y, position.z)
    local groundTwo     = Vector(position.x + dimensions.x, position.y, position.z)
    local groundThree   = Vector(position.x + dimensions.x, position.y + dimensions.y, position.z)
    local groundFour    = Vector(position.x, position.y + dimensions.y, position.z)

    local borderColor = Color(0,255,0,255)

    if(self:GetShouldDrawLines()) then
        local heightOffset = Vector(0,0,dimensions.z)

        -- Bottom
        render.DrawLine(groundOne, groundTwo, borderColor, true)
        render.DrawLine(groundTwo, groundThree, borderColor, true)
        render.DrawLine(groundThree, groundFour, borderColor, true)
        render.DrawLine(groundFour, groundOne, borderColor, true)

        -- Top
        render.DrawLine(groundOne   + heightOffset, groundTwo   + heightOffset, borderColor, true)
        render.DrawLine(groundTwo   + heightOffset, groundThree + heightOffset, borderColor, true)
        render.DrawLine(groundThree + heightOffset, groundFour  + heightOffset, borderColor, true)
        render.DrawLine(groundFour  + heightOffset, groundOne   + heightOffset, borderColor, true)

        -- Sides
        render.DrawLine(groundOne,   groundOne   + heightOffset, borderColor, true)
        render.DrawLine(groundTwo,   groundTwo   + heightOffset, borderColor, true)
        render.DrawLine(groundThree, groundThree + heightOffset, borderColor, true)
        render.DrawLine(groundFour,  groundFour  + heightOffset, borderColor, true)
    end

    if(self.Material and self:GetShouldDrawBeams()) then
        render.SetMaterial(self.Material)
        render.StartBeam(5)
        render.AddBeam(groundOne,   32, CurTime(), borderColor)
        render.AddBeam(groundTwo,   32, CurTime(), borderColor)
        render.AddBeam(groundThree, 32, CurTime(), borderColor)
        render.AddBeam(groundFour,  32, CurTime(), borderColor)
        render.AddBeam(groundOne,   32, CurTime(), borderColor)
        render.EndBeam()
    end
end