local TS = require(game:GetService("ReplicatedStorage").TS)
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local Mouse = player:GetMouse()

local Enabled = true 

local function GetClosestPlayer()
    local Closest = nil 
    local Last = math.huge 

    for i, v in next, Players:GetPlayers() do
        if v ~= player and not TS.Teams:ArePlayersFriendly(player, v) then
            local Character = TS.Characters:GetCharacter(v)

            if Character and Character:FindFirstChild("Root") then
                local Magnitude = (TS.Characters:GetCharacter(player).Root.Position - Character.Root.Position).magnitude

                if Magnitude < Last then 
                    Last = Magnitude 
                    Closest = v
                end
            end
        end
    end

    return Closest
end

workspace.Throwables.ChildAdded:Connect(function(child)
	if Enabled then
		local PrimaryBody = child:WaitForChild("Body"):WaitForChild("BodyPrimary")
		local ClosestPlayer = GetClosestPlayer()
		if ClosestPlayer then 
			repeat  
				local ClosestCharacter = TS.Characters:GetCharacter(ClosestPlayer)
				if ClosestCharacter and ClosestCharacter.PrimaryPart then
					PrimaryBody.CFrame = ClosestCharacter:GetPrimaryPartCFrame()
				end
			wait() until child == nil or not child:IsDescendantOf(workspace)
		end
	end
end)

Mouse.KeyDown:connect(function(Key)
    if Key == shared.Keybind then
        Enabled = not Enabled
    end
end)
