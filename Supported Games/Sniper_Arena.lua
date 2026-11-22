-- ==========================================
-- 1. TISZTÍTÁS ÉS BETÖLTÉS
-- ==========================================
if isfile("T9ou_Configs/autosave.json") then
    delfile("T9ou_Configs/autosave.json")
end
if isfile("T9ou_Configs/.last") then
    delfile("T9ou_Configs/.last")
end

local T9ou = loadstring(game:HttpGet("https://raw.githubusercontent.com/t9ou/T9ou-ScriptHub/main/T9ou_ui.lua"))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera

T9ou:CreateWindow({
    Title = "T9ou hub",
    Icon = "flame"
})

T9ou:SetFooter("Sniper Arena")
T9ou:Notify("Loaded", "Sniper Arena script loaded!")

-- ==========================================
-- 2. ESP VÁLTOZÓK
-- ==========================================
local ESPPlayers = {}
local ESPEnabled = false
local ESPBoxEnabled = false
local ESPNameEnabled = false
local ESPDistanceEnabled = false
local ESPSkeletonEnabled = false
local ESPTracerEnabled = false
local ESPTracerPosition = "Bottom"
local ESPColor = Color3.fromRGB(255, 85, 120)
local ESPNameTags = {}

-- ==========================================
-- 3. AIMBOT TAB
-- ==========================================
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
    Default = false, 
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
    Name = "Visible Check", 
    Flag = "AimbotVisibleCheck", 
    Default = false, 
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

T9ou:Slider(Aimbot, { Name = "FOV Size", Flag = "AimbotFOVSize", Min = 20, Max = 400, Default = 120, Icon = "sliders", Callback = function(v) end })

-- ==========================================
-- 4. SILENT AIM TAB
-- ==========================================
local SilentAim = T9ou:Tab("Silent Aim", "target")
T9ou:Toggle(SilentAim, { Name = "Enable Silent Aim", Flag = "SilentEnabled", Default = false, Icon = "target", Callback = function(v) end })
T9ou:Slider(SilentAim, { Name = "Hit Chance", Flag = "SilentHitChance", Min = 1, Max = 100, Default = 100, Icon = "percent", Callback = function(v) end })
T9ou:Toggle(SilentAim, { Name = "Prediction", Flag = "SilentPrediction", Default = false, Icon = "activity", Callback = function(v) end })
T9ou:Toggle(SilentAim, { Name = "Visible Check", Flag = "SilentVisibleCheck", Default = false, Icon = "eye", Callback = function(v) end })
T9ou:Dropdown(SilentAim, { Name = "Target Part", Flag = "SilentPart", Options = {"Head", "UpperTorso", "HumanoidRootPart"}, Default = "Head", Icon = "target", Callback = function(v) end })
T9ou:Toggle(SilentAim, { Name = "Show FOV", Flag = "SilentFOV", Default = false, Icon = "circle", Callback = function(v) end })
T9ou:Slider(SilentAim, { Name = "FOV Size", Flag = "SilentFOVSize", Min = 20, Max = 400, Default = 150, Icon = "sliders", Callback = function(v) end })

-- ==========================================
-- 5. WEAPON TAB
-- ==========================================
local Weapon = T9ou:Tab("Weapon", "swords")
T9ou:Toggle(Weapon, { Name = "No Recoil", Flag = "NoRecoil", Default = false, Icon = "crosshair", Callback = function(v) end })
T9ou:Toggle(Weapon, { Name = "No Spread", Flag = "NoSpread", Default = false, Icon = "target", Callback = function(v) end })
T9ou:Toggle(Weapon, { Name = "Infinite Ammo", Flag = "InfAmmo", Default = false, Icon = "box", Callback = function(v) end })
T9ou:Toggle(Weapon, { Name = "Rapid Fire", Flag = "RapidFire", Default = false, Icon = "zap", Callback = function(v) end })
T9ou:Slider(Weapon, { Name = "Damage Multiplier", Flag = "DamageMult", Min = 1, Max = 10, Default = 1, Icon = "sliders", Callback = function(v) end })

-- ==========================================
-- 6. ESP LOGIKA ÉS TÁROLÓK
-- ==========================================
local SkeletonBones = {
	{"Head", "UpperTorso"}, {"UpperTorso", "LowerTorso"},
	{"UpperTorso", "LeftUpperArm"}, {"LeftUpperArm", "LeftLowerArm"}, {"LeftLowerArm", "LeftHand"},
	{"UpperTorso", "RightUpperArm"}, {"RightUpperArm", "RightLowerArm"}, {"RightLowerArm", "RightHand"},
	{"LowerTorso", "LeftUpperLeg"}, {"LeftUpperLeg", "LeftLowerLeg"}, {"LeftLowerLeg", "LeftFoot"},
	{"LowerTorso", "RightUpperLeg"}, {"RightUpperLeg", "RightLowerLeg"}, {"RightLowerLeg", "RightFoot"},
}

local ExistingGui = PlayerGui:FindFirstChild("T9ou_PlayerESP")
if ExistingGui then ExistingGui:Destroy() end

local ESPGui = Instance.new("ScreenGui")
ESPGui.Name = "T9ou_PlayerESP"
ESPGui.ResetOnSpawn = false
ESPGui.IgnoreGuiInset = true
ESPGui.DisplayOrder = 999
ESPGui.Parent = PlayerGui

local function SetupCharacter(Player, Character)
	local Head = Character:WaitForChild("Head", 5)
	if not Head then return end
	if ESPNameTags[Player] then ESPNameTags[Player]:Destroy() end

	local Billboard = Instance.new("BillboardGui")
	Billboard.Name = "T9ou_NameTag"
	Billboard.Size = UDim2.fromOffset(160, 20)
	Billboard.StudsOffset = Vector3.new(0, 2.8, 0)
	Billboard.AlwaysOnTop = true
	Billboard.MaxDistance = 3000
	Billboard.Enabled = ESPNameEnabled
	Billboard.Adornee = Head
	Billboard.Parent = Head

	local Label = Instance.new("TextLabel")
	Label.Size = UDim2.fromScale(1, 1)
	Label.BackgroundTransparency = 1
	Label.Text = Player.DisplayName
	Label.TextColor3 = ESPColor
	Label.TextStrokeTransparency = 0.2
	Label.Font = Enum.Font.GothamBold
	Label.TextSize = 14
	Label.Parent = Billboard

	ESPNameTags[Player] = Billboard
end

local function CreateESP(Player)
	if Player == LocalPlayer or ESPPlayers[Player] then return end
	local Data = { 
		Box = Instance.new("Frame"), 
		DistText = Instance.new("TextLabel"), 
		Tracer = Instance.new("Frame"),
		Skeleton = {} 
	}
	
	-- Box
	Data.Box.Name = Player.Name
	Data.Box.BackgroundTransparency = 1
	Data.Box.BorderSizePixel = 0
	Data.Box.Visible = false
	Data.Box.Parent = ESPGui

	local Stroke = Instance.new("UIStroke")
	Stroke.Color = ESPColor
	Stroke.Thickness = 1
	Stroke.Parent = Data.Box

	-- Distance Text (Jobb oldalon)
	Data.DistText.Name = "DistanceText"
	Data.DistText.BackgroundTransparency = 1
	Data.DistText.TextColor3 = ESPColor
	Data.DistText.TextStrokeTransparency = 0.2
	Data.DistText.Font = Enum.Font.GothamBold
	Data.DistText.TextSize = 12
	Data.DistText.TextXAlignment = Enum.TextXAlignment.Left
	Data.DistText.TextYAlignment = Enum.TextYAlignment.Center
	Data.DistText.Visible = false
	Data.DistText.Parent = ESPGui

	-- Tracer Line
	Data.Tracer.Name = "Tracer"
	Data.Tracer.BackgroundColor3 = ESPColor
	Data.Tracer.BorderSizePixel = 0
	Data.Tracer.Visible = false
	Data.Tracer.Parent = ESPGui

	-- Skeleton Lines
	for i = 1, #SkeletonBones do
		local line = Instance.new("Frame")
		line.BackgroundColor3 = ESPColor
		line.BorderSizePixel = 0
		line.Visible = false
		line.Parent = ESPGui
		
		local lineContainer = { Frame = line }
		table.insert(Data.Skeleton, lineContainer)
	end

	ESPPlayers[Player] = Data
	Player.CharacterAdded:Connect(function(Char) SetupCharacter(Player, Char) end)
	if Player.Character then task.spawn(SetupCharacter, Player, Player.Character) end
end

local function RemoveESP(Player)
	if ESPPlayers[Player] then
		ESPPlayers[Player].Box:Destroy()
		ESPPlayers[Player].DistText:Destroy()
		ESPPlayers[Player].Tracer:Destroy()
		for _, line in ipairs(ESPPlayers[Player].Skeleton) do
			line.Frame:Destroy()
		end
		ESPPlayers[Player] = nil
	end
	if ESPNameTags[Player] then ESPNameTags[Player]:Destroy() ESPNameTags[Player] = nil end
end

for _, Player in Players:GetPlayers() do CreateESP(Player) end
Players.PlayerAdded:Connect(CreateESP)
Players.PlayerRemoving:Connect(RemoveESP)

-- ==========================================
-- 7. RENDERSTEPPED CIKLUS
-- ==========================================
RunService.RenderStepped:Connect(function()
	if not Camera then return end
	local Viewport = Camera.ViewportSize
	local MyChar = LocalPlayer.Character
	local MyHrp = MyChar and MyChar:FindFirstChild("HumanoidRootPart")
	
	local rawDist = T9ou.Options.ESP_Distance
	local maxDist = (type(rawDist) == "number") and rawDist or 1500

	for Player, Data in pairs(ESPPlayers) do
		local Character = Player.Character
		local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
		local Hrp = Character and Character:FindFirstChild("HumanoidRootPart")
		
		local isValid = Character and Humanoid and Hrp and Humanoid.Health > 0
		local inRange = false
		
		if isValid and MyHrp then
			if (MyHrp.Position - Hrp.Position).Magnitude <= maxDist then
				inRange = true
			end
		end

		local headPos = inRange and Camera:WorldToViewportPoint(Hrp.Position + Vector3.new(0, 2.5, 0))
		local footPos = inRange and Camera:WorldToViewportPoint(Hrp.Position - Vector3.new(0, 3, 0))
		
		-- 1. BOX ÉS TÁVOLSÁG
		if inRange and ESPEnabled and ESPBoxEnabled and headPos.Z > 0 and footPos.Z > 0 then
			local height = math.abs(footPos.Y - headPos.Y)
			local width = height * 0.55
			
			Data.Box.Position = UDim2.fromOffset(headPos.X - width/2, headPos.Y)
			Data.Box.Size = UDim2.fromOffset(width, height)
			Data.Box.Visible = true
			
			if ESPDistanceEnabled and MyHrp then
				local dist = math.floor((MyHrp.Position - Hrp.Position).Magnitude)
				Data.DistText.Text = "[" .. dist .. "]"
				Data.DistText.Position = UDim2.fromOffset(headPos.X + width/2 + 5, headPos.Y + height/2 - 10)
				Data.DistText.Visible = true
			else
				Data.DistText.Visible = false
			end
		else
			Data.Box.Visible = false
			Data.DistText.Visible = false
		end

		-- 2. NÉV
		local Billboard = ESPNameTags[Player]
		if Billboard and Billboard.Parent then
			Billboard.Enabled = inRange and ESPNameEnabled
			local label = Billboard:FindFirstChildOfClass("TextLabel")
			if label then label.TextColor3 = ESPColor end
		end

		-- 3. TRACER
		if inRange and ESPTracerEnabled and footPos.Z > 0 then
			local startPos
			if ESPTracerPosition == "Top" then
				startPos = Vector2.new(Viewport.X / 2, 0)
			elseif ESPTracerPosition == "Center" then
				startPos = Vector2.new(Viewport.X / 2, Viewport.Y / 2)
			else
				startPos = Vector2.new(Viewport.X / 2, Viewport.Y)
			end
			
			local endPos = Vector2.new(footPos.X, footPos.Y)
			local center = (startPos + endPos) / 2
			local diff = endPos - startPos
			local length = diff.Magnitude
			local angle = math.deg(math.atan2(diff.Y, diff.X))

			Data.Tracer.Size = UDim2.fromOffset(length, 1)
			Data.Tracer.Position = UDim2.fromOffset(center.X, center.Y)
			Data.Tracer.AnchorPoint = Vector2.new(0.5, 0.5)
			Data.Tracer.Rotation = angle
			Data.Tracer.BackgroundColor3 = ESPColor
			Data.Tracer.Visible = true
		else
			Data.Tracer.Visible = false
		end

		-- 4. SKELETON
		if inRange and ESPSkeletonEnabled then
			for i, bone in ipairs(SkeletonBones) do
				local lineObj = Data.Skeleton[i]
				local part1 = Character:FindFirstChild(bone[1])
				local part2 = Character:FindFirstChild(bone[2])
				
				if part1 and part2 then
					local p1 = Camera:WorldToViewportPoint(part1.Position)
					local p2 = Camera:WorldToViewportPoint(part2.Position)
					
					if p1.Z > 0 and p2.Z > 0 then
						local v1 = Vector2.new(p1.X, p1.Y)
						local v2 = Vector2.new(p2.X, p2.Y)
						local center = (v1 + v2) / 2
						local diff = v2 - v1
						local length = diff.Magnitude
						local angle = math.deg(math.atan2(diff.Y, diff.X))

						lineObj.Frame.Size = UDim2.fromOffset(length, 1)
						lineObj.Frame.Position = UDim2.fromOffset(center.X, center.Y)
						lineObj.Frame.AnchorPoint = Vector2.new(0.5, 0.5)
						lineObj.Frame.Rotation = angle
						lineObj.Frame.BackgroundColor3 = ESPColor
						lineObj.Frame.Visible = true
					else
						lineObj.Frame.Visible = false
					end
				else
					lineObj.Frame.Visible = false
				end
			end
		else
			for _, line in ipairs(Data.Skeleton) do line.Frame.Visible = false end
		end
	end
end)

-- ==========================================
-- 8. VISUAL TAB
-- ==========================================
local Visual = T9ou:Tab("Visual", "eye")

T9ou:Toggle(Visual, { Name = "Enable ESP", Flag = "ESPEnabled", Default = false, Icon = "eye", Callback = function(v) ESPEnabled = v end })
T9ou:Toggle(Visual, { Name = "Box", Flag = "ESP_Box", Default = false, Icon = "square", Callback = function(v) ESPBoxEnabled = v end })
T9ou:Toggle(Visual, { Name = "Name", Flag = "ESP_Name", Default = false, Icon = "type", Callback = function(v) ESPNameEnabled = v end })
T9ou:Toggle(Visual, { Name = "Distance", Flag = "ESP_Distance_Text", Default = false, Icon = "ruler", Callback = function(v) ESPDistanceEnabled = v end })
T9ou:Toggle(Visual, { Name = "Skeleton", Flag = "ESP_Skeleton", Default = false, Icon = "bone", Callback = function(v) ESPSkeletonEnabled = v end })
T9ou:Toggle(Visual, { Name = "Tracer", Flag = "ESP_Tracer", Default = false, Icon = "minus", Callback = function(v) ESPTracerEnabled = v end })
T9ou:Dropdown(Visual, { 
    Name = "Tracer Origin", 
    Flag = "ESP_TracerOrigin", 
    Options = {"Bottom", "Center", "Top"}, 
    Default = "Bottom", 
    Icon = "map-pin", 
    Callback = function(v) ESPTracerPosition = v end 
})
T9ou:ColorPicker(Visual, { Name = "ESP Color", Flag = "ESP_Color", Default = Color3.fromRGB(255, 85, 120), Icon = "palette", Callback = function(c) ESPColor = Color3.new(c.R, c.G, c.B) end })
T9ou:Slider(Visual, { Name = "Max Distance", Flag = "ESP_Distance", Min = 100, Max = 3000, Default = 1500, Icon = "sliders", Callback = function(v) end })

-- ==========================================
-- 9. SKIN CHANGER TAB
-- ==========================================
local SkinChanger = T9ou:Tab("Skin Changer", "palette")
T9ou:Dropdown(SkinChanger, { Name = "Skin", Flag = "SelectedSkin", Options = {"Default", "Gold", "Diamond", "Galaxy", "Neon"}, Default = "Default", Icon = "palette", Callback = function(v) end })
T9ou:Button(SkinChanger, { Name = "Apply Skin", Icon = "check", Callback = function() end })

-- ==========================================
-- 10. MISC TAB
-- ==========================================
local Misc = T9ou:Tab("Misc", "settings")

T9ou:Slider(Misc, { 
    Name = "WalkSpeed", 
    Flag = "WalkSpeed", 
    Min = 16, 
    Max = 150, 
    Default = 16, 
    Icon = "person-standing", 
    Callback = function(v) 
        if type(v) == "number" then
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = v end
        end
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
        if type(v) == "number" then
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then hum.JumpPower = v end
        end
    end 
})

T9ou:Toggle(Misc, { Name = "Fly", Flag = "Fly", Default = false, Icon = "plane", Callback = function(v) end })
T9ou:Toggle(Misc, { Name = "Noclip", Flag = "Noclip", Default = false, Icon = "ghost", Callback = function(v) end })
T9ou:Toggle(Misc, { Name = "Infinite Jump", Flag = "InfJump", Default = false, Icon = "arrow-up-circle", Callback = function(v) end })