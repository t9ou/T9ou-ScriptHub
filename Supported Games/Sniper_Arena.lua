local function request(opts)
    local req = (syn and syn.request) or (http and http.request) or http_request or request
    if req then
        return req(opts)
    end
    return { Body = game:HttpGet(opts.Url, true), StatusCode = 200, Success = true }
end

local T9ou = loadstring(request({ Url = "YOUR_LIBRARY_URL_HERE", Method = "GET" }).Body)()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

T9ou:CreateWindow({
    Title = "T9ou hub",
    Icon = "flame"
})

T9ou:SetFooter("Sniper Arena")
T9ou:Notify("Loaded", "Sniper Arena script loaded!")

-- Aimbot
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

T9ou:Slider(Aimbot, {
    Name = "FOV Size",
    Flag = "AimbotFOVSize",
    Min = 20,
    Max = 400,
    Default = 120,
    Icon = "sliders",
    Callback = function(v) end
})

-- Silent Aim
local SilentAim = T9ou:Tab("Silent Aim", "target")

T9ou:Toggle(SilentAim, {
    Name = "Enable Silent Aim",
    Flag = "SilentEnabled",
    Default = false,
    Icon = "target",
    Callback = function(v) end
})

T9ou:Slider(SilentAim, {
    Name = "Hit Chance",
    Flag = "SilentHitChance",
    Min = 1,
    Max = 100,
    Default = 100,
    Icon = "percent",
    Callback = function(v) end
})

T9ou:Toggle(SilentAim, {
    Name = "Prediction",
    Flag = "SilentPrediction",
    Default = false,
    Icon = "activity",
    Callback = function(v) end
})


T9ou:Toggle(SilentAim, {
    Name = "Visible Check",
    Flag = "SilentVisibleCheck",
    Default = false,
    Icon = "eye",
    Callback = function(v) end
})

T9ou:Dropdown(SilentAim, {
    Name = "Target Part",
    Flag = "SilentPart",
    Options = {"Head", "UpperTorso", "HumanoidRootPart"},
    Default = "Head",
    Icon = "target",
    Callback = function(v) end
})

T9ou:Toggle(SilentAim, {
    Name = "Show FOV",
    Flag = "SilentFOV",
    Default = false,
    Icon = "circle",
    Callback = function(v) end
})

T9ou:Slider(SilentAim, {
    Name = "FOV Size",
    Flag = "SilentFOVSize",
    Min = 20,
    Max = 400,
    Default = 150,
    Icon = "sliders",
    Callback = function(v) end
})

-- Weapon
local Weapon = T9ou:Tab("Weapon", "swords")

T9ou:Toggle(Weapon, {
    Name = "No Recoil",
    Flag = "NoRecoil",
    Default = false,
    Icon = "crosshair",
    Callback = function(v) end
})

T9ou:Toggle(Weapon, {
    Name = "No Spread",
    Flag = "NoSpread",
    Default = false,
    Icon = "target",
    Callback = function(v) end
})

T9ou:Toggle(Weapon, {
    Name = "Infinite Ammo",
    Flag = "InfAmmo",
    Default = false,
    Icon = "box",
    Callback = function(v) end
})

T9ou:Toggle(Weapon, {
    Name = "Rapid Fire",
    Flag = "RapidFire",
    Default = false,
    Icon = "zap",
    Callback = function(v) end
})

T9ou:Slider(Weapon, {
    Name = "Damage Multiplier",
    Flag = "DamageMult",
    Min = 1,
    Max = 10,
    Default = 1,
    Icon = "sliders",
    Callback = function(v) end
})

-- Visual
local Visual = T9ou:Tab("Visual", "eye")


-- ESP System
local ESPPlayers = {}
local ESPEnabled = false
local ESPBoxEnabled = false
local ESPConnectionName = "T9ou_ESP_Update"

-- Name ESP
local ESPNameEnabled = false
local ESPNameTags = {}

-- Name ESP function
local function CreateNameESP(Player)
	if Player == LocalPlayer or ESPNameTags[Player] then
		return
	end

	local function SetupCharacter(Character)
		local Head = Character:WaitForChild("Head", 5)

		if not Head then
			return
		end

		if ESPNameTags[Player] then
			ESPNameTags[Player]:Destroy()
		end

		local Billboard = Instance.new("BillboardGui")
		Billboard.Name = "T9ou_NameTag"
		Billboard.Size = UDim2.fromOffset(160, 30)
		Billboard.StudsOffset = Vector3.new(0, 2.8, 0)
		Billboard.AlwaysOnTop = true
		Billboard.MaxDistance = 1500
		Billboard.Enabled = ESPNameEnabled
		Billboard.Adornee = Head
		Billboard.Parent = Head

		local Label = Instance.new("TextLabel")
		Label.Size = UDim2.fromScale(1, 1)
		Label.BackgroundTransparency = 1
		Label.Text = Player.DisplayName
		Label.TextColor3 = Color3.fromRGB(255, 85, 120)
		Label.TextStrokeTransparency = 0.2
		Label.Font = Enum.Font.GothamBold
		Label.TextSize = 14
		Label.Parent = Billboard

		ESPNameTags[Player] = Billboard
	end

	Player.CharacterAdded:Connect(SetupCharacter)

	if Player.Character then
		task.spawn(SetupCharacter, Player.Character)
	end
end

local function RemoveNameESP(Player)
	local Tag = ESPNameTags[Player]

	if Tag then
		Tag:Destroy()
		ESPNameTags[Player] = nil
	end
end

-- Clean up previous ESP instance.
pcall(function()
	RunService:UnbindFromRenderStep(ESPConnectionName)
end)

local ExistingGui = PlayerGui:FindFirstChild("T9ou_PlayerESP

local ExistingGui = PlayerGui:FindFirstChild("T9ou_PlayerESP")

if ExistingGui then
	ExistingGui:Destroy()
end

local ESPGui = Instance.new("ScreenGui")
ESPGui.Name = "T9ou_PlayerESP"
ESPGui.ResetOnSpawn = false
ESPGui.IgnoreGuiInset = true
ESPGui.DisplayOrder = 999
ESPGui.Parent = PlayerGui

-- Create a player's box.
local function CreateESP(Player)
	if Player == LocalPlayer or ESPPlayers[Player] then
		return
	end

	local Box = Instance.new("Frame")
	Box.Name = Player.Name
	Box.BackgroundTransparency = 1
	Box.BorderSizePixel = 0
	Box.Visible = false
	Box.Parent = ESPGui

	local Stroke = Instance.new("UIStroke")
	Stroke.Color = Color3.fromRGB(255, 85, 120)
	Stroke.Thickness = 1
	Stroke.Parent = Box

	ESPPlayers[Player] = Box
end

-- Remove a player's box.
local function RemoveESP(Player)
	local Box = ESPPlayers[Player]

	if Box then
		Box:Destroy()
		ESPPlayers[Player] = nil
	end
end

for _, Player in Players:GetPlayers() do
	CreateESP(Player)
	CreateNameESP(Player)
end

local PlayerAddedConnection = Players.PlayerAdded:Connect(function(Player)
	CreateESP(Player)
	CreateNameESP(Player)
end)

local PlayerRemovingConnection = Players.PlayerRemoving:Connect(function(Player)
	RemoveESP(Player)
	RemoveNameESP(Player)
end)

-- Update ESP.
local function UpdateESP()
	local Camera = workspace.CurrentCamera

	if not Camera then
		return
	end

	local Viewport = Camera.ViewportSize

	for Player, Box in ESPPlayers do
		if not ESPEnabled or not ESPBoxEnabled then
			Box.Visible = false
			continue
		end

		local Character = Player.Character
		local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

		if not Character or not Humanoid or Humanoid.Health <= 0 then
			Box.Visible = false
			continue
		end

		local Success, BoundingCFrame, BoundingSize = pcall(function()
			return Character:GetBoundingBox()
		end)

		if not Success then
			Box.Visible = false
			continue
		end

		local HalfSize = BoundingSize / 2

		local MinX, MinY = math.huge, math.huge
		local MaxX, MaxY = -math.huge, -math.huge
		local ValidPoints = 0

		for X = -1, 1, 2 do
			for Y = -1, 1, 2 do
				for Z = -1, 1, 2 do
					local Corner = BoundingCFrame:PointToWorldSpace(
						Vector3.new(
							HalfSize.X * X,
							HalfSize.Y * Y,
							HalfSize.Z * Z
						)
					)

					local Point = Camera:WorldToViewportPoint(Corner)

					if Point.Z > 0 then
						ValidPoints += 1
						MinX = math.min(MinX, Point.X)
						MinY = math.min(MinY, Point.Y)
						MaxX = math.max(MaxX, Point.X)
						MaxY = math.max(MaxY, Point.Y)
					end
				end
			end
		end

		if ValidPoints == 0 then
			Box.Visible = false
			continue
		end

		local Width = MaxX - MinX
		local Height = MaxY - MinY

		if Width <= 0 or Height <= 0 then
			Box.Visible = false
			continue
		end

		Box.Position = UDim2.fromOffset(MinX, MinY)
		Box.Size = UDim2.fromOffset(Width, Height)
		Box.Visible = true
	end
end

RunService:BindToRenderStep(ESPConnectionName, Enum.RenderPriority.Camera.Value + 1, UpdateESP)

-- Visual tab wiring
T9ou:Toggle(Visual, {
	Name = "Player ESP",
	Flag = "ESPEnabled",
	Default = false,
	Icon = "box",
	Callback = function(v)
		ESPEnabled = v
	end
})

T9ou:Toggle(Visual, {
	Name = "Box ESP",
	Flag = "ESPBox",
	Default = false,
	Icon = "square",
	Callback = function(v)
		ESPBoxEnabled = v
	end
})

T9ou:Toggle(Visual, {
	Name = "Name ESP",
	Flag = "ESPName",
	Default = false,
	Icon = "type",
	Callback = function(v)
		ESPNameEnabled = v
		for _, Tag in ESPNameTags do
			Tag.Enabled = v
		end
	end
})