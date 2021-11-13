local areamarkers = workspace:WaitForChild("AreaMarkers");
local type, areamarkers_ffc = type, areamarkers.FindFirstChild;

local remote_event_hook;
remote_event_hook = hookfunction(Instance.new("RemoteEvent").FireServer, newcclosure(function(self, ...)
    local arguments = {...};

    if #arguments == 1 and type(arguments[1]) == "string" and areamarkers_ffc(areamarkers, arguments[1]) then 
        return;
    end;

    return remote_event_hook(self, ...);
end));
