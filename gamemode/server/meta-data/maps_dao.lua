function OpenSurfDataBase:CreateMapsTable()
    return sql.Query("CREATE TABLE opensurf_maps( id NUMBER, name TEXT, meta_data TEXT )")
end

function OpenSurfDataBase:InsertMap(id, mapName, metaData)
    return sql.Query("INSERT INTO opensurf_maps VALUES(" .. id .. ", '" .. mapName .. "', '" .. metaData .. "')")
end

function OpenSurfDataBase:UpdateMap(mapName, metaData)
    return sql.Query("UPDATE opensurf_maps SET meta_data = '" .. metaData .. "' WHERE name = '" .. mapName .. "'")
end

function OpenSurfDataBase:GetMap(mapName)
    return sql.Query("SELECT * FROM opensurf_maps WHERE name = '" .. mapName .. "'")
end

function OpenSurfDataBase:GetAllMaps()
    return sql.Query("SELECT * FROM opensurf_maps")
end