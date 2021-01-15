--// ENV 

checkcaller = checkcaller or is_protosmasher_caller

--// Define variables

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local NetworkModule = require(ReplicatedStorage.NetworkModule)
local Weapons, Thing = NetworkModule:InvokeServer("GetWeapons")

local LoadoutFrame = game:GetService("Players").LocalPlayer.PlayerGui.MenuGUI.Top.Loadout
local WeaponModulesFolder = ReplicatedStorage.Weapons.Modules

local ScrollingFrame = LoadoutFrame:WaitForChild("Left"):WaitForChild("ScrollingFrame")
local MainBar = LoadoutFrame:WaitForChild("MainBar")
local Right = LoadoutFrame:WaitForChild("Right")

--// Function to add a connection to a signal, with the unlocking callback

local function AddUnlockConnection(element, signal)
    signal:connect(function()
		for _, Child in next, MainBar:GetChildren() do 
			if tostring(Child.BackgroundColor3) == "0.439216, 1, 0.67451" then
				Child.Image = element.Image 
				Right:WaitForChild("LvlUnlock").Visible = false 
				Right:WaitForChild("Unlocked").Visible = true
				Right:WaitForChild("UnlockFrame").Visible = false
			end
		end
	end)
end

--// Adds connections to all the weapon ui elements 

for _, Child in next, ScrollingFrame:GetChildren() do
	if Child:IsA("ImageButton") then 
		Child.Lock.Visible = false
		AddUnlockConnection(Child, Child.Activated)
	end 
end

ScrollingFrame.ChildAdded:connect(function(Child)
	if Child:IsA("ImageButton") then 
		Child.Lock.Visible = false
		AddUnlockConnection(Child, Child.Activated)
	end 
end)

--// Thing to make sure you don't get detected? Idk 

game:GetService("RunService").Heartbeat:connect(function()
    NetworkModule:FireServer("Animate", "Reload", nil, math.huge) 
end)

--// Hooks the remote to unlock selected weapons

local OldIS = NetworkModule.InvokeServer
        
NetworkModule.InvokeServer = newcclosure(function(self, action, ...)
    local args = {...}
	if not checkcaller() then
		if Weapons and Thing then
			if action == "GetWeapons" then
				return Weapons, Thing
			elseif action == "GetData" and args[1] == "Loadout4" then 
				return {Weapons[1][1], Weapons[2][1], Weapons[3][1], Weapons[4][1], Weapons[5][1]}
			end
		end
    end
    return OldIS(self, action, ...)
end)
