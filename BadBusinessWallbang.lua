local Raycast = require(game:GetService("ReplicatedStorage").TS).Raycast

if shared.WallbangEnabled == true then
    debug.setupvalue(Raycast.CastGeometryAndEnemies, 1, nil)
    debug.setupvalue(Raycast.CastGeometryAndEnemies, 2, nil)
else 
    debug.setupvalue(Raycast.CastGeometryAndEnemies, 1, workspace.Geometry)
    debug.setupvalue(Raycast.CastGeometryAndEnemies, 2, workspace.Terrain)
end
