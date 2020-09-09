local MarketplaceService = game:WaitForChild("MarketplaceService")
local OldCoreGui = game:WaitForChild("CoreGui")
local OldCheckCaller = checkcaller
local OldFind = string.find

local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall 
local oldIndex = mt.__index
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = string.lower(getnamecallmethod())
    
    if OldCheckCaller() and OldFind(method, "purchase") or OldFind(method, "prompt") and self == MarketplaceService then 
        return 
    end
    
    return oldNamecall(self, ...)
end)

mt.__index = newcclosure(function(tbl, idx)
    if OldCheckCaller() and tostring(idx) == "PurchasePromptApp" and tbl == OldCoreGui then 
        return 
    end 
    
    return oldIndex(tbl, idx)
end)

setreadonly(mt, true)
