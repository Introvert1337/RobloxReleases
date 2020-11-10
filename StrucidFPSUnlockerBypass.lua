local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall 
setreadonly(mt, false)
    
mt.__namecall = newcclosure(function(self, ...)
	if getnamecallmethod() == "GetRealPhysicsFPS" and self == workspace and tostring(getfenv(0).script) == "MainLocal" then 
		return 60
	end
    return oldNamecall(self, ...)
end)
        
setreadonly(mt, true)
