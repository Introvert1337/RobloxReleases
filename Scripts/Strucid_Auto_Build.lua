-- im pretty sure this is outdated but if u wanna fix it and release ur own version u have permission :)
-- also i made this a long time ago so the code sux

--// ENV

local getupvalue = getupvalue or debug.getupvalue 
local setupvalue = setupvalue or debug.setupvalue 

--// Define Variables

shared.build_cube_around_yourself_keybind = shared.build_cube_around_yourself_keybind or "K"
shared.build_cube_around_closest_enemy_keybind = shared.build_cube_around_closest_enemy_keybind or "Z"

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Player = game:GetService("Players").LocalPlayer

local SelfKeybind = Enum.KeyCode[shared.build_cube_around_yourself_keybind:upper()]
local ClosestKeybind = Enum.KeyCode[shared.build_cube_around_closest_enemy_keybind:upper()]

local GlobalStuff = require(ReplicatedStorage.GlobalStuff)
local NetworkModule = require(ReplicatedStorage.NetworkModule)
local BuildModule = require(ReplicatedStorage.BuildModule)

local pi = math.pi
local floor = math.floor

local Angles = { --// Angle of each wall / floor
    -pi / 2, pi, pi / 2, -pi, pi / 2
}

local Offsets = { --// Position offset of each wall / floor
    Vector3.new(9, 0, 0), Vector3.new(0, 0, 9), Vector3.new(-9, 0, 0), Vector3.new(0, 0, -9), Vector3.new(0, 9, 0) 
}

--// Function to find the nearest valid grid point

local function GetClosest(Pos)
    return Vector3.new(floor((Pos.X / 9) + 0.5) * 9, floor((Pos.Y / 18) + 0.5) * 18, floor((Pos.Z / 9) + 0.5) * 9)
end

--// Function to build the cube

local function Build(Delta)
    for Index = 1, 5 do --// Modify the position offset each time to have it make a cube
        coroutine.wrap(function()
            local Offset = Offsets[Index]
            local ClosestPosition = GetClosest(Delta + Offset)
            local Position = Index == 5 and ClosestPosition + Offset or ClosestPosition 
            local AnglesY = GlobalStuff:Round(Angles[Index], pi / 2)
            local ObjectName = Index == 5 and "Floor" or "Wall"

            --// Call Strucid's Functions / Remotes To Build 

            BuildModule:UpdateGridData(Position.X, Position.Y, Position.Z, ObjectName, AnglesY, Player.Name)

            local Response = NetworkModule:InvokeServer("Build", Position.X, Position.Y, Position.Z, ObjectName, AnglesY)
        
            if Response == true then
                local UpdateResourceCount = getsenv(Player.PlayerGui.MainGui.MainLocal).UpdateResourceCount
                setupvalue(UpdateResourceCount, 2, getupvalue(UpdateResourceCount, 2) - 10)
                UpdateResourceCount()
            elseif Response == false then
                BuildModule:UpdateGridData(Position.X, Position.Y, Position.Z, nil);
            end 
        end)()
    end
end

game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Keyboard  then
        if Player:FindFirstChild("PlayerGui") and Player.PlayerGui:FindFirstChild("MainGui") and Player.PlayerGui.MainGui:FindFirstChild("MainLocal") then --// Check if player is spawned in
            if input.KeyCode == ClosestKeybind then 
                local ClosestPlayer = getsenv(Player.PlayerGui.MainGui.MainLocal).GetClosestPlayer()

                if ClosestPlayer and ClosestPlayer.Character and ClosestPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    Build(ClosestPlayer.Character.HumanoidRootPart.Position)
                end
            elseif input.KeyCode == SelfKeybind then 
                if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then 
                    Build(Player.Character.HumanoidRootPart.Position)
                end
            end
        end
    end
end)
