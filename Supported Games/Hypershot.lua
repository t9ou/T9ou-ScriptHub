-- Only run if in Hypershot
    local T9ou = loadstring(game:HttpGet("https://raw.githubusercontent.com/t9ou/T9ou-ScriptHub/main/T9ou_ui.lua"))()
    
    T9ou:CreateWindow({
        Title = "T9ou Hub",
        Icon = "flame"
    })
    
    T9ou:SetFooter("Hypershot")
    
    -- Tabs
    local AimbotTab = T9ou:Tab("Aimbot", "crosshair")
    local SilentaimTab = T9ou:Tab("Silent Aim", "target")
    local VisualTab = T9ou:Tab("Visual", "eye")
    local MovementTab = T9ou:Tab("Movement", "zap")
    local UtilityTab = T9ou:Tab("Utility", "wrench")
    local SettingTab = T9ou:Tab("Settings", "settings")
    
    T9ou:Notify("Loaded", "Hypershot script loaded!")
    
    -- Services for Logic
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local LocalPlayer = Players.LocalPlayer
    
    -- ==========================================
    -- VISUALS (ESP)
    -- ==========================================
    local ESPEnabled = false
    local ESPObjects = {}
    
    T9ou:Toggle(VisualTab, {
        Name = "Player ESP",
        Flag = "PlayerESP",
        Default = false,
        Callback = function(state)
            ESPEnabled = state
            if not state then
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
                
                -- Create objects if they don't exist
                if not ESPObjects[player] then
                    ESPObjects[player] = {
                        Box = Drawing.new("Square"),
                        Name = Drawing.new("Text")
                    }
                    ESPObjects[player].Box.Thickness = 1
                    ESPObjects[player].Box.Color = Color3.fromRGB(255, 85, 120) -- Your theme accent
                    ESPObjects[player].Box.Filled = false
                    ESPObjects[player].Name.Size = 14
                    ESPObjects[player].Name.Center = true
                    ESPObjects[player].Name.Outline = true
                    ESPObjects[player].Name.Color = Color3.fromRGB(255, 255, 255)
                end
    
                local pos, onScreen = camera:WorldToViewportPoint(hrp.Position)
                local headPos = camera:WorldToViewportPoint(hrp.Position + Vector3.new(0, 1.5, 0))
                
                if onScreen then
                    local height = math.abs(headPos.Y - pos.Y) * 2
                    local width = height / 2
                    
                    ESPObjects[player].Box.Size = Vector2.new(width, height)
                    ESPObjects[player].Box.Position = Vector2.new(pos.X - width/2, pos.Y - height/2)
                    ESPObjects[player].Box.Visible = true
                    
                    ESPObjects[player].Name.Text = player.Name
                    ESPObjects[player].Name.Position = Vector2.new(pos.X, pos.Y - height/2 - 18)
                    ESPObjects[player].Name.Visible = true
                else
                    ESPObjects[player].Box.Visible = false
                    ESPObjects[player].Name.Visible = false
                end
            elseif ESPObjects[player] then
                ESPObjects[player].Box.Visible = false
                ESPObjects[player].Name.Visible = false
            end
        end
    end)
    
    -- ==========================================
    -- AIMBOT (Camera Lock)
    -- ==========================================
    local AimbotEnabled = false
    local AimbotFOV = 150
    
    T9ou:Toggle(AimbotTab, {
        Name = "Enable Aimbot",
        Flag = "AimbotToggle",
        Callback = function(state) AimbotEnabled = state end
    })
    
    T9ou:Slider(AimbotTab, {
        Name = "FOV",
        Flag = "AimbotFOV",
        Min = 10, Max = 500, Default = 150,
        Callback = function(val) AimbotFOV = val end
    })
    
    local function getClosestPlayer()
        local closest, closestDist = nil, AimbotFOV
        local mousePos = UserInputService:GetMouseLocation()
        local camera = workspace.CurrentCamera
    
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
                local hrp = player.Character.HumanoidRootPart
                local screenPos, onScreen = camera:WorldToViewportPoint(hrp.Position)
                
                if onScreen then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(mousePos.X, mousePos.Y)).Magnitude
                    if dist < closestDist then
                        closest = hrp
                        closestDist = dist
                    end
                end
            end
        end
        return closest
    end
    
    RunService.RenderStepped:Connect(function()
        -- Hold Right Mouse Button (MouseButton2) to lock
        if AimbotEnabled and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
            local target = getClosestPlayer()
            if target then
                workspace.CurrentCamera.CFrame = workspace.CurrentCamera.CFrame:Lerp(CFrame.new(workspace.CurrentCamera.CFrame.Position, target.Position), 0.15)
            end
        end
    end)
    
else
    warn("This script is only for Hypershot!")
end