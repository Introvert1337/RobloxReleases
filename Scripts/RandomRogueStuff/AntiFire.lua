loadstring(game:HttpGet("https://raw.githubusercontent.com/Introvert1337/RobloxReleases/master/Scripts/Rogue_Lineage_Key_Fetcher.lua"))()

local player = game:GetService("Players").LocalPlayer; 
local character = player.Character or player.CharacterAdded:Wait();

local wait = wait;
local m_random = math.random;

local dodge_remote = get_remote("Dodge");

local function apply_antifire(character)
    character.ChildAdded:Connect(function(child)
        if child.Name == "Burning" then 
            wait();
            dodge_remote:FireServer({4, m_random()});
        end;
    end);
end;

apply_antifire(character);
player.CharacterAdded:Connect(apply_antifire);
