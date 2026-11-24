local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/Library.lua"))()

local Window = Library:CreateWindow({
    Title = "T9ou Hub",
    Footer = "Araenal",
    Icon = "eclipse",
    NotifySide = "Right",
})

Library:Notify("Script Loaded: Arsenal", 3)
--================================
-- Aimbot
--================================
do
local Aimbot = Window:AddTab({
    Name = "Aimbot",
    Description = "Targeting & Aim Assistance",
    Icon = "crosshair",
    Tooltip = false,
})

    local AimbotSetting = Aimbot:AddGroupbox({
        Side = "Left",
        Name = "Aimbot Setting",
    })

        local EnableAimbot = AimbotSetting:AddToggle("Enable Aimbot", {
            Text = "Enable Aimbot",
            Default = false,
        })
    
        local AimbotKeybind = EnableAimbot:AddKeyPicker("Enable Aimbot", {
            Text = "Aimbot Keybind",
            Default = "F",
            Mode = "Toggle",
        })
    
        local TargetPart = AimbotSetting:AddDropdown("MyDropdown", {
            Text = "Target Part:",
            Values = { "Head", "Torso", "HumanoidRootPart"},
            Default = 1,
            Multi = false,
        })
    
        local AimbotSmoothing = AimbotSetting:AddSlider("Sensitivity", {
            Text = "Aimbot Smoothing",
            Default = 1,
            Min = 0,
            Max = 100,
            Rounding = 0,
        })
    
        local AimbotPrediction = AimbotSetting:AddSlider("Sensitivity", {
            Text = "Aimbot Prediction",
            Default = 1,
            Min = 0,
            Max = 100,
            Rounding = 0,
        })

    local AimbotFOV = Aimbot:AddGroupbox({
        Side = "Right",
        Name = "Aimbot FOV",
    })
end
--================================
--Silent Aim
--================================
do
local SilentAim = Window:AddTab({
    Name = "Silent Aim",
    Description = "Undetected Targeting Features",
    Icon = "scan",
    Tooltip = false,
})

end
--================================
--Weapon
--================================
do
local Weapon = Window:AddTab({
    Name = "Weapon",
    Description = "Weapon Features",
    Icon = "target",
    Tooltip = false,
})

end
--================================
-- Visual
--================================
do
local Visual = Window:AddTab({
    Name = "Visual",
    Description = "ESP & Visual Enhancements",
    Icon = "eye",
    Tooltip = false,
})

end
--================================
-- Player
--================================
do
    local LPlayer = Window:AddTab({
        Name = "Player",
        Description = "Player Movement & Utilities",
        Icon = "user",
        Tooltip = false,
    })

end