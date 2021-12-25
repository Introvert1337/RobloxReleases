--// Game Loaded

if not game:IsLoaded() then 
    game.Loaded:Wait();
end;

--// Exploit Support 

local rconsolename = rconsolename or rconsolesettitle;
local rconsolewarn = rconsolewarn or function(text) rconsoleprint(text, "yellow") end;
local rconsoleerr = rconsoleerr or function(text) rconsoleprint(text, "red") end;

--// Init Variables 

local replicated_storage = game:GetService("ReplicatedStorage");
local players = game:GetService("Players");
local collection_service = game:GetService("CollectionService");

local player = players.LocalPlayer;

local game_folder = replicated_storage:WaitForChild("Game");
local item_folder = game_folder:WaitForChild("Item");

local dependencies = {
    network = getupvalue(require(replicated_storage:WaitForChild("Module").AlexChassis).SetEvent, 1),
    start_time = tick(),
    marked_functions = {},
    network_keys = {},
    keys_list = {"Punch", "Hijack", "Kick", "FallDamage", "SwitchTeam", "BroadcastInputBegan", "BroadcastInputEnded", "Arrest", "Eject", "EnterCar", "ExitCar", "PlaySound", "SpawnCar", "RedeemCode", "Damage"};
    modules = {
        default_actions = require(game_folder.DefaultActions),
        military_turret_binder = require(game_folder.MilitaryTurret.MilitaryTurretBinder),
        team_choose_ui = require(game_folder.TeamChooseUI),
        item_system = require(game_folder.ItemSystem.ItemSystem),
        taser = require(item_folder.Taser),
        gun = require(item_folder.Gun),
        falling = require(game_folder.Falling),
        spawn_ui = require(game_folder.Garage.GarageUI.SpawnUI),
        codes = require(game_folder.Codes)
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

--// Network Hook

local old_fire_server = getupvalue(dependencies.network.FireServer, 1);

setupvalue(dependencies.network.FireServer, 1, function(key, ...)
    if checkcaller() then
        local caller_info = getinfo(2, "f").func;

        if caller_info == dependencies.network.FireServer then 
            caller_info = getinfo(3, "f").func;
        end;

        local mark_info = dependencies.marked_functions[caller_info];

        if mark_info then 
            dependencies.network_keys[mark_info.name] = key;
            dependencies.marked_functions[caller_info] = nil;

            return;
        end;
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

do -- kick
    local connection = getconnections(collection_service:GetInstanceRemovedSignal("Door"))[1].Function;
    local kick_function = getupvalue(getupvalue(getupvalue(getupvalue(connection, 2), 2).Run, 1), 1)[4].c;

    functions.mark_function(kick_function, "Kick");

    local old_environment = getfenv(kick_function);

    setfenv(kick_function, {pcall = function() return false end});

    pcall(kick_function);

    setupvalue(kick_function, 2, false);
    setfenv(kick_function, old_environment);
end;

do -- damage
    local military_turret_connection = dependencies.modules.military_turret_binder._classAddedSignal._handlerListHead._fn;

    pcall(military_turret_connection, {
        _maid = {GiveTask = function() end}, 
        onBulletHit = {Connect = function(self, connection_callback)
            functions.mark_function(connection_callback, "Damage");
            pcall(connection_callback);
        end}
    });
end;

do -- switchteam
    local connection = getconnections(dependencies.modules.team_choose_ui.Gui.Container.ContainerTeam.Police.MouseButton1Down)[1].Function;
    local switch_team_function = getupvalue(connection, 4);
    local old_upvalue = getupvalue(switch_team_function, 1);

    functions.mark_function(switch_team_function, "SwitchTeam");
    
    setupvalue(switch_team_function, 1, 1);

    pcall(switch_team_function);

    setupvalue(switch_team_function, 1, old_upvalue);
end;

do -- broadcastinputbegan / broadcastinputended
    local equip_function = dependencies.modules.item_system._equip;
    local old_upvalues = getupvalues(equip_function);
    
    setupvalue(equip_function, 1, {getName = function() return "gamer" end});
    setupvalue(equip_function, 2, {gamer = {new = function()
        return setmetatable({Local = true, ShootBegin = true, Maid = {GiveTask = function() end}}, {
            __newindex = function(self, index, value)
                if index == "BroadcastInputBegan" or index == "BroadcastInputEnded" then 
                    functions.mark_function(value, index);
                    pcall(value, true, {});
                end;
                
                return rawset(self, index, value);
            end;
        });
    end}});
    setupvalue(equip_function, 3, {});
    setupvalue(equip_function, 4, {
        GetKeysPressed = function() return {} end, GetMouseButtonsPressed = function() return {} end, 
        InputBegan = {Connect = function() end}, InputEnded = {Connect = function() end}
    });
    setupvalue(equip_function, 7, {OnLocalItemEquipped = {Fire = function() end}});

    pcall(equip_function, true, {Name = "gamer"});

    for index = 1, 4 do 
        setupvalue(equip_function, index, old_upvalues[index]);
    end;

    setupvalue(equip_function, 7, old_upvalues[7]);
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
        UpdateMousePosition = function() end, Tip = {Position = Vector3.new(0, 0, 0)}, Local = true, MousePosition = Vector3.new(0, 0, 0)
    });

    setupvalue(taze_function, 1, old_upvalues[1]); 
    setupvalue(taze_function, 2, old_upvalues[2]); 
    setupvalue(taze_function, 3, players); 
    setupvalue(taze_function, 5, old_upvalues[5]); 
    setupvalue(taze_function, 6, old_upvalues[6]); 
end;

do -- playsound 
    local play_sound_function;
    
    for index, connection in next, getconnections(game:GetService("RunService").Heartbeat) do 
        local connection_function = connection.Function;
        
        if type(connection_function) == "function" and table.find(getconstants(connection_function), "Vehicle Heartbeat") then 
            for index, upvalue in next, getupvalues(connection_function) do 
                if type(upvalue) == "function" and islclosure(upvalue) and table.find(getconstants(upvalue), "NitroLoop") then 
                    play_sound_function = getupvalue(upvalue, 1);
                    functions.mark_function(play_sound_function, "PlaySound");

                    local old_upvalue = getupvalue(play_sound_function, 2);
                    setupvalue(play_sound_function, 2, setmetatable({}, {__index = function() return function() end; end}));

                    pcall(play_sound_function, nil, nil);

                    setupvalue(play_sound_function, 2, old_upvalue);
                    
                    break;
                end;
            end;
        end;
        
        if play_sound_function then 
            break 
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

do -- spawncar
    local spawn_car_function = dependencies.modules.spawn_ui.OnItemSpawnClick._handlerListHead._fn;

    functions.mark_function(spawn_car_function, "SpawnCar");

    pcall(spawn_car_function, {});
end;

do -- redeemcode
    local redeem_code_function = getconnections(player.PlayerGui:WaitForChild("CodesGui").CodeContainer.Background.Redeem.MouseButton1Down)[1].Function;
    
    functions.mark_function(redeem_code_function, "RedeemCode");
    
    local old_upvalues = getupvalues(redeem_code_function);
    
    setupvalue(redeem_code_function, 1, {CodeContainer = {Background = {CodeContainer = {Code = {Text = " "}}}}});
    setupvalue(redeem_code_function, 3, {WindowClose = function() end});
    
    pcall(redeem_code_function);

    setupvalue(redeem_code_function, 1, old_upvalues[1]);
    setupvalue(redeem_code_function, 3, old_upvalues[3]);
end;

--// Reset Network

setupvalue(dependencies.network.FireServer, 1, old_fire_server);

--// Output Keys 

if rconsolecreate then 
    rconsolecreate()
end 

rconsolename("Jailbreak Key Fetcher");
rconsolewarn(("Took %s seconds to grab keys!\n"):format(tick() - dependencies.start_time));

for index, key in next, dependencies.network_keys do 
    rconsoleprint(("%s : %s\n"):format(index, key));
end;

--// Check for Missing Keys 

for index, key_name in next, dependencies.keys_list do 
    if not dependencies.network_keys[key_name] then 
        rconsoleerr(("Failed to fetch key %s"):format(key_name));
    end;
end;

return dependencies.network_keys, dependencies.network;
