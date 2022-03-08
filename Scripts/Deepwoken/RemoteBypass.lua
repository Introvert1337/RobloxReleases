--// variables

local virtual_input_manager = game:GetService("VirtualInputManager");

local roll_function = getsenv(game:GetService("Players").LocalPlayer.Character.CharacterHandler.InputClient).Roll;
local remote_constant_index = table.find(getconstants(roll_function), "Unblock");

--// function to get remote 

return function(remote_name)
    local old_upvalues = getupvalues(roll_function);

    setupvalue(roll_function, 1, {
        FindEffect = function(self, effect_name)
            return effect_name == "Blocking";
        end;
    });
    
    local thread = coroutine.running();
    
    setupvalue(roll_function, 3, newcclosure(function(remote)
        setupvalue(roll_function, 1, old_upvalues[1]);
        setupvalue(roll_function, 3, old_upvalues[3]);
        
        setconstant(roll_function, remote_constant_index, "Unblock");
        
        coroutine.resume(thread, remote);
        
        coroutine.yield();
    end));
    
    setconstant(roll_function, remote_constant_index, remote_name);
    
    virtual_input_manager:SendKeyEvent(true, "Q", false, game);
    virtual_input_manager:SendKeyEvent(false, "Q", false, game);
    
    return coroutine.yield();
end;
