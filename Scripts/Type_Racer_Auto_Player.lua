--// wait until game is loaded 

if not game:IsLoaded() then 
    game.Loaded:Wait();
end;

--// init variables

local player = game:GetService("Players").LocalPlayer;
local http_service = game:GetService("HttpService");
local on_typed = game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("OnTyped");

local cam_part = workspace:WaitForChild("CamPart");

local race_text_box = player.PlayerGui:WaitForChild("ScreenGui"):WaitForChild("Main"):WaitForChild("RaceScreen"):WaitForChild("TextBox");
local race_text_changed = getconnections(race_text_box:GetPropertyChangedSignal("Text"))[1].Function;

local wait_time = shared.wait_time and math.clamp(shared.wait_time / 1000, 0.04, math.huge) or 0.04;

--// wait until round has begun 

while not getupvalue(race_text_changed, 5) do 
    wait();
end;

--// typing functions & utilities

local player_environments = getupvalue(race_text_changed, 3);
local keys = getupvalue(race_text_changed, 4);
local virtual = getupvalue(race_text_changed, 7);
local encryption = getupvalue(race_text_changed, 8);
local game_settings = getupvalue(race_text_changed, 12);

local index_key = getconstant(race_text_changed, 8);

--// loop through keys and type them

for index = 1, #keys do
    virtual(player);
    
    on_typed:FireServer(encryption(http_service:JSONEncode({
        [index_key] = index
    }), 10));

    cam_part.Position = player_environments[player].letterParts[index].Position + Vector3.new(game_settings.camDistance, game_settings.camHeight, 0);
    
    wait(wait_time);
end;
