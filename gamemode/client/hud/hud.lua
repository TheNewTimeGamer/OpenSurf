-- TNTG

function secondsToTimeStamp(seconds)
    if(seconds < 0) then
        return "00:00:00.00"
    end

    totalSeconds = math.floor(seconds)
    decimals = seconds - totalSeconds

    hours = math.floor(totalSeconds/3600)
    totalSeconds = totalSeconds - (hours * 360)
    minutes = math.floor(totalSeconds / 60) - (hours * 60)
    totalSeconds = totalSeconds - (minutes * 60)

    if(hours < 10) then
        hours = "0" .. hours
    end

    if(minutes < 10) then
        minutes = "0" .. minutes
    end

    if(totalSeconds < 10) then
        totalSeconds = "0" .. totalSeconds
    end
    
    decimals = math.Round(decimals*100)
    if(decimals < 10) then
        decimals = "0" .. decimals
    end
    return hours .. ":" .. minutes .. ":" .. totalSeconds .. "." .. decimals
end

OpenSurfHud = {
    trackedPlayer = LocalPlayer(),
    currentStartTime = 0,
    currentEndTime = 0,
    personalBestTime = 0,
    runStopped = true,
    worldRecordHolderTime = "00:00:00.00",
    worldRecordHolderName = "Unknown",
    isSpectating = false,
    isSpectatingThirdPerson = false,
    spectateIndex = 0,
    isThirdperson = false,
}

function OpenSurfHud:SetCurrentStartTime(time)
    self.currentStartTime = CurTime()
end

function OpenSurfHud:initialize()
    surface.CreateFont("OpenSurfFontNormal",{
        font = "CenterPrintText",
        size = 24,
        outline = true,
        antialias = false
    })

    surface.CreateFont("OpenSurfFontSmall",{
        font = "CenterPrintText",
        size = 16
    })


    hook.Add( "HUDShouldDraw", "OpenSurfDefault", function( name )
        if ( name == "CHudHealth" or name == "CHudBattery") then
            return false
        end        
        return true
    end )

    hook.Add( "HUDDrawTargetID", "OpenSurfTargetID", function()
        if(self.isSpectating) then
            return false
        end
    end )

    hook.Add("HUDPaint", "OpenSurfHud", function()
        if(!IsValid(self.trackedPlayer)) then
            self.trackedPlayer = LocalPlayer()
            return
        end
        local velocityVector = self.trackedPlayer:GetVelocity()
        local velocityX = math.abs(velocityVector.x)
        local velocityY = math.abs(velocityVector.y)
        local velocity = math.sqrt(math.pow(velocityX, 2) + math.pow(velocityY, 2))
        local factor = velocity/4000
        if(factor > 1.0) then
            factor = 1.0
        end
        
        surface.SetFont("OpenSurfFontNormal")
        surface.SetTextColor(255,255,255,255)
        surface.SetTextPos(34,surface.ScreenHeight()-128)
        surface.DrawText("Current Time: ", false)
        
        surface.SetTextColor(255,255,255,255)
        surface.SetTextPos(34,surface.ScreenHeight()-96)
        surface.DrawText("Personal Best: ", false)

        surface.SetTextColor(255,255,255,255)
        surface.SetTextPos(176,surface.ScreenHeight()-128)

        if(!self.runStopped) then
            surface.DrawText(secondsToTimeStamp(CurTime()-self.currentStartTime), false)
        else
            surface.DrawText(secondsToTimeStamp(self.currentEndTime-self.currentStartTime), false)
        end

        surface.SetTextColor(255,255,255,255)
        surface.SetTextPos(176,surface.ScreenHeight()-96)
        surface.DrawText(secondsToTimeStamp(self.personalBestTime), false)
        
        surface.SetDrawColor(255,255,255,75)
        surface.DrawRect(32,surface.ScreenHeight()-64,256,32)

        surface.SetDrawColor(0,0,255,245)
        surface.DrawRect(33,surface.ScreenHeight()-63,factor*254,30)

        surface.SetTextColor(255,255,255,255)
        surface.SetTextPos(150,surface.ScreenHeight()-61)
        surface.DrawText(math.Round(velocity), false)

        surface.SetTextColor(255,255,255,255)
        surface.SetTextPos(8,8)
        surface.DrawText(game.GetMap(), false)

        surface.SetFont("OpenSurfFontSmall")
        surface.SetTextColor(255,255,255,255)
        surface.SetTextPos(8,38)
        if(OpenSurfHud.worldRecordHolderTime == "00:00:00.00") then
            surface.DrawText("No world record yet!", false)
        else
            surface.DrawText("World Record: " .. OpenSurfHud.worldRecordHolderTime .. " by " .. OpenSurfHud.worldRecordHolderName, false)
        end
    end )

end