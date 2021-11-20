OpenSurfHud.rtv = {}
OpenSurfHud.rtv.enabled = false
OpenSurfHud.rtv.maps = {}


hook.Add("HUDPaint", "OpenSurfHudRtv", function()
    surface.SetDrawColor( 0, 0, 0, 128 )
	surface.DrawRect( 5, 75, 256, 516 )
end )