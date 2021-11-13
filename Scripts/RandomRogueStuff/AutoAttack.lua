local player = game:GetService("Players").LocalPlayer;
local m_random = math.random;
local t_wait = task.wait;

while wait(0.1) do 
    if player.Character and player.Character:FindFirstChild("CharacterHandler") and player.Character.CharacterHandler:FindFirstChild("Remotes") then
        local remotes = player.Character.CharacterHandler.Remotes;
        
        if remotes:FindFirstChild("LeftClick") and remotes:FindFirstChild("LeftClickRelease") then
            remotes.LeftClick:FireServer({m_random(1, 10), m_random()});
            t_wait();
            remotes.LeftClickRelease:FireServer({m_random(1, 10), m_random()});
        end;
    end;
end;
