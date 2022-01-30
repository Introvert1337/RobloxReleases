--// variables 

local player = game:GetService("Players").LocalPlayer;
local ingredient_folder = workspace.Ingredients;

local effect_replicator = require(game:GetService("ReplicatedStorage").EffectReplicator);

--// functions

local function apply_auto_pickup(ingredient) -- bad code
    local pickup_prompt = ingredient:WaitForChild("InteractPrompt");
    local activation_distance = pickup_prompt.MaxActivationDistance;
    
    task.spawn(function()
        while task.wait(0.1) do 
            local distance = player:DistanceFromCharacter(ingredient.Position);
            
            if distance < activation_distance and distance ~= 0 then
                break;
            end;
        end;
        
        repeat
            if not effect_replicator:FindEffect("Action") then
                fireproximityprompt(pickup_prompt);
            end;
            
            task.wait(0.1);
        until not ingredient or not ingredient:IsDescendantOf(workspace);
    end);
end;

--// apply ingredients

for index, ingredient in next, ingredient_folder:GetChildren() do 
    apply_auto_pickup(ingredient);
end;

ingredient_folder.ChildAdded:Connect(function(ingredient)
    apply_auto_pickup(ingredient);
end);
