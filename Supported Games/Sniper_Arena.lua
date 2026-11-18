local T9ou = loadstring(game:HttpGet("https://raw.githubusercontent.com/t9ou/T9ou-ScriptHub/main/T9ou_ui.lua"))()

T9ou:CreateWindow({
    Title = "T9ou hub",
    Icon = "flame"
})

T9ou:SetFooter("Sniper Arena")

T9ou:Notify("Loaded", "Sniper Arena script loaded!")

local Aimbot = T9ou:Tab("Aimbot", "crosshair")
    T9ou:Toggle(Aimbot, {
    Name = "Toggle Aimbot",
    Flag = "AimbotTrue",
    Default = false,
    Icon = "box",
    Callback = function(v) end
    })

local SilentAim = T9ou:Tab("Silent Aim", "target")

local Weapon = T9ou:Tab("Weapon", "swords")

local Visual = T9ou:Tab("Visual", "eye")

local SkinChanger = T9ou:Tab("Skin Changer", "palette")

local Misc = T9ou:Tab("Misc", "settings")
