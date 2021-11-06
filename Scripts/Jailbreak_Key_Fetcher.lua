--// Game Loaded

if not game:IsLoaded() then
    game.Loaded:Wait()
end

--// Init Variables

local Keys = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local StartTime = tick()

local Game = ReplicatedStorage:WaitForChild("Game")
local ItemSystem = require(Game:WaitForChild("ItemSystem"):WaitForChild("ItemSystem"))
local Network = getupvalue(ItemSystem.Init, 1)

--// Localizations

local getupvalue = getupvalue or debug.getupvalue 
local setupvalue = setupvalue or debug.setupvalue
local getupvalues = getupvalues or debug.getupvalues
local getconstant = getconstant or debug.getconstant
local setconstant = setconstant or debug.setconstant
local getconstants = getconstants or debug.getconstants
local getproto = getproto or debug.getproto
local islclosure = islclosure or is_l_closure
local is_exploit_function = is_synapse_function or is_protosmasher_closure or checkclosure

local tfind = table.find
local tinsert = table.insert

local require = require
local type = type 
local rawget = rawget
local unpack = unpack

--// Function Identification and Fixes

local ConstantMapping
ConstantMapping = {
    CarKick = {
        Constants = {"Eject", "MouseButton1Down"},
        UpvalueIndex = 1,
        ProtoIndex = 1
    },
    
    BrodcastInputBegan = {
        LocatedFunction = ItemSystem._equip,
        ProtoIndex = 5,
        UpvalueIndex = 1,
        CustomArguments = {true, {}}
    },
    
    BrodcastInputEnded = {
        LocatedFunction = ItemSystem._equip,
        ProtoIndex = 6,
        UpvalueIndex = 1,
        CustomArguments = {true, {}}
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
        ProtoIndex = 4,
        UpvalueIndex = 2,
        LocatedFunction = require(Game:WaitForChild("TeamChooseUI")).Show
    },

    Punch = {
        Constants = {"LoadAnimation", "GetLocalEquipped"},
        CustomArguments = {{Name = "Punch"}, true}, 
        CustomFix = function(Function)
            local Constants = getconstants(Function)
            
            for Index, Constant in next, Constants do 
                if Constant == "Play" and getconstant(Function, Index - 1) == "LoadAnimation" then 
                    ConstantMapping.Punch.ConstantIndex = Index
                    setconstant(Function, Index, "Stop")
                    break
                end
            end
        end,
        RevertFix = function(Function)
            setconstant(Function, ConstantMapping.Punch.ConstantIndex, "Play")
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
            ConstantMapping.ExitCar.OldUpvalue = getupvalue(Function, 1)
            setupvalue(Function, 1, {})
        end,
        RevertFix = function(Function)
            setupvalue(Function, 1, ConstantMapping.ExitCar.OldUpvalue)
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
        LocatedFunction = getproto(getproto(require(Game:WaitForChild("MilitaryTurret"):WaitForChild("MilitaryTurretSystem")).init, 1), 1),
        UpvalueIndex = 1
    },

    FallDamage = {
        Constants = {"NoFallDamage", "NoRagdoll"},
        CustomArguments = {0},
        CustomFix = function(Function)
            ConstantMapping.Damage.OldUpvalues = getupvalues(Function)

            setupvalue(Function, 1, true)
            setupvalue(Function, 3, function() end)
            setupvalue(Function, 4, function() end)
            setupvalue(Function, 5, 25)
            setupvalue(Function, 6, true)
        end,
        RevertFix = function(Function)
            local OldUpvalues = ConstantMapping.Damage.OldUpvalues

            for Index = 1, 6 do
                if Index ~= 2 then
                    setupvalue(Function, Index, OldUpvalues[Index])
                end
            end
        end
    },

    Kick = {
        Constants = {"FailedPcall"},
        CustomGrab = function(Function)
            local OldEnv = getfenv(Function)

            setfenv(Function, {pcall = function() return false end})

            local OldKickFunction = getupvalue(Function, 3)

            setupvalue(Function, 3, function(Key)
                setupvalue(Function, 3, OldKickFunction)
                Keys["Kick"] = Key
            end)
            
            Function()

            setfenv(Function, OldEnv)
        end
    },

    Taze = {
        CustomFix = function(Function)
            local OldItemUtils = getupvalue(Function, 1)
            local OldAudio = getupvalue(Function, 2)
            local OldCasting = getupvalue(Function, 5) 
            local OldPlayerUtils = getupvalue(Function, 6)
            
            setupvalue(Function, 1, {getAttr = function() return 0 end, setAttr = function() setupvalue(Function, 1, OldItemUtils) end})
            setupvalue(Function, 2, {ObjectLocal = function() setupvalue(Function, 2, OldAudio) end})
            setupvalue(Function, 3, {
                GetPlayers = function() 
                    setupvalue(Function, 3, Players)
                    return {}
                end
            })
            setupvalue(Function, 5, {
                RayIgnoreNonCollideWithIgnoreList = function() 
                    setupvalue(Function, 5, OldCasting)     
                    return true
                end
            })
            setupvalue(Function, 6, {
                getPlayerFromDescendant = function() 
                    setupvalue(Function, 6, OldPlayerUtils)
                    return {Name = ""}
                end
            })
        end,
        CustomArguments = {
            {ItemData = {NextUse = 0}, CrossHair = {Flare = function() end, Spring = {Accelerate = function() end}}, Config = {Sound = {tazer_buzz = 0}, ReloadTime = 0, ReloadTimeHit = 0}, IgnoreList = {}, Draw = function() end, BroadcastInputBegan = function() end, UpdateMousePosition = function() end, Tip = Instance.new("Part"), Local = true, MousePosition = Vector3.new()}
        },
        LocatedFunction = require(ReplicatedStorage:WaitForChild("Game"):WaitForChild("Item"):WaitForChild("Taser")).Tase,
        UpvalueIndex = 4
    },

    PopTire = {
        Constants = {"LastImpactSound", "LastImpact", "OnHitSurface"},
        ProtoIndex = 2,
        UpvalueIndex = 7,
        CustomArguments = {{Color = Color3.new(0, 0, 0), IsDescendantOf = function(self, obj) return obj.Name == "ShootingRange" end}, Vector3.new(), Vector3.new(), 0},
        CustomFix = function(Function)
            ConstantMapping.PopTire.OldUpvalues = getupvalues(Function)
            
            setupvalue(Function, 1, {Weld = function() end})
            setupvalue(Function, 2, {Local = false, LastImpactSound = 0, LastImpact = 0.2})
            setupvalue(Function, 5, ReplicatedStorage)
            setupvalue(Function, 6, {AddItem = function() getupvalue(Function, 2).Local = true end})
        end,
        RevertFix = function(Function)
            local OldUpvalues = ConstantMapping.PopTire.OldUpvalues
            
            setupvalue(Function, 1, OldUpvalues[1])
            setupvalue(Function, 2, OldUpvalues[2])
            setupvalue(Function, 6, game:GetService("Debris"))
        end
    }
}

--// Main Key Grabbing Functions

local KeyGrabber
KeyGrabber = {
    Utilities = {
        CompareConstants = function(Constants)
            local Matches = {}

            for Index, ConstantMap in next, ConstantMapping do
                local MapConstants = ConstantMap.Constants
                
                if MapConstants then
                    if tfind(Constants, MapConstants[1]) then 
                        local Amount = 1
                        local MapConstantsAmount = #MapConstants
            
                        for Index = 2, MapConstantsAmount do 
                            if tfind(Constants, MapConstants[Index]) then 
                                Amount = Amount + 1 
                            end 
                        end
            
                        if Amount == MapConstantsAmount then 
                            tinsert(Matches, Index)
                        end
                    end
                end
            end
            
            return #Matches > 0 and Matches or false
        end,

        HookFireServer = function(Function, UpvalueIndex, ConstantMap, ComparedConstants)
            setupvalue(Function, UpvalueIndex, {
                FireServer = function(self, Key)
                    setupvalue(Function, UpvalueIndex, Network)

                    if ConstantMap.RevertFix then 
                        ConstantMap.RevertFix(Function)
                    end
                    
                    Keys[ComparedConstants] = Key
                end
            })
        end,

        PerformCall = function(Function, ConstantMap, KeyName)
            local Success, Error = pcall(function()
                if ConstantMap.CustomFix then 
                    ConstantMap.CustomFix(Function)
                end

                if ConstantMap.CustomArguments then
                    Function(unpack(ConstantMap.CustomArguments))
                else 
                    Function()
                end
            end)
            
            if not Success then 
                warn(("Failed to grab key for: %s\nError: %s"):format(KeyName or "Unknown", Error))
            end
        end,
        
        ValidateProtoConstants = function(Constants)
            for Index, Constant in next, Constants do 
                if Constant == "FireServer" then 
                    return true 
                end 
            end 
            
            return false
        end
    },

    GrabMethods = {
        UpvalueScan = function(Value, ConstantMap, ComparedConstants)
            local UpvalueIndex = ConstantMap.UpvalueIndex

            if not UpvalueIndex then
                for Index, Upvalue in next, getupvalues(Value) do 
                    if type(Upvalue) == "table" and rawget(Upvalue, "FireServer") then
                        UpvalueIndex = Index
                    end
                end
            end

            KeyGrabber.Utilities.HookFireServer(Value, UpvalueIndex, ConstantMap, ComparedConstants)
            KeyGrabber.Utilities.PerformCall(Value, ConstantMap, ComparedConstants)
        end,

        NestedUpvalueScan = function(Value, ConstantMap, ComparedConstants)
            local Upvalue = getupvalues(Value)[ConstantMap.UpvalueIndex]

            if type(Upvalue) == "function" then
                for Index, SecondUpvalue in next, getupvalues(Upvalue) do
                    if type(SecondUpvalue) == "table" and rawget(SecondUpvalue, "FireServer") then 
                        KeyGrabber.Utilities.HookFireServer(Upvalue, Index, ConstantMap, ComparedConstants)
                        KeyGrabber.Utilities.PerformCall(Upvalue, ConstantMap, ComparedConstants)
                    elseif type(SecondUpvalue) == "function" then 
                        for SecondIndex, ThirdUpvalue in next, getupvalues(SecondUpvalue) do
                            if type(ThirdUpvalue) == "table" and rawget(ThirdUpvalue, "FireServer") then 
                                KeyGrabber.Utilities.HookFireServer(SecondUpvalue, SecondIndex, ConstantMap, ComparedConstants)
                                KeyGrabber.Utilities.PerformCall(SecondUpvalue, ConstantMap, ComparedConstants)
                            end
                        end
                    end
                end
            end
        end,

        ProtoScan = function(Value, ConstantMap, ComparedConstants)
            local Proto = getproto(Value, ConstantMap.ProtoIndex)

            if KeyGrabber.Utilities.ValidateProtoConstants(getconstants(Proto)) then
                KeyGrabber.Utilities.HookFireServer(Proto, ConstantMap.UpvalueIndex, ConstantMap, ComparedConstants, ProtoNetwork)
                KeyGrabber.Utilities.PerformCall(Proto, ConstantMap, ComparedConstants)
            else 
                warn(("Invalid proto fetched for key %s"):format(ComparedConstants))
            end
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

local GarbageCollection = getgc()

for Index = 1, #GarbageCollection do  
    local Value = GarbageCollection[Index]
    
    if islclosure(Value) and not is_exploit_function(Value) then 
        local ComparedConstants = KeyGrabber.Utilities.CompareConstants(getconstants(Value))
        
        if ComparedConstants then 
            for Index, ComparedName in next, ComparedConstants do
                local ConstantMap = ConstantMapping[ComparedName]

                if ConstantMap.CustomGrab then -- Custom Method
                    ConstantMap.CustomGrab(Value)
                elseif not ConstantMap.ProtoIndex and not ConstantMap.UpvalueIndex then -- Method 1
                    KeyGrabber.GrabMethods.UpvalueScan(Value, ConstantMap, ComparedName)
                elseif not ConstantMap.ProtoIndex and ConstantMap.UpvalueIndex then -- Method 2
                    KeyGrabber.GrabMethods.NestedUpvalueScan(Value, ConstantMap, ComparedName)
                elseif ConstantMap.ProtoIndex then -- Method 3
                    KeyGrabber.GrabMethods.ProtoScan(Value, ConstantMap, ComparedName)
                end 
            end
        end
    end 
end

--// Output Keys

if shared.OutputKeys then
    rconsolewarn(("Took %s seconds to grab keys!\n"):format(tick() - StartTime))
    
    for Index, Key in next, Keys do 
        rconsoleprint(("%s : %s\n"):format(Index, Key))
    end
end

--// Add Keys and Network to Global Environment

if shared.AddToEnv then
    local Environment = getgenv()
    
    Environment.Keys = Keys
    Environment.Network = Network
end

--// Return Keys and Network

return Keys, Network
