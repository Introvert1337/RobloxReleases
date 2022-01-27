--// Game Loaded

if not game:IsLoaded() then 
    game.Loaded:Wait();
end;

--// Localizations 

local getupvalue = getupvalue or debug.getupvalue;
local setupvalue = setupvalue or debug.setupvalue;
local getupvalues = getupvalues or debug.getupvalues;
local setconstant = setconstant or debug.setconstant;
local getconstants = getconstants or debug.getconstants;
local getinfo = getinfo or debug.getinfo;
local getproto = getproto or debug.getproto;
local checkcaller = checkcaller;
local getconnections = getconnections;
local islclosure = islclosure;

local require = require;
local tostring = tostring;
local pcall = pcall;
local table_find = table.find;
local vector3_new = Vector3.new;

local rconsoleprint = rconsoleprint;
local rconsolename = rconsolename or rconsolesettitle;
local rconsolecreate = rconsolecreate;
local rconsolewarn = rconsolewarn or function(...) rconsoleprint(tostring(...), "yellow") end;
local rconsolerrr = rconsolerrr or function(...) rconsoleprint(tostring(...), "red") end;

--// Init Variables 

local replicated_storage = game:GetService("ReplicatedStorage");
local players = game:GetService("Players");
local collection_service = game:GetService("CollectionService");

local dependencies = {
    network = getupvalue(require(replicated_storage.Module.AlexChassis).SetEvent, 1),
    start_time = tick(),
    marked_functions = {},
    network_keys = {},
    keys_list = {"Punch", "Hijack", "Kick", "CarKick", "FallDamage", "SwitchTeam", "BroadcastInputBegan", "BroadcastInputEnded", "Arrest", "Eject", "EnterCar", "ExitCar", "SwitchTeam", "PlaySound", "SpawnCar", "RedeemCode"};
    modules = {
        default_actions = require(replicated_storage.Game.DefaultActions),
        military_turret_system = require(replicated_storage.Game.MilitaryTurret.MilitaryTurretSystem),
        team_choose_ui = require(replicated_storage.Game.TeamChooseUI),
        item_system = require(replicated_storage.Game.ItemSystem.ItemSystem),
        taser = require(replicated_storage.Game.Item.Taser),
        gun = require(replicated_storage.Game.Item.Gun),
        falling = require(replicated_storage.Game.Falling),
        garage_ui = require(replicated_storage.Game.Garage.GarageUI),
        codes = require(replicated_storage.Game.Codes)
    };
};

local functions = {
    mark_function = function(func, name)
        dependencies.marked_functions[func] = {name = name};
    end,

    hook_fire_server = function(func, index, name)
        setupvalue(func, index, {
            FireServer = function(self, key)
                dependencies.network_keys[name] = key;
            end;
        });
    end
};

--// Network Hook (credit to senser for the "marking" method)

local old_fire_server = getupvalue(dependencies.network.FireServer, 1);

setupvalue(dependencies.network.FireServer, 1, function(key, ...)
    local caller_info = getinfo(2, "f");
        
    if caller_info.func == dependencies.network.FireServer then 
        caller_info = getinfo(3, "f");
    end;

    local mark_info = dependencies.marked_functions[caller_info.func];

    if caller_info and mark_info and checkcaller() then 
        dependencies.network_keys[mark_info.name] = key;
        dependencies.marked_functions[caller_info.func] = nil;

        return;
    end;

    return old_fire_server(key, ...);
end);

--// Key Fetching 

do -- punch
    local punch_function = getupvalue(dependencies.modules.default_actions.punchButton.onPressed, 1).attemptPunch;
    
    functions.mark_function(punch_function, "Punch");

    setupvalue(punch_function, 1, 0);

    local constants = getconstants(punch_function);
        
    for index, constant in next, constants do 
        if constant == "Play" and constants[index - 1] == "LoadAnimation" then 
            setconstant(punch_function, index, "Stop");
            pcall(punch_function);

            if getupvalue(punch_function, 1) == 0 then 
                setupvalue(punch_function, 1, tick());
            end;

            setconstant(punch_function, index, "Play");

            break;
        end;
    end;
end;

do -- kick / carkick
    local connection = getconnections(collection_service:GetInstanceRemovedSignal("Door"))[1].Function;
    local functions_table = getupvalue(getupvalue(getupvalue(getupvalue(connection, 2), 2).Run, 1), 1);

    local car_kick_function = getproto(functions_table[3].c, 1);
    local kick_function = functions_table[4].c;

    do -- kick
        functions.mark_function(kick_function, "Kick");
    
        local old_environment = getfenv(kick_function);

        setfenv(kick_function, {pcall = function() return false end});
    
        pcall(kick_function);
    
        setupvalue(kick_function, 2, false);
        setfenv(kick_function, old_environment);
    end;

    do -- carkick
        functions.hook_fire_server(car_kick_function, 1, "CarKick");

        pcall(car_kick_function);
    end;
end;

do -- damage
    local damage_function = getproto(getproto(dependencies.modules.military_turret_system.init, 1), 1);

    functions.hook_fire_server(damage_function, 1, "Damage");

    pcall(damage_function);
end;

do -- switchteam
    local switch_team_function = getproto(dependencies.modules.team_choose_ui.Show, 4);

    functions.hook_fire_server(switch_team_function, 2, "SwitchTeam");

    pcall(switch_team_function);
end;

do -- broadcastinputbegan / broadcastinputended
    local equip_function = dependencies.modules.item_system._equip;
    local input_began_function = getproto(equip_function, 5);
    local input_ended_function = getproto(equip_function, 6);

    do -- broadcastinputbegan
        functions.hook_fire_server(input_began_function, 1, "BroadcastInputBegan");
        pcall(input_began_function, true, {});
    end;

    do -- broadcastinputended
        functions.hook_fire_server(input_ended_function, 1, "BroadcastInputEnded");
        pcall(input_ended_function, true, {});
    end;
end;

do -- taze
    local taze_function = dependencies.modules.taser.Tase;
    local old_upvalues = getupvalues(taze_function);

    functions.mark_function(taze_function, "Taze");

    setupvalue(taze_function, 1, {getAttr = function() return 0; end, setAttr = function() end});
    setupvalue(taze_function, 2, {ObjectLocal = function() end});
    setupvalue(taze_function, 3, {GetPlayers = function() return {}; end});
    setupvalue(taze_function, 5, {RayIgnoreNonCollideWithIgnoreList = function() return true; end});
    setupvalue(taze_function, 6, {getPlayerFromDescendant = function() return {Name = ""}; end});

    pcall(taze_function, {
        ItemData = {NextUse = 0}, CrossHair = {Flare = function() end, Spring = {Accelerate = function() end}}, 
        Config = {Sound = {tazer_buzz = 0}, ReloadTime = 0, ReloadTimeHit = 0}, IgnoreList = {}, Draw = function() end, BroadcastInputBegan = function() end, 
        UpdateMousePosition = function() end, Tip = {Position = vector3_new()}, Local = true, MousePosition = vector3_new()
    });

    setupvalue(taze_function, 1, old_upvalues[1]); 
    setupvalue(taze_function, 2, old_upvalues[2]); 
    setupvalue(taze_function, 3, players); 
    setupvalue(taze_function, 5, old_upvalues[5]); 
    setupvalue(taze_function, 6, old_upvalues[6]); 
end;

do -- playsound 
    for index, connection in next, getconnections(game:GetService("RunService").Heartbeat) do 
        local connection_function = connection.Function;
        
        if type(connection_function) == "function" and table_find(getconstants(connection_function), "Vehicle Heartbeat") then 
            for index, upvalue in next, getupvalues(connection_function) do 
                if type(upvalue) == "function" and islclosure(upvalue) and table_find(getconstants(upvalue), "NitroLoop") then 
                    local play_sound_function = getupvalue(upvalue, 1);
                    functions.mark_function(play_sound_function, "PlaySound");

                    local old_upvalue = getupvalue(play_sound_function, 2);
                    setupvalue(play_sound_function, 2, setmetatable({}, {__index = function() return function() end; end}));

                    pcall(play_sound_function, nil, nil);

                    setupvalue(play_sound_function, 2, old_upvalue);
                end;
            end;
        end;
    end;
end;

do -- eject / hijack / entercar
    local connection = getconnections(collection_service:GetInstanceAddedSignal("VehicleSeat"))[1].Function;
    local seat_interact_function = getupvalue(connection, 1);

    local hijack_function = getupvalue(seat_interact_function, 1);
    local eject_function = getupvalue(seat_interact_function, 2);
    local enter_car_function = getupvalue(seat_interact_function, 3);

    do -- hijack
        functions.mark_function(hijack_function, "Hijack");
        pcall(hijack_function);
    end;

    do -- eject
        functions.mark_function(eject_function, "Eject");
        pcall(eject_function);
    end;

    do -- entercar
        functions.mark_function(enter_car_function, "EnterCar");

        local old_upvalue = getupvalue(enter_car_function, 1);
        setupvalue(enter_car_function, 1, nil);

        pcall(enter_car_function, {});

        setupvalue(enter_car_function, 1, old_upvalue);
    end;
end;

do -- pickpocket / arrest
    local connection = getconnections(collection_service:GetInstanceAddedSignal("Character"))[1].Function;
    local interact_function = getupvalue(connection, 2);
    local pickpocket_function = getupvalue(getupvalue(interact_function, 2), 2);
    local arrest_function = getupvalue(getupvalue(interact_function, 1), 7);

    do -- pickpocket
        functions.mark_function(pickpocket_function, "Pickpocket");
        pcall(pickpocket_function, {});
    end;

    do -- arrest
        functions.mark_function(arrest_function, "Arrest");
        pcall(arrest_function, {});
    end;
end;

do -- falldamage
    local connection = getconnections(getupvalue(dependencies.modules.falling.Init, 3).Button.MouseButton1Down)[1].Function;
    local fall_function = getupvalue(getupvalue(getupvalue(connection, 1), 4), 3);

    functions.mark_function(fall_function, "FallDamage");

    local old_upvalues = getupvalues(fall_function);

    setupvalue(fall_function, 1, true);
    setupvalue(fall_function, 3, function() end);
    setupvalue(fall_function, 4, function() end);
    setupvalue(fall_function, 5, 25);
    setupvalue(fall_function, 6, true);

    pcall(fall_function, 0);

    for index = 1, 6 do 
        if index ~= 2 then 
            setupvalue(fall_function, index, old_upvalues[index]);
        end;
    end;
end;

do -- exitcar
    local exit_car_function = getupvalue(dependencies.modules.team_choose_ui.Init, 3);

    functions.mark_function(exit_car_function, "ExitCar");

    local old_upvalues = getupvalues(exit_car_function);

    setupvalue(exit_car_function, 1, true);
    setupvalue(exit_car_function, 2, {OnVehicleJumpExited = {Fire = function() end}});
    setupvalue(exit_car_function, 6, {Heli = {}});

    pcall(exit_car_function);

    setupvalue(exit_car_function, 1, old_upvalues[1]);
    setupvalue(exit_car_function, 2, old_upvalues[2]);
    setupvalue(exit_car_function, 6, old_upvalues[6]);
end;

do -- spawncar (given to me by Tazed#8126)
    local spawn_car_function = getproto(dependencies.modules.garage_ui.Init, 3);

    functions.hook_fire_server(spawn_car_function, 1, "SpawnCar");

    pcall(spawn_car_function, {});
end;

do -- redeemcode
    local redeem_code_function = getproto(dependencies.modules.codes.Init, 4);
    
    setupvalue(redeem_code_function, 1, {CodeContainer = {Background = {CodeContainer = {Code = {Text = " "}}}}});
    setupvalue(redeem_code_function, 3, {WindowClose = function() end})
    
    functions.hook_fire_server(redeem_code_function, 2, "RedeemCode");
    
    pcall(redeem_code_function);
end;

--// Reset Network

setupvalue(dependencies.network.FireServer, 1, old_fire_server);

--// Output Keys 

if shared.output_keys then
    if rconsolecreate then 
        rconsolecreate();
    end; 
    
    rconsolename("Jailbreak Key Fetcher");
    rconsolewarn(("Took %s seconds to grab keys!\n"):format(tick() - dependencies.start_time));

    for index, key in next, dependencies.network_keys do 
        rconsoleprint(("%s : %s\n"):format(index, key));
    end;
end;

--// Add Keys to Environment 

if shared.add_to_env then 
    local environment = getgenv();

    environment.keys = dependencies.network_keys;
    environment.network = dependencies.network;
end;

--// Check for Missing Keys 

local console_created, console_named = false, false; -- i hate scriptware's console system lol

for index, key_name in next, dependencies.keys_list do 
    if not dependencies.network_keys[key_name] then 
    	if rconsolecreate and not console_created and not shared.output_keys then 
	    console_created = true; 
	    rconsolecreate();
	    rconsolename("Jailbreak Key Fetcher");
	end; 
    
        rconsoleerr(("Failed to fetch key %s"):format(key_name));

        if not console_created and not console_named and not shared.output_keys then 
	    console_named = true;
            rconsolename("Jailbreak Key Fetcher");
        end;
    end;
end;

return dependencies.network_keys, dependencies.network;
