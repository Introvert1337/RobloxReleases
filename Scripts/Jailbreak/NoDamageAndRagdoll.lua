--// variables 

local keys, network = loadstring(game:HttpGet("https://raw.githubusercontent.com/Introvert1337/RobloxReleases/main/Scripts/Jailbreak/KeyFetcher.lua"))()

--// no ragdoll

local tagUtils = require(game:GetService("ReplicatedStorage").Tag.TagUtils)

local oldIsPointInTag
tagUtils.isPointInTag = function(point, tag)
    if tag == "NoRagdoll" or tag == "NoFallDamage" then 
        return true
    end
    
    return oldIsPointInTag(point, tag)
end

--// no damage (only applies to some things like tomb spikes)

local oldFireServer = getupvalue(network.FireServer, 1)
setupvalue(network.FireServer, 1, function(key, ...)
    if key == keys.Damage then
        return
    end

    return oldFireServer(key, ...)
end)
