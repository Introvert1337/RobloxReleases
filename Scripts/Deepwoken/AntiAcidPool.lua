--// variables

local acid_check_remote = game:GetService("ReplicatedStorage").Requests.AcidCheck;

--// main hook

local old_namecall;
old_namecall = hookmetamethod(game, "__namecall", function(self, ...)
    if self == acid_check_remote then
        local namecall_method = getnamecallmethod();
    
        if namecall_method == "FireServer" or namecall_method == "fireServer" then
            return;
        end;
    end;

    return old_namecall(self, ...);
end);
