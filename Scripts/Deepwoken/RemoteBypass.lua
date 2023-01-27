local VirtualInputManager = game:GetService("VirtualInputManager")

local rollFunction = getsenv(game:GetService("Players").LocalPlayer.Character.CharacterHandler.InputClient).Roll
local remoteConstantIndex = table.find(getconstants(rollFunction), "Unblock")

local function getRemote(remoteName)
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

if not integrityHooked then
    return getRemote
end

getgenv().integrityHooked = true

local modules = game:GetService("ReplicatedStorage").Modules

local keyHandler = require(modules.ClientManager.KeyHandler)
local integrity = modules.Persistence.Integrity

local remoteKey = getupvalue(getrawmetatable(getupvalue(keyHandler, 8)).__index, 1)[1][1][64] -- credits to some guy on v3rm

local oldRequire
oldRequire = hookfunction(getrenv().require, function(module) -- hooking the integrity function directly crashes synapse? is that an actor thing or something idk much about parallel luau yet
    if module == integrity then
        return function()
            return remoteKey
        end
    end
    
    return oldRequire(module)
end)

return getRemote
