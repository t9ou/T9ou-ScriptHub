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


--=========================================
-- Function
--=========================================
local items = {}
local blacklist = {"Tool"}

for _, v in ipairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
    if v:IsA("Tool") and not table.find(blacklist, v.Name) then
        table.insert(items, v.Name)
    end
end


--=========================================
-- Farm Tab
--=========================================
local Farm = T9ou:Tab("Farm", "zap")
    local AutoGroup = T9ou:GroupBox(Farm, {
    Name = "Auto Farm",
    Icon = "zap",
    DefaultOpen = true,
    Side = "Left" 
    })

        T9ou:Toggle(AutoGroup, {
            Name = "Auto Farm",
            Default = false,
            Callback = function(v) end
        })
    
        T9ou:Dropdown(AutoGroup, {
            Name = "Select Mob",
            Options = {"Bandit", "Monkey", "Gorilla", "Pirate", "Brute", "Desert Bandit", "Desert Officer", "Snow Bandit", "Snowman", "Chief Petty Officer", "Sky Bandit", "Dark Master", "Prisoner", "Dangerous Prisoner", "Toga Warrior", "Gladiator", "Military Soldier", "Military Spy"},
            Default = "Bandit",
            Multi = false, 
            Icon = "list",
            Callback = function(v)
                print(v)
            end
        })
    
        T9ou:Dropdown(AutoGroup, {
            Name = "Inventory",
            Options = items,
            Default = items[1] or "None",
            Callback = function(v)
                print(v)
            end
        })
    
        T9ou:Button(Player, {
            Name = "Refresh Weapon",
            Icon = "refresh-cw",
            Callback = function() 
                items = {}
                local lp = game.Players.LocalPlayer
                for _, v in ipairs(lp.Backpack:GetChildren()) do
                    if v:IsA("Tool") and not table.find(blacklist, v.Name) then
                        table.insert(items, v.Name)
                    end
    end
    if lp.Character then
        for _, v in ipairs(lp.Character:GetChildren()) do
            if v:IsA("Tool") and not table.find(blacklist, v.Name) then
                table.insert(items, v.Name)
            end
        end
    end
    if T9ou.Elements["Inventory"] then
        T9ou.Elements["Inventory"](items[1] or "None")
    end
    T9ou:Notify("Weapon", "Refreshed!")

            end
        })

    local QuestGroup = T9ou:GroupBox(Farm, {
    Name = "Auto Farm",
    Icon = "zap",
    DefaultOpen = true,
    Side = "Left" 
    })

    local MasteryGroup = T9ou:GroupBox(Farm, {
    Name = "Mastery Farm",
    Icon = "target",
    DefaultOpen = true,
    Side = "Left" 
    })

    local BossGroup = T9ou:GroupBox(Farm, {
    Name = "Boss Farm",
    Icon = "skull",
    DefaultOpen = true,
    Side = "Right" 
    })

    local MoneyGroup = T9ou:GroupBox(Farm, {
    Name = "Money Farm",
    Icon = "coins",
    DefaultOpen = true,
    Side = "Full" 
    })

--=========================================
-- Combat Tab
--=========================================
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

--=========================================
-- World Tab
--=========================================
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

--=========================================
-- Player Tab
--=========================================
local Player = T9ou:Tab("Player", "user-round")
    local MovementGroup = T9ou:GroupBox(Player, {
    Name = "Movement",
    Icon = "footprints",
    DefaultOpen = true,
    Side = "Full" 
    })
    
    T9ou:Toggle(Player, {
    Name = "Anti-AFK",
    Default = false,
    Icon = "clock",
    Callback = function(v) end
    })

    T9ou:Button(Player, {
    Name = "Server Hop",
    Icon = "server",
    Callback = function() end
    })

    T9ou:Button(Player, {
    Name = "Rejoin Server",
    Icon = "refresh-cw",
    Callback = function() end
    })

--=========================================
-- Fruit Tab
--=========================================
local Fruits = T9ou:Tab("Fruits", "apple")
    T9ou:Toggle(Fruits, {
    Name = "Auto Collect Fruits",
    Default = false,
    Icon = "apple",
    Callback = function(v) end
    })

    T9ou:Button(Fruits, {
    Name = "Fruit Gacha",
    Icon = "dices",
    Callback = function() end
    })

    T9ou:Toggle(Fruits, {
    Name = "Fruit Notifier",
    Default = false,
    Icon = "bell",
    Callback = function(v) end
    })

    T9ou:Toggle(Fruits, {
    Name = "Auto Store Fruit",
    Default = false,
    Icon = "package-check",
    Callback = function(v) end
    })

--=========================================
-- Visual Tab
--=========================================
local Visuals = T9ou:Tab("Visuals", "eye")
    local PlayerESPGroup = T9ou:GroupBox(Visuals, {
    Name = "Player ESP",
    Icon = "scan-eye",
    DefaultOpen = true,
    Side = "Left" 
    })

    local FruitESPGroup = T9ou:GroupBox(Visuals, {
    Name = "Fruit ESP",
    Icon = "apple",
    DefaultOpen = true,
    Side = "Right" 
    })

    local ChestESPGroup = T9ou:GroupBox(Visuals, {
    Name = "Chest ESP",
    Icon = "treasure-chest",
    DefaultOpen = true,
    Side = "Left" 
    })

    local FlowerESPGroup = T9ou:GroupBox(Visuals, {
    Name = "Flower ESP",
    Icon = "flower-2",
    DefaultOpen = true,
    Side = "Right" 
    })

--=========================================
-- Setting Tab
--=========================================
local Settings = T9ou:Tab("Settings", "settings")
    T9ou:Divider(Settings, "created by T9ou")
    T9ou:Divider(Settings, "currently under development")
    T9ou:Divider(Settings, "version: 1.0")