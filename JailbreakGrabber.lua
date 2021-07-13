--// Init Variables

getgenv().Keys = {}

local StartTime = tick()
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

--// Function Identification and Fixes

local ConstantMapping
ConstantMapping = {
    CarKick = {
        Constants = {"Eject", "MouseButton1Down"},
        UpvalueIndex = 1,
        ProtoIndex = 1
    },

    PlaySound = {
        Constants = {"Source", "Play", "FireServer"},
        CustomArguments = {"", {Source = true}, false}
    },

    Eject = {
        Constants = {"ShouldEject", "Vehicle"},
        UpvalueIndex = 2,
    },

    Hijack = {
        Constants = {"ShouldEject", "Vehicle"},
        UpvalueIndex = 1,
    },

    SwitchTeam = {
        ProtoIndex = 6,
        UpvalueIndex = 2,
        LocatedFunction = require(ReplicatedStorage:WaitForChild("Game"):WaitForChild("TeamChooseUI")).Show
    },

    Punch = {
        Constants = {"Punch", "Play"},
        CustomArguments = {{Name = "Punch"}, true}, 
        CustomFix = function(Function)
            local Constants = debug.getconstants(Function)

            for Index, Constant in next, Constants do 
                if Constant == "Play" and Index ~= #Constants and debug.getconstant(Function, Index + 1) == "Punch" then 
                    debug.setconstant(Function, Index, "Stop")
                end
            end
        end,
        RevertFix = function(Function)
            local Constants = debug.getconstants(Function)

            for Index, Constant in next, Constants do 
                if Constant == "Stop" and Index ~= #Constants and debug.getconstant(Function, Index + 1) == "Punch" then 
                    debug.setconstant(Function, Index, "Play")
                end
            end
        end
    },

    EnterCar = {
        Constants = {"ShouldHotwire", "ShouldEject", "Vehicle"},
        UpvalueIndex = 3,
        CustomArguments = {{}}
    },

    ExitCar = {
        Constants = {"OnVehicleJumpExited", "FireServer", "LastVehicleExit"},
        CustomFix = function(Function)
            local OldValue = debug.getupvalue(Function, 1)
            debug.setupvalue(Function, 1, {OldValue = OldValue})
        end,
        RevertFix = function(Function)
            debug.setupvalue(Function, 1, debug.getupvalue(Function, 1).OldValue)
        end
    },

    Flip = {
        Constants = {"Punch", "Play"},
        CustomArguments = {{Name = "Flip"}, true}, 
        CustomFix = function(Function)
            local Upvalues = debug.getupvalues(Function) 

            for Index, Value in next, Upvalues do 
                if type(Value) == "table" and rawget(Value, "Window") and type(Upvalues[Index + 2]) == "function" then
                    local OldValue = debug.getupvalue(Function, Index + 1)
                    debug.setupvalue(Function, Index + 1, {OldValue = OldValue})
                end 
            end 
        end,
        RevertFix = function(Function)
            local Upvalues = debug.getupvalues(Function) 

            for Index, Value in next, Upvalues do 
                if type(Value) == "table" and rawget(Value, "Window") and type(Upvalues[Index + 2]) == "function" then
                    debug.setupvalue(Function, Index + 1, debug.getupvalue(Function, Index + 1).OldValue)
                end 
            end 
        end
    },

    Pickpocket = {
        Constants = {"ShouldArrest", "ShouldPickpocket"},
        UpvalueIndex = 2,
        CustomArguments = {{Name = ""}}
    },

    Arrest = {
        Constants = {"ShouldArrest", "ShouldPickpocket"},
        UpvalueIndex = 1,
        CustomArguments = {{Name = ""}}
    },

    Damage = {
        Constants = {"NoFallDamage", "NoRagdoll"},
        CustomArguments = {0},
        CustomFix = function(Function)
            ConstantMapping.Damage.OldUpvalues = debug.getupvalues(Function)

            debug.setupvalue(Function, 1, true)
            debug.setupvalue(Function, 3, function() end)
            debug.setupvalue(Function, 4, function() end)
            debug.setupvalue(Function, 5, 25)
            debug.setupvalue(Function, 6, true)
        end,
        RevertFix = function(Function)
            local OldUpvalues = ConstantMapping.Damage.OldUpvalues

            debug.setupvalue(Function, 1, OldUpvalues[1])
            debug.setupvalue(Function, 3, OldUpvalues[3])
            debug.setupvalue(Function, 4, OldUpvalues[4])
            debug.setupvalue(Function, 5, OldUpvalues[5])
            debug.setupvalue(Function, 6, OldUpvalues[6])
        end
    },

    Kick = {
        Constants = {"FailedPcall"},
        CustomGrab = function(Function)
            local OldEnv = getfenv(Function)

            setfenv(Function, {
                pcall = function()
                    return false 
                end
            })

            local OldKickFunction = debug.getupvalue(Function, 3)

            debug.setupvalue(Function, 3, function(Key, ...)
                debug.setupvalue(Function, 3, OldKickFunction)
                Keys["Kick"] = Key
            end)
            
            Function()

            setfenv(Function, OldEnv)
        end
    },

    Taze = {
        CustomFix = function(Function)
            local OldCasting = debug.getupvalue(Function, 2) 

            debug.setupvalue(Function, 1, {ObjectLocal = function() end})

            debug.setupvalue(Function, 2, {
                RayIgnoreNonCollideWithIgnoreList = function() 
                    debug.setupvalue(Function, 2, OldCasting)

                    local FakeCharacter = Instance.new("Model")
                    local FakeHumanoid = Instance.new("Part")

                    FakeHumanoid.Name = "Humanoid"
                    FakeHumanoid.Parent = FakeCharacter

                    return FakeHumanoid
                end
            })

            debug.setupvalue(Function, 3, {
                GetPlayerFromCharacter = function() 
                    debug.setupvalue(Function, 3, Players)

                    return {Name = ""}
                end
            })
        end,
        CustomArguments = {
            {ItemData = {NextUse = 0}, CrossHair = {Flare = function() end, Spring = {Accelerate = function() end}}, Config = {Sound = {tazer_buzz = 0}, ReloadTime = 0, ReloadTimeHit = 0}, IgnoreList = {}, Draw = function() end, BroadcastInputBegan = function() end, UpdateMousePosition = function() end, Tip = Instance.new("Part"), Local = true, MousePosition = Vector3.new(0, 0, 0)}
        },
        LocatedFunction = require(ReplicatedStorage:WaitForChild("Game"):WaitForChild("Item"):WaitForChild("Taser")).Tase,
        UpvalueIndex = 4
    }
}

--// Main Key Grabbing Functions

local KeyGrabber

KeyGrabber = {
    Utilities = {
        CompareConstants = function(Constants)
            local Matches = {}

            for Index, ConstantMap in next, ConstantMapping do 
                if ConstantMap.Constants then
                    local Amount = 0 
        
                    for Index, Constant in next, ConstantMap.Constants do 
                        if table.find(Constants, Constant) then 
                            Amount = Amount + 1 
                        end 
                    end
        
                    if Amount == #ConstantMap.Constants then 
                        table.insert(Matches, Index)
                    end
                end
            end
            
            return #Matches > 0 and Matches or false
        end,

        HookFireServer = function(Function, UpvalueIndex, ConstantMap, ComparedConstants)
            local OldNetwork = debug.getupvalue(Function, UpvalueIndex)

            debug.setupvalue(Function, UpvalueIndex, {
                FireServer = function(self, Key, ...)
                    debug.setupvalue(Function, UpvalueIndex, OldNetwork)

                    if ConstantMap.RevertFix then 
                        ConstantMap.RevertFix(Function)
                    end
                    
                    Keys[ComparedConstants] = Key
                end
            })
        end,

        PerformCall = function(Function, ConstantMap)
            if ConstantMap.CustomFix then 
                ConstantMap.CustomFix(Function)
            end

            if ConstantMap.CustomArguments then
                Function(unpack(ConstantMap.CustomArguments))
            else 
                Function()
            end
        end
    },

    GrabMethods = {
        UpvalueScan = function(Value, ConstantMap, ComparedConstants)
            local UpvalueIndex = ConstantMap.UpvalueIndex or 1

            for Index, Upvalue in next, debug.getupvalues(Value) do 
                if type(Upvalue) == "table" and rawget(Upvalue, "FireServer") then
                    UpvalueIndex = Index
                end
            end

            KeyGrabber.Utilities.HookFireServer(Value, UpvalueIndex, ConstantMap, ComparedConstants)
            KeyGrabber.Utilities.PerformCall(Value, ConstantMap)
        end,

        NestedUpvalueScan = function(Value, ConstantMap, ComparedConstants)
            local Upvalue = debug.getupvalues(Value)[ConstantMap.UpvalueIndex]

            if type(Upvalue) == "function" then
                for Index, SecondUpvalue in next, debug.getupvalues(Upvalue) do
                    if type(SecondUpvalue) == "table" and rawget(SecondUpvalue, "FireServer") then 
                        KeyGrabber.Utilities.HookFireServer(Upvalue, Index, ConstantMap, ComparedConstants)
                        KeyGrabber.Utilities.PerformCall(Upvalue, ConstantMap)
                    elseif type(SecondUpvalue) == "function" then 
                        for SecondIndex, ThirdUpvalue in next, debug.getupvalues(SecondUpvalue) do
                            if type(ThirdUpvalue) == "table" and rawget(ThirdUpvalue, "FireServer") then 
                                KeyGrabber.Utilities.HookFireServer(SecondUpvalue, SecondIndex, ConstantMap, ComparedConstants)
                                KeyGrabber.Utilities.PerformCall(SecondUpvalue, ConstantMap)
                            end
                        end
                    end
                end
            end
        end,

        ProtoScan = function(Value, ConstantMap, ComparedConstants)
            local Proto = debug.getproto(Value, ConstantMap.ProtoIndex)

            KeyGrabber.Utilities.HookFireServer(Proto, ConstantMap.UpvalueIndex, ConstantMap, ComparedConstants)
            KeyGrabber.Utilities.PerformCall(Proto, ConstantMap)
        end
    }
}

--// Grab Keys With Pre-Located Functions

for Index, ConstantMap in next, ConstantMapping do 
    local LocatedFunction = ConstantMap.LocatedFunction 

    if LocatedFunction then
        if ConstantMap.ProtoIndex then
            KeyGrabber.GrabMethods.ProtoScan(LocatedFunction, ConstantMap, Index)
        else 
            KeyGrabber.GrabMethods.UpvalueScan(LocatedFunction, ConstantMap, Index)
        end
    end
end

-- Main GC Loop to Grab Keys From Non-Located Functions

for Index, Value in next, getgc() do  
    if islclosure(Value) and not is_synapse_function(Value) then 
        local Constants = debug.getconstants(Value)
        local ComparedConstants = KeyGrabber.Utilities.CompareConstants(Constants)
        
        if ComparedConstants then 
            for Index, ComparedName in next, ComparedConstants do
                local ConstantMap = ConstantMapping[ComparedName]

                if ConstantMap.CustomGrab then
                    ConstantMap.CustomGrab(Value)
                else
                    --// Method 1

                    if not ConstantMap.ProtoIndex and not ConstantMap.UpvalueIndex then
                        KeyGrabber.GrabMethods.UpvalueScan(Value, ConstantMap, ComparedName)
                    end 
                    
                    --// Method 2 

                    if not ConstantMap.ProtoIndex and ConstantMap.UpvalueIndex then
                        KeyGrabber.GrabMethods.NestedUpvalueScan(Value, ConstantMap, ComparedName)
                    end

                    --// Method 3

                    if ConstantMap.ProtoIndex then
                        KeyGrabber.GrabMethods.ProtoScan(Value, ConstantMap, ComparedName)
                    end
                end
            end
        end
    end 
end

--// Output Keys

rconsolewarn(string.format("Took %s seconds to grab keys!\n", tick() - StartTime))

for Index, Key in next, Keys do 
    rconsoleprint(Index .. " : " .. Key .. "\n")
end
