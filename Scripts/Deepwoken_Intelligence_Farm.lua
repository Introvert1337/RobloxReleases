local function get_math_answer(text)
    -- parse the first number, operation and second number out of the text
    -- this could be more specific [What is (%-?%d*%.?%d+) (%a+) ?%a* (%-?%d*%.?%d+)] but since the format is always the same i simplified it
    
    local first_number, operation, second_number = text:match("What is(%L+)(%l+) %l*(.+)");

    -- if for some reason it failed to parse return false

    if not operation then 
        return false;
    end;

    -- return the solved equation based on the data 
    
    if operation == "plus" then 
        return first_number + second_number;
    elseif operation == "minus" then 
        return first_number - second_number;
    elseif operation == "times" then 
        return first_number * second_number;
    elseif operation == "divided" then 
        return first_number / second_number;
    end;
end;

-- when a gui is added to playergui check if it is a prompt 

game:GetService("Players").LocalPlayer.PlayerGui.ChildAdded:Connect(function(child)
    if child.Name == "ChoicePrompt" then 
        -- get the answer from the gui text 
        
        local choice_frame = child:WaitForChild("ChoiceFrame");
        local answer = get_math_answer(choice_frame:WaitForChild("DescSheet"):WaitForChild("Desc").Text);

        -- if the answer has successfully been fetched get the correct answer button 
        
        if answer then 
            local answer_button = choice_frame:WaitForChild("Options"):FindFirstChild(tostring(answer));
            
            if answer_button then
                -- press the correct answer button after a randomized delay 
                
                wait(math.random(3, 5));
                for i,v in pairs(getconnections(answer_button.MouseButton1Click)) do v:Fire() end
            end;
        end;
    end;
end);
