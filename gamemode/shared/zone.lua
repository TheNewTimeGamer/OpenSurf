function createZone(dimensions, isEnd)
    local entity = ents.Create("prop_static")
    local zone = {
        entity = entity,
        dimensions = dimensions,
        isEnd = isEnd
    }
    return zone
end