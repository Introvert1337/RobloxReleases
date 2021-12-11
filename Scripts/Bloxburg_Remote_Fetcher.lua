--// variables 

local remotes = {}; -- table that remotes will be stored in with name index

local data_manager = require(game:GetService("ReplicatedStorage").Modules.DataManager); -- data manager module
local hashes = getupvalue(getupvalue(data_manager.FireServer, 4), 3); -- table of remotes with keys

--// locate remoteAdded function 

local registry = getreg();

for index = 1, #registry do -- loop through registry
    local value = registry[index]; -- get the value of the registry at the current for loop index
    
    if type(value) == "function" and islclosure(value) then -- checks if value is a function and lua closure
        if getconstants(value)[1] == "tostring" and getinfo(value).source:find("DataManager") then -- checks if first constant is tostring and script is DataManager
            for hash, name in next, getupvalue(getupvalue(value, 2), 1) do
                remotes[name:sub(1, 2) == "F_" and name:sub(3) or name] = hashes[hash]; -- sort remotes and remove prefix from some
            end;

            break;
        end;
    end;
end;

--// call remote

local function call_remote(name, arguments)
    local remote_instance = remotes[tostring(name)]; -- gets remote instance from remote table
    
    if remote_instance then -- checks if remote instance exists
        if remote_instance.ClassName == "RemoteEvent" then -- if remote is a remoteevent
            return remote_instance:FireServer(arguments); -- fires remote with specified arguments
        elseif remote_instance.ClassName == "RemoteFunction" then -- if remote is a remotefunction
            return remote_instance:InvokeServer(arguments); -- invokes remote with specified arguments
        end;
    end;
end;

--// example

--[[

local player = game:GetService("Players").LocalPlayer;
local character = player.Character or player.CharacterAdded:Wait();

local plot_cframe = call_remote("ToPlot", {
    Player = player;
});

character:SetPrimaryPartCFrame(plot_cframe);

]]
