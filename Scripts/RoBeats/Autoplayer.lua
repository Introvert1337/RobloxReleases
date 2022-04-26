local VirtualInputManager = game:GetService("VirtualInputManager")
local camera = workspace.CurrentCamera

local Autoplayer = {
    noteY = 3879,
    sliderY = 3878,
    laneDistanceThreshold = 25,
    distanceLowerBound = 0.1,
    distanceUpperBound = 1.2,
    delayLowerBound = 0.03,
    delayUpperBound = 0.05,
    random = Random.new(),
    pressedLanes = {},
    heldLanes = {false, false, false, false},
    keys = shared.keys or {"Z", "X", "Comma", "Period"},
    lanePositions = {
        -- singleplayer
        [Vector3.new(-309.01, 387.70, -181.10)] = 1,
        [Vector3.new(-306.87, 387.70, -178.56)] = 2,
        [Vector3.new(-304.53, 387.70, -176.22)] = 3,
        [Vector3.new(-302.00, 387.70, -174.01)] = 4,
        -- multiplayer
        [Vector3.new(-254.46, 387.70, -235.65)] = 1,
        [Vector3.new(-251.92, 387.70, -233.51)] = 2,
        [Vector3.new(-249.58, 387.70, -231.17)] = 3,
        [Vector3.new(-247.44, 387.70, -228.63)] = 4,
    }
}

local function GetNearestLane(position)
    local nearestDistance = Autoplayer.laneDistanceThreshold
    local nearestLane = {}

    for lanePosition, laneIndex in next, Autoplayer.lanePositions do
        local distance = (lanePosition - position).Magnitude

        if distance < nearestDistance then
            nearestDistance = distance
            nearestLane = {laneIndex, lanePosition}
        end
    end

    return nearestLane[1], nearestLane[2]
end

for index, instance in next, workspace:GetDescendants() do
    local isNoteOrSliderEnd, isSliderStart = instance.ClassName == "CylinderHandleAdornment", instance.ClassName == "SphereHandleAdornment"

    if isNoteOrSliderEnd or isSliderStart then
        instance:GetPropertyChangedSignal("CFrame"):Connect(function()
            if isNoteOrSliderEnd and instance.Transparency == 0 and math.floor(instance.CFrame.Y * 10) == Autoplayer.noteY then
                local noteLane, notePosition = GetNearestLane(instance.CFrame.Position)
                
                if noteLane then
                    local randomDistance = Autoplayer.random:NextNumber(Autoplayer.distanceLowerBound, Autoplayer.distanceUpperBound)
                    local distance = instance.CFrame.Position.X - notePosition.X

                    if not Autoplayer.pressedLanes[noteLane] and distance <= randomDistance then
                        Autoplayer.pressedLanes[noteLane] = true

                        VirtualInputManager:SendKeyEvent(true, Autoplayer.keys[noteLane], false, game)
                        task.wait(Autoplayer.random:NextNumber(Autoplayer.delayLowerBound, Autoplayer.delayUpperBound))
                        VirtualInputManager:SendKeyEvent(false, Autoplayer.keys[noteLane], false, game)

                        Autoplayer.pressedLanes[noteLane] = false
                    end
                end
            elseif (isNoteOrSliderEnd and instance.Transparency < 1 and instance.Height > 0.2 and math.floor(instance.CFrame.Y * 10) == Autoplayer.sliderY) or (isSliderStart and instance.Transparency == 0 and instance.Visible) then
                local noteLane, notePosition = GetNearestLane(instance.CFrame.Position)

                if noteLane then
                    local randomDistance = Autoplayer.random:NextNumber(Autoplayer.distanceLowerBound, Autoplayer.distanceUpperBound)
                    local distance = (isNoteOrSliderEnd and instance.CFrame.X + instance.Height / 3 or instance.CFrame.X) - notePosition.X

                    if Autoplayer.heldLanes[noteLane] == isNoteOrSliderEnd and distance <= randomDistance then
                        VirtualInputManager:SendKeyEvent(isSliderStart, Autoplayer.keys[noteLane], false, game)

                        if isNoteOrSliderEnd then
                            Autoplayer.heldLanes[noteLane] = nil
                            task.wait(0.04)
                        end

                        Autoplayer.heldLanes[noteLane] = isSliderStart
                    end
                end
            end
        end)
    end
end
