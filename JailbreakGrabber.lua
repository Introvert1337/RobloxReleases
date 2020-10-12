local Game = game:GetService("ReplicatedStorage").Game 
local AllHashes

getgenv().Hashes = {}

for i,v in next, getgc(true) do
    if type(v) == "table" and rawget(v, "FireServer") then
        AllHashes = debug.getupvalue(debug.getupvalue(v.FireServer, 1), 3)
    end
end 

local function Grab(c)
    local FireServer = table.find(c, "FireServer")
    local a = c[FireServer - 1]
    local b = c[FireServer - 2]
    if #c == 3 and #b == 1 then 
        return b..a
    end
    local start, finish = nil, #a <= 3 and a or b
    for k,x in next, c do 
        if typeof(x) == "string" and #x == 1 then 
            start = x 
        end
    end
    for k,x in next, AllHashes do 
        if string.sub(k, 1, 1) == start and string.sub(k, #k - (#finish - 1), #k) == finish then
            return k
        end
    end
end

for i,v in next, getgc() do 
    if getfenv(v).script == Game.TeamChooseUI then 
        local c = debug.getconstants(v)
        if table.find(c, "Police") and table.find(c, "Prisoner") then 
            getgenv().Hashes.ChangeTeam = Grab(c)
        end
    elseif getfenv(v).script == Game.Item.Taser then 
        local c = debug.getconstants(v)
        if table.find(c, "tick") and table.find(c, "GetPlayerFromCharacter") then 
            getgenv().Hashes.Taze = Grab(c)
        end
    elseif getfenv(v).script == game:GetService("Players").LocalPlayer.PlayerScripts.LocalScript then 
        local c = debug.getconstants(v)
        if table.find(c, "Eject") and table.find(c, "Passenger") then 
            getgenv().Hashes.Eject = Grab(debug.getconstants(debug.getproto(v, 1)))
        end
    elseif getfenv(v).script == Game.Item.Donut then
        local c = debug.getconstants(v)
        if table.find(c, "delay") and table.find(c, "Eat") then 
            for k,x in next, debug.getprotos(v) do 
                local c = debug.getconstants(x)
                if table.find(c, "LastConsumed") and table.find(c, "FireServer") then 
                    getgenv().Hashes.EatDonut = Grab(c)
                end
            end
        end
    end
end
