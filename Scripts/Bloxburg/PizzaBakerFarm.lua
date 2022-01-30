--// variables 

local player = game:GetService("Players").LocalPlayer;
local job_manager = require(player.PlayerGui.MainGUI.Scripts.JobManager);

--// grab remotes 

local remotes = {};

local remote_added = getconnections(game:GetService("ReplicatedStorage").Modules.DataManager.DescendantAdded)[1].Function;
local remote_keys = getupvalue(remote_added, 1);

for remote_key, remote_name in next, getupvalue(getupvalue(remote_added, 2), 1) do
    remotes[remote_name:sub(1, 2) == "F_" and remote_name:sub(3) or remote_name] = remote_keys[remote_key];
end;

--// correct order hook

local old_namecall;
old_namecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    if self == remotes.JobCompleted then
        local arguments = {...};
        local order_data = arguments[1];

        if type(order_data) == "table" then
            if checkcaller() and getnamecallmethod() == "FireServer" and rawget(order_data, "Order") then
                local target_workstation = rawget(order_data, "Workstation");

                if target_workstation and target_workstation.Parent.Name == "BakerWorkstations"then
                    order_data.Order = {
                        true, 
                        true, 
                        true, 
                        target_workstation.Order.Value
                    };

                    return old_namecall(self, unpack(arguments));
                end;
            end;
        end;
    end;

    return old_namecall(self, ...);
end));

--// functions 

local function get_nearest_crate()
    local nearest_crate;
    local nearest_distance = math.huge;

    for index, crate_object in next, workspace.Environment.Locations.PizzaPlanet.IngredientCrates:GetChildren() do
        local distance = (player.Character.HumanoidRootPart.Position - crate_object.Position).Magnitude;

        if distance < nearest_distance then
            nearest_distance = distance;
            nearest_crate = crate_object;
        end;
    end;
    
    return nearest_crate;
end;

local function hide_fail_indicator(baker_gui)
    local baker_gui_overlay = baker_gui:FindFirstChild("Overlay");
    
    if baker_gui_overlay then 
        local fail_indicator_gui = baker_gui_overlay:FindFirstChild("false");
        
        if fail_indicator_gui then 
            fail_indicator_gui.ImageRectOffset = Vector2.new(0, 0)
            fail_indicator_gui.ImageColor3 = Color3.new(0, 255, 0)
        end
    end
end;

local function get_dual_station(current_workstation)
    for index, station in next, current_workstation.Parent:GetChildren() do
        if station ~= current_workstation then
            local distance = (station.PrimaryPart.Position - current_workstation.PrimaryPart.Position).Magnitude;

            if distance <= 11 then 
                local main_baker_display = station.OrderDisplay.DisplayMain;
                local baker_gui = main_baker_display:FindFirstChild("BakerGUI");

                if baker_gui and (baker_gui.Used.Visible == false or baker_gui.Used.TitleLabel.Text == "Too far") then
                    return station;
                end;
            end;
        end;
    end;
end;

local function restock_ingredients(current_workstation)
    local nearest_crate = get_nearest_crate();

    if nearest_crate then
        player.Character.HumanoidRootPart.CFrame = nearest_crate.CFrame + Vector3.new(6, 0, 0);
    
        repeat
            remotes.TakeIngredientCrate:FireServer({
                Object = nearest_crate
            });
    
            wait();
        until player.Character:FindFirstChild("Ingredient Crate");
    
        player.Character.HumanoidRootPart.CFrame = current_workstation.CounterTop.CFrame + Vector3.new(-7, 1.1, 0);
    
        repeat 
            remotes.RestockIngredients:FireServer({
                Workstation = current_workstation
            });
    
            wait();
        until current_workstation.Order.IngredientsLeft.Value > 0;
    end;
end;
    
--// main autofarm loop

while task.wait(0.1) do 
    if job_manager:GetJob() == "PizzaPlanetBaker" then
        local pizza_planet = workspace.Environment.Locations:FindFirstChild("PizzaPlanet");
        
        if pizza_planet then 
            local baker_workstations = pizza_planet:FindFirstChild("BakerWorkstations");
            
            if baker_workstations then
                for index, baker_station in next, baker_workstations:GetChildren() do
                    local main_baker_display = baker_station.OrderDisplay.DisplayMain;
                    local baker_gui = main_baker_display:FindFirstChild("BakerGUI");
            
                    if baker_gui and not baker_gui.Used.Visible then
                        local dual_station = get_dual_station(baker_station);
            
                        if dual_station then -- get middle position of 2 stations
                            local main_position, dual_position = baker_station.PrimaryPart.Position, dual_station.PrimaryPart.Position;
                            local middle_cframe = CFrame.new(main_position, dual_position) * CFrame.new(0, 0, -(main_position - dual_position).Magnitude / 2);
            
                            player.Character.HumanoidRootPart.CFrame = middle_cframe + Vector3.new(-7, 1.1, 0);
                        end;
            
                        if baker_station.Order.IngredientsLeft.Value == 0 then
                            restock_ingredients(baker_station);
                        end;
            
                        hide_fail_indicator(baker_gui);
            
                        local baker_gui_frame = baker_gui:FindFirstChild("Frame");
            
                        if baker_gui_frame then
                            local baker_frame_done_button = baker_gui_frame:FindFirstChild("Done");
            
                            if baker_frame_done_button then
                                firesignal(baker_frame_done_button.Activated);
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;
end;
