-- Server Init

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "client/autobhop.lua" )
AddCSLuaFile( "client/hud.lua" )
AddCSLuaFile( "client/networking.lua")

AddCSLuaFile( "shared.lua" )

include("server/meta-data/maps.lua")
include("server/meta-data/db.lua")

include( "server/server.lua" )
include( "server/networking.lua" )
include( "server/commands.lua" )

include( "shared.lua" )
