--// variables

local get_remote = loadstring(game:HttpGet("https://raw.githubusercontent.com/Introvert1337/RobloxReleases/main/Scripts/Deepwoken/RemoteBypass.lua"))();

local fall_damage_remote = get_remote("FallDamage");

--// re-grab remote on respawn

game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function(character)
    fall_damage_remote = character:WaitForChild("CharacterHandler"):WaitForChild("Requests").FallDamage;
end);

--// main hook

local old_namecall;
old_namecall = hookmetamethod(game, "__namecall", function(self, ...)
    local namecall_method = getnamecallmethod();

    if namecall_method == "FireServer" or namecall_method == "fireServer" then
        if self == fall_damage_remote then
            return;
        end;
    end;

    return old_namecall(self, ...);
end);
