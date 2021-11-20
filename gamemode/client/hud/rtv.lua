OpenSurfHud.rtv = {}
OpenSurfHud.rtv.enabled = false
OpenSurfHud.rtv.maps = {}

OpenSurfHud.rtv.maps[1] = {
    name = "surf_beginner",
    enabled = false
}

hook.Add("HUDPaint", "OpenSurfHudRtv", function()
    surface.SetDrawColor( 0, 0, 0, 128 )
	surface.DrawRect( 5, 75, 256, 516 )

    for k, v in pairs(OpenSurfHud.rtv.maps) do
        local x = 5
        local y = 75 + (k-1)*32
        local w = 256
        local h = 32
        local color = Color(255,255,255,255)
        if v.enabled then
            color = Color(0,255,0,255)
        else
            color = Color(255,255,255,255)
        end
        surface.SetDrawColor(color)
        surface.DrawRect(x,y,w,h)
        surface.SetTextColor(0,0,0,255)
        surface.SetTextPos(x+2,y+2)
        surface.DrawText(v.name)
    end

end )