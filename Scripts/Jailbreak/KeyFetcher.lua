--// Check if already in env

if networkKeys and network then 
    return networkKeys, network
end

--// Variables 

local startTime = tick()

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService")

local network = getupvalue(require(ReplicatedStorage.Module.AlexChassis).SetEvent, 1)
local keysList = getupvalue(getupvalue(network.FireServer, 1), 3)

local gameFolder = ReplicatedStorage.Game

local teamChooseUI = require(gameFolder.TeamChooseUI) -- module used in multiple keys
local defaultActions = require(gameFolder.DefaultActions) -- module used in multiple keys
local itemSystem = require(gameFolder.ItemSystem.ItemSystem) -- module used in multiple keys

local networkKeys = {}
local keyFunctions = {}

local exceptionKeys = { -- keys to use alternative method (deemed to be more efficient for these cases)
    PlaySound = function(checkFunction)
        return getconstants(checkFunction)[1] == "Source"
    end,
    CameraUpdate = function(checkFunction)
        return getconstants(checkFunction)[1] == "MakeSpring"
    end
}

--// Functions

local function fetchKey(callerFunction, keyIndex)
    local constants = getconstants(callerFunction)
    local prefixIndexes = { }
    local foundKeys = { }
    
    keyIndex = keyIndex or 1
    
    for index, constant in next, constants do
        if keysList[constant] then -- if the constants already contain the raw key
            table.insert(foundKeys, { constant, 0 })
        elseif typeof(constant) ~= "string" or constant == "" or constant:lower() ~= constant then
            constants[index] = nil -- remove constants that are 100% not the ones we need to make it a bit faster
        end
    end
    
    for key, remote in next, keysList do
        local prefixPassed, prefixIndex = false
        local keyLength = #key
        local keyFound = false

        for index, constant in next, constants do
            local constantLength = #constant

            if not prefixPassed and key:sub(1, constantLength) == constant then -- check if the key starts with one of the constants
                prefixPassed, prefixIndex = constant, index
            elseif prefixPassed and constant ~= prefixPassed and key:sub(keyLength - (constantLength - 1), keyLength) == constant then -- check if the key ends with one of the constants
                keyFound = true
                
                table.insert(prefixIndexes, prefixIndex)
                table.insert(foundKeys, { key, index })

                break
            end
        end
        
        -- awful edge case when the prefix is the same as the suffix (eg. jf0esd9j, prefix and suffix is j)
        -- it isnt a perfect fix but afaik there isnt a good method to do it
        if not keyFound and prefixPassed and key:sub(keyLength - (#prefixPassed - 1), keyLength) == prefixPassed then
            local constantCharacters = {}
            local charactersValid = true
            
            for _, constant in next, constants do
                for character in constant:gmatch("(%w)") do
                    table.insert(constantCharacters, character)
                end
            end
            
            for character in key:gmatch("(%w)") do -- make sure every character in the key shows up
                if not table.find(constantCharacters, character) then
                    charactersValid = false
                    
                    break
                end
            end
            
            if charactersValid then
                table.insert(prefixIndexes, prefixIndex)
                table.insert(foundKeys, { key, index })
            end
        end
    end
    
    -- cleanse invalid keys
    for index, keyInfo in next, foundKeys do
        if table.find(prefixIndexes, keyInfo[2]) then -- invalid keys will have a suffix of a prefix used in another key
            table.remove(foundKeys, index)
        end
    end

    local correctKey = foundKeys[keyIndex]

    return correctKey and correctKey[1] or "Failed to fetch key"
end

--// Fetch functions for keys

do -- redeemcode
    keyFunctions.RedeemCode = function()
        return getproto(require(gameFolder.Codes).Init, 8)
    end
end

do -- kick
    keyFunctions.Kick = function()
        local doorRemovedFunction = getconnections(CollectionService:GetInstanceRemovedSignal("Door"))[1].Function

        return getupvalue(getupvalue(getupvalue(getupvalue(doorRemovedFunction, 2), 2).Run, 1), 1)[4].c
    end
end

do -- damage
    keyFunctions.Damage = function()
        local militaryAddedFunction = require(gameFolder.MilitaryTurret.MilitaryTurretBinder)._classAddedSignal._handlerListHead._fn

        return getproto(militaryAddedFunction, 1)
    end
end

do -- switchteam (needs to be called before jointeam)
    keyFunctions.JoinTeam = function()
        return getproto(teamChooseUI.Show, 4)
    end
end

do -- jointeam
    keyFunctions.SwitchTeam = function()
        return getproto(getproto(getproto(require(gameFolder.SidebarUI).Init, 2), 1), 1)
    end
end

do -- exitcar
    keyFunctions.ExitCar = function()
        return getupvalue(teamChooseUI.Init, 3)
    end
end

do -- taze
    keyFunctions.Taze = function()
        return require(gameFolder.Item.Taser).Tase
    end
end

do -- punch
    keyFunctions.Punch = function()
        return getupvalue(defaultActions.punchButton.onPressed, 1).attemptPunch
    end
end

do -- arrest / pickpocket
    local characterAddedFunction = getconnections(CollectionService:GetInstanceAddedSignal("Character"))[1].Function -- hopefully this doesnt error but im not putting this in every callback cuz thats unoptimized
    local characterInteractFunction = getupvalue(characterAddedFunction, 2)

    keyFunctions.Arrest = function()
        return getupvalue(getupvalue(characterInteractFunction, 1), 7)
    end

    keyFunctions.Pickpocket = function()
        return getupvalue(characterInteractFunction, 3)
    end
    
    keyFunctions.Breakout = function()
        return getupvalue(characterInteractFunction, 4)
    end
end

do -- broadcastinputbegan / broadcastinputended
    keyFunctions.BroadcastInputBegan = function()
        return getproto(itemSystem._equip, 5)
    end

    keyFunctions.BroadcastInputEnded = function()
        return getproto(itemSystem._equip, 6)
    end
end

do -- eject / hijack / entercar
    local seatAddedFunction = getconnections(CollectionService:GetInstanceAddedSignal("VehicleSeat"))[1].Function -- hopefully this doesnt error but im not putting this in every callback cuz thats unoptimized
    local seatInteractFunction = getupvalue(seatAddedFunction, 1)
    
    keyFunctions.Hijack = function()
        return seatInteractFunction
    end

    keyFunctions.Eject = function()
        return seatInteractFunction
    end

    keyFunctions.EnterCar = function()
        return getupvalue(seatInteractFunction, 3)
    end
end

do -- robstart / robend
    local storeAddedFunction = getconnections(CollectionService:GetInstanceAddedSignal("SmallStore"))[1].Function
    local robFunction = getupvalue(storeAddedFunction, 1)

    keyFunctions.RobStart = function()
        return robFunction
    end
    
    keyFunctions.RobEnd = function()
        return robFunction, 2
    end
end

do -- equipgun / unequipgun / buygun
    local displayGunList = getproto(require(gameFolder.GunShop.GunShopUI).displayList, 1)

    keyFunctions.BuyGun = function()
        return displayGunList, 1
    end

    keyFunctions.EquipGun = function()
        return displayGunList, 2
    end

    keyFunctions.UnequipGun = function()
        return displayGunList, 3
    end
end

do -- opendoor
    -- this may not work on all exploits, your exploit must support the gc argument for getproto
    -- you can replace it with a gc search for a function with the constant "SequenceRequireState" if your exploit doesnt support this

    keyFunctions.OpenDoor = function()
        local doorAddedFunction = getconnections(CollectionService:GetInstanceAddedSignal("Door"))[1].Function

        return getupvalue(getproto(getupvalue(doorAddedFunction, 2), 1, true)[1], 7)
    end
end

do -- falldamage
    keyFunctions.FallDamage = function()
        return getupvalue(defaultActions.onJumpPressed._handlerListHead._next._fn, 4)
    end
end

do -- exception keys
    local success, errorMessage = pcall(function()
        for key, clientFunction in next, getupvalue(teamChooseUI.Init, 2) do 
            if typeof(clientFunction) == "function" then 
                for keyName, keyCheck in next, exceptionKeys do
                    if keyCheck(clientFunction) then
                        networkKeys[keyName] = key

                        break
                    end
                end
            end
        end
    end)

    if not success then
        local failedMessage = ("Failed to fetch key ( %s )"):format(errorMessage)

        for keyName in next, exceptionKeys do
            networkKeys[keyName] = networkKeys[keyName] or failedMessage
        end
    end
end

--// Fetch keys from functions

for keyName, keyFunction in next, keyFunctions do
    local success, errorMessage = pcall(function()
        networkKeys[keyName] = fetchKey(keyFunction())
    end)

    if not success then
        networkKeys[keyName] = ("Failed to fetch key ( %s )"):format(errorMessage)
    end
end

--// Return variables 

local environment = getgenv()

environment.networkKeys, environment.network = networkKeys, network

if debugOutput then -- set this in a getgenv before loadstringing if u want it ig
    rconsolewarn(("Key Fetcher Loaded in %s Seconds\n"):format(tick() - startTime))
    
    for index, key in next, networkKeys do
        rconsoleprint(("%s : %s\n"):format(index, key))
    end
else
    warn(("Key Fetcher Loaded in %s Seconds"):format(tick() - startTime))
end

return networkKeys, network
