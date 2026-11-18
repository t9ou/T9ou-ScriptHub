local T9ou = loadstring(game:HttpGet("https://raw.githubusercontent.com/t9ou/T9ou-ScriptHub/main/T9ou_ui.lua"))()

T9ou:CreateWindow({
    Title = "T9ou hub",
    Icon = "flame"
})

T9ou:SetFooter("Sniper Arena")

T9ou:Notify("Loaded", "Sniper Arena script loaded!")

local Aimbot = T9ou:Tab("Aimbot", "icon")

local SilentAim = T9ou:Tab("Silent Aim", "icon")

local Weapon = T9ou:Tab("Weapon", "icon")

local Visual = T9ou:Tab("Visual", "icon")

local SkinChanger = T9ou:Tab("Skin Changer", "icon")

local Misc = T9ou:Tab("Misc", "icon")
