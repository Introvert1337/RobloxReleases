--// Check if already in env

if networkKeys and network then 
    return networkKeys, network
end

--// Wait for game load

if not game:IsLoaded() then
    game.Loaded:Wait()
end

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = game:GetService("Players").LocalPlayer

if not player.Character then
    player.CharacterAdded:Wait()
end

local setEvent = require(ReplicatedStorage:WaitForChild("Module").AlexChassis).SetEvent
local network = getupvalue(setEvent, 1)

while not network and task.wait() do
    network = getupvalue(setEvent, 1)
end

--// Variables

local startTime = os.clock()

local CollectionService = game:GetService("CollectionService")

local keysList = getupvalue(getupvalue(network.FireServer, 1), 3)

local gameFolder = ReplicatedStorage.Game
local robloxEnvironment = getrenv()

local teamChooseUI = require(ReplicatedStorage.TeamSelect.TeamChooseUI) -- module used in multiple keys
local defaultActions = require(gameFolder.DefaultActions) -- module used in multiple keys
local itemSystem = require(gameFolder.ItemSystem.ItemSystem) -- module used in multiple keys

local networkKeys = {}
local keyFunctions = {}
local blacklistedConstants = {}
local keyCache = {}
local backupKeys = { -- could do getinfo numparams but this is faster
    Arrest = true,
    Breakout = true,
    Eject = true
}

local exceptionKeys = { -- keys to use alternative method (deemed to be more efficient for these cases)
    PlaySound = function(checkFunction)
        return getconstants(checkFunction)[1] == "Source"
    end,
    CameraUpdate = function(checkFunction)
        return getconstants(checkFunction)[1] == "MakeSpring"
    end
}

for index, value in getrenv() do -- soooo bad
    if index ~= "_G" and index ~= "shared" and typeof(value) == "table" then
        for name in value do
            table.insert(blacklistedConstants, name)
        end
    end

    table.insert(blacklistedConstants, index)
end

--// Functions

local function fetchKey(callerFunction, keyIndex, multiSearch)
    keyIndex = keyIndex or 1
    
    if keyCache[callerFunction] then
        local correctKey = keyCache[callerFunction][keyIndex]

        return correctKey and correctKey[1] or "Failed to fetch key"
    end
    
    local constants = getconstants(callerFunction)
    local originalConstants = table.clone(constants)
    
    local prefixIndexes = {}
    local foundKeys = {}
    local constantCharacters = {}
    
    for index, constant in constants do
        if keysList[constant] then -- if the constants already contain the raw key
            table.insert(foundKeys, { constant, 0 })
            
            constants[index] = nil
        elseif typeof(constant) ~= "string" or constant == "" or constant:match("[%u%W]") or table.find(blacklistedConstants, constant) then
            constants[index] = nil -- remove constants that are 100% not the ones we need to make it a bit faster
        else
            for character in constant:gmatch("(%w)") do
                table.insert(constantCharacters, character)
            end
        end
    end
    
    for key, remote in keysList do
        local prefixPassed, prefixIndex = false
        local keyLength = #key
        
        for index, constant in constants do
            local constantLength = #constant

            if not prefixPassed and key:sub(1, constantLength) == constant then -- check if the key starts with one of the constants
                prefixPassed, prefixIndex = constant, index
            elseif prefixPassed and key:sub(keyLength - (constantLength - 1), keyLength) == constant then -- check if the key ends with one of the constants
                local currentConstantCharacters = table.clone(constantCharacters)
                local charactersValid = true

                for character in key:gmatch("(%w)") do -- make sure every character in the key shows up
                    if not table.find(currentConstantCharacters, character) then
                        charactersValid = false
                        
                        break
                    end
                    
                    table.remove(currentConstantCharacters, table.find(currentConstantCharacters, character))
                end
                
                if charactersValid then
                    table.insert(prefixIndexes, prefixIndex)
                    table.insert(foundKeys, { key, index })
                end

                break
            end
        end
    end
    
    -- cleanse invalid keys
    for index, keyInfo in foundKeys do
        if table.find(prefixIndexes, keyInfo[2]) then -- invalid keys will have a suffix of a prefix used in another key
            table.remove(foundKeys, index)
        end
    end
    
    keyCache[callerFunction] = foundKeys

    if multiSearch then
        return foundKeys, originalConstants, constants, prefixIndexes
    end

    local correctKey = foundKeys[keyIndex]

    return correctKey and correctKey[1] or "Failed to fetch key"
end

local function errorHandle(callback)
    local success, returnValue = pcall(callback)

    if not success then
        return warn("Jailbreak Key Fetcher Error: " .. returnValue)
    end

    return returnValue
end

local function errorHandleMultiSearch(callerFunction, keyNames)
    local success, foundKeys, orginalConstants, modifiedConstants, prefixIndexes = pcall(function()
        return fetchKey(callerFunction, nil, true)
    end)

    if not success then
        for _, keyName in keyNames do
            networkKeys[keyName] = ("Failed to fetch key ( %s )"):format(foundKeys)
        end

        return false
    end

    return foundKeys, orginalConstants, modifiedConstants, prefixIndexes
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
        return getproto(teamChooseUI.Show, 3)
    end
end

do -- jointeam
    keyFunctions.SwitchTeam = function()
        return getproto(getproto(getproto(require(gameFolder.SidebarUI).Init, 3), 1), 1)
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
    
do -- droprope
    keyFunctions.DropRope = function()
        return getproto(require(gameFolder.Vehicle.Heli), 5)
    end
end

do -- punch
    keyFunctions.Punch = function()
        return getupvalue(defaultActions.punchButton.onPressed, 1).attemptPunch
    end
end

do -- arrest / pickpocket / breakout
    local characterInteractFunction = errorHandle(function()
        return getupvalue(getupvalue(require(ReplicatedStorage.App.CharacterBinder)._classAddedSignal._handlerListHead._fn, 1), 2)
    end)

    keyFunctions.Arrest = function(backup)
        if backup then
            return getupvalue(getupvalue(characterInteractFunction, 1), 7)
        else
            return getupvalue(characterInteractFunction, 1)
        end
    end

    keyFunctions.Pickpocket = function()
        return getupvalue(characterInteractFunction, 4)
    end
    
    keyFunctions.Breakout = function(backup)
        return characterInteractFunction
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
    local seatInteractFunction = errorHandle(function()
        return getupvalue(getconnections(CollectionService:GetInstanceAddedSignal("VehicleSeat"))[1].Function, 1)
    end)
    
    keyFunctions.Hijack = function()
        return getupvalue(seatInteractFunction, 1)
    end

    keyFunctions.Eject = function(backup)
        if backup then
            return getupvalue(seatInteractFunction, 2)
        else
            return seatInteractFunction
        end
    end

    keyFunctions.EnterCar = function()
        return getupvalue(seatInteractFunction, 3)
    end
end

do -- robstart / robend
    local robFunction = errorHandle(function()
        return getupvalue(getconnections(CollectionService:GetInstanceAddedSignal("SmallStore"))[1].Function, 1)
    end)

    local foundKeys, orginalConstants, modifiedConstants, prefixIndexes = errorHandleMultiSearch(robFunction, { "RobEnd", "RobStart" })

    if foundKeys then
        for index = 1, 2 do
            local key = foundKeys[index] and foundKeys[index][1] or "Failed to fetch key"
            local originalPrefixIndex = table.find(orginalConstants, modifiedConstants[prefixIndexes[index]])
            local previousConstant = originalPrefixIndex and orginalConstants[originalPrefixIndex - 1]
    
            networkKeys[previousConstant == "FireServer" and "RobEnd" or "RobStart"] = key
        end
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
        return getupvalue(defaultActions.onJumpPressed._handlerListHead._next._fn, 2)
    end
end

do -- equipgun / unequipgun / buygun
    local displayGunList = errorHandle(function()
        return getproto(require(gameFolder.GunShop.GunShopUI).displayList, 1)
    end)
    
    local foundKeys, orginalConstants, modifiedConstants, prefixIndexes = errorHandleMultiSearch(displayGunList, { "UneqipGun", "EquipGun", "BuyGun" })

    if foundKeys then
        for index = 1, 3 do
            local key = foundKeys[index] and foundKeys[index][1] or "Failed to fetch key"
            local originalPrefixIndex = table.find(orginalConstants, modifiedConstants[prefixIndexes[index]])
            local previousConstant = originalPrefixIndex and orginalConstants[originalPrefixIndex - 1]
    
            if previousConstant == "GetEquipped" then
                networkKeys.UnequipGun = key
            elseif previousConstant == "doesPlayerOwn" then
                networkKeys.EquipGun = key
            else
                networkKeys.BuyGun = key
            end
        end
    end
end

do -- ragdoll
    keyFunctions.Ragdoll = function()
        return require(gameFolder.Falling).StartRagdolling
    end
end

do -- exception keys
    local exceptionKeysFound, exceptionKeyCount = 0, 0
    
    for _ in exceptionKeys do
        exceptionKeyCount += 1
    end
    
    local success, errorMessage = pcall(function()
        for key, clientFunction in getupvalue(teamChooseUI.Init, 2) do 
            if typeof(clientFunction) == "function" then
                for keyName, keyCheck in exceptionKeys do
                    if keyCheck(clientFunction) then
                        exceptionKeysFound += 1
                        networkKeys[keyName] = key

                        break
                    end
                end
                
                if exceptionKeysFound == exceptionKeyCount then
                    break
                end
            end
        end
    end)

    if not success then
        local failedMessage = ("Failed to fetch key ( %s )"):format(errorMessage)

        for keyName in exceptionKeys do
            networkKeys[keyName] = failedMessage
        end
    end
end

--// Fetch keys from functions

for keyName, keyFunction in keyFunctions do
    local success, errorMessage = pcall(function()
        networkKeys[keyName] = fetchKey(keyFunction()) or "Failed to fetch key"
    end)

    if not success or networkKeys[keyName] == "Failed to fetch key" then
        if backupKeys[keyName] then
            success, errorMessage = pcall(function()
                networkKeys[keyName] = fetchKey(keyFunction(true)) or "Failed to fetch key"
            end)
        end

        if not success then
            networkKeys[keyName] = ("Failed to fetch key ( %s )"):format(errorMessage)
        end
    end
end

--// Return variables

local environment = getgenv()

environment.networkKeys, environment.network = networkKeys, network

if debugOutput or debugOutput == nil then -- defaults to true unless explicitly set to false
    rconsolename("Jailbreak Key Fetcher - Made by Introvert")
    rconsolewarn(("Key Fetcher Loaded in %s Seconds\n"):format(os.clock() - startTime))
    
    for index, key in networkKeys do
        rconsoleprint(("%s : %s\n"):format(index, key))
    end
else
    warn(("Key Fetcher Loaded in %s Seconds"):format(os.clock() - startTime))
end

return networkKeys, network
