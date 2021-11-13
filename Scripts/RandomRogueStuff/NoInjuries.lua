-- this code is old and terrible, too lazy to rewrite

local collection_service = game:GetService("CollectionService");
local player = game:GetService("Players").LocalPlayer;
local character = player.Character or player.CharacterAdded:Wait();
local boosts = character:WaitForChild("Boosts");

local has_tag_hook;
has_tag_hook = hookfunction(collection_service.HasTag, function(self, instance, tag)
    if tag == "BrokenArm" or tag == "BrokenLeg" then 
        return false; 
    end;
    
    return has_tag_hook(self, instance, tag);
end);

local function speed_boost_added(speed_boost_instance)
    speed_boost_instance.Value = 0;
    
    speed_boost_instance:GetPropertyChangedSignal("Value"):Connect(function()
        if speed_boost_instance.Value == -6 then 
            speed_boost_instance.Value = 0;
        end;
    end);
end;

local function boosts_folder_added(boosts)
    for index, value in next, boosts:GetChildren() do
        if value:IsA("IntValue") and value.Name == "SpeedBoost" and value.Value == -6 then
            speed_boost_added(value);
        end;
    end;

    boosts.ChildAdded:Connect(function(child)
        if child:IsA("IntValue") and child.Name == "SpeedBoost" and child.Value == -6 then 
            speed_boost_added(child);
        end;
    end);
end;

boosts_folder_added(boosts);

player.CharacterAdded:Connect(function(character)
    local boosts = character:WaitForChild("Boosts");

    boosts_folder_added(boosts);
end);
