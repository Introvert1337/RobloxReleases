-- i released this to the bloxburg epic thing server (discord.gg/bloxburgepicthing) a while back, posting it here now
-- this is the only script i actually fully commented lol

--// env 

local getupvalue = getupvalue or debug.getupvalue;
local getinfo = getinfo or debug.getinfo;
local islclosure = islclosure or is_l_closure;
local getreg = getreg or debug.getregistry;
local getconstants = debug.getconstants or getconstants;

--// variables 

local remotes = {}; -- table that remotes will be stored in with name index

local data_manager = require(game:GetService("ReplicatedStorage").Modules.DataManager); -- data manager module
local hashes = getupvalue(getupvalue(data_manager.FireServer, 4), 3); -- table of remotes with keys
local remote_added; -- empty variable for function

--// locate remoteAdded function 

for index, value in next, getreg() do -- loop through registry
    if type(value) == "function" and islclosure(value) then -- checks if value is a function and lua closure
        local first_constant = getconstants(value)[1]; -- could getconstant(value, 1), this is to avoid constant index error
        local source_script = getinfo(value).source; -- script that function is in
        
        if first_constant == "tostring" and source_script:find("DataManager") then -- checks if first constant is tostring and script is DataManager
            remote_added = value; -- func that has remote name and key table upvalue, called on datamanager.descendantadded, but getconnections is unreliable
            break; -- breaks loop since function is found
        end;
    end;
end;

--// sort remotes

for index, value in next, getupvalue(getupvalue(remote_added, 2), 1) do -- loop through table that has remote name and key
    remotes[value:sub(1, 2) == "F_" and value:sub(3) or value] = hashes[index]; -- store remotes by name and instance
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
    
    return false; -- returns false if something fails
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
