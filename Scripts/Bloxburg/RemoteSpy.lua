--// function to convert a table to a formatted string (credits to aztup)

local table_print = loadstring(game:HttpGet("https://raw.githubusercontent.com/Introvert1337/RobloxReleases/main/Scripts/Utilities/TableFormatter.lua"))();

--// variables 

local remote_blacklist = {
    LookDir = true,
    GetServerTime = true,
    FloorPos = true
};

--// grab remotes 

local remotes = {};

local remote_added = getconnections(game:GetService("ReplicatedStorage").Modules.DataManager.DescendantAdded)[1].Function;
local remote_keys = getupvalue(remote_added, 1);

for remote_key, remote_name in next, getupvalue(getupvalue(remote_added, 2), 1) do
    remotes[remote_keys[remote_key]] = remote_name:sub(1, 2) == "F_" and remote_name:sub(3) or remote_name;
end;

--// remote call hook 

local old_namecall;
old_namecall = hookmetamethod(game, "__namecall", function(self, ...)
    local remote_name = remotes[self];
    
    if remote_name and not remote_blacklist[remote_name] then 
        local namecall_method = getnamecallmethod();

        if namecall_method == "FireServer" or namecall_method == "InvokeServer" then 
            local arguments = {...};
            
            local caller_info = getinfo(5, "sl") or getinfo(4, "sl");
            
            local source = caller_info.source;
            local line = ":" .. caller_info.currentline;
            
            arguments.__name = remote_name;
            arguments.__method = namecall_method;
            arguments.__source = source:sub(2, #source) .. line;

            rconsolewarn(table_print(arguments) .. "\n\n");
        end;
    end;
    
    return old_namecall(self, ...);
end);
