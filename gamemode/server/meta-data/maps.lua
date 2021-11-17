-- TNTG

OpenSurfMap = util.JSONToTable(OpenSurfDataBase:GetMap(game.GetMap())[1].meta_data)
OpenSurfMap.trigger_zone_start = nil
OpenSurfMap.trigger_zone_end = nil
OpenSurfMap.trigger_zone_start_center = nil -- TODO: Add nicer way of storing this.

function OpenSurfMap:spawnTriggerZones()
    if(!self.start_point) then print("Missing map start_point.") return end
    if(!self.end_point) then print("Missing map end_point.") return end

    self.trigger_zone_end = ents.Create("trigger_zone")

    local endPoint = OpenSurfMap.end_point;

    self.trigger_zone_end:SetPos(Vector(endPoint.x, endPoint.y, endPoint.z))
    self.trigger_zone_end:SetShouldDrawBeams(endPoint.drawBeams)
    self.trigger_zone_end:SetShouldDrawLines(endPoint.drawLines)

    self.trigger_zone_end:SetStartZone(false)
    self.trigger_zone_end:SetPosition(Vector(endPoint.x, endPoint.y, endPoint.z))
    self.trigger_zone_end:SetDimensions(Vector(endPoint.width, endPoint.depth, endPoint.height))
    self.trigger_zone_end:Spawn()

    ---------------------------------------------------------------------

    self.trigger_zone_start = ents.Create("trigger_zone")

    local startPoint = OpenSurfMap.start_point;

    self.trigger_zone_start:SetPos(Vector(startPoint.x, startPoint.y, startPoint.z))
    self.trigger_zone_start:SetShouldDrawBeams(startPoint.drawBeams)
    self.trigger_zone_start:SetShouldDrawLines(startPoint.drawLines)

    self.trigger_zone_start:SetStartZone(true)
    self.trigger_zone_start:SetPosition(Vector(startPoint.x, startPoint.y, startPoint.z))
    self.trigger_zone_start:SetDimensions(Vector(startPoint.width, startPoint.depth, startPoint.height))
    self.trigger_zone_start_center = Vector(startPoint.x + startPoint.width / 2, startPoint.y + startPoint.depth / 2, startPoint.z)
    self.trigger_zone_start:Spawn()
end