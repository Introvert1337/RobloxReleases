--// Check if Already in Env 

if network_keys and network then 
    return network_keys, network;
end;

--// Variables 

local start_time = tick();

local replicated_storage = game:GetService("ReplicatedStorage");
local collection_service = game:GetService("CollectionService");

local network = getupvalue(require(replicated_storage.Module.AlexChassis).SetEvent, 1);
local keys_list = getupvalue(getupvalue(network.FireServer, 1), 3);

local game_folder = replicated_storage.Game;

local team_choose_ui = require(game_folder.TeamChooseUI); -- module used in multiple keys
local default_actions = require(game_folder.DefaultActions); -- module used in multiple keys

local roblox_environment = getrenv();
local network_keys = {};

--// Functions 

local function fetch_key(caller_function)
    local constants = getconstants(caller_function);
    
    for index, constant in next, constants do
        if keys_list[constant] then -- if the constants already contain the raw key
            return constant;
        elseif type(constant) ~= "string" or constant == "" or roblox_environment[constant] or string[constant] or table[constant] or #constant > 7 or constant:lower() ~= constant then
            constants[index] = nil; -- remove constants that are 100% not the ones we need to make it a bit faster
        end;
    end;
    
    for key, remote in next, keys_list do 
        local prefix_passed = false;
        local key_length = #key;
        
        for index, constant in next, constants do 
            local constant_length = #constant;
            
            if not prefix_passed and key:sub(1, constant_length) == constant then -- check if the key starts with one of the constants
                prefix_passed = constant;
            elseif prefix_passed and constant ~= prefix_passed and key:sub(key_length - (constant_length - 1), key_length) == constant then -- check if the key ends with one of the constants
                return key;
            end;
        end;
    end;
end;

--// Key Fetching 

do -- redeemcode
    local redeem_code_function = getproto(require(game_folder.Codes).Init, 4);

    network_keys.RedeemCode = fetch_key(redeem_code_function);
end;

do -- kick
    local door_removed_function = getconnections(collection_service:GetInstanceRemovedSignal("Door"))[1].Function;
    local kick_function = getupvalue(getupvalue(getupvalue(getupvalue(door_removed_function, 2), 2).Run, 1), 1)[4].c;
    
    network_keys.Kick = fetch_key(kick_function);
end;

do -- damage
    local military_added_function = require(game_folder.MilitaryTurret.MilitaryTurretBinder)._classAddedSignal._handlerListHead._fn;
    local damage_function = getproto(military_added_function, 1);
    
    network_keys.Damage = fetch_key(damage_function);
end;

do -- switchteam
    local switch_team_function = getproto(team_choose_ui.Show, 4);

    network_keys.SwitchTeam = fetch_key(switch_team_function);
end;

do -- exitcar
    local exit_car_function = getupvalue(team_choose_ui.Init, 3);
    
    network_keys.ExitCar = fetch_key(exit_car_function);
end;

do -- taze
    local taze_function = require(game_folder.Item.Taser).Tase;

    network_keys.Taze = fetch_key(taze_function);
end;

do -- punch
    local punch_function = getupvalue(default_actions.punchButton.onPressed, 1).attemptPunch;
    
    network_keys.Punch = fetch_key(punch_function);
end;

do -- falldamage
    local jump_function = default_actions.onJumpPressed._handlerListHead._next._fn;
    local fall_function = getupvalue(getupvalue(getupvalue(jump_function, 1), 4), 3);
    
    network_keys.FallDamage = fetch_key(fall_function);
end;

do -- pickpocket / arrest
    local character_added_function = getconnections(collection_service:GetInstanceAddedSignal("Character"))[1].Function;
    local interact_function = getupvalue(character_added_function, 2);

    local pickpocket_function = getupvalue(getupvalue(interact_function, 2), 2);
    local arrest_function = getupvalue(getupvalue(interact_function, 1), 7);

    network_keys.Pickpocket = fetch_key(pickpocket_function);
    network_keys.Arrest = fetch_key(arrest_function);
end;

do -- broadcastinputbegan / broadcastinputended
    local equip_function = require(game_folder.ItemSystem.ItemSystem)._equip;

    local input_began_function = getproto(equip_function, 5);
    local input_ended_function = getproto(equip_function, 6);

    network_keys.BroadcastInputBegan = fetch_key(input_began_function);
    network_keys.BroadcastInputEnded = fetch_key(input_ended_function);
end;

do -- eject / hijack / entercar
    local seat_added_function = getconnections(collection_service:GetInstanceAddedSignal("VehicleSeat"))[1].Function;
    local seat_interact_function = getupvalue(seat_added_function, 1);

    local hijack_function = getupvalue(seat_interact_function, 1);
    local eject_function = getupvalue(seat_interact_function, 2);
    local enter_car_function = getupvalue(seat_interact_function, 3);

    network_keys.Hijack = fetch_key(hijack_function);
    network_keys.Eject = fetch_key(eject_function);
    network_keys.EnterCar = fetch_key(enter_car_function);
end;

do -- playsound
    for key, client_function in next, getupvalue(team_choose_ui.Init, 2) do 
        if type(client_function) == "function" and getconstants(client_function)[1] == "Source" then 
            network_keys.PlaySound = key;
            
            break;
        end;
    end; 
end;

--// Return Variables 

local environment = getgenv();

environment.network_keys, environment.network = network_keys, network;

warn(("Key Fetcher Loaded in %s Seconds"):format(tick() - start_time));

return network_keys, network;
