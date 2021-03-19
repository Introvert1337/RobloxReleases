--// ENV

islclosure = islclosure or is_l_closure
getgc = getgc or get_gc_objects
getconstants = getconstants or debug.getconstants

if not islclosure or not getgc or not getconstants then 
    return game:GetService("Players").LocalPlayer:Kick("Exploit Not Supported")
end

--// Variables

local Autoplayer = {}
local Variables = {}

do 
    Variables.Keys = {
        "Left",
        "Down",
        "Up",
        "Right"
    }

    Variables.KeyFunctions = {}
    Variables.Pressed = {}
    Variables.Constants = {}
    Variables.NoteAccuracy = {}

    Variables.Constants.DISTANCE_TO_ACCURACY = {
        ["Sick"] = 0.05,
        ["Good"] = 0.1,
        ["Ok"] = 0.15,
        ["Bad"] = 0.2
    }

    Variables.Constants.ACCURACY_NAMES = {
        "Sick", 
        "Good", 
        "Ok", 
        "Bad"
    }
end

--// Functions

do 
    function Autoplayer:GetDirection(Position)
        return Variables.Keys[Position - 3] or Variables.Keys[Position + 1]
    end 

    function Autoplayer:GetDistance(Time)
        return math.abs(Time - Variables.Framework.SongPlayer.CurrentlyPlaying.TimePosition)
    end

    function Autoplayer:IsValidDistance(Distance, Arrow)
        if Variables.NoteAccuracy[Arrow] then 
            return Distance <= Variables.NoteAccuracy[Arrow]
        end
            
        local Accuracy = Autoplayer:GetHitAccuracy() 

        Variables.NoteAccuracy[Arrow] = Variables.Constants.DISTANCE_TO_ACCURACY[Accuracy]

        return Distance <= Variables.Constants.DISTANCE_TO_ACCURACY[Accuracy]
    end 

    function Autoplayer:PressKey(Direction, Arrow)
        Variables.Pressed[Arrow] = true

        Variables.KeyFunctions.KeyDown(Direction)
        
        local ReleaseDelay = shared.Settings.ReleaseDelay / 1000

        if Arrow.Data.Length > 0 then
            wait(Arrow.Data.Length + ReleaseDelay)
        else
            wait(0.05 + ReleaseDelay)
        end

        Variables.KeyFunctions.KeyUp(Direction)

        Variables.Pressed[Arrow] = nil
        Variables.NoteAccuracy[Arrow] = nil
    end

    function Autoplayer:IsPressed(Arrow)
        return Variables.Pressed[Arrow]
    end
        
    function Autoplayer:GetHitAccuracy()
        local Percentages = shared.Settings.Percentages
        local Total = 0 
        
        local ChanceData = {} 
        local ACCURACY_NAMES = Variables.Constants.ACCURACY_NAMES
        
        for Index = 1, #ACCURACY_NAMES do 
            local Name = ACCURACY_NAMES[Index] 
            
            if Percentages[Name] > 0 then 
                ChanceData[Percentages[Name]] = Name 
            end
        end
        
        local Entries = {} 
        
        for Index, Chance in next, ChanceData do 
            Entries[Chance] = {Min = Total, Max = Total + Index} 
            Total = Total + Index 
        end
        
        local Percentage = math.random(0, 100) 
        
        for Index, Entry in next, Entries do 
            if Entry.Min <= Percentage and Entry.Max >= Percentage then 
                return Index
            end
        end 
    end
end

--// Init GC loop

for Index, Value in next, getgc(true) do
    if type(Value) == "table" and rawget(Value, "GameUI") then
        Variables.Framework = Value
    elseif type(Value) == "function" and islclosure(Value) and tostring(getfenv(Value).script) == "Arrows" then
		local Constants = getconstants(Value)
		 
		if table.find(Constants, "CurrentScore") and table.find(Constants, "Data") then 
			Variables.KeyFunctions.KeyUp = Value 
		elseif table.find(Constants, "NewThread") and table.find(Constants, "Section") then
			Variables.KeyFunctions.KeyDown = Value 
		end 
    end
end

--// Main autoplayer loop

game:GetService("RunService").Heartbeat:Connect(function()
    if shared.Settings.Autoplay then
        for Index, Arrow in next, Variables.Framework.UI.ActiveSections do
            if Arrow.Side == Variables.Framework.UI.CurrentSide then 
                local Direction = Autoplayer:GetDirection(Arrow.Data.Position)
                local Distance = Autoplayer:GetDistance(Arrow.Data.Time)

                if Autoplayer:IsValidDistance(Distance, Arrow) and not Autoplayer:IsPressed(Arrow) then 
                    Autoplayer:PressKey(Direction, Arrow)
                end
            end 
        end
    end
end)
