--// Wait for game loaded 

repeat wait() until game:IsLoaded()

if game.PlaceId == 3978370137 then
    --// ENV 
    
    getinfo = getinfo or debug.getinfo 
    hookfunction = hookfunction or hookfunc or detour_function
    getgc = getgc or get_gc_objects 
    getconnections = getconnections or get_signal_cons
    getupvalue = getupvalue or debug.getupvalue
    
    --// Variables 
    
    local ShipSpeed = math.clamp(shared.ShipSpeed, 0, 60) * 3.75
    local Player = game:GetService("Players").LocalPlayer
    
    --// ENV check
    
    if not hookfunction or not ((getconnections and getupvalue and getinfo) or getgc) then 
        return Player:Kick("Exploit Not Supported")
    end
    
    --// Check if ship already exists and player is in driver seat 
    
    if workspace:FindFirstChild("Ships") then 
        local PlayerShip = workspace.Ships:FindFirstChild(string.format("%sShip", Player.Name)) 
        
        if PlayerShip and PlayerShip:FindFirstChild("VehicleSeat") and PlayerShip.VehicleSeat.Occupant then 
            --// Grab existing ship data table and modify speed
            
            if getconnections and getupvalue and getinfo then 
                for Index, Connection in next, getconnections(game:GetService("RunService").Heartbeat) do
                    if type(Connection.Function) == "function" and getinfo(Connection.Function).source:find("ShipClient") then
                        local ShipData = getupvalue(Connection.Function, 3) 
                        
                        ShipData.Speed = ShipSpeed
                        ShipData.MaxSpeed = ShipSpeed
                    end
                end
            else 
                for Index, Value in next, getgc(true) do 
                    if type(Value) == "table" and rawget(Value, "MaxSpeed") and rawget(Value, "Driver") then 
                        Value.Speed = ShipSpeed
                        Value.MaxSpeed = ShipSpeed
                    end
                end
            end
        end
    end 
    
    --// Hook new ship setup and modify speed on init
    
    ShipHook = hookfunction(require(game:GetService("ReplicatedStorage").ShipModules.ShipManager).SetUp, function(...)
        local ShipData = ShipHook(...)
        
        ShipData.Speed = ShipSpeed
        ShipData.MaxSpeed = ShipSpeed
        
        return ShipData
    end)
end
