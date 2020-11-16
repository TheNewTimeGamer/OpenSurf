-- CreateMove allows you to change the player's movements before they are send to the server.
-- This script checks the following:
-- 1. If the player is on the ground.
-- 2. If the player is submerged.
-- 3. If the player is on a ladder.
-- If all these conditions are true, the jump command is removed from the move set.
-- This essentially tells the client that it isn't jumping anymore as soon as it leaves the ground, allowing the next jump to be queued without delay.

-- WaterLevel
-- 0 - The entity isn't in water.
-- 1 - Slightly submerged (at least to the feet).
-- 2 - The majority of the entity is submerged (at least to the waist).
-- 3 - Completely submerged.

hook.Add( "CreateMove", "OpenSurf.AutoBhop", function(e)
    if e:KeyDown( IN_JUMP ) then
        if !LocalPlayer():IsOnGround() && LocalPlayer():WaterLevel() < 2 then
            if LocalPlayer():GetMoveType() != MOVETYPE_LADDER then
                e:RemoveKey( IN_JUMP )
            end
        end
	end
end )