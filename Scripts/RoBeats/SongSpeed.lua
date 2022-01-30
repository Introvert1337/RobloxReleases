--// variables

local song_speed = shared.song_speed or 2;

local camera = workspace.CurrentCamera;

--// grab dependecies and main hook 

for index, module in next, getloadedmodules() do 
    local module_data = require(module);
    
    if type(module_data) == "table" then 
        if rawget(module_data, "get_local_elements_folder") then 
            module_data:get_local_elements_folder().ChildAdded:Connect(function(child)
                if child.ClassName == "Sound" then 
                    child:GetPropertyChangedSignal("PlaybackSpeed"):Connect(function()
                        child.PlaybackSpeed = song_speed; -- speed up song
                    end);
                end;
            end);
        else 
            local timescale_to_delta_time = rawget(module_data, "TimescaleToDeltaTime");
            
            if timescale_to_delta_time then 
                module_data.TimescaleToDeltaTime = function(...)
                    local arguments = {...};
                    
                    if camera.CameraType == Enum.CameraType.Scriptable then -- easy way to see if in a game
                        arguments[2] = arguments[2] * song_speed;
                    end;
                    
                    return timescale_to_delta_time(unpack(arguments));
                end;
            end;
        end;
    end;
end;
