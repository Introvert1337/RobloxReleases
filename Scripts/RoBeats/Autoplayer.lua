-- this is the lua version of the external autoplayer made by my friend and i (https://github.com/ViperTools/RoBeats-External-Autoplayer)

local keys = shared.keys or {} -- MAKE THIS YOUR ROBEATS KEYBINDS FROM LEFT TO RIGHT, OR SET IN SHARED.KEYS
local autoGrabKeys = shared.autoGrabKeys ~= nil and shared.autoGrabKeys or true

local VirtualInputManager = game:GetService("VirtualInputManager")
local camera = workspace.CurrentCamera

local Autoplayer = {
    noteY = 3879,
    sliderY = 3878,
    laneDistanceThreshold = 25,
    distanceLowerBound = 0.2,
    distanceUpperBound = 0.6,
    delayLowerBound = 0.03,
    delayUpperBound = 0.05,
    sliderDebounce = 0.06,
    random = Random.new(),
    pressedLanes = {},
    heldLanes = {},
    currentLanePositionsIndex = nil,
    lanePositions = {
        {
            Vector3.new(-309.00, 387.70, -181.09),
            Vector3.new(-306.87, 387.70, -178.56),
            Vector3.new(-304.53, 387.70, -176.21),
            Vector3.new(-301.99, 387.70, -174.08)
        },

        {
            Vector3.new(-301.99, 387.70, -235.64),
            Vector3.new(-304.53, 387.70, -233.51),
            Vector3.new(-306.87, 387.70, -231.16),
            Vector3.new(-309.00, 387.70, -228.60)
        },

        {
            Vector3.new(-247.44, 387.70, -228.63),
            Vector3.new(-249.57, 387.70, -231.16),
            Vector3.new(-251.92, 387.70, -233.51),
            Vector3.new(-254.46, 387.70, -235.64)
        },

        {
            Vector3.new(-254.46, 387.70, -174.08),
            Vector3.new(-251.92, 387.70, -176.21),
            Vector3.new(-249.57, 387.70, -178.56),
            Vector3.new(-247.44, 387.70, -181.09)
        }
    }
}

local function UpdateLanePositions()
    local nearestDistance = Autoplayer.laneDistanceThreshold
    local nearestGroupIndex

    for groupIndex, groupPositions in next, Autoplayer.lanePositions do
        local distance = (groupPositions[1] - camera.CFrame.Position).Magnitude

        if distance < nearestDistance then
            nearestDistance = distance
            nearestGroupIndex = groupIndex
        end
    end

    Autoplayer.currentLanePositionsIndex = nearestGroupIndex
end

local function GetNearestLane(position)
    UpdateLanePositions()
    
    local nearestDistance = Autoplayer.laneDistanceThreshold
    local nearestLane

    for laneIndex, lanePosition in next, Autoplayer.lanePositions[Autoplayer.currentLanePositionsIndex] do
        local distance = (lanePosition - position).Magnitude

        if distance < nearestDistance then
            nearestDistance = distance
            nearestLane = { laneIndex, lanePosition}
        end
    end

    if not nearestLane then 
        return
    end

    return nearestLane[1], nearestLane[2]
end

local function GrabKeys()
    if not autoGrabKeys or #keys == 4 then 
        return
    end
    
    for _, child in next, workspace:GetChildren() do
        if child:FindFirstChild("ControlPopup") then
            for _, descendant in next, child:GetChildren() do
                if descendant.Name == "ControlPopup" then
                    local popupLane = GetNearestLane(descendant.Position)
                    
                    if popupLane then
                    	keys[popupLane] = descendant.SurfaceGui.Frame.Letter.Text
                    end
                end
            end
        end
    end
end

for index, instance in next, workspace:GetDescendants() do
    if instance.ClassName == "CylinderHandleAdornment" then
        instance:GetPropertyChangedSignal("CFrame"):Connect(function()
            GrabKeys()

            if instance.Transparency == 0 and math.floor(instance.CFrame.Y * 10) == Autoplayer.noteY then
                local noteLane, lanePosition = GetNearestLane(instance.CFrame.Position)
                
                if noteLane then
                    local randomDistance = Autoplayer.random:NextNumber(Autoplayer.distanceLowerBound, Autoplayer.distanceUpperBound)
                    local distance = instance.CFrame.Position.X - lanePosition.X

                    if Autoplayer.currentLanePositionsIndex > 2 then 
                        distance = math.abs(distance)
                    end

                    if not Autoplayer.pressedLanes[noteLane] and distance <= randomDistance then
                        Autoplayer.pressedLanes[noteLane] = true

                        VirtualInputManager:SendKeyEvent(true, keys[noteLane], false, game)
                        task.wait(Autoplayer.random:NextNumber(Autoplayer.delayLowerBound, Autoplayer.delayUpperBound))
                        VirtualInputManager:SendKeyEvent(false, keys[noteLane], false, game)

                        Autoplayer.pressedLanes[noteLane] = false
                    end
                end
            elseif instance.Transparency < 1 and instance.Height > 0.2 and math.floor(instance.CFrame.Y * 10) == Autoplayer.sliderY then
                GrabKeys()

                local noteLane, lanePosition = GetNearestLane(instance.CFrame.Position)

                if noteLane then
                    local randomDistance = Autoplayer.random:NextNumber(Autoplayer.distanceLowerBound, Autoplayer.distanceUpperBound)
                    local distance = (instance.CFrame - instance.CFrame.LookVector * instance.Height / 2).X - lanePosition.X

                    if Autoplayer.currentLanePositionsIndex > 2 then 
                        distance = math.abs(distance)
                    end

                    if not Autoplayer.heldLanes[noteLane] and distance <= randomDistance then
                        Autoplayer.heldLanes[noteLane] = true
                        
                        VirtualInputManager:SendKeyEvent(true, keys[noteLane], false, game)
                        
                        local noteDistance

                        repeat
                            noteDistance = (instance.CFrame + instance.CFrame.LookVector * instance.Height / 2).X - lanePosition.X

                            task.wait()
                        until (Autoplayer.currentLanePositionsIndex > 2 and math.abs(noteDistance) or noteDistance) <= randomDistance
                        
                        VirtualInputManager:SendKeyEvent(false, keys[noteLane], false, game)
                        
                        task.wait(Autoplayer.sliderDebounce)
                        
                        Autoplayer.heldLanes[noteLane] = false
                    end
                end
            end
        end)
    end
end
