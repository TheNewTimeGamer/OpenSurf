OpenSurfDataBase = {}

include("maps_dao.lua")
include("runs_dao.lua")

function CreateTables()
    if(!sql.TableExists("opensurf_runs")) then
        OpenSurfDataBase:CreateRunsTable()
    end
    if(!sql.TableExists("opensurf_maps")) then
        OpenSurfDataBase:CreateMapsTable()
    end
end

CreateTables()