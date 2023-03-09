for _, module in next, getloadedmodules() do -- this used to be a lot harder :skull:
    local moduleData = require(module)
    
    if typeof(moduleData) == "table" and rawget(moduleData, "playerblob_has_vip_for_current_day") then
        moduleData.playerblob_has_vip_for_current_day = function()
            return true
        end
        
        break
    end
end
