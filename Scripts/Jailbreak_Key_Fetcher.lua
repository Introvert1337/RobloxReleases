--// Game Loaded

do 
    if not game:IsLoaded() then 
        game.Loaded:Wait();
    end;
end;

--// Services 

local replicated_storage = game:GetService("ReplicatedStorage");
local players = game:GetService("Players");
local collection_service = game:GetService("CollectionService");

--// Localizations 

local getupvalue = getupvalue or debug.getupvalue
local setupvalue = setupvalue or debug.setupvalue
local getupvalues = getupvalues or debug.getupvalues
local setconstant = setconstant or debug.setconstant
local getconstants = getconstants or debug.getconstants
local getinfo = getinfo or debug.getinfo
local getproto = getproto or debug.getproto
local checkcaller = checkcaller
local getconnections = getconnections
local islclosure = islclosure

local require = require
local t_find = table.find
local v3_new = Vector3.new

--// Init Variables 

local dependencies = {
    network = getupvalue(require(replicated_storage.Module.AlexChassis).SetEvent, 1);
    game_folder = replicated_storage.Game;
    marked_functions = {};
    network_keys = {};
    start_time = tick();
    keys_list = {"Punch", "Hijack", "Kick", "CarKick", "FallDamage", "PopTire", "SwitchTeam", "BroadcastInputBegan", "BroadcastInputEnded", "Arrest", "Eject", "EnterCar", "ExitCar", "SwitchTeam", "PlaySound"}
};

local functions = {
    mark_function = function(func, name)
        dependencies.marked_functions[func] = {name = name};
    end;

    hook_fire_server = function(func, index, name)
        setupvalue(func, index, {
            FireServer = function(self, key)
                dependencies.network_keys[name] = key;
            end;
        });
    end;
};

--// Network Hook (credit to senser for the "marking" method)

local old_fire_server = getupvalue(dependencies.network.FireServer, 1);

do 
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
end;

--// Key Fetching 

do 
    do -- punch
        local punch_function = getupvalue(require(dependencies.game_folder.DefaultActions).punchButton.onPressed, 1).attemptPunch;
        
        functions.mark_function(punch_function, "Punch");

        setupvalue(punch_function, 1, 0);

        local constants = getconstants(punch_function);
            
        for index, constant in next, constants do 
            if constant == "Play" and constants[index - 1] == "LoadAnimation" then 
                setconstant(punch_function, index, "Stop");
                punch_function();
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

            setfenv(kick_function, {
                pcall = function() return false end;
            });
        
            kick_function();
        
            setupvalue(kick_function, 2, false);
            setfenv(kick_function, old_environment);
        end;

        do -- carkick
            functions.hook_fire_server(car_kick_function, 1, "CarKick");

            car_kick_function()
        end;
    end;

    do -- damage
        local damage_function = getproto(getproto(require(dependencies.game_folder.MilitaryTurret.MilitaryTurretSystem).init, 1), 1);

        functions.hook_fire_server(damage_function, 1, "Damage");

        damage_function();
    end;

    do -- switchteam
        local switch_team_function = getproto(require(dependencies.game_folder.TeamChooseUI).Show, 4);

        functions.hook_fire_server(switch_team_function, 2, "SwitchTeam");

        switch_team_function();
    end;

    do -- broadcastinputbegan / broadcastinputended
        local equip_function = require(dependencies.game_folder.ItemSystem.ItemSystem)._equip;
        local input_began_function = getproto(equip_function, 5);
        local input_ended_function = getproto(equip_function, 6);

        functions.hook_fire_server(input_began_function, 1, "BroadcastInputBegan");
        functions.hook_fire_server(input_ended_function, 1, "BroadcastInputEnded");

        input_began_function(true, {});
        input_ended_function(true, {});
    end;

    do -- taze
        local taze_function = require(dependencies.game_folder.Item.Taser).Tase;
        local old_upvalues = getupvalues(taze_function);

        functions.mark_function(taze_function, "Taze");

        setupvalue(taze_function, 1, {getAttr = function() return 0 end, setAttr = function() setupvalue(taze_function, 1, old_upvalues[1]) end});
        setupvalue(taze_function, 2, {ObjectLocal = function() setupvalue(taze_function, 2, old_upvalues[2]) end});
        setupvalue(taze_function, 3, {GetPlayers = function() setupvalue(taze_function, 3, players) return {} end});
        setupvalue(taze_function, 5, {RayIgnoreNonCollideWithIgnoreList = function() setupvalue(taze_function, 5, old_upvalues[5]) return true end});
        setupvalue(taze_function, 6, {getPlayerFromDescendant = function() setupvalue(taze_function, 6, old_upvalues[6]) return {Name = ""} end});

        taze_function({
            ItemData = {NextUse = 0}, CrossHair = {Flare = function() end, Spring = {Accelerate = function() end}}, 
            Config = {Sound = {tazer_buzz = 0}, ReloadTime = 0, ReloadTimeHit = 0}, IgnoreList = {}, Draw = function() end, BroadcastInputBegan = function() end, 
            UpdateMousePosition = function() end, Tip = {Position = v3_new(0, 0, 0)}, Local = true, MousePosition = v3_new(0, 0, 0)
        });
    end;

    do -- playsound 
        for index, connection in next, getconnections(game:GetService("RunService").Heartbeat) do 
            local connection_function = connection.Function;
            
            if type(connection_function) == "function" and t_find(getconstants(connection_function), "Vehicle Heartbeat") then 
                for index, upvalue in next, getupvalues(connection_function) do 
                    if type(upvalue) == "function" and islclosure(upvalue) and t_find(getconstants(upvalue), "NitroLoop") then 
                        local play_sound_function = getupvalue(upvalue, 1);
                        functions.mark_function(play_sound_function, "PlaySound");

                        local old_upvalue = getupvalue(play_sound_function, 2);
                        setupvalue(play_sound_function, 2, setmetatable({}, {__index = function() setupvalue(play_sound_function, 2, old_upvalue) return function() end end}));

                        play_sound_function(nil, nil);
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

        functions.mark_function(hijack_function, "Hijack");
        functions.mark_function(eject_function, "Eject");
        functions.mark_function(enter_car_function, "EnterCar");

        hijack_function()
        eject_function()

        local old_upvalue = getupvalue(enter_car_function, 1);
        setupvalue(enter_car_function, 1, nil);

        enter_car_function({});

        setupvalue(enter_car_function, 1, old_upvalue);
    end;

    do -- poptire
        local bullet_function = getproto(require(dependencies.game_folder.Item.Gun).SetupBulletEmitter, 2);

        setupvalue(bullet_function, 1, {Weld = function() end});
        setupvalue(bullet_function, 2, {Local = false, LastImpactSound = 0, LastImpact = 0.2});
        setupvalue(bullet_function, 5, replicated_storage);
        setupvalue(bullet_function, 6, {AddItem = function() getupvalue(bullet_function, 2).Local = true end});

        functions.hook_fire_server(bullet_function, 7, "PopTire");

        bullet_function({Color = Color3.new(0, 0, 0), IsDescendantOf = function(self, obj) return obj.Name == "ShootingRange" end}, v3_new(0, 0, 0), v3_new(0, 0, 0), 0);
    end;

    do -- pickpocket / arrest
        local connection = getconnections(collection_service:GetInstanceAddedSignal("Character"))[1].Function;
        local interact_function = getupvalue(connection, 2);
        local pickpocket_function = getupvalue(getupvalue(interact_function, 2), 2);
        local arrest_function = getupvalue(getupvalue(interact_function, 1), 7);

        functions.mark_function(pickpocket_function, "Pickpocket");
        functions.mark_function(arrest_function, "Arrest");

        pickpocket_function({});
        arrest_function({});
    end;

    do -- falldamage
        local connection = getconnections(getupvalue(require(game.ReplicatedStorage.Game.Falling).Init, 3).Button.MouseButton1Down)[1].Function;
        local fall_function = getupvalue(getupvalue(getupvalue(connection, 1), 4), 3);

        functions.mark_function(fall_function, "FallDamage");

        local old_upvalues = getupvalues(fall_function);

        setupvalue(fall_function, 1, true);
        setupvalue(fall_function, 3, function() end);
        setupvalue(fall_function, 4, function() end);
        setupvalue(fall_function, 5, 25);
        setupvalue(fall_function, 6, true);

        fall_function(0);

        for index = 1, 6 do 
            if index ~= 2 then 
                setupvalue(fall_function, index, old_upvalues[index]);
            end;
        end;
    end;

    do -- exitcar
        local exit_car_function = getupvalue(require(dependencies.game_folder.TeamChooseUI).Init, 3);

        functions.mark_function(exit_car_function, "ExitCar");

        local old_upvalues = getupvalues(exit_car_function);

        setupvalue(exit_car_function, 1, true);
        setupvalue(exit_car_function, 2, {OnVehicleJumpExited = {Fire = function() setupvalue(exit_car_function, 2, old_upvalues[2]) end}});
        setupvalue(exit_car_function, 6, {Heli = {}});

        exit_car_function();

        setupvalue(exit_car_function, 1, old_upvalues[1]);
        setupvalue(exit_car_function, 6, old_upvalues[6]);
    end;
end;

--// Reset Network

do
    setupvalue(dependencies.network.FireServer, 1, old_fire_server);
end;

--// Output Keys 

do
    if shared.output_keys ~= false then
        rconsolewarn(("Took %s seconds to grab keys!\n"):format(tick() - dependencies.start_time));
        
        for index, key in next, dependencies.network_keys do 
            rconsoleprint(("%s : %s\n"):format(index, key));
        end;
    end;
end;

--// Add Keys to Environment 

do 
    if shared.add_to_env then 
        local environment = getgenv();
    
        environment.keys = dependencies.network_keys;
        environment.network = dependencies.network;
    end;
end;

--// Check for Missing Keys 

do 
    for index, key_name in next, dependencies.keys_list do 
        if not dependencies.network_keys[key_name] then 
            rconsoleerr(("Failed to fetch key %s"):format(key_name));
        end;
    end;
end;

return dependencies.network_keys, dependencies.network;
