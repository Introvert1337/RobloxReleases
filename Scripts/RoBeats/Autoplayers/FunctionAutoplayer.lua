--[[
  Created January 2022
  This autoplayer is fully reliant on RoBeats functions and data
]]

--// variables

local player = game:GetService("Players").LocalPlayer

local accuracyBounds = {
    Perfect = -20, 
    Great = -50,
    Okay = -100
}

local accuracyNames = {"Perfect", "Great", "Okay"}

local accuracy = "Perfect" -- Perfect, Great, Okay, Random
local noteTimeTarget = accuracyBounds[accuracy]

local trackSystem
local random = Random.new()

--// functions 

local function getTrackActionFunctions(trackSystem)
    local pressTrack, releaseTrack
    
    for index, trackFunction in trackSystem do 
        if typeof(trackFunction) == "function" then 
            local constants = getconstants(trackFunction)
            
            if table.find(constants, "press") then 
                pressTrack = trackFunction

                if releaseTrack then 
                    break 
                end
            elseif table.find(constants, "release") then 
                releaseTrack = trackFunction

                if pressTrack then 
                    break 
                end
            end
        end
    end
    
    return pressTrack, releaseTrack
end

local function getLocalTrackSystem(session)
    local localSlotIndex = getupvalue(session.set_local_game_slot, 1)
    
    for index, sessionFunction in session do 
        if typeof(sessionFunction) == "function" then 
            local object = getupvalues(sessionFunction)[1]
            
            if typeof(object) == "table" and rawget(object, "count") and object:count() <= 4 then 
                return object:get(localSlotIndex)
            end
        end
    end
end

--// get trackSystem 

for index, module in getloadedmodules() do 
    local moduleValue = require(module)
    
    if typeof(moduleValue) == "table" then 
        local newFunction = rawget(moduleValue, "new")
        
        if newFunction then 
            local firstUpvalue = getupvalues(newFunction)[1]
            
            if typeof(firstUpvalue) == "table" and rawget(firstUpvalue, "twister") then 
                trackSystem = moduleValue

                break
            end
        end
    end
end

--// main autoplayer 

local oldTrackSystemNew = trackSystem.new
trackSystem.new = function(...)
    local trackFunctions = oldTrackSystemNew(...)
    local arguments = {...}
    
    if arguments[2]._players._slots:get(arguments[3])._name == player.Name then -- make sure its only autoplaying your notes if in multiplayer
        for index, trackFunction in trackFunctions do 
            local upvalues = getupvalues(trackFunction)
            
            if typeof(upvalues[1]) == "table" and rawget(upvalues[1], "profilebegin") then 
                local notesTable = upvalues[2]
                
                trackFunctions[index] = function(self, slot, session)
                    local localTrackSystem = getLocalTrackSystem(session)
                    local pressTrack, releaseTrack = getTrackActionFunctions(localTrackSystem)
                    
                    local testPressName = getconstant(pressTrack, 10)
                    local testReleaseName = getconstant(releaseTrack, 6)
                    
                    if accuracy == "Random" then 
                        noteTimeTarget = accuracyBounds[accuracyNames[random:NextInteger(1, 3)]]
                    end

                    local randomizedTarget = random:NextNumber(noteTimeTarget, noteTimeTarget + 20)
    
                    for noteIndex = 1, notesTable:count() do 
                        local note = notesTable:get(noteIndex)
                        
                        if note then 
                            local testPress, testRelease = note[testPressName], note[testReleaseName]
                            
                            local noteTrackIndex = note:get_track_index(noteIndex)
                            local pressed, pressResult, pressDelay = testPress(note)
                            
                            if pressed and pressDelay >= randomizedTarget then
                                pressTrack(localTrackSystem, session, noteTrackIndex)
                                session:debug_any_press()
                                
                                if rawget(note, "get_time_to_end") then -- if its not a long note then release right after
                                    task.delay(random:NextNumber(0.05, 0.12), function()
                                        releaseTrack(localTrackSystem, session, noteTrackIndex)
                                    end)
                                end
                            end
                            
                            if testRelease then 
                                local released, releaseResult, releaseDelay = testRelease(note)
                                
                                if released and releaseDelay >= randomizedTarget then 
                                    task.delay(random:NextNumber(0.02, 0.05), function()
                                        releaseTrack(localTrackSystem, session, noteTrackIndex)
                                    end)
                                end
                            end
                        end
                    end
                    
                    return trackFunction(self, slot, session)
                end
            end
        end
    end
    
    return trackFunctions
end
