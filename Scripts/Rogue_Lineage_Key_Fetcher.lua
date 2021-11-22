if getgenv().get_remote then return end;

--// wait until game loaded

if not game:IsLoaded() then 
    game.Loaded:Wait();
end;

--// variables/localizations

local getupvalue = getupvalue or debug.getupvalue;
local getupvalues = getupvalues or debug.getupvalues;
local setupvalue = setupvalue or debug.setupvalue;
local getinfo = getinfo or debug.getinfo;
local getconstants = getconstants or debug.getconstants;
local islclosure = islclosure or is_l_closure;
local getnamecallmethod = getnamecallmethod;

local t_find = table.find;
local t_wait = task.wait;
local c_yield = coroutine.yield;
local type = type;
local tonumber = tonumber;

local run_service = game:GetService("RunService");
local player = game:GetService("Players").LocalPlayer;

assert(hookmetamethod, "Exploit not supported!")

--// psu patcher (credit to sor) 

local dependencies = { -- how to get dependencies values: https://pastebin.com/raw/jE9RQW82
    psu_struct = {
        next = "sBgaL",
        rB = -50014
    },
    script_hash = "59b53f13c91177e3630a6e877d966ec5e272071125413b9f3c4604e824b8b6a1bb632563cc9ce33c70833edb032a6b06"
};

local function patch_method(upvalues, method)
    local instructions, stack;

    for index, upvalue in ipairs(upvalues) do 
        if type(upvalue) == "table" then
            local entry = upvalue[0];

            if entry then
                if type(entry) == "table" and entry[dependencies.psu_struct.next] then
                    instructions = upvalue;
                end;
            else
                stack = upvalue;
            end;
        end;
    end;

    if method == 1 then -- module type
        instructions[0] = instructions[#instructions - 5];
    elseif method == 2 then -- getkey type
        local cur_instr = 0;
        local to_patch;

        while true do 
            local instr = instructions[cur_instr];

            if instr and type(instr[dependencies.psu_struct.rB]) == "table" then 
                local success = true;

                for index = 1, 5 do 
                    if type(instructions[cur_instr + index][dependencies.psu_struct.rB]) ~= "table" then 
                        success = false;
                    end;
                end;

                if success then
                    local to_patch = instr;
                    local go_to = instr[dependencies.psu_struct.rB];

                    for index, value in next, go_to do 
                        to_patch[index] = value;
                    end;

                    cur_instr = t_find(instructions, go_to);

                    break;
                end;
            end;

            cur_instr = cur_instr + 1;
        end;
    end;
end;

--// check if keyhandler updated

local keyhandler = game:GetService("ReplicatedStorage"):WaitForChild("Assets"):WaitForChild("Modules"):WaitForChild("KeyHandler");
assert(getscripthash(keyhandler) == dependencies.script_hash, "keyhandler script updated!");

--// wait until character spawned

local character = player.Character;

if not character then 
    character = player.CharacterAdded:Wait();
end

character:WaitForChild("CharacterHandler"):WaitForChild("Input");

--// gc loop to find the dodge remote fpe key

local start_time = tick();
local dodge_fpe_key;

repeat -- repeating a gc loop is usually bad it should be fine in this case considering it will probably only ever repeat once
    for index, value in next, getgc() do 
        if islclosure(value) and getinfo(value).source:find("Input") then 
            local constants = getconstants(value);
            
            if t_find(constants, "SpeedBoost") and t_find(constants, "HasHammer") then 
                local dodge_function = getproto(value, 1);

                setupvalue(dodge_function, 1, function() end);
                setupvalue(dodge_function, 2,  function(key)
                    dodge_fpe_key = tonumber(("%0.50f"):format(key)); -- terrible method
                end);
                setupvalue(dodge_function, 3, tonumber);
                setupvalue(dodge_function, 4, tostring);
                setupvalue(dodge_function, 5, function() end);
                
                dodge_function();

                break
            end;
        end;
    end;
    
    if not dodge_fpe_key then 
        wait(1);
    end;
until dodge_fpe_key;

--// patch module and getkey function

local module = require(keyhandler);
patch_method(getupvalues(module), 1);

local get_key = module()[1];
patch_method(getupvalues(get_key), 2);

--// fetch remote functions

local area_client_connection_function, area_client_remote_function;

repeat 
    for index, connection in next, getconnections(run_service.RenderStepped) do 
        local connection_function = connection.Function;
        
        if type(connection_function) == "function" and getinfo(connection_function).source:find("AreaClient") then 
            area_client_connection_function = connection_function;
            area_client_remote_function = getupvalue(area_client_connection_function, 5);
        end;
    end;
    
    if not (area_client_connection_function and area_client_remote_function) then 
        wait(0.1);
    end;
until area_client_connection_function and area_client_remote_function;

--// utilities 

local area_markers_folder = workspace:WaitForChild("AreaMarkers");
local area_client = player.PlayerGui:WaitForChild("AreaGui"):WaitForChild("AreaClient");

local function get_fake_area()
    local current_area = getupvalue(area_client_remote_function, 2);
    
    for index, area in next, area_markers_folder:GetChildren() do 
        if area.Name ~= current_area then 
            return area;
        end;
    end;
end;

--// hook wait to stop detection loop in the areaclient script

local wait_hook;
wait_hook = hookfunction(wait, newcclosure(function(t)
    if getinfo(3).source:find("AreaClient") and not t then
        return c_yield();
    end;
    
    return wait_hook(t);
end));

--// hook raycast to make fake area 

local old_namecall;
old_namecall = hookmetamethod(game, "__namecall", function(self, ...)
    if self == workspace and getnamecallmethod() == "FindPartOnRayWithWhitelist" then 
        if getinfo(3, "f").func == area_client_connection_function and getupvalue(area_client_connection_function, 6) == 0 then
            local fake_area = get_fake_area();
    
            return fake_area, fake_area.Position, fake_area.Material;
        end;
    end;
    
    return old_namecall(self, ...);
end);

--// remote fetcher

getgenv().get_remote = function(remote_name)
    local remote;
    
    local old_upvalues = getupvalues(area_client_connection_function);
    local old_remote_upvalues = getupvalues(area_client_remote_function);
    
    setupvalue(area_client_remote_function, 3, function(fired_remote)
        remote = fired_remote;
        setupvalue(area_client_remote_function, 1, false);
    end);
    setupvalue(area_client_remote_function, 5, remote_name == "Dodge" and dodge_fpe_key or remote_name);
    setupvalue(area_client_remote_function, 6, function() end);
    
    setupvalue(area_client_connection_function, 6, 0);
    setupvalue(area_client_connection_function, 7, function() 
        return c_yield(); 
    end);
    
    while not remote do t_wait() end;

    setupvalue(area_client_connection_function, 6, old_upvalues[6]);
    setupvalue(area_client_connection_function, 7, old_upvalues[7]);

    setupvalue(area_client_remote_function, 3, old_remote_upvalues[3]);
    setupvalue(area_client_remote_function, 5, old_remote_upvalues[5]);
    setupvalue(area_client_remote_function, 6, old_remote_upvalues[6]);

    return remote;
end;

warn(("KeyHandler Bypass Loaded, Took %s"):format(tick() - start_time));
