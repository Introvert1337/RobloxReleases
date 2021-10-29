local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
local TextService = game:GetService("TextService")
local library = {flags = {}}

local function tweenObject(object, data, time)
	local tweenInfo = TweenInfo.new(time, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
	local tween = TweenService:Create(object, tweenInfo, data)
	tween:Play()
	return tween
end

local http = game:GetService("HttpService")

if not isfile("epicthing.config") then 
    writefile("epicthing.config", tostring(http:JSONEncode({})))
end

local function GetSetting(name)
    if not isfile("epicthing.config") then 
        writefile("epicthing.config", tostring(http:JSONEncode({})))
    end
    local content = readfile("epicthing.config")
    local parsed = http:JSONDecode(content)
	name = name:gsub("%s+", "")
    if parsed[tostring(game.GameId)] and parsed[tostring(game.GameId)][name] then 
		return parsed[tostring(game.GameId)][name] 
    end
end

local function AddSetting(name, value)
    if not isfile("epicthing.config") then 
        writefile("epicthing.config", tostring(http:JSONEncode({})))
    end
	
    local content = readfile("epicthing.config")
    local parsed = http:JSONDecode(content)
    if not parsed[tostring(game.GameId)] then 
        parsed[tostring(game.GameId)] = {}
    end 
    parsed[tostring(game.GameId)][name:gsub("%s+", "")] = value 
    writefile("epicthing.config", tostring(http:JSONEncode(parsed)))
end

function library:Window(TitleWhite)
	if game.CoreGui:FindFirstChild("BloxburgUi") then
		game.CoreGui:FindFirstChild("BloxburgUi"):Destroy()
	end
	local BloxburgUi = Instance.new("ScreenGui")
	local MainUIFrame = Instance.new("ImageLabel")
	local Cool = Instance.new("ImageLabel")
	local BloxburgCool = Instance.new("Frame")
	local TabsHolder = Instance.new("ImageLabel")
	local UIListLayout = Instance.new("UIListLayout")
	local UIPadding = Instance.new("UIPadding")
	local BloxburgTitle1 = Instance.new("Frame")
	local BloxburgTitle = Instance.new("TextLabel")
	local BloxburgHubTitle = Instance.new("TextLabel")
	BloxburgUi.Name = "BloxburgUi"
	BloxburgUi.Parent = game:GetService("CoreGui")
	BloxburgUi.DisplayOrder = 1
	MainUIFrame.Name = "MainUIFrame"
	MainUIFrame.Parent = BloxburgUi
	MainUIFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	MainUIFrame.BackgroundTransparency = 1.000
	MainUIFrame.Position = UDim2.new(0.252025217, 0, 0.226720661, 0)
	MainUIFrame.Size = UDim2.new(0, 551, 0, 404)
	MainUIFrame.Image = "rbxassetid://3570695787"
	MainUIFrame.ImageColor3 = Color3.fromRGB(22, 22, 22)
	MainUIFrame.ScaleType = Enum.ScaleType.Slice
	MainUIFrame.SliceCenter = Rect.new(100, 100, 100, 100)
	MainUIFrame.SliceScale = 0.050
	Cool.Name = "Cool"
	Cool.Parent = MainUIFrame
	Cool.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Cool.BackgroundTransparency = 1.000
	Cool.Position = UDim2.new(0.065, 0, 0.025, 0)
	Cool.Size = UDim2.new(0, 55, 0, 55)
	Cool.ZIndex = 2
	Cool.Image = "rbxassetid://166652117"
	BloxburgCool.Name = "BloxburgCool"
	BloxburgCool.Parent = MainUIFrame
	BloxburgCool.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
	BloxburgCool.BorderSizePixel = 0
	BloxburgCool.Size = UDim2.new(0, 125, 0, 97)
	TabsHolder.Name = "TabsHolder"
	TabsHolder.Parent = MainUIFrame
	TabsHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TabsHolder.BackgroundTransparency = 1.000
	TabsHolder.Position = UDim2.new(0, 0, 0.25, 0)
	TabsHolder.Size = UDim2.new(0, 125, 0, 300)
	TabsHolder.Image = "rbxassetid://3570695787"
	TabsHolder.ImageColor3 = Color3.fromRGB(24, 24, 24)
	TabsHolder.ScaleType = Enum.ScaleType.Slice
	TabsHolder.SliceCenter = Rect.new(100, 100, 100, 100)
	TabsHolder.SliceScale = 0.050
	BloxburgTitle1.Name = "BloxburgTitle"
	BloxburgTitle1.Parent = MainUIFrame
	BloxburgTitle1.BackgroundColor3 = Color3.fromRGB(19, 19, 19)
	BloxburgTitle1.BorderSizePixel = 0
	BloxburgTitle1.Position = UDim2.new(0.226860255, 0, 0, 0)
	BloxburgTitle1.Size = UDim2.new(0, 426, 0, 35)
	BloxburgTitle.Name = "BloxburgTitle"
	BloxburgTitle.Parent = BloxburgTitle1
	BloxburgTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	BloxburgTitle.BackgroundTransparency = 1.000
	BloxburgTitle.BorderColor3 = Color3.fromRGB(27, 42, 53)
	BloxburgTitle.Position = UDim2.new(0.0148883378, 0, 0, 0)
	BloxburgTitle.Size = UDim2.new(0, 420, 0, 35)
	BloxburgTitle.Font = Enum.Font.GothamBold
	BloxburgTitle.Text = TitleWhite
	BloxburgTitle.TextColor3 = Color3.fromRGB(233, 233, 233)
	BloxburgTitle.TextSize = 15.000
	BloxburgTitle.TextXAlignment = Enum.TextXAlignment.Left
	BloxburgHubTitle.Name = "BloxburgHubTitle"
	BloxburgHubTitle.Parent = MainUIFrame
	BloxburgHubTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	BloxburgHubTitle.BackgroundTransparency = 1.000
	BloxburgHubTitle.Position = UDim2.new(0.038, 0, 0.16, 0)
	BloxburgHubTitle.Size = UDim2.new(0, 372, 0, 35)
	BloxburgHubTitle.Font = Enum.Font.GothamBold
	BloxburgHubTitle.Text = "Under Ware"
	BloxburgHubTitle.TextColor3 = Color3.fromRGB(84, 116, 224)
	BloxburgHubTitle.TextSize = 15.000
	BloxburgHubTitle.TextXAlignment = Enum.TextXAlignment.Left
	UIListLayout.Parent = TabsHolder
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIPadding.Parent = TabsHolder
	local MainUITabPickedHolder = Instance.new("Frame")
	MainUITabPickedHolder.Name = "MainUITabPickedHolder"
	MainUITabPickedHolder.Parent = MainUIFrame
	MainUITabPickedHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	MainUITabPickedHolder.BackgroundTransparency = 1.000
	MainUITabPickedHolder.Position = UDim2.new(0.226860255, 0, 0.0866336599, 0)
	MainUITabPickedHolder.Size = UDim2.new(0, 426, 0, 369)
	local connections = {}

	MainUIFrame.InputBegan:connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			local InitialPos = input.Position
			local InitialFramePos = MainUIFrame.Position
			connections.MouseMoved = UserInputService.InputChanged:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseMovement then
					local delta = input.Position - InitialPos
					tweenObject(MainUIFrame, {
						Position = UDim2.new(InitialFramePos.X.Scale, InitialFramePos.X.Offset + delta.X, InitialFramePos.Y.Scale, InitialFramePos.Y.Offset + delta.Y)
					}, 0.1)
				end
			end)
			MainUIFrame.InputEnded:connect(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 then
					connections.MouseMoved:Disconnect()
				end
			end)
		end
	end)

	local opened = true

	UserInputService.InputBegan:Connect(function(input)
		if input.KeyCode == Enum.KeyCode.RightControl then
			if opened == true then
				if MainUIFrame.Parent ~= nil then
					MainUIFrame.ClipsDescendants = true
					MainUIFrame:TweenSize(UDim2.new(0, 0, 0, 404), Enum.EasingDirection.In, Enum.EasingStyle.Linear, 0.5, true)
					opened = false
					wait(0.5)
				end
			elseif opened == false then
				if MainUIFrame.Parent ~= nil then
					MainUIFrame:TweenSize(UDim2.new(0, 551, 0, 404), Enum.EasingDirection.Out, Enum.EasingStyle.Linear, 0.5, true)
					opened = true
					wait(0.5)
					MainUIFrame.ClipsDescendants = false
				end
			end
		end
	end)

	local window = {}
	function window:Notification(Type, content, callback)
		if Type == "Message" then
			local NotificationMain = Instance.new("ImageLabel")
			local NotificationDropShadow = Instance.new("ImageLabel")
			local NotificationTitleHodler = Instance.new("Frame")
			local NotificationTitle = Instance.new("TextLabel")
			local NotificationCool = Instance.new("ImageLabel")
			local NotificationText = Instance.new("TextLabel")
			local NotificationOkay = Instance.new("TextButton")
			NotificationMain.Name = "NotificationMain"
			NotificationMain.Parent = BloxburgUi
			NotificationMain.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			NotificationMain.BackgroundTransparency = 1.000
			NotificationMain.Position = UDim2.new(-0.3, 0, 0.775, 0)
			tweenObject(NotificationMain, {
				Position = UDim2.new(0.015, 0, 0.775, 0)
			}, 0.5)
			NotificationMain.Size = UDim2.new(0, 268, 0, 124)
			NotificationMain.Image = "rbxassetid://3570695787"
			NotificationMain.ImageColor3 = Color3.fromRGB(22, 22, 22)
			NotificationMain.ScaleType = Enum.ScaleType.Slice
			NotificationMain.SliceCenter = Rect.new(100, 100, 100, 100)
			NotificationMain.SliceScale = 0.050
			NotificationDropShadow.Name = "NotificationDropShadow"
			NotificationDropShadow.Parent = NotificationMain
			NotificationDropShadow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			NotificationDropShadow.BackgroundTransparency = 1.000
			NotificationDropShadow.Position = UDim2.new(-0.315028518, 0, -0.540322602, 0)
			NotificationDropShadow.Size = UDim2.new(0, 442, 0, 258)
			NotificationDropShadow.ZIndex = -1
			NotificationDropShadow.Image = "rbxassetid://5089202498"
			NotificationTitleHodler.Name = "NotificationTitleHodler"
			NotificationTitleHodler.Parent = NotificationMain
			NotificationTitleHodler.BackgroundColor3 = Color3.fromRGB(14, 14, 14)
			NotificationTitleHodler.BorderSizePixel = 0
			NotificationTitleHodler.Size = UDim2.new(0, 268, 0, 31)
			NotificationTitle.Name = "NotificationTitle"
			NotificationTitle.Parent = NotificationTitleHodler
			NotificationTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			NotificationTitle.BackgroundTransparency = 1.000
			NotificationTitle.Position = UDim2.new(0.0261194035, 0, 0, 0)
			NotificationTitle.Size = UDim2.new(0, 261, 0, 31)
			NotificationTitle.Font = Enum.Font.GothamSemibold
			NotificationTitle.Text = "Notification"
			NotificationTitle.TextColor3 = Color3.fromRGB(233, 233, 233)
			NotificationTitle.TextSize = 14.000
			NotificationTitle.TextXAlignment = Enum.TextXAlignment.Left
			NotificationCool.Name = "NotificationCool"
			NotificationCool.Parent = NotificationTitleHodler
			NotificationCool.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			NotificationCool.BackgroundTransparency = 1.000
			NotificationCool.Position = UDim2.new(0.914178967, 0, 0.225806445, 0)
			NotificationCool.Size = UDim2.new(0, 17, 0, 17)
			NotificationCool.Image = "rbxgameasset://Images/w"
			NotificationText.Name = "NotificationText"
			NotificationText.Parent = NotificationMain
			NotificationText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			NotificationText.BackgroundTransparency = 1.000
			NotificationText.Position = UDim2.new(-0.0037313432, 0, 0.25, 0)
			NotificationText.Size = UDim2.new(0, 268, 0, 66)
			NotificationText.ZIndex = 2
			NotificationText.Font = Enum.Font.GothamSemibold
            NotificationText.TextScaled = true
			NotificationText.Text = content.Text
			NotificationText.TextColor3 = Color3.fromRGB(233, 233, 233)
			NotificationText.TextSize = 14.000
			NotificationOkay.Name = "NotificationOkay"
			NotificationOkay.Parent = NotificationMain
			NotificationOkay.BackgroundColor3 = Color3.fromRGB(14, 14, 14)
			NotificationOkay.BorderSizePixel = 0
			NotificationOkay.Position = UDim2.new(0.0223880596, 0, 0.782258093, 0)
			NotificationOkay.Size = UDim2.new(0, 256, 0, 21)
			NotificationOkay.Font = Enum.Font.GothamSemibold
			NotificationOkay.Text = content.ConfirmText
			NotificationOkay.TextColor3 = Color3.fromRGB(233, 233, 233)
			NotificationOkay.TextSize = 13.000
			NotificationOkay.MouseButton1Click:connect(function()
				tweenObject(NotificationMain, {
					Position = UDim2.new(-0.3, 0, 0.775, 0)
				}, 0.5)
				wait(0.5)
				NotificationMain:Destroy()
			end)
		elseif Type == "Error" then
			local ErrorMain = Instance.new("ImageLabel")
			local ErrorDropShadow = Instance.new("ImageLabel")
			local ErrorTitleHolder = Instance.new("Frame")
			local ErrorTitle = Instance.new("TextLabel")
			local ErrorBad = Instance.new("ImageLabel")
			local ErrorText = Instance.new("TextLabel")
			local ErrorOkay = Instance.new("TextButton")
			ErrorMain.Name = "ErrorMain"
			ErrorMain.Parent = BloxburgUi
			ErrorMain.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			ErrorMain.BackgroundTransparency = 1.000
			ErrorMain.Position = UDim2.new(-0.3, 0, 0.775, 0)
			tweenObject(ErrorMain, {
				Position = UDim2.new(0.015, 0, 0.775, 0)
			}, 0.5)
			ErrorMain.Size = UDim2.new(0, 268, 0, 124)
			ErrorMain.Image = "rbxassetid://3570695787"
			ErrorMain.ImageColor3 = Color3.fromRGB(22, 22, 22)
			ErrorMain.ScaleType = Enum.ScaleType.Slice
			ErrorMain.SliceCenter = Rect.new(100, 100, 100, 100)
			ErrorMain.SliceScale = 0.050
			ErrorDropShadow.Name = "ErrorDropShadow"
			ErrorDropShadow.Parent = ErrorMain
			ErrorDropShadow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			ErrorDropShadow.BackgroundTransparency = 1.000
			ErrorDropShadow.Position = UDim2.new(-0.315028518, 0, -0.540322602, 0)
			ErrorDropShadow.Size = UDim2.new(0, 442, 0, 258)
			ErrorDropShadow.ZIndex = -1
			ErrorDropShadow.Image = "rbxassetid://5089202498"
			ErrorTitleHolder.Name = "ErrorTitleHolder"
			ErrorTitleHolder.Parent = ErrorMain
			ErrorTitleHolder.BackgroundColor3 = Color3.fromRGB(14, 14, 14)
			ErrorTitleHolder.BorderSizePixel = 0
			ErrorTitleHolder.Size = UDim2.new(0, 268, 0, 31)
			ErrorTitle.Name = "ErrorTitle"
			ErrorTitle.Parent = ErrorTitleHolder
			ErrorTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			ErrorTitle.BackgroundTransparency = 1.000
			ErrorTitle.Position = UDim2.new(0.0261194035, 0, 0, 0)
			ErrorTitle.Size = UDim2.new(0, 261, 0, 31)
			ErrorTitle.Font = Enum.Font.GothamSemibold
			ErrorTitle.Text = "ERROR"
			ErrorTitle.TextColor3 = Color3.fromRGB(233, 58, 53)
			ErrorTitle.TextSize = 14.000
			ErrorTitle.TextXAlignment = Enum.TextXAlignment.Left
			ErrorBad.Name = "ErrorBad"
			ErrorBad.Parent = ErrorTitleHolder
			ErrorBad.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			ErrorBad.BackgroundTransparency = 1.000
			ErrorBad.Position = UDim2.new(0.914178848, 0, 0.225806445, 0)
			ErrorBad.Size = UDim2.new(0, 17, 0, 17)
			ErrorBad.Image = "rbxgameasset://Images/d"
			ErrorBad.ImageColor3 = Color3.fromRGB(233, 58, 53)
			ErrorText.Name = "ErrorText"
			ErrorText.Parent = ErrorMain
			ErrorText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			ErrorText.BackgroundTransparency = 1.000
			ErrorText.Position = UDim2.new(-0.0037313432, 0, 0.25, 0)
			ErrorText.Size = UDim2.new(0, 268, 0, 66)
			ErrorText.ZIndex = 2
			ErrorText.Font = Enum.Font.GothamSemibold
			ErrorText.Text = content.Text
			ErrorText.TextColor3 = Color3.fromRGB(233, 233, 233)
			ErrorText.TextSize = 14.000
			ErrorOkay.Name = "ErrorOkay"
			ErrorOkay.Parent = ErrorMain
			ErrorOkay.BackgroundColor3 = Color3.fromRGB(14, 14, 14)
			ErrorOkay.BorderSizePixel = 0
			ErrorOkay.Position = UDim2.new(0.0223880596, 0, 0.782258093, 0)
			ErrorOkay.Size = UDim2.new(0, 256, 0, 21)
			ErrorOkay.Font = Enum.Font.GothamSemibold
			ErrorOkay.Text = content.ConfirmText
			ErrorOkay.TextColor3 = Color3.fromRGB(233, 233, 233)
			ErrorOkay.TextSize = 13.000
			ErrorOkay.MouseButton1Click:connect(function()
				tweenObject(ErrorMain, {
					Position = UDim2.new(-0.3, 0, 0.775, 0)
				}, 0.5)
				wait(0.5)
				ErrorMain:Destroy()
			end)
		elseif Type == "Confirm" then
			local NotificationMain = Instance.new("ImageLabel")
			local NotificationDropShadow = Instance.new("ImageLabel")
			local NotificationTitleHodler = Instance.new("Frame")
			local NotificationTitle = Instance.new("TextLabel")
			local NotificationCool = Instance.new("ImageLabel")
			local NotificationText = Instance.new("TextLabel")
			local NotificationYes = Instance.new("TextButton")
			local NotificationNo = Instance.new("TextButton")
			NotificationMain.Name = "NotificationMain"
			NotificationMain.Parent = BloxburgUi
			NotificationMain.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			NotificationMain.BackgroundTransparency = 1.000
			NotificationMain.Position = UDim2.new(-0.3, 0, 0.775, 0)
			NotificationMain.Size = UDim2.new(0, 268, 0, 124)
			NotificationMain.Image = "rbxassetid://3570695787"
			NotificationMain.ImageColor3 = Color3.fromRGB(22, 22, 22)
			NotificationMain.ScaleType = Enum.ScaleType.Slice
			NotificationMain.SliceCenter = Rect.new(100, 100, 100, 100)
			NotificationMain.SliceScale = 0.050
			tweenObject(NotificationMain, {
				Position = UDim2.new(0.015, 0, 0.775, 0)
			}, 0.5)
			NotificationDropShadow.Name = "NotificationDropShadow"
			NotificationDropShadow.Parent = NotificationMain
			NotificationDropShadow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			NotificationDropShadow.BackgroundTransparency = 1.000
			NotificationDropShadow.Position = UDim2.new(-0.315028518, 0, -0.540322602, 0)
			NotificationDropShadow.Size = UDim2.new(0, 442, 0, 258)
			NotificationDropShadow.ZIndex = -1
			NotificationDropShadow.Image = "rbxassetid://5089202498"
			NotificationTitleHodler.Name = "NotificationTitleHodler"
			NotificationTitleHodler.Parent = NotificationMain
			NotificationTitleHodler.BackgroundColor3 = Color3.fromRGB(14, 14, 14)
			NotificationTitleHodler.BorderSizePixel = 0
			NotificationTitleHodler.Size = UDim2.new(0, 268, 0, 31)
			NotificationTitle.Name = "NotificationTitle"
			NotificationTitle.Parent = NotificationTitleHodler
			NotificationTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			NotificationTitle.BackgroundTransparency = 1.000
			NotificationTitle.Position = UDim2.new(0.0261194035, 0, 0, 0)
			NotificationTitle.Size = UDim2.new(0, 261, 0, 31)
			NotificationTitle.Font = Enum.Font.GothamSemibold
			NotificationTitle.Text = "Confirm"
			NotificationTitle.TextColor3 = Color3.fromRGB(88, 170, 205)
			NotificationTitle.TextSize = 14.000
			NotificationTitle.TextXAlignment = Enum.TextXAlignment.Left
			NotificationCool.Name = "NotificationCool"
			NotificationCool.Parent = NotificationTitleHodler
			NotificationCool.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			NotificationCool.BackgroundTransparency = 1.000
			NotificationCool.Position = UDim2.new(0.914178967, 0, 0.225806445, 0)
			NotificationCool.Size = UDim2.new(0, 17, 0, 17)
			NotificationCool.Image = "rbxgameasset://Images/w"
			NotificationText.Name = "NotificationText"
			NotificationText.Parent = NotificationMain
			NotificationText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			NotificationText.BackgroundTransparency = 1.000
			NotificationText.Position = UDim2.new(-0.0037313432, 0, 0.25, 0)
			NotificationText.Size = UDim2.new(0, 268, 0, 66)
			NotificationText.ZIndex = 2
			NotificationText.Font = Enum.Font.GothamSemibold
			NotificationText.Text = content.Text
			NotificationText.TextColor3 = Color3.fromRGB(233, 233, 233)
			NotificationText.TextSize = 14.000
			NotificationYes.Name = "NotificationYes"
			NotificationYes.Parent = NotificationMain
			NotificationYes.BackgroundColor3 = Color3.fromRGB(14, 14, 14)
			NotificationYes.BorderSizePixel = 0
			NotificationYes.Position = UDim2.new(0.0223880596, 0, 0.782258093, 0)
			NotificationYes.Size = UDim2.new(0, 128, 0, 21)
			NotificationYes.Font = Enum.Font.GothamSemibold
			NotificationYes.Text = "Yes"
			NotificationYes.TextColor3 = Color3.fromRGB(0, 255, 0)
			NotificationYes.TextSize = 13.000
			NotificationNo.Name = "NotificationNo"
			NotificationNo.Parent = NotificationMain
			NotificationNo.BackgroundColor3 = Color3.fromRGB(14, 14, 14)
			NotificationNo.BorderSizePixel = 0
			NotificationNo.Position = UDim2.new(0.5, 0, 0.782258093, 0)
			NotificationNo.Size = UDim2.new(0, 128, 0, 21)
			NotificationNo.Font = Enum.Font.GothamSemibold
			NotificationNo.Text = "No"
			NotificationNo.TextColor3 = Color3.fromRGB(233, 0, 0)
			NotificationNo.TextSize = 13.000
			NotificationYes.MouseButton1Click:Connect(function()
				tweenObject(NotificationMain, {
					Position = UDim2.new(-0.3, 0, 0.775, 0)
				}, 0.5)
				wait(0.5)
				NotificationMain:Destroy()
				NotificationMain = nil
				if callback then
					callback(true)
				end
			end)
			NotificationNo.MouseButton1Click:Connect(function()
				tweenObject(NotificationMain, {
					Position = UDim2.new(-0.3, 0, 0.775, 0)
				}, 0.5)
				wait(0.5)
				NotificationMain:Destroy()
				NotificationMain = nil
				if callback then
					callback(false)
				end
			end)
		end
	end
	local activeTab = nil
	local activeTabFrame = nil
	function window:Tab(name)
		local TabSelected = Instance.new("TextButton")
		local TabTOpFrame = Instance.new("Frame")
		local TabBottomFrame = Instance.new("Frame")
		local MainUITabPicked = Instance.new("ScrollingFrame")
		TabSelected.Name = "TabSelected"
		TabSelected.Parent = TabsHolder
		TabSelected.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
		TabSelected.BorderSizePixel = 0
		TabSelected.Size = UDim2.new(0, 125, 0, 30)
		TabSelected.AutoButtonColor = false
		TabSelected.Font = Enum.Font.GothamSemibold
		TabSelected.Text = name
		TabSelected.TextColor3 = Color3.fromRGB(66, 66, 66)
		TabSelected.TextSize = 13.000
		TabTOpFrame.Name = "TabTOpFrame"
		TabTOpFrame.Parent = TabSelected
		TabTOpFrame.BackgroundColor3 = Color3.fromRGB(84, 116, 224)
		TabTOpFrame.BorderColor3 = Color3.fromRGB(84, 116, 224)
		TabTOpFrame.BorderSizePixel = 0
		TabTOpFrame.Size = UDim2.new(0, 125, 0, 1)
		TabTOpFrame.BackgroundTransparency = 1
		TabBottomFrame.Name = "TabBottomFrame"
		TabBottomFrame.Parent = TabSelected
		TabBottomFrame.BackgroundColor3 = Color3.fromRGB(84, 116, 224)
		TabBottomFrame.BorderColor3 = Color3.fromRGB(84, 116, 224)
		TabBottomFrame.BorderSizePixel = 0
		TabBottomFrame.Position = UDim2.new(0, 0, 0.966666639, 0)
		TabBottomFrame.Size = UDim2.new(0, 125, 0, 1)
		TabBottomFrame.BackgroundTransparency = 1
		local UIListLayout_2 = Instance.new("UIListLayout")
		local UIPadding_2 = Instance.new("UIPadding")
		MainUITabPicked.Name = "MainUITabPicked"
		MainUITabPicked.Parent = MainUITabPickedHolder
		MainUITabPicked.CanvasSize = UDim2.new(0, 0, 0, 0)
		MainUITabPicked.Active = true
		MainUITabPicked.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		MainUITabPicked.BackgroundTransparency = 1.000
		MainUITabPicked.Size = UDim2.new(0, 426, 0, 369)
		MainUITabPicked.ScrollBarThickness = 2
		MainUITabPicked.Visible = false
		UIListLayout_2.Parent = MainUITabPicked
		UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout_2.Padding = UDim.new(0, 8)
		UIPadding_2.Parent = MainUITabPicked
		UIPadding_2.PaddingLeft = UDim.new(0, 8)
		UIPadding_2.PaddingTop = UDim.new(0, 8)
		if activeTab == nil then
			MainUITabPicked.Visible = true
			activeTabFrame = MainUITabPicked
			tweenObject(TabSelected, {
				BackgroundColor3 = Color3.fromRGB(17, 17, 30)
			}, 0.5)
			tweenObject(TabSelected, {
				TextColor3 = Color3.fromRGB(84, 116, 224)
			}, 0.5)
			activeTab = TabSelected
			tweenObject(TabBottomFrame, {
				BackgroundTransparency = 0
			}, 0.5)
			tweenObject(TabTOpFrame, {
				BackgroundTransparency = 0
			}, 0.5)
		end
		TabSelected.MouseButton1Click:Connect(function()
			tweenObject(activeTab.TabBottomFrame, {
				BackgroundTransparency = 1
			}, 0.5)
			tweenObject(activeTab.TabTOpFrame, {
				BackgroundTransparency = 1
			}, 0.5)
			tweenObject(activeTab, {
				BackgroundColor3 = Color3.fromRGB(24, 24, 24)
			}, 0.5)
			tweenObject(activeTab, {
				TextColor3 = Color3.fromRGB(66, 66, 66)
			}, 0.5)
			activeTabFrame.Visible = false
			activeTab = TabSelected
			activeTabFrame = MainUITabPicked
			MainUITabPicked.Visible = true
			tweenObject(TabSelected, {
				BackgroundColor3 = Color3.fromRGB(17, 17, 30)
			}, 0.5)
			tweenObject(TabSelected, {
				TextColor3 = Color3.fromRGB(84, 116, 224)
			}, 0.5)
			tweenObject(TabBottomFrame, {
				BackgroundTransparency = 0
			}, 0.5)
			tweenObject(TabTOpFrame, {
				BackgroundTransparency = 0
			}, 0.5)
		end)
		local tab = {}
		local tabSize = 39
		local function ResizeTab()
			MainUITabPicked.CanvasSize = UDim2.new(0, 0, 0, tabSize)
		end

		function tab:Section(name)
			local SectionBack = Instance.new("ImageLabel")
			local SectionTitleBack = Instance.new("Frame")
			local SectionTitle = Instance.new("TextLabel")
			local SectionFrame = Instance.new("Frame")
			local UIListLayout_3 = Instance.new("UIListLayout")
			local UIPadding_3 = Instance.new("UIPadding")
			local UIListLayout_4 = Instance.new("UIListLayout")
			SectionBack.Name = "Section Back"
			SectionBack.Parent = MainUITabPicked
			SectionBack.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			SectionBack.BackgroundTransparency = 1.000
			SectionBack.Position = UDim2.new(0.018779343, 0, -0.978319764, 0)
			SectionBack.Size = UDim2.new(0, 403, 0, 31)
			SectionBack.Image = "rbxassetid://3570695787"
			SectionBack.ImageColor3 = Color3.fromRGB(15, 15, 15)
			SectionBack.ScaleType = Enum.ScaleType.Slice
			SectionBack.SliceCenter = Rect.new(100, 100, 100, 100)
			SectionBack.SliceScale = 0.050

			UIListLayout_4.Parent = SectionBack
			UIListLayout_4.SortOrder = Enum.SortOrder.LayoutOrder
			SectionTitleBack.Name = "SectionTitleBack"
			SectionTitleBack.Parent = SectionBack
			SectionTitleBack.BackgroundColor3 = Color3.fromRGB(14, 14, 14)
			SectionTitleBack.BorderSizePixel = 0
			SectionTitleBack.Size = UDim2.new(0, 403, 0, 31)
			SectionTitle.Name = "SectionTitle"
			SectionTitle.Parent = SectionTitleBack
			SectionTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			SectionTitle.BackgroundTransparency = 1.000
			SectionTitle.Position = UDim2.new(0.0148883378, 0, 0, 0)
			SectionTitle.Size = UDim2.new(0, 397, 0, 31)
			SectionTitle.Font = Enum.Font.GothamSemibold
			SectionTitle.Text = name
			SectionTitle.TextColor3 = Color3.fromRGB(233, 233, 233)
			SectionTitle.TextSize = 14.000
			SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
			SectionFrame.Name = "SectionFrame"
			SectionFrame.Parent = SectionBack
			SectionFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			SectionFrame.BackgroundTransparency = 1.000
			SectionFrame.BorderSizePixel = 0
			SectionFrame.Position = UDim2.new(0, 0, 0.0775000006, 0)
			SectionFrame.Size = UDim2.new(0, 403, 0, 0)
			UIListLayout_3.Parent = SectionFrame
			UIListLayout_3.SortOrder = Enum.SortOrder.LayoutOrder
			UIListLayout_3.Padding = UDim.new(0, 8)
			UIPadding_3.Parent = SectionFrame
			UIPadding_3.PaddingLeft = UDim.new(0, 8)
			UIPadding_3.PaddingTop = UDim.new(0, 8)

			--tabSize = tabSize +
			tabSize = tabSize + 41
			ResizeTab()
			local sectionSize = 39
			local function ResizeSection()
				SectionBack.Size = UDim2.new(0, 403, 0, sectionSize)
				SectionFrame.Size = UDim2.new(0, 403, 0, sectionSize - 31)
			end

			local section = {}
			function section:Label(name)
				sectionSize = sectionSize + 39
				tabSize = tabSize + 39
				ResizeTab()
				ResizeSection()
				local LabelBack = Instance.new("Frame")
				local LabelTitle = Instance.new("TextLabel")
				LabelBack.Name = "LabelBack"
				LabelBack.Parent = SectionFrame
				LabelBack.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
				LabelBack.BorderSizePixel = 0
				LabelBack.Position = UDim2.new(0.018779343, 0, 0.233062327, 0)
				LabelBack.Size = UDim2.new(0, 390, 0, 31)
				LabelTitle.Name = "LabelTitle"
				LabelTitle.Parent = LabelBack
				LabelTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				LabelTitle.BackgroundTransparency = 1.000
				LabelTitle.Position = UDim2.new(0.0147783253, 0, 0, 0)
				LabelTitle.Size = UDim2.new(0, 400, 0, 31)
				LabelTitle.Font = Enum.Font.GothamSemibold
				LabelTitle.TextColor3 = Color3.fromRGB(233, 233, 233)
				LabelTitle.TextSize = 13.000
				LabelTitle.Text = name
				LabelTitle.TextXAlignment = Enum.TextXAlignment.Left

				local label = {}
				function label:Update(name)
					LabelTitle.Text = name
				end
                function label:Destroy()
                    LabelBack:Destroy()
                    sectionSize = sectionSize - 39 
                    tabSize = tabSize - 39
                    ResizeTab()
				    ResizeSection()
                end
				return label
			end
			function section:Slider(name, options, callback)
				if not library.flags[name] then 
					library.flags[name] = options.default or options.min
				end 
				local setting = GetSetting(name) 
				setting = setting and tonumber(setting)
				options.default = setting or options.default
				sectionSize = sectionSize + 63
				tabSize = tabSize + 63
				ResizeTab()
				ResizeSection()
				local Sliderback = Instance.new("Frame")
				local SliderTitle = Instance.new("TextLabel")
				local SliderBarBack = Instance.new("ImageButton")
				local Sliderhandle = Instance.new("ImageLabel")
				local SliderValueBack = Instance.new("ImageLabel")
				local SliderValue = Instance.new("TextBox")
				local TextButton = Instance.new("TextButton")
				local TextButton_2 = Instance.new("TextButton")

				Sliderback.Name = "Sliderback"
				Sliderback.Parent = SectionFrame
				Sliderback.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
				Sliderback.BorderSizePixel = 0
				Sliderback.Position = UDim2.new(0.018779343, 0, 0.233062327, 0)
				Sliderback.Size = UDim2.new(0, 390, 0, 55)
				TextButton.Parent = Sliderback
				TextButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				TextButton.BackgroundTransparency = 1
				TextButton.Position = UDim2.new(0.675, 0, 0.0181818306, 0)
				TextButton.Size = UDim2.new(0, 35, 0, 35)
				TextButton.Font = Enum.Font.Gotham
				TextButton.Text = "-"
				TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
				TextButton.TextSize = 14.000
				TextButton_2.Parent = Sliderback
				TextButton_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				TextButton_2.BackgroundTransparency = 1
				TextButton_2.Position = UDim2.new(0.92, 0, 9.31322575e-09, 0)
				TextButton_2.Size = UDim2.new(0, 35, 0, 35)
				TextButton_2.Font = Enum.Font.Gotham
				TextButton_2.Text = "+"
				TextButton_2.TextColor3 = Color3.fromRGB(255, 255, 255)
				TextButton_2.TextSize = 14.000

				SliderTitle.Name = "SliderTitle"
				SliderTitle.Parent = Sliderback
				SliderTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				SliderTitle.BackgroundTransparency = 1.000
				SliderTitle.Position = UDim2.new(0.0147783253, 0, 0, 0)
				SliderTitle.Size = UDim2.new(0, 400, 0, 31)
				SliderTitle.Font = Enum.Font.GothamSemibold
				SliderTitle.Text = name
				SliderTitle.TextColor3 = Color3.fromRGB(233, 233, 233)
				SliderTitle.TextSize = 13.000
				SliderTitle.TextXAlignment = Enum.TextXAlignment.Left
				SliderBarBack.Name = "SliderBarBack"
				SliderBarBack.Parent = Sliderback
				SliderBarBack.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				SliderBarBack.BackgroundTransparency = 1.000
				SliderBarBack.Position = UDim2.new(0.0147783253, 0, 0.76363641, 0)
				SliderBarBack.Size = UDim2.new(0, 380, 0, 6)
				SliderBarBack.Image = "rbxassetid://3570695787"
				SliderBarBack.ImageColor3 = Color3.fromRGB(77, 77, 77)
				SliderBarBack.ScaleType = Enum.ScaleType.Slice
				SliderBarBack.SliceCenter = Rect.new(100, 100, 100, 100)
				SliderBarBack.SliceScale = 0.050
				Sliderhandle.Name = "Sliderhandle"
				Sliderhandle.Parent = SliderBarBack
				Sliderhandle.BackgroundColor3 = Color3.fromRGB(84, 116, 224)
				Sliderhandle.BackgroundTransparency = 1.000
				Sliderhandle.Size = UDim2.new(0, 0, 0, 6)
				Sliderhandle.Image = "rbxassetid://3570695787"
				Sliderhandle.ImageColor3 = Color3.fromRGB(84, 116, 224)
				Sliderhandle.ScaleType = Enum.ScaleType.Slice
				Sliderhandle.SliceCenter = Rect.new(100, 100, 100, 100)
				Sliderhandle.SliceScale = 0.050
				SliderValueBack.Name = "SliderValueBack"
				SliderValueBack.Parent = Sliderback
				SliderValueBack.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				SliderValueBack.BackgroundTransparency = 1.000
				SliderValueBack.Position = UDim2.new(0.78, 0, 0.109090909, 0)
				SliderValueBack.Size = UDim2.new(0, 50, 0, 25)
				SliderValueBack.Image = "rbxassetid://3570695787"
				SliderValueBack.ImageColor3 = Color3.fromRGB(14, 14, 14)
				SliderValueBack.ScaleType = Enum.ScaleType.Slice
				SliderValueBack.SliceCenter = Rect.new(100, 100, 100, 100)
				SliderValueBack.SliceScale = 0.050
				SliderValue.Name = "SliderValue"
				SliderValue.Parent = SliderValueBack
				SliderValue.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				SliderValue.BackgroundTransparency = 1.000
				SliderValue.Size = UDim2.new(0, 50, 0, 25)
				SliderValue.Font = Enum.Font.GothamSemibold
				SliderValue.Text = options.default or options.min < 0 and options.max > 0 and "0" or tostring(options.min)
				SliderValue.TextColor3 = Color3.fromRGB(233, 233, 233)
				SliderValue.TextSize = 13.000
				
                local OldCallback = callback or function() end
				callback = function(Value)
					library.flags[name] = Value
					AddSetting(name, tostring(Value))
                    return OldCallback(Value)
				end

				if options.default then
					value = math.clamp(options.default, options.min, options.max)
					local percent = 1 - ((options.max - value) / (options.max - options.min))
					tweenObject(Sliderhandle, {
						Size = UDim2.new(0, percent * 380, 0, 6)
					}, 0.1)
					manual = true
					SliderValue.Text = tostring(value)
					manual = false
					callback(value)
				end

				local value = options.default or options.min;
				local connections = {}
				local manual = false
				TextButton.MouseButton1Click:Connect(function()
					value = math.clamp(value - 1, options.min, options.max)
					local percent = 1 - ((options.max - value) / (options.max - options.min))
					tweenObject(Sliderhandle, {
						Size = UDim2.new(0, percent * 380, 0, 6)
					}, 0.1)
					manual = true
					SliderValue.Text = tostring(value)
					manual = false
					if callback then
						callback(value)
					end
				end)
				TextButton_2.MouseButton1Click:Connect(function()
					value = math.clamp(value + 1, options.min, options.max)
					local percent = 1 - ((options.max - value) / (options.max - options.min))
					tweenObject(Sliderhandle, {
						Size = UDim2.new(0, percent * 380, 0, 6)
					}, 0.1)
					manual = true
					SliderValue.Text = tostring(value)
					manual = false
					if callback then
						callback(value)
					end
				end)
				SliderValue:GetPropertyChangedSignal("Text"):Connect(function()
					if not manual then
						if tonumber(SliderValue.Text) ~= nil then
							value = math.clamp(tonumber(SliderValue.Text), options.min, options.max)
							local percent = 1 - ((options.max - value) / (options.max - options.min))
							tweenObject(Sliderhandle, {
								Size = UDim2.new(0, percent * 380, 0, 6)
							}, 0.1)
							local con
							con = SliderValue.FocusLost:Connect(function()
								con:Disconnect()
								if callback then
									callback(value)
								end
							end)
						end
					end
				end)

				SliderBarBack.MouseButton1Down:Connect(function()
					value = math.floor((((tonumber(options.max) - tonumber(options.min)) / 380) * Sliderhandle.AbsoluteSize.X) + tonumber(options.min) + 0.5) or 0
					SliderValue.Text = value
					tweenObject(Sliderhandle, {
						Size = UDim2.new(0, math.clamp(Mouse.X - Sliderhandle.AbsolutePosition.X, 0, 380), 0, 6)
					}, 0.1)
					tweenObject(Sliderhandle, {
						ImageColor3 = Color3.fromRGB(255, 255, 255)
					}, 0.2)
					if callback then
						callback(value)
					end
					connections.MoveConnection = Mouse.Move:Connect(function()
						value = math.floor((((tonumber(options.max) - tonumber(options.min)) / 380) * Sliderhandle.AbsoluteSize.X) + tonumber(options.min) + 0.5) or 0
						SliderValue.Text = value
						tweenObject(Sliderhandle, {
							Size = UDim2.new(0, math.clamp(Mouse.X - Sliderhandle.AbsolutePosition.X, 0, 380), 0, 6)
						}, 0.1)
						tweenObject(Sliderhandle, {
							ImageColor3 = Color3.fromRGB(255, 255, 255)
						}, 0.2)
						if callback then
							callback(value)
						end
					end)
					connections.ReleaseConnection = UserInputService.InputEnded:Connect(function(mouse)
						if mouse.UserInputType == Enum.UserInputType.MouseButton1 then
							value = math.floor((((tonumber(options.max) - tonumber(options.min)) / 380) * Sliderhandle.AbsoluteSize.X) + tonumber(options.min) + 0.5) or 0
							SliderValue.Text = value
							tweenObject(Sliderhandle, {
								Size = UDim2.new(0, math.clamp(Mouse.X - Sliderhandle.AbsolutePosition.X, 0, 380), 0, 6)
							}, 0.1)
							tweenObject(Sliderhandle, {
								ImageColor3 = Color3.fromRGB(84, 116, 224)
							}, 0.2)
							connections.MoveConnection:Disconnect()
							connections.ReleaseConnection:Disconnect()
							if callback then
								callback(value)
							end
						end
					end)
				end)
				local slider = {}
				function slider:Update(val)
					value = math.clamp(val, options.min, options.max)
					local percent = 1 - ((options.max - value) / (options.max - options.min))
					tweenObject(Sliderhandle, {
						Size = UDim2.new(0, percent * 380, 0, 6)
					}, 0.1)
					if callback then
						callback(value)
					end
				end
				return slider
			end

			function section:Box(name, default, callback)
				default = GetSetting(name) or default 

				if not library.flags[name] then 
					library.flags[name] = default or ""
				end 

				sectionSize = sectionSize + 39
				tabSize = tabSize + 39
				ResizeTab()
				ResizeSection()
				local TextBoxMain = Instance.new("Frame")
				local TextBoxTitle = Instance.new("TextLabel")
				local TextBox = Instance.new("TextBox")
				local TextBox_Roundify_5px = Instance.new("ImageLabel")
				TextBoxMain.Name = "TextBoxMain"
				TextBoxMain.Parent = SectionFrame
				TextBoxMain.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
				TextBoxMain.BorderColor3 = Color3.fromRGB(27, 42, 53)
				TextBoxMain.BorderSizePixel = 0
				TextBoxMain.Position = UDim2.new(0.018779343, 0, 0.615176141, 0)
				TextBoxMain.Size = UDim2.new(0, 390, 0, 31)
				TextBoxTitle.Name = "TextBoxTitle"
				TextBoxTitle.Parent = TextBoxMain
				TextBoxTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				TextBoxTitle.BackgroundTransparency = 1.000
				TextBoxTitle.Position = UDim2.new(0.0147783253, 0, 0, 0)
				TextBoxTitle.Size = UDim2.new(0, 400, 0, 31)
				TextBoxTitle.Font = Enum.Font.GothamSemibold
				TextBoxTitle.Text = name
				TextBoxTitle.TextColor3 = Color3.fromRGB(233, 233, 233)
				TextBoxTitle.TextSize = 13.000
				TextBoxTitle.TextXAlignment = Enum.TextXAlignment.Left
				TextBox.Parent = TextBoxMain
				TextBox.BackgroundColor3 = Color3.fromRGB(13, 13, 13)
				TextBox.BackgroundTransparency = 1.000
				TextBox.BorderSizePixel = 0
				TextBox.Position = UDim2.new(0.270329684, 0, 0.193548381, 0)
				TextBox.Size = UDim2.new(0, 284, 0, 18)
				TextBox.ZIndex = 2
				TextBox.Font = Enum.Font.GothamSemibold
				TextBox.PlaceholderColor3 = Color3.fromRGB(66, 66, 66)
				TextBox.PlaceholderText = name
				TextBox.Text = default or ""
				TextBox.TextColor3 = Color3.fromRGB(233, 233, 233)
				TextBox.TextSize = 13.000
				TextBox_Roundify_5px.Name = "TextBox_Roundify_5px"
				TextBox_Roundify_5px.Parent = TextBox
				TextBox_Roundify_5px.Active = true
				TextBox_Roundify_5px.AnchorPoint = Vector2.new(0.5, 0.5)
				TextBox_Roundify_5px.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				TextBox_Roundify_5px.BackgroundTransparency = 1.000
				TextBox_Roundify_5px.Position = UDim2.new(0.5, 0, 0.5, 0)
				TextBox_Roundify_5px.Selectable = true
				TextBox_Roundify_5px.Size = UDim2.new(1, 0, 1, 0)
				TextBox_Roundify_5px.Image = "rbxassetid://3570695787"
				TextBox_Roundify_5px.ImageColor3 = Color3.fromRGB(13, 13, 13)
				TextBox_Roundify_5px.ScaleType = Enum.ScaleType.Slice
				TextBox_Roundify_5px.SliceCenter = Rect.new(100, 100, 100, 100)
				TextBox_Roundify_5px.SliceScale = 0.040
				local LastSize = -1

				local OldCallback = callback or function() end
				callback = function(Value)
					library.flags[name] = Value
					AddSetting(name, tostring(Value))
                    return OldCallback(Value)
				end

				TextBox:GetPropertyChangedSignal("Text"):connect(function()
					local Size = TextService:GetTextSize(TextBox.Text, TextBox.TextSize + 1, TextBox.Font, TextBoxMain.AbsoluteSize)
					local Length = string.len(TextBox.Text)
					if Size.X > 284 then 
						LastSize = Length
						TextBox.TextScaled = true 
					elseif Size.X <= 284 and Length < LastSize then 
						TextBox.TextScaled = false 
						TextBox.TextSize = 13
					end
				end)

				TextBox.FocusLost:Connect(function()
					if callback then
						callback(TextBox.Text)
					end
				end)

				if default and callback then 
					callback(default)
				end

				local box = {}

				function box:Update(val)
					TextBox.Text = val
					if callback then
						callback(val)
					end
				end

				return box
			end
			function section:Picker(name, options, default, callback, dontsave)
				default = GetSetting(name) or default 

				if not library.flags[name] then 
					library.flags[name] = default or options[1]
				end 

				sectionSize = sectionSize + 70
				tabSize = tabSize + 70
				ResizeTab()
				ResizeSection()
				local PickerBack = Instance.new("Frame")
				local PickerTitle = Instance.new("TextLabel")
				local OptionsHolder = Instance.new("ImageLabel")
				local UIListLayout = Instance.new("UIListLayout")
				PickerBack.Name = "PickerBack"
				PickerBack.Parent = SectionFrame
				PickerBack.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
				PickerBack.BorderSizePixel = 0
				PickerBack.Position = UDim2.new(0.018779343, 0, 0.420054197, 0)
				PickerBack.Size = UDim2.new(0, 390, 0, 62)
				PickerTitle.Name = "PickerTitle"
				PickerTitle.Parent = PickerBack
				PickerTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				PickerTitle.BackgroundTransparency = 1.000
				PickerTitle.Position = UDim2.new(0.0147783253, 0, 0, 0)
				PickerTitle.Size = UDim2.new(0, 400, 0, 31)
				PickerTitle.Font = Enum.Font.GothamSemibold
				PickerTitle.Text = name
				PickerTitle.TextColor3 = Color3.fromRGB(233, 233, 233)
				PickerTitle.TextSize = 13.000
				PickerTitle.TextXAlignment = Enum.TextXAlignment.Left
				OptionsHolder.Name = "OptionsHolder"
				OptionsHolder.Parent = PickerBack
				OptionsHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				OptionsHolder.BackgroundTransparency = 1.000
				OptionsHolder.Position = UDim2.new(0.0147783328, 0, 0.5, 0)
				OptionsHolder.Size = UDim2.new(0, 384, 0, 24)
				OptionsHolder.Image = "rbxassetid://3570695787"
				OptionsHolder.ImageColor3 = Color3.fromRGB(14, 14, 14)
				OptionsHolder.ScaleType = Enum.ScaleType.Slice
				OptionsHolder.SliceCenter = Rect.new(100, 100, 100, 100)
				OptionsHolder.SliceScale = 0.050
				UIListLayout.Parent = OptionsHolder
				UIListLayout.FillDirection = Enum.FillDirection.Horizontal
				UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
				local OldCallback = callback or function() end
				callback = function(Value)
					library.flags[name] = Value
                    if dontsave ~= true then
					    AddSetting(name, tostring(Value))
                    end
                    return OldCallback(Value)
				end

				local activeButton = nil
				for i, v in next, options do
					local OptionDeselected = Instance.new("TextButton")
					OptionDeselected.Name = "OptionDeselected"
					OptionDeselected.Parent = OptionsHolder
					OptionDeselected.BackgroundColor3 = Color3.fromRGB(14, 14, 14)
					OptionDeselected.BorderSizePixel = 0
					OptionDeselected.Size = UDim2.new(0, 77, 0, 24)
					OptionDeselected.AutoButtonColor = false
					OptionDeselected.Font = Enum.Font.GothamSemibold
					OptionDeselected.Text = v
					OptionDeselected.TextColor3 = Color3.fromRGB(66, 66, 66)
					OptionDeselected.TextSize = 13.000
					if activeButton == nil then
						if not default or default == v then
							activeButton = OptionDeselected
							OptionDeselected.TextColor3 = Color3.fromRGB(84, 116, 224)
							if callback then
								callback(v)
							end
						end
					end
					OptionDeselected.MouseButton1Click:Connect(function()
						if activeButton == OptionDeselected then
							return
						end
						if activeButton then
							tweenObject(activeButton, {
								TextColor3 = Color3.fromRGB(66, 66, 66)
							}, 0.2)
						end
						tweenObject(OptionDeselected, {
							TextColor3 = Color3.fromRGB(84, 116, 224)
						}, 0.2)
						activeButton = OptionDeselected
						if callback then
							callback(v)
						end
					end)
				end

				local picker = {}
				function picker:Update(value)
					for i, v in next, OptionsHolder:GetChildren() do 
						if v.Text == value then
							if activeButton == v then
								return
							end
							if activeButton then
								tweenObject(activeButton, {
									TextColor3 = Color3.fromRGB(66, 66, 66)
								}, 0.2)
							end
							tweenObject(v, {
								TextColor3 = Color3.fromRGB(84, 116, 224)
							}, 0.2)
							activeButton = v
							if callback then
								callback(v.Text)
							end
							return
						end
					end
				end
				return picker
			end
			function section:Toggle(name, default, callback, dontsave)
				local setting = GetSetting(name) 
				setting = setting == "true" and true or false
				default = setting or default 

				if not library.flags[name] then 
					library.flags[name] = default or false 
				end 

				sectionSize = sectionSize + 39
				tabSize = tabSize + 39
				ResizeTab()
				ResizeSection()

				local ToggleBackButton = Instance.new("TextButton")
				local ToggleTitle = Instance.new("TextLabel")
				local ToggleIndicator = Instance.new("ImageLabel")
				ToggleBackButton.Name = "ToggleBackButton"
				ToggleBackButton.Parent = SectionFrame
				ToggleBackButton.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
				ToggleBackButton.BorderSizePixel = 0
				ToggleBackButton.Size = UDim2.new(0, 390, 0, 31)
				ToggleBackButton.AutoButtonColor = false
				ToggleBackButton.Font = Enum.Font.SourceSans
				ToggleBackButton.Text = ""
				ToggleBackButton.TextColor3 = Color3.fromRGB(0, 0, 0)
				ToggleBackButton.TextSize = 14.000
				ToggleTitle.Name = "ToggleTitle"
				ToggleTitle.Parent = ToggleBackButton
				ToggleTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				ToggleTitle.BackgroundTransparency = 1.000
				ToggleTitle.Position = UDim2.new(0.0147783253, 0, 0, 0)
				ToggleTitle.Size = UDim2.new(0, 400, 0, 31)
				ToggleTitle.Font = Enum.Font.GothamSemibold
				ToggleTitle.Text = name
				ToggleTitle.TextColor3 = Color3.fromRGB(233, 233, 233)
				ToggleTitle.TextSize = 13.000
				ToggleTitle.TextXAlignment = Enum.TextXAlignment.Left
				ToggleIndicator.Name = "ToggleIndicator"
				ToggleIndicator.Parent = ToggleBackButton
				ToggleIndicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				ToggleIndicator.BackgroundTransparency = 1.000
				ToggleIndicator.Position = UDim2.new(0.933396459, 0, 0.161290318, 0)
				ToggleIndicator.Size = UDim2.new(0, 20, 0, 20)
				ToggleIndicator.Image = "rbxassetid://3570695787"
				ToggleIndicator.ImageColor3 = not default and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(84, 116, 224)
				ToggleIndicator.ScaleType = Enum.ScaleType.Slice
				ToggleIndicator.SliceCenter = Rect.new(100, 100, 100, 100)
				ToggleIndicator.SliceScale = 0.050
				local OldCallback = callback or function() end
				callback = function(Value)
					library.flags[name] = Value
					if dontsave ~= true then
					    AddSetting(name, tostring(Value))
					end
                    return OldCallback(Value)
				end

				if default and callback then 
					callback(default)
				end

				ToggleBackButton.MouseButton1Click:Connect(function()--better color pls
					
					if ToggleIndicator.ImageColor3 == Color3.fromRGB(84, 116, 224) then
						tweenObject(ToggleIndicator, {
							ImageColor3 = Color3.fromRGB(0, 0, 0)
						}, 0.1)
						if callback then
							callback(false)
						end
					elseif ToggleIndicator.ImageColor3 == Color3.fromRGB(0, 0, 0) then
						tweenObject(ToggleIndicator, {
							ImageColor3 = Color3.fromRGB(84, 116, 224)
						}, 0.1)
						if callback then
							callback(true)
						end
					end
				end)

				local toggle = {}

				function toggle:Update(bool)
					if ToggleIndicator.ImageColor3 == Color3.fromRGB(84, 116, 224) and bool == false then
						tweenObject(ToggleIndicator, {
							ImageColor3 = Color3.fromRGB(0, 0, 0)
						}, 0.1)
						if callback then
							callback(false)
						end
					elseif ToggleIndicator.ImageColor3 == Color3.fromRGB(0, 0, 0) and bool == true then
						tweenObject(ToggleIndicator, {
							ImageColor3 = Color3.fromRGB(84, 116, 224)
						}, 0.1)
						if callback then
							callback(true)
						end
					end
				end

				return toggle
			end
			function section:Button(name, callback)
				sectionSize = sectionSize + 39
				tabSize = tabSize + 39
				ResizeTab()
				ResizeSection()

				local Button = Instance.new("TextButton")
				local ButtonTitle = Instance.new("TextLabel")
				local ButtonCool = Instance.new("ImageLabel")
				Button.Name = "Button"
				Button.Parent = SectionFrame
				Button.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
				Button.BorderSizePixel = 0
				Button.ClipsDescendants = true
				Button.Position = UDim2.new(0.018779343, 0, 0.0216802172, 0)
				Button.Size = UDim2.new(0, 390, 0, 31)
				Button.AutoButtonColor = false
				Button.Font = Enum.Font.SourceSans
				Button.Text = ""
				Button.TextColor3 = Color3.fromRGB(0, 0, 0)
				Button.TextSize = 14.000
				ButtonTitle.Name = "ButtonTitle"
				ButtonTitle.Parent = Button
				ButtonTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				ButtonTitle.BackgroundTransparency = 1.000
				ButtonTitle.Position = UDim2.new(0.0147783253, 0, 0, 0)
				ButtonTitle.Size = UDim2.new(0, 400, 0, 31)
				ButtonTitle.Font = Enum.Font.GothamBold
				ButtonTitle.Text = name
				ButtonTitle.TextColor3 = Color3.fromRGB(233, 233, 233)
				ButtonTitle.TextSize = 13.000
				ButtonTitle.TextXAlignment = Enum.TextXAlignment.Center
				ButtonCool.Name = "ButtonCool"
				ButtonCool.Parent = ButtonTitle
				ButtonCool.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				ButtonCool.BackgroundTransparency = 1.000
				ButtonCool.Position = UDim2.new(0.899178982, 0, 0.225806445, 0)
				ButtonCool.Size = UDim2.new(0, 17, 0, 17)
				ButtonCool.Image = "rbxgameasset://Images/w"
				Button.MouseEnter:Connect(function()
					tweenObject(Button, {
						BackgroundColor3 = Color3.fromRGB(64, 64, 64)
					}, 0.3)
				end)

				Button.MouseLeave:Connect(function()
					tweenObject(Button, {
						BackgroundColor3 = Color3.fromRGB(24, 24, 24)
					}, 0.3)
				end)
				Button.MouseButton1Click:Connect(function()
					coroutine.resume(coroutine.create(function()
						local Circle = Instance.new("ImageLabel")
						Circle.Name = "Circle"
						Circle.Parent = Button
						Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
						Circle.BackgroundTransparency = 1
						Circle.ZIndex = 10
						Circle.Image = "rbxassetid://266543268"
						Circle.ImageColor3 = Color3.fromRGB(255, 255, 255)
						Circle.ImageTransparency = 0.900
						Button.ClipsDescendants = true
						Circle.Position = UDim2.new(0, Mouse.X - Circle.AbsolutePosition.X, 0, Mouse.Y - Circle.AbsolutePosition.Y)
						Circle:TweenSizeAndPosition(UDim2.new(0, Button.AbsoluteSize.X * 1.5, 0, Button.AbsoluteSize.X * 1.5), UDim2.new(0.5, -Button.AbsoluteSize.X * 1.5 / 2, 0.5, -Button.AbsoluteSize.X * 1.5 / 2), "Out", "Quad", 0.75, false, nil)
						tweenObject(Circle, {
							ImageTransparency = 1
						}, 0.75)
						wait(0.75)
						Circle:Destroy()
					end))
					if callback then
						callback()
					end
				end)
			end
			function section:ColorPicker(name, default, callback)
				local setting = GetSetting(name) 
				if setting then 
					local NoSpaces = setting:gsub("%s+", "")
					local Split = NoSpaces:split(",")
					setting = Color3.fromRGB(tonumber(Split[1]), tonumber(Split[2]), tonumber(Split[3]))
				end 

				default = setting or default 

				if not library.flags[name] then 
					library.flags[name] = default or Color3.fromRGB(255, 0, 0)
				end 

				sectionSize = sectionSize + 39
				tabSize = tabSize + 39
				ResizeTab()
				ResizeSection()

				local OldCallback = callback or function() end
				callback = function(Value)
					library.flags[name] = Value
					AddSetting(name, tostring(Value))
                    return OldCallback(Value)
				end

				local Main = Instance.new("ImageLabel")
				local Dark = Instance.new("ImageLabel")
				local White = Instance.new("ImageButton")
				local Val = Instance.new("ImageLabel")
				local Sat = Instance.new("ImageLabel")
				local UIGradient = Instance.new("UIGradient")
				local UIGradient_2 = Instance.new("UIGradient")
				local icon = Instance.new("ImageLabel")
				local Hue = Instance.new("ImageButton")
				local UIGradient_3 = Instance.new("UIGradient")
				local RBGbox = Instance.new("ImageLabel")
				local Holder = Instance.new("Frame")
				local UIListLayout = Instance.new("UIListLayout")
				local Back_R = Instance.new("ImageLabel")
				local R = Instance.new("TextBox")
				local Back_G = Instance.new("ImageLabel")
				local G = Instance.new("TextBox")
				local Back_B = Instance.new("ImageLabel")
				local B = Instance.new("TextBox")
				local Submit = Instance.new("ImageButton")
				local Title_2 = Instance.new("TextLabel")
				local Icon = Instance.new("ImageLabel")
				local ColorButton = Instance.new("TextButton")
				local ColorTitle = Instance.new("TextLabel")
				local ColorIndicator = Instance.new("ImageLabel")

				ColorButton.Name = "ColorButton"
				ColorButton.Parent = SectionFrame
				ColorButton.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
				ColorButton.BorderSizePixel = 0
				ColorButton.Size = UDim2.new(0, 390, 0, 31)
				ColorButton.AutoButtonColor = false
				ColorButton.Font = Enum.Font.SourceSans
				ColorButton.Text = ""
				ColorButton.TextColor3 = Color3.fromRGB(0, 0, 0)
				ColorButton.TextSize = 14.000
				ColorTitle.Name = "ColorTitle"
				ColorTitle.Parent = ColorButton
				ColorTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				ColorTitle.BackgroundTransparency = 1.000
				ColorTitle.Position = UDim2.new(0.0147783253, 0, 0, 0)
				ColorTitle.Size = UDim2.new(0, 400, 0, 31)
				ColorTitle.Font = Enum.Font.GothamSemibold
				ColorTitle.Text = name
				ColorTitle.TextColor3 = Color3.fromRGB(233, 233, 233)
				ColorTitle.TextSize = 13.000
				ColorTitle.TextXAlignment = Enum.TextXAlignment.Left
				ColorIndicator.Name = "ToggleIndicator"
				ColorIndicator.Parent = ColorButton
				ColorIndicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				ColorIndicator.BackgroundTransparency = 1.000
				ColorIndicator.Position = UDim2.new(0.933396459, 0, 0.161290318, 0)
				ColorIndicator.Size = UDim2.new(0, 20, 0, 20)
				ColorIndicator.Image = "rbxassetid://3570695787"
				ColorIndicator.ImageColor3 = default or Color3.fromRGB(255,0,0)
				ColorIndicator.ScaleType = Enum.ScaleType.Slice
				ColorIndicator.SliceCenter = Rect.new(100, 100, 100, 100)
				ColorIndicator.SliceScale = 0.050

				Main.Name = "Colour"
				Main.Parent = MainUIFrame
				Main.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
				Main.BackgroundTransparency = 1.000
				Main.BorderColor3 = Color3.fromRGB(27, 42, 53)
				Main.Position = UDim2.new(1, 10, 0, 0)
				Main.Size = UDim2.new(0, 157, 0, 156)
				Main.Image = "rbxassetid://4608020054"
				Main.ImageColor3 = Color3.fromRGB(22, 22, 22)
				Main.ScaleType = Enum.ScaleType.Slice
				Main.SliceCenter = Rect.new(128, 128, 128, 128)
				Main.SliceScale = 0.03
				Main.Visible = false

				Dark.Name = "Dark"
				Dark.Parent = Main
				Dark.AnchorPoint = Vector2.new(0.5, 0.5)
				Dark.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
				Dark.BackgroundTransparency = 1.000
				Dark.BorderColor3 = Color3.fromRGB(27, 42, 53)
				Dark.Position = UDim2.new(0.5, 0, 0.5, 0)
				Dark.Size = UDim2.new(1, -10, 1, -10)
				Dark.Image = "rbxassetid://4608020054"
				Dark.ImageColor3 = Color3.fromRGB(14, 14, 14)
				Dark.ScaleType = Enum.ScaleType.Slice
				Dark.SliceCenter = Rect.new(128, 128, 128, 128)
				Dark.SliceScale = 0.02

				White.Name = "White"
				White.Parent = Dark
				White.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
				White.BackgroundTransparency = 1.000
				White.BorderColor3 = Color3.fromRGB(27, 42, 53)
				White.Position = UDim2.new(0, 5, 0, 5)
				White.Size = UDim2.new(0, 116, 0, 88)
				White.Image = "rbxassetid://4608020054"
				White.ScaleType = Enum.ScaleType.Slice
				White.SliceCenter = Rect.new(128, 128, 128, 128)
				White.SliceScale = 0.02

				Val.Name = "Val"
				Val.Parent = White
				Val.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
				Val.BackgroundTransparency = 1.000
				Val.BorderColor3 = Color3.fromRGB(27, 42, 53)
				Val.Size = UDim2.new(1, 0, 1, 0)
				Val.Image = "rbxassetid://4608020054"
				Val.ImageColor3 = default or Color3.fromRGB(255,0,0)
				Val.ScaleType = Enum.ScaleType.Slice
				Val.SliceCenter = Rect.new(128, 128, 128, 128)
				Val.SliceScale = 0.02

				Sat.Name = "Sat"
				Sat.Parent = Val
				Sat.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
				Sat.BackgroundTransparency = 1.000
				Sat.BorderColor3 = Color3.fromRGB(27, 42, 53)
				Sat.Size = UDim2.new(1, 0, 1, 0)
				Sat.Image = "rbxassetid://4608020054"
				Sat.ScaleType = Enum.ScaleType.Slice
				Sat.SliceCenter = Rect.new(128, 128, 128, 128)
				Sat.SliceScale = 0.02

				UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)), ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))}
				UIGradient.Rotation = 90
				UIGradient.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0.00, 1.00), NumberSequenceKeypoint.new(1.00, 0.00)}
				UIGradient.Parent = Sat

				UIGradient_2.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0.00, 1.00), NumberSequenceKeypoint.new(1.00, 0.00)}
				UIGradient_2.Parent = Val

				icon.Name = "icon"
				icon.Parent = White
				icon.AnchorPoint = Vector2.new(0.5, 0.5)
				icon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				icon.BackgroundTransparency = 1.000
				icon.Size = UDim2.new(0, 6, 0, 6)
				icon.ZIndex = 4
				icon.Image = "rbxassetid://5052625837"
				icon.ImageColor3 = Color3.fromRGB(130, 130, 130)

				Hue.Name = "Hue"
				Hue.Parent = Dark
				Hue.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
				Hue.BackgroundTransparency = 1.000
				Hue.BorderColor3 = Color3.fromRGB(27, 42, 53)
				Hue.Position = UDim2.new(0, 124, 0, 5)
				Hue.Size = UDim2.new(1, -129, 0, 88)
				Hue.Image = "rbxassetid://4608020054"
				Hue.ScaleType = Enum.ScaleType.Slice
				Hue.SliceCenter = Rect.new(128, 128, 128, 128)
				Hue.SliceScale = 0.02

				UIGradient_3.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)), ColorSequenceKeypoint.new(0.167, Color3.fromRGB(255, 255, 0)), ColorSequenceKeypoint.new(0.333, Color3.fromRGB(0, 255, 0)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)), ColorSequenceKeypoint.new(0.667, Color3.fromRGB(0, 0, 255)), ColorSequenceKeypoint.new(0.833, Color3.fromRGB(255, 0, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))}
				UIGradient_3.Rotation = 90
				UIGradient_3.Parent = Hue

				RBGbox.Name = "RBGbox"
				RBGbox.Parent = Dark
				RBGbox.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
				RBGbox.BackgroundTransparency = 1.000
				RBGbox.BorderColor3 = Color3.fromRGB(27, 42, 53)
				RBGbox.Position = UDim2.new(0, 5, 0, 97)
				RBGbox.Size = UDim2.new(1, -10, 0, 20)
				RBGbox.Image = "rbxassetid://4608020054"
				RBGbox.ImageColor3 = Color3.fromRGB(16, 16, 16)
				RBGbox.ScaleType = Enum.ScaleType.Slice
				RBGbox.SliceCenter = Rect.new(128, 128, 128, 128)
				RBGbox.SliceScale = 0.02

				Holder.Name = "Holder"
				Holder.Parent = RBGbox
				Holder.AnchorPoint = Vector2.new(0.5, 0.5)
				Holder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Holder.BackgroundTransparency = 1.000
				Holder.Position = UDim2.new(0.5, 0, 0.5, 0)
				Holder.Size = UDim2.new(1, -4, 1, -4)

				UIListLayout.Parent = Holder
				UIListLayout.FillDirection = Enum.FillDirection.Horizontal
				UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
				UIListLayout.Padding = UDim.new(0, 2)

				Back_R.Name = "Back_R"
				Back_R.Parent = Holder
				Back_R.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
				Back_R.BackgroundTransparency = 1.000
				Back_R.BorderColor3 = Color3.fromRGB(27, 42, 53)
				Back_R.Position = UDim2.new(0, 5, 0, 97)
				Back_R.Size = UDim2.new(0, 43, 1, 0)
				Back_R.Image = "rbxassetid://4608020054"
				Back_R.ImageColor3 = Color3.fromRGB(22, 22, 22)
				Back_R.ScaleType = Enum.ScaleType.Slice
				Back_R.SliceCenter = Rect.new(128, 128, 128, 128)
				Back_R.SliceScale = 0.02

				R.Name = "R"
				R.Parent = Back_R
				R.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				R.BackgroundTransparency = 1.000
				R.Size = UDim2.new(0, 44, 1, 0)
				R.Font = Enum.Font.GothamSemibold
				R.Text = "R: 255"
				R.TextColor3 = Color3.fromRGB(255, 255, 255)
				R.TextSize = 10.000

				Back_G.Name = "Back"
				Back_G.Parent = Holder
				Back_G.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
				Back_G.BackgroundTransparency = 1.000
				Back_G.BorderColor3 = Color3.fromRGB(27, 42, 53)
				Back_G.Position = UDim2.new(0, 5, 0, 97)
				Back_G.Size = UDim2.new(0, 43, 1, 0)
				Back_G.Image = "rbxassetid://4608020054"
				Back_G.ImageColor3 = Color3.fromRGB(22, 22, 22)
				Back_G.ScaleType = Enum.ScaleType.Slice
				Back_G.SliceCenter = Rect.new(128, 128, 128, 128)
				Back_G.SliceScale = 0.02

				G.Name = "G"
				G.Parent = Back_G
				G.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				G.BackgroundTransparency = 1.000
				G.Size = UDim2.new(0, 44, 1, 0)
				G.Font = Enum.Font.GothamSemibold
				G.Text = "G: 255"
				G.TextColor3 = Color3.fromRGB(255, 255, 255)
				G.TextSize = 10.000

				Back_B.Name = "Back"
				Back_B.Parent = Holder
				Back_B.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
				Back_B.BackgroundTransparency = 1.000
				Back_B.BorderColor3 = Color3.fromRGB(27, 42, 53)
				Back_B.Position = UDim2.new(0, 5, 0, 97)
				Back_B.Size = UDim2.new(0, 43, 1, 0)
				Back_B.Image = "rbxassetid://4608020054"
				Back_B.ImageColor3 = Color3.fromRGB(22, 22, 22)
				Back_B.ScaleType = Enum.ScaleType.Slice
				Back_B.SliceCenter = Rect.new(128, 128, 128, 128)
				Back_B.SliceScale = 0.02

				B.Name = "B"
				B.Parent = Back_B
				B.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				B.BackgroundTransparency = 1.000
				B.Size = UDim2.new(0, 44, 1, 0)
				B.Font = Enum.Font.GothamSemibold
				B.Text = "G: 255"
				B.TextColor3 = Color3.fromRGB(255, 255, 255)
				B.TextSize = 10.000

				Submit.Name = "Submit"
				Submit.Parent = Dark
				Submit.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
				Submit.BackgroundTransparency = 1.000
				Submit.BorderColor3 = Color3.fromRGB(27, 42, 53)
				Submit.Position = UDim2.new(0, 5, 0, 121)
				Submit.Size = UDim2.new(1, -10, 0, 20)
				Submit.Image = "rbxassetid://4608020054"
				Submit.ImageColor3 = Color3.fromRGB(22, 22, 22)
				Submit.ScaleType = Enum.ScaleType.Slice
				Submit.SliceCenter = Rect.new(128, 128, 128, 128)
				Submit.SliceScale = 0.02

				Title_2.Name = "Title"
				Title_2.Parent = Submit
				Title_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Title_2.BackgroundTransparency = 1.000
				Title_2.BorderSizePixel = 0
				Title_2.Position = UDim2.new(0, 5, 0, 0)
				Title_2.Size = UDim2.new(0, 42, 1, 0)
				Title_2.ZIndex = 3
				Title_2.Font = Enum.Font.GothamSemibold
				Title_2.Text = "Submit"
				Title_2.TextColor3 = Color3.fromRGB(255, 255, 255)
				Title_2.TextSize = 10.000
				Title_2.TextXAlignment = Enum.TextXAlignment.Left

				Icon.Name = "Icon"
				Icon.Parent = Submit
				Icon.AnchorPoint = Vector2.new(1, 0.5)
				Icon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Icon.BackgroundTransparency = 1.000
				Icon.Position = UDim2.new(1, -3, 0.5, 0)
				Icon.Size = UDim2.new(0, 14, 0, 14)
				Icon.ZIndex = 6
				Icon.Image = "rbxassetid://6267058610"

				local Satdown = false
				local Huedown = false

				local OldHue = 1
				local OldSat = 1
				local OldVal = 1

				if default then 
					local h, s, v = default:ToHSV()

					OldHue, OldSat, OldVal = h, s, v 
				end

				local function UpdColour(NewHue, NewSat, NewVal)
					OldHue = NewHue or OldHue
					OldSat = NewSat or OldSat
					OldVal = NewVal or OldVal
					return Color3.fromHSV(OldHue, OldSat, OldVal)
				end

				White.MouseButton1Down:Connect(function()
					Satdown = true
				end)

				Hue.MouseButton1Down:Connect(function()
					Huedown = true
				end)

				UserInputService.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						Satdown = false;
						Huedown = false;
					end;
				end);

				Mouse.Move:Connect(function()
					if Satdown then
						local AbsPos = White.AbsolutePosition
						local AbsSize = White.AbsoluteSize

						local SizeX = AbsSize.X
						local SizeY = AbsSize.Y

						local RelX = math.clamp(Mouse.X - AbsPos.X, 0, SizeX) / SizeX
						local RelY = math.clamp(Mouse.Y - AbsPos.Y, 0, SizeY) / SizeY

						ColorIndicator.ImageColor3 = UpdColour(nil, RelX, 1 - RelY)
						
						R.Text = "R: "..math.floor(ColorIndicator.ImageColor3.R * 255)
						G.Text = "G: "..math.floor(ColorIndicator.ImageColor3.G * 255)
						B.Text = "B: "..math.floor(ColorIndicator.ImageColor3.B * 255)
					end
					
					if Huedown then
						local PosY = Hue.AbsolutePosition.Y
						local SizeY = Hue.AbsoluteSize.Y
						local RelY = math.clamp(Mouse.Y - PosY, 0, SizeY) / SizeY

						Val.ImageColor3 = Color3.fromHSV(RelY, 1, 1)
						ColorIndicator.ImageColor3 = UpdColour(RelY)
						
						R.Text = "R: "..math.floor(ColorIndicator.ImageColor3.R * 255)
						G.Text = "G: "..math.floor(ColorIndicator.ImageColor3.G * 255)
						B.Text = "B: "..math.floor(ColorIndicator.ImageColor3.B * 255)
					end
				end)

				local OldRText, OldGText, OldBText = R.Text, G.Text, B.Text

				R.FocusLost:connect(function()
					if not tonumber(R.Text) then 
						R.Text = OldRText 
						return
					end 

					R.Text = "R: "..tostring(math.floor(tonumber(R.Text)))
					OldRText = R.Text
					ColorIndicator.ImageColor3 = Color3.fromRGB(math.floor(tonumber(R.Text:sub(4))), math.floor(tonumber(G.Text:sub(4))), math.floor(tonumber(B.Text:sub(4))))
				end)

				G.FocusLost:connect(function()
					if not tonumber(G.Text) then 
						G.Text = OldGText 
						return
					end 

					G.Text = "G: "..tostring(math.floor(tonumber(G.Text)))
					OldRText = G.Text
					ColorIndicator.ImageColor3 = Color3.fromRGB(math.floor(tonumber(R.Text:sub(4))), math.floor(tonumber(G.Text:sub(4))), math.floor(tonumber(B.Text:sub(4))))
				end)

				B.FocusLost:connect(function()
					if not tonumber(B.Text) then 
						B.Text = OldBText 
						return
					end 

					B.Text = "B: "..tostring(math.floor(tonumber(B.Text)))
					OldRText = B.Text
					ColorIndicator.ImageColor3 = Color3.fromRGB(math.floor(tonumber(R.Text:sub(4))), math.floor(tonumber(G.Text:sub(4))), math.floor(tonumber(B.Text:sub(4))))
				end)
				
				Submit.MouseButton1Click:Connect(function()
					Main.Visible = false

					if callback then
						callback(ColorIndicator.ImageColor3)
					end
				end)

				ColorButton.MouseButton1Click:Connect(function()
					Main.Visible = not Main.Visible
				end)
			end
			function section:Keybind(name, default, callback)
				local setting = GetSetting(name) 
				setting = setting and setting:split(".")[3]
				default = setting or default 

				sectionSize = sectionSize + 39
				tabSize = tabSize + 39
				ResizeTab()
				ResizeSection()

				local OldCallback = callback or function() end
				callback = function(Value)
					library.flags[name] = Value
					AddSetting(name, tostring(Value))
                    return OldCallback(Value)
				end

				local KeybindButton = Instance.new("TextButton")
				local KeybindTitle = Instance.new("TextLabel")
				local KeybindValueback = Instance.new("ImageLabel")
				local KeybindValue = Instance.new("TextLabel")
				KeybindButton.Name = "KeybindButton"
				KeybindButton.Parent = SectionFrame
				KeybindButton.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
				KeybindButton.BorderSizePixel = 0
				KeybindButton.ClipsDescendants = true
				KeybindButton.Size = UDim2.new(0, 390, 0, 31)
				KeybindButton.AutoButtonColor = false
				KeybindButton.Font = Enum.Font.SourceSans
				KeybindButton.Text = ""
				KeybindButton.TextColor3 = Color3.fromRGB(0, 0, 0)
				KeybindButton.TextSize = 14.000
				KeybindTitle.Name = "KeybindTitle"
				KeybindTitle.Parent = KeybindButton
				KeybindTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				KeybindTitle.BackgroundTransparency = 1.000
				KeybindTitle.Position = UDim2.new(0.0147783253, 0, 0, 0)
				KeybindTitle.Size = UDim2.new(0, 400, 0, 31)
				KeybindTitle.Font = Enum.Font.GothamSemibold
				KeybindTitle.Text = name
				KeybindTitle.TextColor3 = Color3.fromRGB(233, 233, 233)
				KeybindTitle.TextSize = 13.000
				KeybindTitle.TextXAlignment = Enum.TextXAlignment.Left
				KeybindValueback.Name = "KeybindValueback"
				KeybindValueback.Parent = KeybindButton
				KeybindValueback.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				KeybindValueback.BackgroundTransparency = 1.000
				KeybindValueback.Position = UDim2.new(0.862068951, 0, 0.109090909, 0)
				KeybindValueback.Size = UDim2.new(0, 50, 0, 25)
				KeybindValueback.Image = "rbxassetid://3570695787"
				KeybindValueback.ImageColor3 = Color3.fromRGB(14, 14, 14)
				KeybindValueback.ScaleType = Enum.ScaleType.Slice
				KeybindValueback.SliceCenter = Rect.new(100, 100, 100, 100)
				KeybindValueback.SliceScale = 0.050
				KeybindValue.Name = "KeybindValue"
				KeybindValue.Parent = KeybindValueback
				KeybindValue.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				KeybindValue.BackgroundTransparency = 1.000
				KeybindValue.Size = UDim2.new(0, 50, 0, 25)
				KeybindValue.Font = Enum.Font.GothamSemibold
				KeybindValue.Text = default or ". . ."
				KeybindValue.TextColor3 = Color3.fromRGB(233, 233, 233)
				KeybindValue.TextSize = 13.000
				
				local pressConnection

				KeybindButton.MouseButton1Click:Connect(function()
					if pressConnection then
						pressConnection:Disconnect()
					end
					KeybindValue.Text = ". . ."
					pressConnection = UserInputService.InputBegan:Connect(function(input)
						pressConnection:Disconnect()
						KeybindValue.Text = string.split(tostring(input.KeyCode), ".")[3]
						if callback then
							callback(input.KeyCode)
						end
					end)
				end)
			end
			function section:SearchBox(name, options, default, callback, dontsave)
				default = GetSetting(name) or default 

				sectionSize = sectionSize + 39
				tabSize = tabSize + 39
				ResizeTab()
				ResizeSection()
                local OldCallback = callback or function() end
				callback = function(Value)
					library.flags[name] = Value
                    if dontsave ~= true then
					    AddSetting(name, tostring(Value))
                    end
                    return OldCallback(Value)
				end
				local TextBoxMain = Instance.new("Frame")
				local TextBoxTitle = Instance.new("TextLabel")
				local TextBox = Instance.new("TextBox")
				--local TextBox_Roundify_5px = Instance.new("ImageLabel")
				TextBoxMain.Name = "TextBoxMain"
				TextBoxMain.Parent = SectionFrame
				TextBoxMain.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
				TextBoxMain.BorderColor3 = Color3.fromRGB(27, 42, 53)
				TextBoxMain.BorderSizePixel = 0
				TextBoxMain.Position = UDim2.new(0.018779343, 0, 0.615176141, 0)
				TextBoxMain.Size = UDim2.new(0, 390, 0, 31)
				TextBoxTitle.Name = "TextBoxTitle"
				TextBoxTitle.Parent = TextBoxMain
				TextBoxTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				TextBoxTitle.BackgroundTransparency = 1.000
				TextBoxTitle.Position = UDim2.new(0.0147783253, 0, 0, 0)
				TextBoxTitle.Size = UDim2.new(0, 400, 0, 31)
				TextBoxTitle.Font = Enum.Font.GothamSemibold
				TextBoxTitle.Text = name
				TextBoxTitle.TextColor3 = Color3.fromRGB(233, 233, 233)
				TextBoxTitle.TextSize = 13.000
				TextBoxTitle.TextXAlignment = Enum.TextXAlignment.Left
				TextBox.Parent = TextBoxMain
				TextBox.BackgroundColor3 = Color3.fromRGB(13, 13, 13)
				TextBox.BackgroundTransparency = 0
				TextBox.BorderSizePixel = 0
				TextBox.Position = UDim2.new(0.270329684, 0, 0.193548381, 0)
				TextBox.Size = UDim2.new(0, 284, 0, 18)
				TextBox.ZIndex = 2
				TextBox.Font = Enum.Font.GothamSemibold
				TextBox.PlaceholderColor3 = Color3.fromRGB(66, 66, 66)
				TextBox.PlaceholderText = default or name
				TextBox.Text = default or ""
				TextBox.TextColor3 = Color3.fromRGB(233, 233, 233)
				TextBox.TextSize = 13.000
				local SearchBoxBack = Instance.new("ImageLabel")
				local ScrollingFrame = Instance.new("ScrollingFrame")
				local UIListLayout = Instance.new("UIListLayout")
				local Title = Instance.new("TextLabel")
				local Frame = Instance.new("Frame")
				SearchBoxBack.Name = "SearchBoxBack"
				SearchBoxBack.Parent = MainUITabPickedHolder
				SearchBoxBack.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				SearchBoxBack.BackgroundTransparency = 1.000
				SearchBoxBack.Position = UDim2.new(0, 0, 0, 0)
				SearchBoxBack.Size = UDim2.new(0, 210, 0, 36)
				SearchBoxBack.Image = "rbxassetid://3570695787"
				SearchBoxBack.ImageColor3 = Color3.fromRGB(22, 22, 22)
				SearchBoxBack.ImageTransparency = 1
				SearchBoxBack.ScaleType = Enum.ScaleType.Slice
				SearchBoxBack.SliceCenter = Rect.new(100, 100, 100, 100)
				SearchBoxBack.SliceScale = 0.050
				SearchBoxBack.Visible = false
				SearchBoxBack.ZIndex = -4
				ScrollingFrame.Parent = SearchBoxBack
				ScrollingFrame.Active = true
				ScrollingFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				ScrollingFrame.BackgroundTransparency = 1.000
				ScrollingFrame.BorderSizePixel = 0
				ScrollingFrame.Position = UDim2.new(0, 0, 0, 31)
				ScrollingFrame.Size = UDim2.new(0, 210, 1, -32)
				ScrollingFrame.BottomImage = ""
				ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
				ScrollingFrame.ScrollBarThickness = 2
				ScrollingFrame.TopImage = ""
				ScrollingFrame.ZIndex = -4
				UIListLayout.Parent = ScrollingFrame
				UIListLayout.SortOrder = Enum.SortOrder.Name
				Title.Name = "Title"
				Title.Parent = SearchBoxBack
				Title.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
				Title.BackgroundTransparency = 0
				Title.Size = UDim2.new(0, 210, 0, 31)
				Title.Font = Enum.Font.GothamSemibold
				Title.Text = name
				Title.BorderSizePixel = 0
				Title.TextColor3 = Color3.fromRGB(233, 233, 233)
				Title.TextSize = 13.000
				Title.ZIndex = -4
				Frame.Parent = SearchBoxBack
				Frame.BackgroundColor3 = Color3.fromRGB(84, 116, 224)
				Frame.BorderSizePixel = 0
				Frame.Position = UDim2.new(0, 0, 0, 31)
				Frame.Size = UDim2.new(0, 210, 0, 1)
				Frame.ZIndex = -4
				local buttons = {}
				local isDone = false
				local function updateVisibles()
					local si = 33
					for i, v in next, buttons do
						if v.Visible == true then
							si = si + 30
						end
					end
					if si >= 183 then
						ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, si - 33)
						SearchBoxBack.Size = UDim2.new(0, 210, 0, 183)
					else
						ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
						SearchBoxBack.Size = UDim2.new(0, 210, 0, si)
					end
				end

				local function searchboxon()
					if isDone == false then
						if SearchBoxBack.Position == UDim2.new(0, 0, 0, 0) then
							SearchBoxBack.Visible = true
							tweenObject(SearchBoxBack, {
								Position = UDim2.new(1.05, 0, 0, 0)
							}, 0.4)
						end
						if #buttons == 0 then
							for i, v in next, options do
								local TextButton = Instance.new("TextButton")
								TextButton.Parent = ScrollingFrame
								TextButton.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
								TextButton.BorderSizePixel = 0
								TextButton.AutoButtonColor = false
								TextButton.Position = UDim2.new(-0.0153846154, 0, 0, 0)
								TextButton.Size = UDim2.new(0, 215, 0, 30)
								TextButton.Font = Enum.Font.GothamSemibold
								TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
								TextButton.TextSize = 14.000
								TextButton.Text = v
								TextButton.ZIndex = -4
								TextButton.Visible = false
								table.insert(buttons, TextButton)
								TextButton.MouseEnter:Connect(function()
									tweenObject(TextButton, {
										BackgroundColor3 = Color3.fromRGB(77, 77, 77)
									}, 0.2)
								end)
								TextButton.MouseLeave:Connect(function()
									tweenObject(TextButton, {
										BackgroundColor3 = Color3.fromRGB(22, 22, 22)
									}, 0.2)
								end)
								TextButton.MouseButton1Click:Connect(function()
									isDone = true
									TextBox.Text = v
									if callback then
										callback(v)
									end
									local tw = tweenObject(SearchBoxBack, {
										Position = UDim2.new(0, 0, 0, 0)
									}, 0.4)
									tw.Completed:wait()
									SearchBoxBack.Visible = false
									for i, v in next, buttons do
										v:Destroy()
										buttons[i] = nil
									end
									isDone = false
								end)
							end
						end
						updateVisibles()
						for i, v in pairs(buttons) do
							if string.sub(string.lower(v.Text), 1, string.len(TextBox.Text)) == string.lower(TextBox.Text) then
								if v.Visible == false then
									spawn(function()
										v.Visible = true
										updateVisibles()
										tweenObject(v, {
											TextTransparency = 0
										}, 0.2)
										tweenObject(v, {
											BackgroundTransparency = 0
										}, 0.2)
									end)
								end
							else
								if v.Visible == true then
									spawn(function()
										local tw = tweenObject(v, {
											TextTransparency = 1
										}, 0.2)
										tweenObject(v, {
											BackgroundTransparency = 0
										}, 0.2)
										tw.Completed:wait(0.1)
										v.Visible = false
										updateVisibles()
									end)
								end
							end
						end
					end
				end

				if default then 
					for i, v in next, options do 
						if v == default then 
							TextBox.Text = v 
							if callback then 
								callback(v)
							end
						end 
					end
				end

				TextBox.Focused:Connect(searchboxon)
				TextBox.FocusLost:Connect(function()
					wait(0.5)
					isDone = true
					local tw = tweenObject(SearchBoxBack, {
						Position = UDim2.new(0, 0, 0, 0)
					}, 0.4)
					tw.Completed:wait()
					SearchBoxBack.Visible = false
					for i, v in next, buttons do
						v:Destroy()
						buttons[i] = nil
					end
					isDone = false
				end)
				TextBox:GetPropertyChangedSignal("Text"):Connect(searchboxon)

				local searchbox = {}
				function searchbox:Update(val)
					if table.find(options, val) then 
						TextBox.Text = val
					end
				end
				return searchbox
			end
			return section
		end
		return tab
	end
	return window
end

return library
