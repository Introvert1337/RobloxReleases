local player = game:GetService("Players").LocalPlayer
local twitter = player.statz.twitter

if not getgenv().last_used then 
    getgenv().last_used = nil 
end 

twitter:ClearAllChildren()

local Code 

if #getgenv().game_codes == 1 or not getgenv().last_used then 
    Code = getgenv().game_codes[1]
else    
    local last_used_index = table.find(getgenv().game_codes, getgenv().last_used)
    if last_used_index == #getgenv().game_codes then 
        last_used_index = 0
    end 
    Code = getgenv().game_codes[last_used_index + 1]
end 

player.PlayerGui.Main.Customization.Codes.Text = Code
getgenv().last_used = Code
