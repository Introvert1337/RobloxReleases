--// localizations 

local getupvalue = getupvalue or debug.getupvalue;
local getupvalues = getupvalues or debug.getupvalues;
local getinfo = getinfo or debug.getinfo;
local checkcaller = checkcaller;

local type = type;
local typeof = typeof;
local rawget = rawget;

--// init variables

local replicated_storage = game:GetService("ReplicatedStorage");
local remote_folder = replicated_storage.Remote;

local remote_function = getupvalue(require(replicated_storage.Scripts.ShipPurchaseModule).ShowAvailableShips, 2);

--// bypass env checks

local old_getfenv;
old_getfenv = replaceclosure(getfenv, function(level)
    if level == 2 then 
        local info = getinfo(3);
        
        if info and info.source:find("ClientLib") then
            local env_upvalue = getupvalues(info.func)[1];
            
            if type(env_upvalue) == "table" and rawget(env_upvalue, "script") then 
                return env_upvalue;
            end;
        end;
    end;
    
    return old_getfenv(level);
end);

--// function to fire remote            
                                                
getgenv().fire_remote = function(remote, ...)
    local remote = typeof(remote) == "Instance" and remote or type(remote) == "string" and remote_folder:FindFirstChild(remote);

    if remote then 
        return remote_function(remote, ...);
    end;
    
    return false;
end;
