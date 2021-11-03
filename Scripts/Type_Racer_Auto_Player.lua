--// Wait Until Game is Loaded 

if not game:IsLoaded() then 
    game.Loaded:Wait()
end 

shared.WaitTime = 1000

--// Localizations

local getconstant = getconstant or debug.getconstant
local getupvalue = getupvalue or debug.getupvalue 
local getconnections = getconnections or get_signal_cons

--// Init Variables

local Player = game:GetService("Players").LocalPlayer
local OnTyped = game:GetService("ReplicatedStorage").Events.OnTyped
local HttpService = game:GetService("HttpService")
local Stepped = game:GetService("RunService").Stepped

local CamPart = workspace:WaitForChild("CamPart")

local RaceTextBox = Player.PlayerGui:WaitForChild("ScreenGui"):WaitForChild("Main"):WaitForChild("RaceScreen"):WaitForChild("TextBox")
local RaceTextChanged = getconnections(RaceTextBox:GetPropertyChangedSignal("Text"))[1].Function 

local WaitTime = shared.WaitTime / 1000 or 0

--// Typing Functions & Utilities

local PlayerEnvironments = getupvalue(RaceTextChanged, 3)
local Keys = getupvalue(RaceTextChanged, 4)
local Encrypt = getupvalue(RaceTextChanged, 8)
local Virtual = getupvalue(RaceTextChanged, 7)
local Settings = getupvalue(RaceTextChanged, 12)

local IndexKey = getconstant(RaceTextChanged, 8)

--// Loop Through Keys and Type Them

for Index, Value in next, Keys do 
    Virtual(Player, Value:lower())
    
    OnTyped:FireServer(Encrypt(HttpService:JSONEncode({
        [IndexKey] = Index
    }), 10))

    CamPart.Position = PlayerEnvironments[Player].letterParts[Index].Position + Vector3.new(Settings.camDistance, Settings.camHeight, 0)
    
    if WaitTime == 0 then 
        Stepped:Wait()
    else 
        wait(WaitTime)
    end
end
