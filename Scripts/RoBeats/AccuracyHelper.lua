-- this will make great hits perfect and okay hits great

local function validateNoteResultFunction(moduleFunction)
    local constants, upvalues = getconstants(moduleFunction), getupvalues(moduleFunction)
    
    if #constants == 4 and #upvalues == 1 then
        local possibleNoteResults = upvalues[1]
        
        if type(possibleNoteResults) == "table" and rawget(possibleNoteResults, constants[2]) then
            return possibleNoteResults, constants
        end
    end
end

for index, module in next, getloadedmodules() do
    if not module.Parent then
        local moduleValue = require(module)

        if type(moduleValue) == "table" and rawget(moduleValue, "lookat_matrix") then
            for functionName, functionValue in next, moduleValue do
                if type(functionValue) == "function" then
                    local noteResults, functionConstants = validateNoteResultFunction(functionValue)
                    
                    if noteResults then
                        local perfectNoteResult = noteResults[functionConstants[4]]
                        local greatNoteResult = noteResults[functionConstants[3]]
                        local okayNoteResult = noteResults[functionConstants[2]]
                        
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
                    end
                end
            end
        end
    end
end
