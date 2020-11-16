-- Client Init

include( "shared.lua" )
include( "client/autobhop.lua")
include( "client/hud.lua" )
include( "client/networking.lua" )


hook.Add( "InitPostEntity", "OpenSurf.PostInitialization", function()
	openSurfHud:initialize()	
end )