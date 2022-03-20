--// functions

local function get_math_answer(text)
    local first_number, operation, second_number = text:match(" (%L+)(%D+)(.+)");

    if not operation then 
        return false;
    end;

    if operation == "plus" then 
        return first_number + second_number;
    elseif operation == "minus" then 
        return first_number - second_number;
    elseif operation == "times" then 
        return first_number * second_number;
    elseif operation == "divided by" then 
        return first_number / second_number;
    end;
end;

--// main connection

game:GetService("Players").LocalPlayer.PlayerGui.ChildAdded:Connect(function(child)
    if child.Name == "ChoicePrompt" then 
        local choice_frame = child.ChoiceFrame;
        local answer = get_math_answer(choice_frame.DescSheet.Desc.Text);

        if answer then 
            local answer_button = choice_frame.Options:FindFirstChild(tostring(answer));
            
            if answer_button then
                task.wait(math.random(3, 5)); -- delay to make it more legit
                
                for index, connection in next, getconnections(answer_button.MouseButton1Click) do
                    connection:Fire(); -- firesignal can be detected
                end;
            end;
        end;
    end;
end);
