local player = game:GetService("Players").LocalPlayer;
local checkcaller = checkcaller;

local ffc_hook;
ffc_hook = hookfunction(game.FindFirstChild, newcclosure(function(instance, find)
    if not checkcaller() and instance == player.Character and find == "Confused" then 
        return false;
    end;
    
    return ffc_hook(instance, find);
end));
