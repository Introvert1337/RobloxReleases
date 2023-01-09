--// Check if Already in Env 

if network_keys and network then 
    return network_keys, network;
end;

--// Variables 

local start_time = tick();
local debug_output = false;

local replicated_storage = game:GetService("ReplicatedStorage");
local collection_service = game:GetService("CollectionService");

local network = getupvalue(require(replicated_storage.Module.AlexChassis).SetEvent, 1);
local keys_list = getupvalue(getupvalue(network.FireServer, 1), 3);

local game_folder = replicated_storage.Game;

local team_choose_ui = require(game_folder.TeamChooseUI); -- module used in multiple keys
local default_actions = require(game_folder.DefaultActions); -- module used in multiple keys

local network_keys = {};

--// Functions 

local function fetch_key(caller_function, key_index)
    local constants = getconstants(caller_function);
    local prefix_indexes = { };
    local found_keys = { };
    
    key_index = key_index or 1;
    
    for index, constant in next, constants do
        if keys_list[constant] then -- if the constants already contain the raw key
            return constant;
        elseif type(constant) ~= "string" or constant == "" or #constant > 7 or constant:lower() ~= constant then
            constants[index] = nil; -- remove constants that are 100% not the ones we need to make it a bit faster
        end;
    end;
    
    for key, remote in next, keys_list do
        local prefix_passed = false;
        local prefix_index;
        local key_length = #key;

        for index, constant in next, constants do
            local constant_length = #constant;

            if not prefix_passed and key:sub(1, constant_length) == constant then -- check if the key starts with one of the constants
                prefix_passed, prefix_index = constant, index;
            elseif prefix_passed and constant ~= prefix_passed and key:sub(key_length - (constant_length - 1), key_length) == constant then -- check if the key ends with one of the constants
                table.insert(prefix_indexes, prefix_index);
                table.insert(found_keys, { key, index });
 
                break;
            end;
        end;
    end;
    
    -- cleanse invalid keys
    for index, key_info in next, found_keys do
        if table.find(prefix_indexes, key_info[2]) then
            table.remove(found_keys, index);
        end;
    end;
    
    local correct_key = found_keys[key_index];

    return correct_key and correct_key[1] or "Failed to fetch key";
end;

--// Key Fetching 

do -- redeemcode
    local redeem_code_function = getproto(require(game_folder.Codes).Init, 8);

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

do -- arrest
    local character_added_function = getconnections(collection_service:GetInstanceAddedSignal("Character"))[1].Function;
    local arrest_function = getupvalue(getupvalue(character_added_function, 2), 1);

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

if debug_output then
    rconsolewarn(("Key Fetcher Loaded in %s Seconds\n"):format(tick() - start_time));
    
    for index, key in next, network_keys do
        rconsoleprint(("%s : %s\n"):format(index, key));
    end;
else
    warn(("Key Fetcher Loaded in %s Seconds"):format(tick() - start_time));
end;

return network_keys, network;
