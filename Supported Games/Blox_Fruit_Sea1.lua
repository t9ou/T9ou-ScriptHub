if isfile("T9ou_Configs/autosave.json") then
    delfile("T9ou_Configs/autosave.json")
end
if isfile("T9ou_Configs/.last") then
    delfile("T9ou_Configs/.last")
end

local T9ou = loadstring(game:HttpGet("https://raw.githubusercontent.com/t9ou/T9ou-ScriptHub/main/T9ou_ui.lua"))()

T9ou:CreateWindow({
    Title = "T9ou hub",
    Icon = "flame"
})

T9ou:SetFooter("Blox Fruit Sea 1")
T9ou:Notify("Loaded", "Blox Fruit🌊 script loaded!")

local Farm = T9ou:Tab("Farm", "zap")
    local AutoGroup = T9ou:GroupBox(Farm, {
    Name = "Auto Farm",
    Icon = "folder",
    DefaultOpen = true,
    Side = "left" 
    })

    local MasteryGroup = T9ou:GroupBox(Farm, {
    Name = "Mastery Farm",
    Icon = "folder",
    DefaultOpen = true,
    Side = "right" 
    })

    local BossGroup = T9ou:GroupBox(Farm, {
    Name = "Boss Farm",
    Icon = "folder",
    DefaultOpen = true,
    Side = "left" 
    })

    local MoneyGroup = T9ou:GroupBox(Farm, {
    Name = "Money Farm",
    Icon = "folder",
    DefaultOpen = true,
    Side = "right" 
    })


local Combat = T9ou:Tab("Combat", "swords")

local World = T9ou:Tab("World", "earth")

local Player = T9ou:Tab("Player", "user-round")

local Fruits = T9ou:Tab("Fruits", "apple")

local Visuals = T9ou:Tab("Visuals", "eye")

local Misc = T9ou:Tab("Misc", "grid-3x3")

local Settings = T9ou:Tab("Settings", "settings")