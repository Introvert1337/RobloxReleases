local library = loadstring(game:HttpGet('http://spooderquest.com/VenyxUI.lua', true))()

local LocalPlayer = game:GetService("Players").LocalPlayer

local Main = library.new("Epic Space", 5013109572)

local themes = {
    Background = Color3.fromRGB(24, 24, 24),
    Glow = Color3.fromRGB(0, 0, 0),
    Accent = Color3.fromRGB(10, 10, 10),
    LightContrast = Color3.fromRGB(20, 20, 20),
    DarkContrast = Color3.fromRGB(14, 14, 14),
    TextColor = Color3.fromRGB(255, 255, 255)
}

local AutoTab = Main:addPage("Autoplay", 5012544693)

local OtherTab = Main:addPage("Other", 5012544693)

local theme = Main:addPage("Theme", 5012544693)

local auto = AutoTab:addSection("Cheats")

local other = OtherTab:addSection("Cheats")

local colors = theme:addSection("Colors")

local autoplay = false

local autorestart = false

local songspeed = 1

local trail = false

local RainbowCursor = false

local smoothness = 25

local miss = 0

auto:addToggle("Autoplayer", nil, function(bool)
    autoplay = bool
end)

auto:addSlider("Roughness", 25, 10, 50, function(value)
    smoothness = value
end)

auto:addSlider("Miss Chance", 0, 0, 100, function(value)
    miss = value
end)

auto:addToggle("Autofarm", nil, function(bool)
    autorestart = bool
end)

other:addSlider("Song Speed", 1, 1, 5, function(value)
    songspeed = value
end)

other:addToggle("Rainbow Cursor", nil, function(bool)
    RainbowCursor = bool
    if not RainbowCursor then 
        LocalPlayer.PlayerGui.CursorGui.ImageLabel.ImageColor3 = Color3.fromRGB(255, 255, 255)
        LocalPlayer.PlayerGui.CursorGui.ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    end
end)

other:addToggle("Cursor Trail", nil, function(bool)
    trail = bool
end)

other:addToggle("NoFail", nil, function(bool)
    game:GetService('Players').LocalPlayer.MapData.Mods.NoFail.Value = bool
end)

for theme, color in next, themes do 
    colors:addColorPicker(theme, color, function(color3)
        Main:setTheme(theme, color3)
    end)
end

local hook
hook = hookfunction(getfenv(getsenv(LocalPlayer.PlayerScripts["3DGuiScript"]).OnClickPageShop)._G.ShowGui, function(...)
    if autorestart then
        wait(1)
        getfenv(getsenv(LocalPlayer.PlayerScripts["3DGuiScript"]).OnClickPageShop).TryReplayLast()
    end
    return hook(...)
end)

game:GetService("RunService").RenderStepped:Connect(function()
    if autoplay then
        local randomizer = math.random(1, 100)
        local dist = math.huge
        if randomizer > miss then
            for i,v in next, workspace:GetDescendants() do
                if v:IsA("Part") and tonumber(v.Name) and (v.Position - workspace.CurrentCamera.CFrame.p).magnitude < dist then
                    dist = (v.Position - workspace.CurrentCamera.CFrame.p).magnitude
                    game:GetService("TweenService"):Create(workspace.CurrentCamera, TweenInfo.new(dist / (smoothness * 10), Enum.EasingStyle.Linear), {CFrame = CFrame.new(workspace.CurrentCamera.CFrame.p, Vector3.new(0, v.Position.Y, v.Position.Z))}):Play()
                end
            end
        end
    end
    if RainbowCursor then
        local hue = tick() % 5 / 5
        local color = Color3.fromHSV(hue, 1, 1)
        LocalPlayer.PlayerGui.CursorGui.ImageLabel.ImageColor3 = color
        LocalPlayer.PlayerGui.CursorGui.ImageLabel.BackgroundColor3 = color
    end
    getfenv(require(game:GetService("ReplicatedFirst").GameScript).CursorTrail)._G.PlayerData.Settings.CursorTrail = trail
    game:GetService("ReplicatedFirst").GameScript.Music.PlaybackSpeed = songspeed
end)

wait(1)

Main:SelectPage(Main.pages[1], true)
