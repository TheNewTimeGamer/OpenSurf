--include("db.lua")

function startPoint(minX,minY,minZ,maxX,maxY,maxZ,angle,shouldDrawBeams)
    obj = {minX = minX, minY = minY, minZ = minZ, maxX = maxX, maxY = maxY, maxZ = maxZ, angle = angle, shouldDrawBeams = shouldDrawBeams}
    function obj:GetCenter()
        return Vector(minX + (maxX-minX)/2, minY + (maxY-minY)/2, minZ + (maxZ-minZ)/2)
    end
    function obj:GetCenterFloor()
        return Vector(minX + (maxX-minX)/2, minY + (maxY-minY)/2, minZ)
    end
    return obj
end

function endPoint(minX,minY,minZ,maxX,maxY,maxZ,angle,shouldDrawBeams)
    return startPoint(minX,minY,minZ,maxX,maxY,maxZ,angle,shouldDrawBeams)
end

function map(startPoint,endPoint)
    return {startPoint=startPoint, endPoint=endPoint}
end

maps = {}
maps["surf_beginner"] = map(
    startPoint(-440, 250, 320, 180, -50, 400, 90, true),
    endPoint(-6067, 4876, -263, -4556, 5230, -400, 90, true)
)

maps["surf_kitsune"] = map(
    startPoint(-247, -946, 100, 248, -613, 200, 0, false),
    endPoint(-16036, 10554, -11935, -15553, 9829, -11771, 0, false)
)

function spawnTriggerZones()
    ent = ents.Create("trigger_zone")

    local endPoint = maps[game.GetMap()].endPoint;
    local minBounds = Vector(endPoint.minX, endPoint.minY, endPoint.minZ)
    local maxBounds = Vector(endPoint.maxX, endPoint.maxY, endPoint.maxZ)

    ent:SetPos(endPoint:GetCenter())
    ent:SetShouldDrawBeams(endPoint.shouldDrawBeams)

    ent:SetStartZone(false)
    ent:SetMinBounds(minBounds)
    ent:SetMaxBounds(maxBounds)
    ent:Spawn()

    ---------------------------------------------------------------------

    ent = ents.Create("trigger_zone")

    local startPoint = maps[game.GetMap()].startPoint;
    local minBounds = Vector(startPoint.minX, startPoint.minY, startPoint.minZ)
    local maxBounds = Vector(startPoint.maxX, startPoint.maxY, startPoint.maxZ)

    ent:SetPos(startPoint:GetCenter())
    ent:SetShouldDrawBeams(startPoint.shouldDrawBeams)

    ent:SetStartZone(true)
    ent:SetMinBounds(minBounds)
    ent:SetMaxBounds(maxBounds)
    ent:Spawn()
end