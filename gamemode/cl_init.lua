-- Client Init

include( "shared.lua" )
include( "client/autobhop.lua")
include( "client/hud/hud.lua" )
include( "client/hud/rtv.lua" )
include( "client/networking.lua" )
include( "client/thirdperson.lua" )


hook.Add( "InitPostEntity", "OpenSurf.PostInitialization", function()
	OpenSurfHud:initialize()
end )