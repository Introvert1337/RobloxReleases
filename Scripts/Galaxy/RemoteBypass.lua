--// variables

local replicated_storage = game:GetService("ReplicatedStorage");
local remote_folder = replicated_storage.Remote;

local remote_function = getupvalue(require(replicated_storage.Scripts.ShipPurchaseModule).ShowAvailableShips, 2);
local valid_env = getupvalue(remote_function, 2);
	
--// bypass env checks

replaceclosure(getfenv(remote_function).getfenv, newcclosure(function()
    return valid_env;
end));

--// function to fire remote            
                                                
return function(remote, ...)
    local remote = typeof(remote) == "Instance" and remote or type(remote) == "string" and remote_folder:FindFirstChild(remote);

    if remote then 
        return remote_function(remote, ...);
    end;
end;
