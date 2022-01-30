local ui_manager = game:GetService("Players").LocalPlayer.PlayerScripts.UIManager;
local text_service_connection = getconnections(game:GetService("TextService").ChildAdded)[1].Function;

local ui_manager_get_remote = getupvalue(text_service_connection, 1);

local get_key_verification_key = getconstant(ui_manager_get_remote, 1); -- plum
local get_key_function = getupvalue(ui_manager_get_remote, 1)[1];

return function(remote_name)
    return syn.secure_call(get_key_function, ui_manager, remote_name, get_key_verification_key); -- synapse only
end;
