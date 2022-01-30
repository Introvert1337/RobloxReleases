--// variables 

local players = game:GetService("Players");
local send_chat = game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest;

--// main connection

game:GetService("Players").LocalPlayer.PlayerGui.ChildAdded:Connect(function(child)
    if child.Name == "SimplePrompt" then
        local correct_text = child.Prompt.Text:match("Try some small talk on someone nearby%.\n'(.+)'");
        
        if correct_text then 
            wait(math.random(3, 5)); -- delay to make it more legit

            players:Chat(correct_text);
            send_chat:FireServer(correct_text, "All");
        end;
    end;
end);
