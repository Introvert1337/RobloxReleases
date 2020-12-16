--// ENV

getupvalue = getupvalue or debug.getupvalue 
setupvalue = setupvalue or debug.setupvalue 

--// Define Variables

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SelfKeybind = Enum.KeyCode[shared.build_cube_around_yourself_keybind:upper()]
local ClosestKeybind = Enum.KeyCode[shared.build_cube_around_closest_enemy_keybind:upper()]
local BuildAssets = ReplicatedStorage.BuildAssets
local GlobalStuff = require(ReplicatedStorage.GlobalStuff)
local NetworkModule = require(ReplicatedStorage.NetworkModule)
local BuildModule = require(ReplicatedStorage.BuildModule)
local player = game:GetService("Players").LocalPlayer
local pi = math.pi
local floor = math.floor
local Angles = { --// Angle of each wall / floor
    -pi / 2, pi, pi / 2, -pi, pi / 2
}

--// Function to find the nearest valid grid point

local function GetClosest(Pos)
    return Vector3.new(floor((Pos.X / 9) + 0.5) * 9, floor((Pos.Y / 18) + 0.5) * 18, floor((Pos.Z / 9) + 0.5) * 9)
end

--// Function to build the cube

local function Build(pos)
    local ObjectToBuild = "Wall" --// The object type
    local Position

    for i = 1, 5 do --// Modify the position offset each time to have it make a cube
        if i == 1 then
            Position = pos + Vector3.new(9, 0, 0)
        elseif i == 2 then
            Position = pos + Vector3.new(0, 0, 9)
        elseif i == 3 then 
            Position = pos - Vector3.new(9, 0, 0)
        elseif i == 4 then
            Position = pos - Vector3.new(0, 0, 9)
        elseif i == 5 then 
            ObjectToBuild = "Floor"
            Position = pos + Vector3.new(0, 9, 0)
        end

        Position = GetClosest(Position)

        if ObjectToBuild == "Floor" then 
            Position = Position + Vector3.new(0, 9, 0)
        end
    
        local BuildNewCFrame = Position

        if Type == "Pyramid" then
            BuildNewCFrame = BuildNewCFrame + Vector3.new(0, -4.5, 0)
        end
        
        local AnglesY = GlobalStuff:Round(Angles[i], pi / 2)
        local ObjectCFrame = CFrame.new(BuildNewCFrame) * CFrame.Angles(0, AnglesY, 0) * CFrame.Angles(0, 0, 0)

        --// Call Strucid's Functions / Remotes To Build 

        BuildModule:UpdateGridData(Position.X, Position.Y, Position.Z, ObjectToBuild, AnglesY, player.Name)

        local Response = NetworkModule:InvokeServer("Build", Position.X, Position.Y, Position.Z, ObjectToBuild, AnglesY)
    
        if Response == true then
            local UpdateResourceCount = getsenv(player.PlayerGui.MainGui.MainLocal).UpdateResourceCount
            setupvalue(UpdateResourceCount, 2, getupvalue(UpdateResourceCount, 2) - 10)
            UpdateResourceCount()
        elseif Response == false then
            BuildModule:UpdateGridData(Position.X, Position.Y, Position.Z, nil);
        end 
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
