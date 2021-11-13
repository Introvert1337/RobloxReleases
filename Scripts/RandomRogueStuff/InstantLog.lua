local player = game:GetService("Players").LocalPlayer;

if player.Character then
    player.Character:Destroy();
end;

task.wait();

player:Kick("Instant Logged");
