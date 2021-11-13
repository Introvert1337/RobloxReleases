if getgenv().get_remote then return end;

--// wait until game loaded

if not game:IsLoaded() then 
    game.Loaded:Wait();
end;

--// localizations 

local getupvalue = getupvalue or debug.getupvalue;
local getupvalues = getupvalues or debug.getupvalues;
local setupvalue = setupvalue or debug.setupvalue;
local getinfo = getinfo or debug.getinfo;
local getconstants = getconstants or debug.getconstants;
local getconnections = getconnections or get_signal_cons;
local islclosure = islclosure or is_l_closure;
local getgc = getgc or get_gc_objects;

local t_find = table.find;
local t_wait = task.wait;
local c_yield = coroutine.yield;
local c_wrap = coroutine.wrap;
local type = type;
local tonumber = tonumber;

local run_service = game:GetService("RunService");

--// method patcher (credit to sor for the patcher) 

local psu_struct = {
    next = "sBgaL",
    rB = -50014
};

local function patch_method(upvalues, method)
    local instructions, stack;

    for index, upvalue in ipairs(upvalues) do 
        if type(upvalue) == "table" then
            local entry = upvalue[0];

            if entry then
                if type(entry) == "table" and entry[psu_struct.next] then
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

            if instr and type(instr[psu_struct.rB]) == "table" then 
                local success = true;

                for index = 1, 5 do 
                    if type(instructions[cur_instr + index][psu_struct.rB]) ~= "table" then 
                        success = false;
                    end;
                end;

                if success then
                    local to_patch = instr;
                    local go_to = instr[psu_struct.rB];

                    for index, val in next, go_to do 
                        to_patch[index] = val;
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

local key_handler = game:GetService("ReplicatedStorage"):WaitForChild("Assets"):WaitForChild("Modules"):WaitForChild("KeyHandler");
assert(getscripthash(key_handler) == "1e619fe2ee00718f0b70188beb78d3bf96f1d86f12141482ddeddf2f1216853df4846eb43b10dcd04bd8b594b3122ff0", "KeyHandler Script Updated!");

--// gc loop to find the dodge remote fpe key

local dodge_fpe_key;

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

--// patch module and getkey function

local module = require(key_handler);
patch_method(getupvalues(module), 1);

local get_key = module()[1];
patch_method(getupvalues(get_key), 2);

--// hook wait to stop detection loop in the areaclient script

local wait_hook;
wait_hook = hookfunction(wait, function(t)
    if getinfo(3).source:find("AreaClient") and not t then
        return c_yield();
    end;
    
    return wait_hook(t);
end);

--// function to grab a remote 

getgenv().get_remote = function(remote_name)
    local remote;
    
    for index, connection in next, getconnections(run_service.RenderStepped) do 
        local connection_function = connection.Function
        
        if type(connection_function) == "function" and getinfo(connection_function).source:find("AreaClient") then 
            local old_upvalues = getupvalues(connection_function);
            local remote_function = old_upvalues[5];
            local old_remote_upvalues = getupvalues(remote_function);
            
            setupvalue(remote_function, 5, remote_name == "Dodge" and dodge_fpe_key or remote_name);
            setupvalue(remote_function, 6, function() end);
            setupvalue(remote_function, 3, function(fired_remote)
                remote = fired_remote;
                setupvalue(remote_function, 1, false);
                return;
            end);
            
            setupvalue(connection_function, 4, "");
            setupvalue(connection_function, 6, 0);
            setupvalue(connection_function, 7, function() 
                return c_yield(); 
            end);
            
            while not remote do t_wait() end;
    
            setupvalue(connection_function, 4, old_upvalues[4]);
            setupvalue(connection_function, 6, old_upvalues[6]);
            setupvalue(connection_function, 7, old_upvalues[7]);

            setupvalue(remote_function, 3, old_remote_upvalues[3]);
            setupvalue(remote_function, 5, old_remote_upvalues[5]);
            setupvalue(remote_function, 6, old_remote_upvalues[6]);
        
            return remote;
        end;
    end;
end;
