--// ENV

getupvalue = getupvalue or debug.getupvalue 
setupvalue = setupvalue or debug.setupvalue 

--// Define Variables

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SelfKeybind = Enum.KeyCode[shared.build_cube_around_yourself_keybind:upper()]
local ClosestKeybind = Enum.KeyCode[shared.build_cube_around_closest_enemy_keybind:upper()]
local GlobalStuff = require(ReplicatedStorage.GlobalStuff)
local NetworkModule = require(ReplicatedStorage.NetworkModule)
local BuildModule = require(ReplicatedStorage.BuildModule)
local player = game:GetService("Players").LocalPlayer
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

local function Build(delta)
    for i = 1, 5 do --// Modify the position offset each time to have it make a cube
        spawn(function()
            local Offset = Offsets[i]
            local Position = GetClosest(delta + Offset)
            local AnglesY = GlobalStuff:Round(Angles[i], pi / 2)
            local ObjectName = "Wall"

            if i == 5 then 
                ObjectName = "Floor"
                Position = Position + Offset 
            end

            --// Call Strucid's Functions / Remotes To Build 

            BuildModule:UpdateGridData(Position.X, Position.Y, Position.Z, ObjectName, AnglesY, player.Name)

            local Response = NetworkModule:InvokeServer("Build", Position.X, Position.Y, Position.Z, ObjectName, AnglesY)
        
            if Response == true then
                local UpdateResourceCount = getsenv(player.PlayerGui.MainGui.MainLocal).UpdateResourceCount
                setupvalue(UpdateResourceCount, 2, getupvalue(UpdateResourceCount, 2) - 10)
                UpdateResourceCount()
            elseif Response == false then
                BuildModule:UpdateGridData(Position.X, Position.Y, Position.Z, nil);
            end 
        end)
    end
end

game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Keyboard  then
        if player:FindFirstChild("PlayerGui") and player.PlayerGui:FindFirstChild("MainGui") and player.PlayerGui.MainGui:FindFirstChild("MainLocal") then --// Check is player is spawned in
            if input.KeyCode == ClosestKeybind then 
                local ClosestPlayer = getsenv(player.PlayerGui.MainGui.MainLocal).GetClosestPlayer()
                if ClosestPlayer and ClosestPlayer.Character and ClosestPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    Build(ClosestPlayer.Character.HumanoidRootPart.Position)
                end
            elseif input.KeyCode == SelfKeybind then 
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then 
                    Build(player.Character.HumanoidRootPart.Position)
                end
            end
        end
    end
end)
