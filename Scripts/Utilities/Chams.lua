-- yeah this was made in like 4 minutes and its bad but i was excited to use the new class :D
-- not bug tested well or anything

--// services

local players = game:GetService("Players");
local core_gui = game:GetService("CoreGui");

--// variables and shit

local local_player = players.LocalPlayer;

local chams_settings = {
    team_outline_color = Color3.new(1, 1, 1),
    enemy_outline_color = Color3.new(1, 1, 1),
    
    team_fill_color = Color3.new(0, 1, 0),
    enemy_fill_color = Color3.new(1, 0, 0),
    
    fill_transparency = 0,
    outline_transparency = 0,
    
    use_team_colors = false,
    show_team = true
};

local highlights = {};
local connections = {character_added = {}, character_removing = {}};

--// main esp stuff

local function remove_cham(player)
    local highlight = highlights[player];
        
    if highlight then 
        highlight:Destroy();
        highlights[player] = nil;
    end;
end;

local function apply_chams(player)
    local function on_character_added(character)
        local highlight = Instance.new("Highlight");
        
        highlight.Adornee = character;
        highlight.Parent = core_gui;
        
        highlight.OutlineTransparency = chams_settings.outline_transparency;
        highlight.FillTransparency = chams_settings.fill_transparency;
        
        highlights[player] = highlight;
    end;
    
    local character = player.Character;
    
    if character then 
        task.spawn(on_character_added, character);
    end;
    
    connections.character_added[player] = player.CharacterAdded:Connect(on_character_added);
    
    connections.character_removing[player] = player.CharacterRemoving:Connect(function()
        remove_cham(player);
    end);
end;

for index, player in next, players:GetPlayers() do 
    if player ~= local_player then
        task.spawn(apply_chams, player);
    end;
end; 

players.PlayerAdded:Connect(apply_chams);

players.PlayerRemoving:Connect(function(player)
    local character_added_connection, character_removing_connection = connections.character_added[player], connections.character_removing[player];
    
    if character_added_connection and character_removing_connection then 
        character_added_connection:Disconnect();
        character_removing_connection:Disconnect();
    end;
    
    remove_cham(player);
end);

game:GetService("RunService").Stepped:Connect(function() -- yeah sorry for ugly long lines in here
    for player, highlight in next, highlights do 
        local is_same_team = player.Team == local_player.Team;
        
        highlight.Enabled = chams_settings.show_team or not is_same_team;
        
        highlight.OutlineColor = is_same_team and chams_settings.team_outline_color or chams_settings.enemy_outline_color;
        highlight.FillColor = chams_settings.use_team_colors and player.TeamColor or (is_same_team and chams_settings.team_fill_color or chams_settings.enemy_fill_color);
    end;
end);
