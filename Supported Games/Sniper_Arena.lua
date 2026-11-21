local T9ou = loadstring(game:HttpGet("https://raw.githubusercontent.com/t9ou/T9ou-ScriptHub/main/T9ou_ui.lua"))()
local ESP = getgenv().ESP

T9ou:CreateWindow({
    Title = "T9ou hub",
    Icon = "flame"
})

T9ou:SetFooter("Sniper Arena")
T9ou:Notify("Loaded", "Sniper Arena script loaded!")

-- Aimbot
local Aimbot = T9ou:Tab("Aimbot", "crosshair")

T9ou:Toggle(Aimbot, {
    Name = "Enable Aimbot",
    Flag = "AimbotEnabled",
    Default = false,
    Icon = "crosshair",
    Callback = function(v) end
})

T9ou:Toggle(Aimbot, {
    Name = "Smooth",
    Flag = "AimbotSmooth",
    Default = true,
    Icon = "box",
    Callback = function(v) end
})

T9ou:Slider(Aimbot, {
    Name = "Smoothness",
    Flag = "AimbotSmoothness",
    Min = 1,
    Max = 20,
    Default = 8,
    Icon = "sliders",
    Callback = function(v) end
})

T9ou:Toggle(Aimbot, {
    Name = "Team Check",
    Flag = "AimbotTeamCheck",
    Default = true,
    Icon = "users",
    Callback = function(v) end
})

T9ou:Toggle(Aimbot, {
    Name = "Visible Check",
    Flag = "AimbotVisibleCheck",
    Default = true,
    Icon = "eye",
    Callback = function(v) end
})

T9ou:Dropdown(Aimbot, {
    Name = "Target Part",
    Flag = "AimbotPart",
    Options = {"Head", "UpperTorso", "HumanoidRootPart"},
    Default = "Head",
    Icon = "target",
    Callback = function(v) end
})

T9ou:Keybind(Aimbot, {
    Name = "Aimbot Key",
    Flag = "AimbotKey",
    Default = Enum.KeyCode.E,
    Icon = "keyboard",
    Callback = function(k) end
})

T9ou:Toggle(Aimbot, {
    Name = "Show FOV",
    Flag = "AimbotFOV",
    Default = false,
    Icon = "circle",
    Callback = function(v) end
})

T9ou:Slider(Aimbot, {
    Name = "FOV Size",
    Flag = "AimbotFOVSize",
    Min = 20,
    Max = 400,
    Default = 120,
    Icon = "sliders",
    Callback = function(v) end
})

-- Silent Aim
local SilentAim = T9ou:Tab("Silent Aim", "target")

T9ou:Toggle(SilentAim, {
    Name = "Enable Silent Aim",
    Flag = "SilentEnabled",
    Default = false,
    Icon = "target",
    Callback = function(v) end
})

T9ou:Slider(SilentAim, {
    Name = "Hit Chance",
    Flag = "SilentHitChance",
    Min = 1,
    Max = 100,
    Default = 100,
    Icon = "percent",
    Callback = function(v) end
})

T9ou:Toggle(SilentAim, {
    Name = "Prediction",
    Flag = "SilentPrediction",
    Default = false,
    Icon = "activity",
    Callback = function(v) end
})

T9ou:Toggle(SilentAim, {
    Name = "Team Check",
    Flag = "SilentTeamCheck",
    Default = true,
    Icon = "users",
    Callback = function(v) end
})

T9ou:Toggle(SilentAim, {
    Name = "Visible Check",
    Flag = "SilentVisibleCheck",
    Default = true,
    Icon = "eye",
    Callback = function(v) end
})

T9ou:Dropdown(SilentAim, {
    Name = "Target Part",
    Flag = "SilentPart",
    Options = {"Head", "UpperTorso", "HumanoidRootPart"},
    Default = "Head",
    Icon = "target",
    Callback = function(v) end
})

T9ou:Toggle(SilentAim, {
    Name = "Show FOV",
    Flag = "SilentFOV",
    Default = false,
    Icon = "circle",
    Callback = function(v) end
})

T9ou:Slider(SilentAim, {
    Name = "FOV Size",
    Flag = "SilentFOVSize",
    Min = 20,
    Max = 400,
    Default = 150,
    Icon = "sliders",
    Callback = function(v) end
})

-- Weapon
local Weapon = T9ou:Tab("Weapon", "swords")

T9ou:Toggle(Weapon, {
    Name = "No Recoil",
    Flag = "NoRecoil",
    Default = false,
    Icon = "crosshair",
    Callback = function(v) end
})

T9ou:Toggle(Weapon, {
    Name = "No Spread",
    Flag = "NoSpread",
    Default = false,
    Icon = "target",
    Callback = function(v) end
})

T9ou:Toggle(Weapon, {
    Name = "Infinite Ammo",
    Flag = "InfAmmo",
    Default = false,
    Icon = "box",
    Callback = function(v) end
})

T9ou:Toggle(Weapon, {
    Name = "Rapid Fire",
    Flag = "RapidFire",
    Default = false,
    Icon = "zap",
    Callback = function(v) end
})

T9ou:Slider(Weapon, {
    Name = "Damage Multiplier",
    Flag = "DamageMult",
    Min = 1,
    Max = 10,
    Default = 1,
    Icon = "sliders",
    Callback = function(v) end
})

-- Visual
local Visual = T9ou:Tab("Visual", "eye")

T9ou:Toggle(Visual, {
    Name = "Enable ESP",
    Flag = "ESPEnabled",
    Default = false,
    Icon = "eye",
    Callback = function(v)
        if v then ESP:start() else ESP:stop() end
    end
})

T9ou:Toggle(Visual, {
    Name = "Box",
    Flag = "ESP_Box",
    Default = true,
    Icon = "square",
    Callback = function(v) end
})

T9ou:Toggle(Visual, {
    Name = "Name",
    Flag = "ESP_Name",
    Default = true,
    Icon = "type",
    Callback = function(v) end
})

T9ou:Toggle(Visual, {
    Name = "Health Bar",
    Flag = "ESP_Health",
    Default = true,
    Icon = "heart",
    Callback = function(v) end
})

T9ou:Toggle(Visual, {
    Name = "Distance",
    Flag = "ESP_Distance_Text",
    Default = true,
    Icon = "ruler",
    Callback = function(v) end
})

T9ou:Toggle(Visual, {
    Name = "Skeleton",
    Flag = "ESP_Skeleton",
    Default = false,
    Icon = "bone",
    Callback = function(v) end
})

T9ou:Toggle(Visual, {
    Name = "Tracer",
    Flag = "ESP_Tracer",
    Default = false,
    Icon = "minus",
    Callback = function(v) end
})

T9ou:Toggle(Visual, {
    Name = "Team Check",
    Flag = "ESP_TeamCheck",
    Default = true,
    Icon = "users",
    Callback = function(v) end
})

T9ou:ColorPicker(Visual, {
    Name = "ESP Color",
    Flag = "ESP_Color",
    Default = Color3.fromRGB(255, 85, 120),
    Icon = "palette",
    Callback = function(c) end
})

T9ou:Slider(Visual, {
    Name = "Max Distance",
    Flag = "ESP_Distance",
    Min = 100,
    Max = 3000,
    Default = 1500,
    Icon = "sliders",
    Callback = function(v) end
})

-- Skin Changer
local SkinChanger = T9ou:Tab("Skin Changer", "palette")

T9ou:Dropdown(SkinChanger, {
    Name = "Skin",
    Flag = "SelectedSkin",
    Options = {"Default", "Gold", "Diamond", "Galaxy", "Neon"},
    Default = "Default",
    Icon = "palette",
    Callback = function(v) end
})

T9ou:Button(SkinChanger, {
    Name = "Apply Skin",
    Icon = "check",
    Callback = function() end
})

-- Misc
local Misc = T9ou:Tab("Misc", "settings")

T9ou:Slider(Misc, {
    Name = "WalkSpeed",
    Flag = "WalkSpeed",
    Min = 16,
    Max = 150,
    Default = 16,
    Icon = "person-standing",
    Callback = function(v)
    end
})

T9ou:Slider(Misc, {
    Name = "JumpPower",
    Flag = "JumpPower",
    Min = 50,
    Max = 200,
    Default = 50,
    Icon = "arrow-up",
    Callback = function(v)
    end
})

T9ou:Toggle(Misc, {
    Name = "Fly",
    Flag = "Fly",
    Default = false,
    Icon = "plane",
    Callback = function(v) end
})

T9ou:Toggle(Misc, {
    Name = "Noclip",
    Flag = "Noclip",
    Default = false,
    Icon = "ghost",
    Callback = function(v) end
})

T9ou:Toggle(Misc, {
    Name = "Infinite Jump",
    Flag = "InfJump",
    Default = false,
    Icon = "arrow-up-circle",
    Callback = function(v) end
})