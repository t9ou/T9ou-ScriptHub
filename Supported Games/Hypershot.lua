local T9ou = loadstring(game:HttpGet("https://raw.githubusercontent.com/t9ou/T9ou-ScriptHub/main/T9ou_ui.lua"))()

T9ou:CreateWindow({
    Title = "T9ou hub",
    Icon = "flame"
})

T9ou:SetFooter("Hypershot")
T9ou:Notify("Loaded", "Hypershot script loaded!")

local Aimbot = T9ou:Tab("Aimbot", "crosshair")
local Silentaim = T9ou:Tab("Silent Aim", "target")
local Visual = T9ou:Tab("Visual", "eye")
local Movement = T9ou:Tab("Movement", "zap")
local Utility = T9ou:Tab("Utility", "wrench")
local Setting = T9ou:Tab("Settings", "settings")

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- ==========================================
-- PLAYER ESP
-- ==========================================
local ESPEnabled = false
local ESPObjects = {}

T9ou:Toggle(Visual, {
    Name = "Player ESP",
    Flag = "PlayerESP",
    Callback = function(state)
        ESPEnabled = state
        if not state then
            -- Clean up drawings when turned off
            for _, obj in pairs(ESPObjects) do
                if obj.Box then obj.Box:Remove() end
                if obj.Name then obj.Name:Remove() end
            end
            table.clear(ESPObjects)
        end
    end
})

RunService.RenderStepped:Connect(function()
    if not ESPEnabled then return end
    
    local camera = workspace.CurrentCamera
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            
            local hrp = player.Character.HumanoidRootPart
            
            -- Create drawings if they don't exist
            if not ESPObjects[player] then
                ESPObjects[player] = {
                    Box = Drawing.new("Square"),
                    Name = Drawing.new("Text")
                }
                ESPObjects[player].Box.Thickness = 1
                ESPObjects[player].Box.Color = Color3.fromRGB(255, 85, 120) -- Pink accent
                ESPObjects[player].Box.Filled = false
                ESPObjects[player].Name.Size = 14
                ESPObjects[player].Name.Center = true
                ESPObjects[player].Name.Outline = true
                ESPObjects[player].Name.Color = Color3.fromRGB(255, 255, 255)
            end

            -- Convert 3D position to 2D screen position
            local pos, onScreen = camera:WorldToViewportPoint(hrp.Position)
            local headPos = camera:WorldToViewportPoint(hrp.Position + Vector3.new(0, 1.5, 0))
            
            if onScreen then
                -- Calculate box size based on distance
                local height = math.abs(headPos.Y - pos.Y) * 2
                local width = height / 2
                
                ESPObjects[player].Box.Size = Vector2.new(width, height)
                ESPObjects[player].Box.Position = Vector2.new(pos.X - width/2, pos.Y - height/2)
                ESPObjects[player].Box.Visible = true
                
                ESPObjects[player].Name.Text = player.Name
                ESPObjects[player].Name.Position = Vector2.new(pos.X, pos.Y - height/2 - 18)
                ESPObjects[player].Name.Visible = true
            else
                -- Hide if off-screen
                ESPObjects[player].Box.Visible = false
                ESPObjects[player].Name.Visible = false
            end
            
        elseif ESPObjects[player] then
            -- Hide if the player dies or leaves
            ESPObjects[player].Box.Visible = false
            ESPObjects[player].Name.Visible = false
        end
    end
end)