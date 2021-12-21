local roblox_environment = getrenv();

local old_getfenv;
old_getfenv = replaceclosure(getsenv(game:GetService("ReplicatedStorage").Modules.KeyHandler).getfenv, newcclosure(function(level)
    local result = old_getfenv(level);
    
    return (type(result) == "table" and result.syn) and roblox_environment or result;
end));

local ui_manager = game:GetService("Players").LocalPlayer.PlayerScripts.UIManager;
local ui_manager_get_remote = getupvalue(getconnections(game:GetService("TextService").ChildAdded)[1].Function, 2);

local function_key = getconstant(ui_manager_get_remote, 1);
local get_key_function = getupvalue(ui_manager_get_remote, 1)[1];

getgenv().get_remote = function(remote_name)
    return syn.secure_call(get_key_function, ui_manager, remote_name, function_key);
end;
