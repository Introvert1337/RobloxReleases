local player = game:GetService("Players").LocalPlayer;
local getinfo = getinfo or debug.getinfo;

local old_index;
old_index = hookmetamethod(game, "__index", function(self, idx)
    if self == player and idx == "CameraMaxZoomDistance" and getinfo(3).source:find("Input") then 
        return 50;
    end;
    
    return old_index(self, idx);
end);

player.CameraMaxZoomDistance = 9e9;
