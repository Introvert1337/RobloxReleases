local player = game:GetService("Players").LocalPlayer;
local character = player.Character or player.CharacterAdded:Wait();
local speed = 100; -- change to change speed boost

local function apply_speed(character, speed)
    local speed_boost = Instance.new("NumberValue");
    
    speed_boost.Name = "SpeedBoost";
    speed_boost.Value = speed;
    speed_boost.Parent = character:WaitForChild("Boosts");
end;

apply_speed(character, speed);

player.CharacterAdded:Connect(function(character)
    apply_speed(character, speed);
end);
