--// variables 

local keys, network = loadstring(game:HttpGet("https://raw.githubusercontent.com/Introvert1337/RobloxReleases/main/Scripts/Jailbreak/KeyFetcher.lua"))();

--// no fall damage / no ragdoll

local player_utils = require(game:GetService("ReplicatedStorage").Game.PlayerUtils);

local old_is_point_in_tag = player_utils.isPointInTag;
player_utils.isPointInTag = function(point, tag)
    if tag == "NoRagdoll" or tag == "NoFallDamage" then 
        return true;
    end;
    
    return old_is_point_in_tag(point, tag);
end;

--// no damage 

local old_fire_server = getupvalue(network.FireServer, 1);
setupvalue(network.FireServer, 1, function(key, ...)
    if key == keys.Damage then 
        return;
    end;
    
    return old_fire_server(key, ...);
end);
