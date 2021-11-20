-- Server Init

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "client/autobhop.lua" )
AddCSLuaFile( "client/hud/hud.lua" )
AddCSLuaFile( "client/hud/rtv.lua" )
AddCSLuaFile( "client/networking.lua")
AddCSLuaFile( "client/thirdperson.lua")

AddCSLuaFile( "shared.lua" )

include("server/meta-data/database.lua")
include("server/meta-data/runs.lua")
include("server/meta-data/maps.lua")

include( "server/networking.lua" )

include( "server/server.lua" )
include( "server/commands.lua" )

include( "shared.lua" )
