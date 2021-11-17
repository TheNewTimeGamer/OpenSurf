function OpenSurfDataBase:CreateRunsTable()
    return sql.Query("CREATE TABLE opensurf_runs( id NUMBER, steam_id TEXT, start_time INTEGER, end_time INTEGER, map TEXT, category INTEGER, date TEXT )")
end

function OpenSurfDataBase:DeleteMap(mapName)
    return sql.Query("DELETE FROM opensurf_maps WHERE name = " .. mapName)
end

function OpenSurfDataBase:InsertRun(id, steamId, startTime, endTime, mapName, category, date)
    return sql.Query("INSERT INTO opensurf_runs VALUES(" .. id .. ", '" .. steamId .. "', " .. startTime .. ", " .. endTime .. ", '" .. mapName .. "', " .. category .. ", '" .. date .. "')")
end

function OpenSurfDataBase:UpdateRun(startTime, endTime, mapName, category)
    return sql.Query("UPDATE opensurf_runs SET start_time = " .. startTime .. ", end_time = " .. endTime .. ", map = '" .. mapName .. "', category = " .. category .. " WHERE id = " .. id)
end

function OpenSurfDataBase:DeleteRun(id)
    return sql.Query("DELETE FROM opensurf_runs WHERE id = " .. id)
end

function OpenSurfDataBase:GetWorldRecord(mapName, category)
    return sql.Query("SELECT * FROM opensurf_runs WHERE map = '" .. mapName .. "' AND category = " .. category .. " ORDER BY end_time - start_time ASC LIMIT 1")
end

function OpenSurfDataBase:GetPersonalBest(steamId, mapName, category)
    return sql.Query("SELECT * FROM opensurf_runs WHERE steam_id = '" .. steamId .. "' AND map = '" .. mapName .. "' AND category = " .. category .. " ORDER BY end_time - start_time ASC LIMIT 1")
end

function GetAllRuns()
    return sql.Query("SELECT * FROM opensurf_runs")
end