-- Server Init

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "client/autobhop.lua" )
AddCSLuaFile( "client/hud.lua" )
AddCSLuaFile( "client/networking.lua")

AddCSLuaFile( "shared.lua" )

print("Database")
include("server/meta-data/database.lua")
print("runs")
include("server/meta-data/runs.lua")
print("maps")
include("server/meta-data/maps.lua")

include( "server/networking.lua" )

print("server")
include( "server/server.lua" )
include( "server/commands.lua" )

include( "shared.lua" )
