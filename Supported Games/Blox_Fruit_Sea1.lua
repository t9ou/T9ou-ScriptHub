local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/Library.lua"))()

local Window = Library:CreateWindow({
    Title = "T9ou Hub",
    Footer = "Araenal",
    Icon = false,
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