local Game = game:GetService("ReplicatedStorage").Game
local LocalScript = game:GetService("Players").LocalPlayer.PlayerScripts.LocalScript

getgenv().Hashes = {}
getgenv().Functions = {}

for i,v in next, getgc() do 
    if islclosure(v) and not is_synapse_function(v) then
        if getfenv(v).script == Game.Item.Taser then 
            local c = debug.getconstants(v) 
            for k,x in next, c do 
                if x == "a" then
                    getgenv().Hashes["Taze"] = c[k + 1]
                end 
            end
        end
        if getfenv(v).script == LocalScript then
            local c = debug.getconstants(v)
            if table.find(c, "Eject") and table.find(c, "Passenger") then 
                for k,x in next, debug.getprotos(v) do 
                    local c = debug.getconstants(x)
                    if table.find(c, "FireServer") then 
                        for a,b in next, c do 
                            if b == "a" then 
                                getgenv().Hashes["Eject"] = c[a + 1]
                            end
                        end
                    end
                end
            end
            if table.find(c, "LastVehicleExit") and table.find(c, "OnVehicleExited") then 
                for k,x in next, c do
                    if x == "sub" and c[k + 1] == "reverse" then 
                        getgenv().Hashes["ExitCar"] = c[k - 1]
                    end
                end
            end
        end
        if getfenv(v).script == Game.NukeControl then 
            for k,x in next, debug.getprotos(v) do
                local c = debug.getconstants(x)
                if table.find(c, "Nuke") and table.find(c, "Shockwave") then 
                    getgenv().Functions["Nuke"] = x 
                end
            end
        end
        if getfenv(v).script == Game.TeamChooseUI then
            local c = debug.getconstants(v)
            if table.find(c, "delay") and table.find(c, "tick") then 
                for k,x in next, debug.getprotos(v) do 
                    local c = debug.getconstants(x) 
                    if table.find(c, "Police") and table.find(c, "Prisoner") then 
                        for i,v in next, c do 
                            if v == "sub" and c[i + 1] == "reverse" then 
                                getgenv().Hashes["ChangeTeam"] = c[i - 1]
                            end
                        end
                    end
                end
            end
        end
        if getfenv(v).script == Game.Item.Donut then 
            for k,x in next, debug.getprotos(v) do 
                local c = debug.getconstants(x) 
                if table.find(c, "LastConsumed") then 
                    for i,v in next, c do 
                        if v == "sub" and c[i + 1] == "reverse" then 
                            getgenv().Hashes["EatDonut"] = c[i - 1]
                        end
                    end
                end
            end
        end
    end
end
