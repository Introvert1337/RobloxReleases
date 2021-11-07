--// Wait Until Game is Loaded 

if not game:IsLoaded() then 
    game.Loaded:Wait()
end 

--// Localizations

local getconstant = getconstant or debug.getconstant
local getupvalue = getupvalue or debug.getupvalue 
local getconnections = getconnections or get_signal_cons

local wait = wait
local twait = task.wait
local v3new = Vector3.new

--// Init Variables

local Player = game:GetService("Players").LocalPlayer
local OnTyped = game:GetService("ReplicatedStorage").Events.OnTyped
local HttpService = game:GetService("HttpService")

local CamPart = workspace:WaitForChild("CamPart")

local RaceTextBox = Player.PlayerGui:WaitForChild("ScreenGui"):WaitForChild("Main"):WaitForChild("RaceScreen"):WaitForChild("TextBox")
local RaceTextChanged = getconnections(RaceTextBox:GetPropertyChangedSignal("Text"))[1].Function 

local WaitTime = shared.WaitTime and math.clamp(shared.WaitTime / 1000, 0.04, math.huge) or 0.04

--// Wait Until Round Has Begun 

while not getupvalue(RaceTextChanged, 5) do 
    wait() 
end

--// Typing Functions & Utilities

local PlayerEnvironments = getupvalue(RaceTextChanged, 3)
local Keys = getupvalue(RaceTextChanged, 4)
local Virtual = getupvalue(RaceTextChanged, 7)
local Encrypt = getupvalue(RaceTextChanged, 8)
local Settings = getupvalue(RaceTextChanged, 12)

local IndexKey = getconstant(RaceTextChanged, 8)

--// Loop Through Keys and Type Them

for Index = 1, #Keys do
    Virtual(Player)
    
    OnTyped:FireServer(Encrypt(HttpService:JSONEncode({
        [IndexKey] = Index
    }), 10))

    CamPart.Position = PlayerEnvironments[Player].letterParts[Index].Position + v3new(Settings.camDistance, Settings.camHeight, 0)
    
    if WaitTime ~= 0 then 
        wait(WaitTime)
    else 
        twait()
    end
end
