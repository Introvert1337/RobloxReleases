--[[
  Made in December 2024
  Made in collaboration with 0_void
  This autoplayer is simply based on the time of each note in the chart
]]

local VirtualInputManager = Instance.new("VirtualInputManager")
local RunService = game:GetService("RunService")

local songList, gameInput, oldSongTime
local random = Random.new()

local function playSession(getTime, songKey)
    setthreadidentity(8)

    local songData = songList:get(songKey)
    local keys = {}

    for index = 0, 3 do
        local keyString = gameInput:get_key_display_str(index)

        if keyString:find("/") then
            keyString = keyString:match("(%a+)/")
        end

        keys[index + 1] = keyString
    end

    local clonedHitObjects = {}

    while #songData.HitObjects == 0 do
        task.wait(0.1)
    end

    for index, hitObject in songData.HitObjects do
        clonedHitObjects[index] = table.clone(hitObject)
    end

    local currentTime = 0

    local autoplayerConnection
    autoplayerConnection = RunService.PreSimulation:Connect(function(deltaTime)
        if #clonedHitObjects == 0 or (currentTime > 0 and currentTime == getTime()) then
            return autoplayerConnection:Disconnect()
        end

        local fpsOffset = 3000 - 1400 / (1 / deltaTime)
        local randomOffset = random:NextNumber(fpsOffset - 15, fpsOffset)

        currentTime = getTime()

        for index, note in clonedHitObjects do
            if currentTime - randomOffset >= note.Time then
                if not note.Pressed then
                    note.Pressed = true

                    VirtualInputManager:SendKeyEvent(true, keys[note.Track], false, game)
                end

                if not note.Duration or currentTime - randomOffset >= note.Time + note.Duration then
                    table.remove(clonedHitObjects, index)

                    task.delay(random:NextNumber(0.02, 0.05), function()
                        VirtualInputManager:SendKeyEvent(false, keys[note.Track], false, game)
                    end)
                end
            end
        end
    end)
end

for _, value in getgc(true) do
    if typeof(value) ~= "table" then
        continue
    end

    if not oldSongTime and typeof(rawget(value, "new")) == "function" and islclosure(value.new) and getconstants(value.new)[2] == "get_native_size" then
        oldSongTime = value.new
        value.new = function(self, data)
            for _, value in data do
                if typeof(value) == "function" and #getconstants(value) == 0 then
                    local firstUpvalue = getupvalues(value)[1]

                    if typeof(firstUpvalue) == "table" and rawget(firstUpvalue, "get_current_mode") then
                        for _, value in firstUpvalue do
                            if typeof(value) == "function" then
                                local upvalues = getupvalues(value)

                                if #upvalues == 2 and typeof(upvalues[1]) == "table" then
                                    task.spawn(playSession, value, firstUpvalue:get_song_key())

                                    break
                                end
                            end
                        end

                        break
                    end
                end
            end

            return oldSongTime(self, data)
        end
    end

    if not songList and rawget(value, "get_title_for_key") then
        songList = getupvalue(value.get_title_for_key, 1)
    end

    if not gameInput and rawget(value, "_input") then
        gameInput = value._input
    end
end
