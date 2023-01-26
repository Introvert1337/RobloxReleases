local VirtualInputManager = game:GetService("VirtualInputManager")

local rollFunction = getsenv(game:GetService("Players").LocalPlayer.Character.CharacterHandler.InputClient).Roll
local remoteConstantIndex = table.find(getconstants(rollFunction), "Unblock")

return function(remoteName)
    local oldUpvalues = getupvalues(rollFunction)
    
    setupvalue(rollFunction, 1, {
        FindEffect = function(self, effectName)
            return effectName == "Blocking"
        end
    })
    
    local thread = coroutine.running()
    
    setupvalue(rollFunction, 3, newcclosure(function(remote)
        setupvalue(rollFunction, 1, oldUpvalues[1])
        setupvalue(rollFunction, 3, oldUpvalues[3])
        
        setconstant(rollFunction, remoteConstantIndex, "Unblock")
        
        coroutine.resume(thread, remote)
        
        coroutine.yield()
    end))
    
    setconstant(rollFunction, remoteConstantIndex, remoteName)
    
    VirtualInputManager:SendKeyEvent(true, "Q", false, game)
    VirtualInputManager:SendKeyEvent(false, "Q", false, game)
    
    return coroutine.yield()
end
