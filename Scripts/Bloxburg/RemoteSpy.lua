--// function to convert a table to a formatted string (credits to aztup)

local tableFormat = loadstring(game:HttpGet("https://raw.githubusercontent.com/Introvert1337/RobloxReleases/main/Scripts/Utilities/TableFormatter.lua"))()

--// variables 

local remoteBlacklist = {
    LookDir = true,
    GetServerTime = true,
    FloorPos = true,
    VehicleUpdate = true
}

--// grab remotes

local remotes = {}

local remoteAdded = getconnections(game:GetService("ReplicatedStorage").Modules.DataService.DescendantAdded)[1].Function
local remoteKeys = getupvalue(remoteAdded, 1)

for remoteKey, remoteName in next, getupvalue(getupvalue(remoteAdded, 2), 1) do
    remotes[remoteKeys[remoteKey]] = remoteName:sub(1, 2) == "F_" and remoteName:sub(3) or remoteName
end

--// remote call hook 

local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local remoteName = remotes[self]
    
    if remoteName and not remoteBlacklist[remoteName] then 
        local namecallMethod = getnamecallmethod()

        if (namecallMethod == "FireServer" and self.ClassName == "RemoteEvent") or (namecallMethod == "InvokeServer" and self.ClassName == "RemoteFunction") then 
            local arguments = {...}
            
            local source = debug.traceback()
            
            if checkcaller() then -- this is probably shit but idk
                source = source:match("\n(.+)")
            else
                source = source:match(("function %s\n(.+)"):format(namecallMethod))
            end

            arguments.__name = remoteName
            arguments.__method = namecallMethod
            arguments.__source = source:sub(1, -2)

            rconsolewarn(tableFormat(arguments) .. "\n\n")
        end
    end
    
    return oldNamecall(self, ...)
end)
