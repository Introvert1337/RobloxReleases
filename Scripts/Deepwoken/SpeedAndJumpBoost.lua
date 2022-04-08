--// variables

local player = game:GetService("Players").LocalPlayer;

local walk_speed, jump_power = shared.walk_speed or 150, shared.jump_power or 250;

--// main hook 

local old_newindex
old_newindex = hookmetamethod(game, "__newindex", function(self, index, value)
    if not checkcaller() then
        if index == "WalkSpeed" or index == "JumpPower" then 
            local character = player.Character;

            if character then 
                local humanoid = character:FindFirstChildOfClass("Humanoid");

                if humanoid and self == humanoid then
                    return old_newindex(self, index, index == "WalkSpeed" and walk_speed or jump_power);
                end;
            end;
        end;
    end;

    return old_newindex(self, index, value);
end);
