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
    Icon = "zap",
    DefaultOpen = true,
    Side = "Left" 
    })

    local MasteryGroup = T9ou:GroupBox(Farm, {
    Name = "Mastery Farm",
    Icon = "target",
    DefaultOpen = true,
    Side = "Right" 
    })

    local BossGroup = T9ou:GroupBox(Farm, {
    Name = "Boss Farm",
    Icon = "skull",
    DefaultOpen = true,
    Side = "Left" 
    })

    local MoneyGroup = T9ou:GroupBox(Farm, {
    Name = "Money Farm",
    Icon = "coins",
    DefaultOpen = true,
    Side = "Right" 
    })


local Combat = T9ou:Tab("Combat", "swords")
    local AimGroup = T9ou:GroupBox(Combat, {
    Name = "Auto Aim",
    Icon = "crosshair",
    DefaultOpen = true,
    Side = "Left" 
    })

    local FovGroup = T9ou:GroupBox(Combat, {
    Name = "FOV Settings",
    Icon = "scan",
    DefaultOpen = true,
    Side = "Right" 
    })

    local HitboxGroup = T9ou:GroupBox(Combat, {
    Name = "Hitbox",
    Icon = "maximize",
    DefaultOpen = true,
    Side = "Full" 
    })

local World = T9ou:Tab("World", "earth")
    local IslandGroup = T9ou:GroupBox(World, {
    Name = "Island Teleport",
    Icon = "map",
    DefaultOpen = true,
    Side = "Left" 
    })

    local NPCGroup = T9ou:GroupBox(World, {
    Name = "NPC Teleport",
    Icon = "users",
    DefaultOpen = true,
    Side = "Right" 
    })

    local BossGroup = T9ou:GroupBox(World, {
    Name = "Boss Teleport",
    Icon = "skull",
    DefaultOpen = true,
    Side = "Left" 
    })

    local ShopGroup = T9ou:GroupBox(World, {
    Name = "Shop Teleport",
    Icon = "shopping-bag",
    DefaultOpen = true,
    Side = "Right" 
    })

    local TrainerGroup = T9ou:GroupBox(World, {
    Name = "Trainer Teleport",
    Icon = "graduation-cap",
    DefaultOpen = true,
    Side = "Full" 
    })

local Player = T9ou:Tab("Player", "user-round")

local Fruits = T9ou:Tab("Fruits", "apple")

local Visuals = T9ou:Tab("Visuals", "eye")

local Misc = T9ou:Tab("Misc", "grid-3x3")

local Settings = T9ou:Tab("Settings", "settings")