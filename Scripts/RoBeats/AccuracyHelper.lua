-- this will make great hits perfect and okay hits great

for index, module in next, getloadedmodules() do
    local moduleValue = require(module)

    if typeof(moduleValue) == "table" and rawget(moduleValue, "lookat_matrix") then
        for functionName, functionValue in next, moduleValue do
            if typeof(functionValue) == "function" then
                local constants, upvalues = getconstants(functionValue), getupvalues(functionValue)

                if #constants == 4 and #upvalues == 1 then
                    local noteResults = upvalues[1]
    
                    if typeof(noteResults) == "table" and rawget(noteResults, constants[2]) then
                        local perfectNoteResult = noteResults[constants[4]]
                        local greatNoteResult = noteResults[constants[3]]
                        local okayNoteResult = noteResults[constants[2]]
        
                        local oldGetNoteResult = moduleValue[functionName]
                        moduleValue[functionName] = function(...)
                            local realNoteResult = oldGetNoteResult(...)
            
                            if realNoteResult == okayNoteResult then
                                return greatNoteResult
                            elseif realNoteResult == greatNoteResult then
                                return perfectNoteResult
                            end
            
                            return realNoteResult
                        end
        
                        return warn("Successfully hooked note results!")
                    end
                end
            end
        end
    end
end
