-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local Lucide = loadstring(game:HttpGet("https://raw.githubusercontent.com/notpoiu/lucide-roblox-direct/main/source.lua"))()

local T9ou = {}
T9ou.Flags = {}
T9ou.Tabs = {}
T9ou.CurrentTab = nil
T9ou.Options = {}
T9ou.Elements = {}
T9ou.ElementsUI = {}
T9ou.Gui = nil
T9ou.AutoExecuteFunc = nil
T9ou.DependencyListeners = {}
T9ou.AutoSaveEnabled = true
T9ou.SaveDebounce = false
T9ou.SearchQuery = ""

local Theme = {
	Accent = Color3.fromRGB(255, 85, 120),
	BgMain = Color3.fromRGB(15, 15, 18),
	BgPanel = Color3.fromRGB(22, 22, 26),
	BgElement = Color3.fromRGB(30, 30, 36),
	BgHover = Color3.fromRGB(42, 42, 50),
	TextMain = Color3.fromRGB(255, 255, 255),
	TextDim = Color3.fromRGB(140, 140, 150),
	Font = Enum.Font.Gotham,
	FontBold = Enum.Font.GothamBold,
	FontCode = Enum.Font.Code,
	TweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
}

local function Create(Class, Props)
	Props = Props or {}
	local Inst = Instance.new(Class)
	for k, v in pairs(Props) do
		pcall(function() Inst[k] = v end)
	end
	return Inst
end

local function Corner(Obj, Radius)
	Create("UICorner", { CornerRadius = UDim.new(0, Radius), Parent = Obj })
end

local function AddIcon(Name, Size, Color, Parent, Position)
	if not Name then return nil end
	local Success, Asset = pcall(Lucide.GetAsset, Name, Size)
	if not Success or not Asset then return nil end
	return Create("ImageLabel", {
		Size = UDim2.fromOffset(Size, Size), Position = Position, BackgroundTransparency = 1,
		Image = Asset.Url, ImageRectOffset = Asset.ImageRectOffset, ImageRectSize = Asset.ImageRectSize,
		ImageColor3 = Color, Parent = Parent, ZIndex = (Parent and Parent.ZIndex or 1) + 1
	})
end

local function MakeDraggable(Frame, DragArea)
	local Dragging, DragStart, StartPos = false, nil, nil
	DragArea.InputBegan:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
			Dragging = true; DragStart = Input.Position; StartPos = Frame.Position
		end
	end)
	UserInputService.InputChanged:Connect(function(Input)
		if Dragging and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
			local Delta = Input.Position - DragStart
			local newX = StartPos.X.Offset + Delta.X
			local newY = StartPos.Y.Offset + Delta.Y
			local viewport = workspace.CurrentCamera.ViewportSize
			local absSize = Frame.AbsoluteSize
			local maxX = (viewport.X / 2) - (absSize.X / 2)
			local maxY = (viewport.Y / 2) - (absSize.Y / 2)
			newX = math.clamp(newX, -maxX, maxX)
			newY = math.clamp(newY, -maxY, maxY)
			Frame.Position = UDim2.new(0.5, newX, 0.5, newY)
		end
	end)
	UserInputService.InputEnded:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then Dragging = false end
	end)
end

local NotifContainer = Create("Frame", {
	Name = "NotifContainer", Parent = nil, AnchorPoint = Vector2.new(1, 1),
	Position = UDim2.new(1, -20, 1, -20), Size = UDim2.fromOffset(250, 300), BackgroundTransparency = 1, ZIndex = 9999
})
Create("UIListLayout", { Parent = NotifContainer, Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder, VerticalAlignment = Enum.VerticalAlignment.Bottom })

function T9ou:Notify(Title, Text, Duration)
	if not NotifContainer.Parent then
		local pg = gethui and gethui() or LocalPlayer.PlayerGui
		NotifContainer.Parent = pg
	end
	local Box = Create("Frame", { Parent = NotifContainer, Size = UDim2.new(1, 0, 0, 60), BackgroundColor3 = Theme.BgPanel, BorderSizePixel = 0, BackgroundTransparency = 1, ZIndex = 9999 })
	Corner(Box, 8)
	local Stroke = Create("UIStroke", { Color = Theme.Accent, Thickness = 1.5, Transparency = 1, Parent = Box })
	AddIcon("bell", 18, Theme.Accent, Box, UDim2.fromOffset(12, 20))

	local TitleL = Create("TextLabel", { Parent = Box, Position = UDim2.fromOffset(40, 10), Size = UDim2.new(1, -50, 0, 16), BackgroundTransparency = 1, Text = Title, TextColor3 = Theme.TextMain, Font = Theme.FontBold, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, TextTransparency = 1, ZIndex = 10000 })
	local TextL = Create("TextLabel", { Parent = Box, Position = UDim2.fromOffset(40, 28), Size = UDim2.new(1, -50, 0, 20), BackgroundTransparency = 1, Text = Text, TextColor3 = Theme.TextDim, Font = Theme.Font, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, TextTransparency = 1, ZIndex = 10000 })

	TweenService:Create(Box, Theme.TweenInfo, { BackgroundTransparency = 0.1 }):Play()
	TweenService:Create(Stroke, Theme.TweenInfo, { Transparency = 0.4 }):Play()
	TweenService:Create(TitleL, Theme.TweenInfo, { TextTransparency = 0 }):Play()
	TweenService:Create(TextL, Theme.TweenInfo, { TextTransparency = 0 }):Play()

	task.delay(Duration or 3, function()
		local tw = TweenService:Create(Box, Theme.TweenInfo, { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0) })
		TweenService:Create(Stroke, Theme.TweenInfo, { Transparency = 1 }):Play()
		TweenService:Create(TitleL, Theme.TweenInfo, { TextTransparency = 1 }):Play()
		TweenService:Create(TextL, Theme.TweenInfo, { TextTransparency = 1 }):Play()
		tw:Play()
		tw.Completed:Connect(function() Box:Destroy() end)
	end)
end

function T9ou:AutoSave()
	if not T9ou.AutoSaveEnabled or T9ou.SaveDebounce then return end
	T9ou.SaveDebounce = true
	task.delay(2, function()
		local folder = "T9ou_Configs"
		if not isfolder(folder) then makefolder(folder) end
		pcall(function()
			writefile(folder .. "/autosave.json", HttpService:JSONEncode(T9ou.Options))
		end)
		T9ou.SaveDebounce = false
	end)
end

local function LoadAutoSave()
	local path = "T9ou_Configs/autosave.json"
	if isfile(path) then
		local Success, Data = pcall(function() return HttpService:JSONDecode(readfile(path)) end)
		if Success and type(Data) == "table" then
			for k, v in pairs(Data) do
				T9ou.Options[k] = v
			end
		end
	end
end
LoadAutoSave()

function T9ou:SaveConfig(Name)
	local folder = "T9ou_Configs"
	if not isfolder(folder) then makefolder(folder) end
	writefile(folder .. "/" .. Name .. ".json", HttpService:JSONEncode(T9ou.Options))
	writefile(folder .. "/.last", Name)
	self:Notify("Config", "Saved: " .. Name)
	if self.RefreshConfigList then self.RefreshConfigList() end
end

function T9ou:LoadConfig(Name)
	local path = "T9ou_Configs/" .. Name .. ".json"
	if isfile(path) then
		local Success, Data = pcall(function() return HttpService:JSONDecode(readfile(path)) end)
		if Success then
			for k, v in pairs(Data) do
				T9ou.Options[k] = v
				if T9ou.Elements[k] then pcall(T9ou.Elements[k], v) end
			end
			writefile("T9ou_Configs/.last", Name)
			self:Notify("Config", "Loaded: " .. Name)
		end
	else
		self:Notify("Config", "File not found!")
	end
end

function T9ou:CreateConfigTab(Tab)
	local function Build()
		T9ou:Divider(Tab, "Save & Load")

		local InputHolder = Create("Frame", { Parent = Tab.Page, Size = UDim2.new(1, 0, 0, 34), BackgroundColor3 = Theme.BgPanel })
		Corner(InputHolder, 6)
		Create("UIStroke", { Color = Color3.fromRGB(50, 50, 60), Thickness = 1, Transparency = 0.5, Parent = InputHolder })
		
		local Input = Create("TextBox", { Parent = InputHolder, Position = UDim2.fromOffset(10, 0), Size = UDim2.new(1, -100, 1, 0), BackgroundTransparency = 1, Text = "", PlaceholderText = "Config Name...", TextColor3 = Theme.TextMain, PlaceholderColor3 = Theme.TextDim, Font = Theme.Font, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, ClearTextOnFocus = false })
		local SaveBtn = Create("TextButton", { Parent = InputHolder, Position = UDim2.new(1, -80, 0.5, -12), Size = UDim2.fromOffset(70, 24), BackgroundColor3 = Theme.Accent, Text = "Save", TextColor3 = Theme.TextMain, Font = Theme.FontBold, TextSize = 12, AutoButtonColor = false })
		Corner(SaveBtn, 4)

		SaveBtn.MouseButton1Click:Connect(function()
			if Input.Text ~= "" then
				T9ou:SaveConfig(Input.Text)
				Input.Text = ""
			end
		end)

		local List = Create("ScrollingFrame", { Parent = Tab.Page, Size = UDim2.new(1, 0, 0, 180), BackgroundColor3 = Theme.BgPanel, BorderSizePixel = 0, ScrollBarThickness = 2, ScrollBarImageColor3 = Theme.Accent, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y })
		Corner(List, 8)
		Create("UIStroke", { Color = Color3.fromRGB(50, 50, 60), Thickness = 1, Transparency = 0.5, Parent = List })
		Create("UIPadding", { Parent = List, PaddingTop = UDim.new(0, 6), PaddingBottom = UDim.new(0, 6), PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6) })
		Create("UIListLayout", { Parent = List, Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder })

		local function RefreshList()
			for _, child in ipairs(List:GetChildren()) do
				if child:IsA("TextButton") then child:Destroy() end
			end

			local files = listfiles("T9ou_Configs")
			local found = false
			for _, file in ipairs(files) do
				if string.sub(file, -5) == ".json" and file ~= "autosave.json" then
					found = true
					local name = string.gsub(file, "%.json$", "")
					local Row = Create("Frame", { Parent = List, Size = UDim2.new(1, 0, 0, 30), BackgroundColor3 = Theme.BgElement })
					Corner(Row, 6)
					Create("TextLabel", { Parent = Row, Position = UDim2.fromOffset(10, 0), Size = UDim2.new(1, -70, 1, 0), BackgroundTransparency = 1, Text = name, TextColor3 = Theme.TextMain, Font = Theme.Font, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left })
					
					local LoadBtn = Create("TextButton", { Parent = Row, Position = UDim2.new(1, -60, 0.5, -10), Size = UDim2.fromOffset(40, 20), BackgroundColor3 = Theme.Accent, Text = "Load", TextColor3 = Theme.TextMain, Font = Theme.FontBold, TextSize = 10, AutoButtonColor = false })
					Corner(LoadBtn, 4)
					local DelBtn = Create("TextButton", { Parent = Row, Position = UDim2.new(1, -18, 0.5, -10), Size = UDim2.fromOffset(16, 20), BackgroundColor3 = Color3.fromRGB(200, 50, 50), Text = "X", TextColor3 = Theme.TextMain, Font = Theme.FontBold, TextSize = 10, AutoButtonColor = false })
					Corner(DelBtn, 4)

					LoadBtn.MouseButton1Click:Connect(function() T9ou:LoadConfig(name) end)
					DelBtn.MouseButton1Click:Connect(function()
						delfile("T9ou_Configs/" .. file)
						Row:Destroy()
						T9ou:Notify("Config", "Deleted: " .. name)
					end)
				end
			end
			if not found then
				Create("TextLabel", { Parent = List, Size = UDim2.new(1, 0, 0, 30), BackgroundTransparency = 1, Text = "No configs found.", TextColor3 = Theme.TextDim, Font = Theme.Font, TextSize = 12 })
			end
		end
		T9ou.RefreshConfigList = RefreshList
		RefreshList()
	end

	if Tab.Build then table.insert(Tab.BuildQueue, Build) else Build() end
end

function T9ou:ApplySearch(Query)
	local q = string.lower(Query)
	for _, obj in pairs(T9ou.ElementsUI) do
		if not obj or not obj.Parent then continue end
		local searchString = (obj:GetAttribute("SearchText") or ""):lower()
		
		if q == "" then
			obj.Visible = true
		else
			obj.Visible = string.find(searchString, q, 1, true) ~= nil
		end
	end
end

function T9ou:CreateWindow(Config)
	Config = Config or {}
	local Gui = Create("ScreenGui", { Name = "T9ouUI", Parent = gethui and gethui() or LocalPlayer.PlayerGui, ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Global })
	T9ou.Gui = Gui
	NotifContainer.Parent = Gui

	local Main = Create("Frame", {
		Parent = Gui, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(600, 350), BackgroundColor3 = Theme.BgMain, BorderSizePixel = 0, ClipsDescendants = true, BackgroundTransparency = 1, ZIndex = 1
	})
	Corner(Main, 10)
	local MainStroke = Create("UIStroke", { Color = Color3.fromRGB(60, 60, 70), Thickness = 1.5, Transparency = 1, Parent = Main })

	local Scale = Instance.new("UIScale", Main)
	Scale.Scale = 0.8
	task.spawn(function()
		TweenService:Create(Scale, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 }):Play()
		TweenService:Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Quint), { BackgroundTransparency = 0 }):Play()
		TweenService:Create(MainStroke, TweenInfo.new(0.4), { Transparency = 0.2 }):Play()
	end)

	local TopBar = Create("Frame", { Parent = Main, Size = UDim2.new(1, 0, 0, 45), BackgroundTransparency = 1 })
	MakeDraggable(Main, TopBar)

	AddIcon(Config.Icon or "zap", 18, Theme.Accent, TopBar, UDim2.fromOffset(15, 13))
	Create("TextLabel", { Parent = TopBar, Position = UDim2.fromOffset(40, 0), Size = UDim2.new(0, 100, 1, 0), BackgroundTransparency = 1, Text = Config.Title or "T9ou", TextColor3 = Theme.TextMain, Font = Theme.FontBold, TextSize = 15, TextXAlignment = Enum.TextXAlignment.Left })

	local SearchBox = Create("TextBox", { Parent = TopBar, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0), Size = UDim2.new(0, 150, 0, 24), BackgroundColor3 = Theme.BgElement, Text = "", PlaceholderText = "Search...", TextColor3 = Theme.TextMain, PlaceholderColor3 = Theme.TextDim, Font = Theme.Font, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left })
	Corner(SearchBox, 6)
	Create("UIPadding", { Parent = SearchBox, PaddingLeft = UDim.new(0, 8) })
	Create("UIStroke", { Color = Color3.fromRGB(50, 50, 60), Thickness = 1, Transparency = 0.5, Parent = SearchBox })
	
	SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
		T9ou:ApplySearch(SearchBox.Text)
	end)
	SearchBox.Focused:Connect(function() TweenService:Create(SearchBox.UIStroke, Theme.TweenInfo, {Color = Theme.Accent, Transparency = 0}):Play() end)
	SearchBox.FocusLost:Connect(function() TweenService:Create(SearchBox.UIStroke, Theme.TweenInfo, {Color = Color3.fromRGB(50, 50, 60), Transparency = 0.5}):Play() end)

	local CollapseBtn = Create("TextButton", { Parent = TopBar, Position = UDim2.new(1, -65, 0.5, -10), Size = UDim2.fromOffset(20, 20), BackgroundColor3 = Theme.BgElement, Text = "-", TextColor3 = Theme.TextDim, Font = Theme.FontBold, TextSize = 16, AutoButtonColor = false })
	Corner(CollapseBtn, 6)

	local CloseBtn = Create("TextButton", { Parent = TopBar, Position = UDim2.new(1, -35, 0.5, -10), Size = UDim2.fromOffset(20, 20), BackgroundColor3 = Theme.BgElement, Text = "×", TextColor3 = Theme.TextDim, Font = Theme.FontBold, TextSize = 16, AutoButtonColor = false })
	Corner(CloseBtn, 6)

	CloseBtn.MouseEnter:Connect(function() TweenService:Create(CloseBtn, Theme.TweenInfo, {BackgroundColor3 = Theme.Accent, TextColor3 = Theme.TextMain}):Play() end)
	CloseBtn.MouseLeave:Connect(function() TweenService:Create(CloseBtn, Theme.TweenInfo, {BackgroundColor3 = Theme.BgElement, TextColor3 = Theme.TextDim}):Play() end)
	CloseBtn.MouseButton1Click:Connect(function() Gui:Destroy() end)

	local ResizeGrip = Create("TextButton", { Parent = Main, Position = UDim2.new(1, -24, 1, -24), Size = UDim2.fromOffset(24, 24), BackgroundTransparency = 1, Text = "" })
	AddIcon("move-diagonal", 14, Theme.TextDim, ResizeGrip, UDim2.fromOffset(5, 5))
	local isResizing = false
	local startSize, startInput = nil, nil

	ResizeGrip.InputBegan:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
			isResizing = true
			startSize = Main.AbsoluteSize
			startInput = Input.Position
		end
	end)

	UserInputService.InputChanged:Connect(function(Input)
		if isResizing and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
			local Delta = Input.Position - startInput
			local scaleFactor = Scale.Scale or 1
			local newX = math.clamp((startSize.X + Delta.X) / scaleFactor, 400, 1200)
			local newY = math.clamp((startSize.Y + Delta.Y) / scaleFactor, 300, 1000)
			Main.Size = UDim2.fromOffset(newX, newY)
		end
	end)

	UserInputService.InputEnded:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
			isResizing = false
		end
	end)

	local NavContainer = Create("Frame", { Parent = Main, Position = UDim2.fromOffset(10, 50), Size = UDim2.new(1, -20, 0, 32), BackgroundTransparency = 1 })
	local NavBar = Create("ScrollingFrame", { Parent = NavContainer, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ScrollBarThickness = 0, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.X })
	Create("UIListLayout", { Parent = NavBar, FillDirection = Enum.FillDirection.Horizontal, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6) })

	local TabIndicator = Create("Frame", { Parent = NavContainer, Position = UDim2.fromOffset(0, 30), Size = UDim2.fromOffset(0, 2), BackgroundColor3 = Theme.Accent, BorderSizePixel = 0, ZIndex = 5 })
	Corner(TabIndicator, 1)

	local Content = Create("ScrollingFrame", { Parent = Main, Position = UDim2.fromOffset(10, 88), Size = UDim2.new(1, -20, 1, -132), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 2, ScrollBarImageColor3 = Theme.Accent, AutomaticCanvasSize = Enum.AutomaticSize.Y, CanvasSize = UDim2.new() })
	Create("UIListLayout", { Parent = Content, Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder })

	local Footer = Create("Frame", { Parent = Main, Position = UDim2.new(0, 10, 1, -40), Size = UDim2.new(1, -20, 0, 25), BackgroundTransparency = 1 })
	local AvatarFrame = Create("Frame", { Parent = Footer, Position = UDim2.fromOffset(0, 1), Size = UDim2.fromOffset(22, 22), BackgroundColor3 = Theme.BgElement, BorderSizePixel = 0 })
	Corner(AvatarFrame, 11)
	Create("UIStroke", { Color = Theme.Accent, Thickness = 1.5, Parent = AvatarFrame })
	Create("ImageLabel", { Parent = AvatarFrame, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=48&h=48", ScaleType = Enum.ScaleType.Crop })
	Corner(AvatarFrame:FindFirstChildOfClass("ImageLabel"), 11)
	Create("TextLabel", { Parent = Footer, Position = UDim2.fromOffset(28, 0), Size = UDim2.new(0, 80, 1, 0), BackgroundTransparency = 1, Text = LocalPlayer.Name, TextColor3 = Theme.TextDim, Font = Theme.Font, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left })

	local StatusFrame = Create("Frame", { Parent = Footer, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0), Size = UDim2.fromOffset(80, 20), BackgroundColor3 = Theme.Accent, BackgroundTransparency = 0.85, BorderSizePixel = 0 })
	Corner(StatusFrame, 10)
	Create("UIStroke", { Color = Theme.Accent, Thickness = 1, Transparency = 0.3, Parent = StatusFrame })
	local StatusText = Create("TextLabel", { Parent = StatusFrame, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "Testing", TextColor3 = Theme.Accent, Font = Theme.FontBold, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Center })
	Create("TextLabel", { Parent = Footer, Position = UDim2.new(1, -50, 0, 0), Size = UDim2.fromOffset(50, 25), BackgroundTransparency = 1, Text = "v1.0.0", TextColor3 = Theme.TextDim, Font = Theme.FontBold, TextSize = 10, TextXAlignment = Enum.TextXAlignment.Right })

	self.Gui, self.Main, self.NavBar, self.Content, self.StatusText, self.StatusFrame, self.TabIndicator = Gui, Main, NavBar, Content, StatusText, StatusFrame, TabIndicator

	UserInputService.InputBegan:Connect(function(Input, GPE)
		if GPE then return end
		if Input.KeyCode == Enum.KeyCode.RightShift then
			Gui.Enabled = not Gui.Enabled
		end
	end)

	local Collapsed = false
	local LastSize = UDim2.fromOffset(600, 350)
	
	-- Create a floating icon that will show when collapsed
	local FloatingIcon = Create("TextButton", { 
		Parent = Gui, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), 
		Size = UDim2.fromOffset(45, 45), BackgroundColor3 = Theme.BgMain, Visible = false, AutoButtonColor = false, Text = "" 
	})
	Corner(FloatingIcon, 22)
	Create("UIStroke", { Color = Theme.Accent, Thickness = 2, Parent = FloatingIcon })
	FloatingIcon.Text = ""
	
	local FloatIconImg = AddIcon(Config.Icon or "zap", 22, Theme.Accent, FloatingIcon, UDim2.new(0.5, -11, 0.5, -11))
	if FloatIconImg then FloatIconImg.ZIndex = 10 end
	
	MakeDraggable(FloatingIcon, FloatingIcon)

	FloatingIcon.MouseButton1Click:Connect(function()
		FloatingIcon.Visible = false
		Main.Visible = true
		CollapseBtn.Text = "-"
		TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {Size = LastSize, Position = UDim2.fromScale(0.5, 0.5)}):Play()
		
		task.delay(0.3, function() 
			NavContainer.Visible = true
			Content.Visible = true
			Footer.Visible = true
			ResizeGrip.Visible = true 
			SearchBox.Visible = true
		end)
	end)

	CollapseBtn.MouseButton1Click:Connect(function()
		Collapsed = not Collapsed
		if Collapsed then
			LastSize = UDim2.fromOffset(Main.Size.X.Offset, Main.Size.Y.Offset)
			Main.Visible = false
			FloatingIcon.Visible = true
		else
			CollapseBtn.Text = "-"
			TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {Size = LastSize, Position = UDim2.fromScale(0.5, 0.5)}):Play()
			task.delay(0.3, function() 
				NavContainer.Visible = true
				Content.Visible = true
				Footer.Visible = true
				ResizeGrip.Visible = true 
				SearchBox.Visible = true
			end)
		end
	end)

	-- Auto-load last config
	task.delay(0.5, function()
		if isfile("T9ou_Configs/.last") then
			local last = readfile("T9ou_Configs/.last")
			if last and last ~= "" then
				T9ou:LoadConfig(last)
			end
		end
	end)

	return self
end

function T9ou:SetFooter(Text)
	if self.StatusText then
		self.StatusText.Text = tostring(Text)
		local textSize = self.StatusText.TextBounds.X
		local newWidth = math.max(textSize + 24, 60)
		TweenService:Create(self.StatusFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quint), {Size = UDim2.fromOffset(newWidth, 20)}):Play()
	end
end

function T9ou:Tab(Name, IconName)
	local Btn = Create("TextButton", { Parent = self.NavBar, Size = UDim2.new(0, 95, 1, 0), BackgroundColor3 = Color3.new(1,1,1), Text = "", AutoButtonColor = false, BorderSizePixel = 0 })
	Corner(Btn, 6)
	local Gradient = Create("UIGradient", { Color = ColorSequence.new(Theme.BgPanel), Rotation = 45, Parent = Btn })
	local BtnStroke = Create("UIStroke", { Color = Color3.fromRGB(60, 60, 70), Thickness = 1, Transparency = 0.7, Parent = Btn })

	local Icon = AddIcon(IconName, 14, Theme.TextDim, Btn, UDim2.fromOffset(10, 9))
	local Label = Create("TextLabel", { Parent = Btn, Position = UDim2.fromOffset(Icon and 30 or 10, 0), Size = UDim2.new(1, -30, 1, 0), BackgroundTransparency = 1, Text = Name, TextColor3 = Theme.TextDim, Font = Theme.FontBold, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 2 })
	Label.Name = "IgnoreSearch"

	local Page = Create("Frame", { Parent = self.Content, Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.Y, Visible = false })
	Create("UIListLayout", { Parent = Page, Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder })

	local BuildQueue = {}
	local IsBuilt = false
	local function BuildUI()
		if IsBuilt then return end
		IsBuilt = true
		for _, func in ipairs(BuildQueue) do func() end
		BuildQueue = {}
	end

	local TabObj = { Button = Btn, Label = Label, Icon = Icon, Page = Page, Stroke = BtnStroke, Gradient = Gradient, BuildQueue = BuildQueue, Build = BuildUI, IsBuilt = false }

	local function Select()
		for _, t in pairs(self.Tabs) do
			TweenService:Create(t.Stroke, Theme.TweenInfo, {Color = Color3.fromRGB(60, 60, 70), Transparency = 0.7}):Play()
			TweenService:Create(t.Label, Theme.TweenInfo, {TextColor3 = Theme.TextDim}):Play()
			if t.Icon then TweenService:Create(t.Icon, Theme.TweenInfo, {ImageColor3 = Theme.TextDim}):Play() end
			t.Gradient.Color = ColorSequence.new(Theme.BgPanel)
			t.Page.Visible = false
		end
		TweenService:Create(BtnStroke, Theme.TweenInfo, {Color = Theme.Accent, Transparency = 0.2}):Play()
		TweenService:Create(Label, Theme.TweenInfo, {TextColor3 = Theme.TextMain}):Play()
		if Icon then TweenService:Create(Icon, Theme.TweenInfo, {ImageColor3 = Theme.Accent}):Play() end
		Gradient.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Theme.BgElement),
			ColorSequenceKeypoint.new(0.6, Theme.BgElement),
			ColorSequenceKeypoint.new(1, Theme.Accent)
		})
		Page.Visible = true
		TweenService:Create(self.TabIndicator, Theme.TweenInfo, {
			Position = UDim2.fromOffset(Btn.AbsolutePosition.X - self.NavBar.AbsolutePosition.X, 30),
			Size = UDim2.fromOffset(Btn.AbsoluteSize.X, 2)
		}):Play()
		if TabObj.Build then TabObj.Build() end
	end

	Btn.MouseButton1Click:Connect(function() self.CurrentTab = TabObj; Select() end)
	table.insert(self.Tabs, TabObj)
	if #self.Tabs == 1 then
		self.CurrentTab = TabObj
		task.delay(0.1, Select)
	end
	return TabObj
end

function T9ou:Divider(Tab, Text)
	local function Build()
		local Holder = Create("Frame", { Parent = Tab.Page, Size = UDim2.new(1, 0, 0, 24), BackgroundTransparency = 1 })
		local Line = Create("Frame", { Parent = Holder, Position = UDim2.new(0, 0, 0.5, 0), Size = UDim2.new(1, 0, 0, 1), BackgroundColor3 = Color3.fromRGB(50, 50, 60), BorderSizePixel = 0 })
		if Text then
			local Label = Create("TextLabel", { Parent = Holder, Position = UDim2.new(0, 10, 0, 4), Size = UDim2.fromOffset(100, 16), BackgroundTransparency = 0, BackgroundColor3 = Theme.BgMain, Text = Text, TextColor3 = Theme.TextDim, Font = Theme.FontBold, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left })
			Label.Size = UDim2.fromOffset(Label.TextBounds.X + 10, 16)
		end
	end
	if Tab.Build then table.insert(Tab.BuildQueue, Build) else Build() end
end

local function ApplyDependency(Tab, Holder, MainObj, Config)
	if not Config.Dependency then return end
	local DepFlag = Config.Dependency
	local function CheckState()
		local isDepEnabled = T9ou.Options[DepFlag]
		TweenService:Create(Holder, TweenInfo.new(0.2), {BackgroundTransparency = isDepEnabled and 0 or 0.6}):Play()
		Holder.Active = isDepEnabled
		Holder.Interactable = isDepEnabled
		for _, child in ipairs(Holder:GetDescendants()) do
			if child:IsA("TextLabel") or child:IsA("TextBox") then
				TweenService:Create(child, TweenInfo.new(0.2), {TextTransparency = isDepEnabled and 0 or 0.6}):Play()
			elseif child:IsA("ImageLabel") then
				TweenService:Create(child, TweenInfo.new(0.2), {ImageTransparency = isDepEnabled and 0 or 0.6}):Play()
			elseif child:IsA("UIStroke") then
				TweenService:Create(child, TweenInfo.new(0.2), {Transparency = isDepEnabled and (child:GetAttribute("OrigTrans") or 0.5) or 0.8}):Play()
			end
		end
	end
	CheckState()
	if not T9ou.DependencyListeners[DepFlag] then T9ou.DependencyListeners[DepFlag] = {} end
	table.insert(T9ou.DependencyListeners[DepFlag], CheckState)
end

function T9ou:Toggle(Tab, Config)
	local function Build()
		local Flag = Config.Flag or Config.Name
		local State = T9ou.Options[Flag] ~= nil and T9ou.Options[Flag] or (Config.Default or false)
		local Holder = Create("TextButton", { Parent = Tab.Page, Size = UDim2.new(1, 0, 0, 32), BackgroundColor3 = Theme.BgPanel, Text = "", AutoButtonColor = false })
		
		Holder:SetAttribute("SearchText", Config.Name or "Toggle")
		table.insert(T9ou.ElementsUI, Holder)
		
		Corner(Holder, 6)
		local Stroke = Create("UIStroke", { Color = Color3.fromRGB(50, 50, 60), Thickness = 1, Transparency = 0.5, Parent = Holder })

		local Icon = AddIcon(Config.Icon or "box", 14, State and Theme.Accent or Theme.TextDim, Holder, UDim2.fromOffset(10, 9))
		local Label = Create("TextLabel", { Parent = Holder, Position = UDim2.fromOffset(32, 0), Size = UDim2.new(1, -70, 1, 0), BackgroundTransparency = 1, Text = Config.Name or "Toggle", TextColor3 = Theme.TextDim, Font = Theme.Font, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left })

		local Switch = Create("Frame", { Parent = Holder, Position = UDim2.new(1, -42, 0.5, -8), Size = UDim2.fromOffset(32, 16), BackgroundColor3 = State and Theme.Accent or Color3.fromRGB(45, 45, 55), BorderSizePixel = 0 })
		Corner(Switch, 8)
		Create("UIStroke", { Color = Color3.fromRGB(25, 25, 35), Thickness = 1, Parent = Switch })

		local Knob = Create("Frame", { Parent = Switch, Position = State and UDim2.new(1, -14, 0, 2) or UDim2.fromOffset(2, 2), Size = UDim2.fromOffset(12, 12), BackgroundColor3 = Color3.new(1,1,1), BorderSizePixel = 0 })
		Corner(Knob, 6)

		local function SetState(NewState)
			State = NewState
			TweenService:Create(Switch, Theme.TweenInfo, {BackgroundColor3 = State and Theme.Accent or Color3.fromRGB(45, 45, 55)}):Play()
			TweenService:Create(Knob, Theme.TweenInfo, {Position = State and UDim2.new(1, -14, 0, 2) or UDim2.fromOffset(2, 2)}):Play()
			if Icon then TweenService:Create(Icon, Theme.TweenInfo, {ImageColor3 = State and Theme.Accent or Theme.TextDim}):Play() end
			T9ou.Options[Flag] = State
			T9ou:AutoSave()
		end

		SetState(State)
		T9ou.Options[Flag] = State
		T9ou.Elements[Flag] = function(val) SetState(val) end

		Holder.MouseEnter:Connect(function()
			TweenService:Create(Holder, Theme.TweenInfo, {BackgroundColor3 = Theme.BgHover}):Play()
			TweenService:Create(Stroke, Theme.TweenInfo, {Color = Theme.Accent, Transparency = 0.5}):Play()
			TweenService:Create(Label, Theme.TweenInfo, {TextColor3 = Theme.TextMain}):Play()
		end)
		Holder.MouseLeave:Connect(function()
			TweenService:Create(Holder, Theme.TweenInfo, {BackgroundColor3 = Theme.BgPanel}):Play()
			TweenService:Create(Stroke, Theme.TweenInfo, {Color = Color3.fromRGB(50, 50, 60), Transparency = 0.5}):Play()
			TweenService:Create(Label, Theme.TweenInfo, {TextColor3 = Theme.TextDim}):Play()
		end)

		Holder.MouseButton1Click:Connect(function()
			SetState(not State)
			if Config.Callback then task.spawn(Config.Callback, State) end
			if T9ou.DependencyListeners[Flag] then
				for _, listener in ipairs(T9ou.DependencyListeners[Flag]) do task.spawn(listener) end
			end
		end)
		ApplyDependency(Tab, Holder, Holder, Config)
	end
	if Tab.BuildQueue then table.insert(Tab.BuildQueue, Build) else Build() end
end

function T9ou:Slider(Tab, Config)
	local function Build()
		local Min, Max = Config.Min or 0, Config.Max or 100
		local Flag = Config.Flag or Config.Name
		local Value = T9ou.Options[Flag] ~= nil and T9ou.Options[Flag] or (Config.Default or Min)

		local Holder = Create("Frame", { Parent = Tab.Page, Size = UDim2.new(1, 0, 0, 56), BackgroundColor3 = Theme.BgPanel, BorderSizePixel = 0 })
		Holder:SetAttribute("SearchText", Config.Name or "Slider")
		table.insert(T9ou.ElementsUI, Holder)
		Corner(Holder, 8)
		local Stroke = Create("UIStroke", { Color = Color3.fromRGB(50, 50, 60), Thickness = 1, Transparency = 0.5, Parent = Holder })

		local Icon = AddIcon(Config.Icon or "sliders", 14, Theme.TextDim, Holder, UDim2.fromOffset(12, 10))
		Create("TextLabel", { Parent = Holder, Position = UDim2.fromOffset(34, 10), Size = UDim2.new(1, -110, 0, 16), BackgroundTransparency = 1, Text = Config.Name or "Slider", TextColor3 = Theme.TextMain, Font = Theme.FontBold, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left })

		local Box = Create("TextBox", { Parent = Holder, Position = UDim2.new(1, -72, 0, 8), Size = UDim2.fromOffset(60, 20), BackgroundColor3 = Theme.BgElement, Text = tostring(Value), TextColor3 = Theme.Accent, Font = Theme.FontCode, TextSize = 11, ClearTextOnFocus = false })
		Corner(Box, 6)
		Create("UIStroke", { Color = Theme.Accent, Thickness = 1, Transparency = 0.5, Parent = Box })

		local Bar = Create("Frame", { Parent = Holder, Position = UDim2.fromOffset(12, 40), Size = UDim2.new(1, -24, 0, 8), BackgroundColor3 = Color3.fromRGB(10, 10, 14), BorderSizePixel = 0, ClipsDescendants = false })
		Corner(Bar, 4)
		Create("UIStroke", { Color = Color3.fromRGB(35, 35, 45), Thickness = 1, Parent = Bar })

		local Fill = Create("Frame", { Parent = Bar, Size = UDim2.new((Value - Min) / (Max - Min), 0, 1, 0), BackgroundColor3 = Theme.Accent, BorderSizePixel = 0 })
		Corner(Fill, 4)

		local Knob = Create("Frame", { Parent = Bar, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new((Value - Min) / (Max - Min), 0, 0.5, 0), Size = UDim2.fromOffset(14, 14), BackgroundColor3 = Theme.Accent, BorderSizePixel = 0, ZIndex = 5 })
		Corner(Knob, 7)
		Create("UIStroke", { Color = Color3.new(1,1,1), Thickness = 2, Parent = Knob })

		local KnobGlow = Create("Frame", { Parent = Knob, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(26, 26), BackgroundColor3 = Theme.Accent, BackgroundTransparency = 0.7, BorderSizePixel = 0, ZIndex = 4 })
		Corner(KnobGlow, 13)

		local function SetValue(NewVal)
			NewVal = math.clamp(math.floor(NewVal), Min, Max)
			local Rel = (NewVal - Min) / (Max - Min)
			Fill.Size = UDim2.new(Rel, 0, 1, 0)
			Knob.Position = UDim2.new(Rel, 0, 0.5, 0)
			Box.Text = tostring(NewVal)
			T9ou.Options[Flag] = NewVal
			T9ou:AutoSave()
		end

		T9ou.Options[Flag] = Value
		T9ou.Elements[Flag] = function(val)
			SetValue(val)
			if Config.Callback then task.spawn(Config.Callback, val) end
		end

		Box.FocusLost:Connect(function()
			local num = tonumber(Box.Text)
			if num then
				SetValue(num)
				if Config.Callback then task.spawn(Config.Callback, T9ou.Options[Flag]) end
			else
				Box.Text = tostring(T9ou.Options[Flag])
			end
		end)

		local DragArea = Create("TextButton", { Parent = Holder, Position = UDim2.fromOffset(0, 28), Size = UDim2.new(1, 0, 0, 28), BackgroundTransparency = 1, Text = "" })
		local Dragging = false

		DragArea.MouseButton1Down:Connect(function()
			Dragging = true
			TweenService:Create(Knob, TweenInfo.new(0.15, Enum.EasingStyle.Quint), {Size = UDim2.fromOffset(18, 18)}):Play()
			TweenService:Create(KnobGlow, TweenInfo.new(0.15), {BackgroundTransparency = 0.5}):Play()
			local Rel = math.clamp((UserInputService:GetMouseLocation().X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
			SetValue(Min + (Max - Min) * Rel)
		end)

		UserInputService.InputEnded:Connect(function(I)
			if I.UserInputType == Enum.UserInputType.MouseButton1 or I.UserInputType == Enum.UserInputType.Touch then
				Dragging = false
				TweenService:Create(Knob, TweenInfo.new(0.2, Enum.EasingStyle.Quint), {Size = UDim2.fromOffset(14, 14)}):Play()
				TweenService:Create(KnobGlow, TweenInfo.new(0.2), {BackgroundTransparency = 0.7}):Play()
				if Config.Callback then task.spawn(Config.Callback, T9ou.Options[Flag]) end
			end
		end)

		RunService.RenderStepped:Connect(function()
			if Dragging then
				local Rel = math.clamp((UserInputService:GetMouseLocation().X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
				SetValue(Min + (Max - Min) * Rel)
			end
		end)
		ApplyDependency(Tab, Holder, Holder, Config)
	end
	if Tab.BuildQueue then table.insert(Tab.BuildQueue, Build) else Build() end
end

function T9ou:Button(Tab, Config)
	local function Build()
		local Btn = Create("TextButton", { Parent = Tab.Page, Size = UDim2.new(1, 0, 0, 32), BackgroundColor3 = Theme.BgPanel, Text = "", AutoButtonColor = false })
		Btn:SetAttribute("SearchText", Config.Name or "Button")
		table.insert(T9ou.ElementsUI, Btn)
		
		Corner(Btn, 6)
		local Stroke = Create("UIStroke", { Color = Color3.fromRGB(50, 50, 60), Thickness = 1, Transparency = 0.5, Parent = Btn })

		local Icon = AddIcon(Config.Icon or "mouse-pointer", 14, Theme.TextDim, Btn, UDim2.fromOffset(10, 9))
		local Label = Create("TextLabel", { Parent = Btn, Position = UDim2.fromOffset(32, 0), Size = UDim2.new(1, -32, 1, 0), BackgroundTransparency = 1, Text = Config.Name or "Button", TextColor3 = Theme.TextDim, Font = Theme.Font, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left })

		Btn.MouseEnter:Connect(function()
			TweenService:Create(Btn, Theme.TweenInfo, {BackgroundColor3 = Theme.BgHover}):Play()
			TweenService:Create(Stroke, Theme.TweenInfo, {Color = Theme.Accent, Transparency = 0.5}):Play()
			TweenService:Create(Label, Theme.TweenInfo, {TextColor3 = Theme.TextMain}):Play()
		end)
		Btn.MouseLeave:Connect(function()
			TweenService:Create(Btn, Theme.TweenInfo, {BackgroundColor3 = Theme.BgPanel}):Play()
			TweenService:Create(Stroke, Theme.TweenInfo, {Color = Color3.fromRGB(50, 50, 60), Transparency = 0.5}):Play()
			TweenService:Create(Label, Theme.TweenInfo, {TextColor3 = Theme.TextDim}):Play()
		end)

		Btn.MouseButton1Click:Connect(function()
			if Config.Callback then task.spawn(Config.Callback) end
		end)
		ApplyDependency(Tab, Btn, Btn, Config)
	end
	if Tab.BuildQueue then table.insert(Tab.BuildQueue, Build) else Build() end
end

function T9ou:Dropdown(Tab, Config)
	local function Build()
		local Options = Config.Options or {"Option 1", "Option 2"}
		local IsMulti = Config.Multi or false
		local Flag = Config.Flag or Config.Name

		local Selected = T9ou.Options[Flag]
		if Selected == nil then
			if IsMulti then
				Selected = Config.Default or {}
				if type(Selected) ~= "table" then Selected = {} end
			else
				Selected = Config.Default or Options[1]
			end
		else
			if IsMulti and type(Selected) ~= "table" then Selected = {} end
			if not IsMulti and type(Selected) == "table" then Selected = Options[1] end
		end

		local Container = Create("Frame", { Parent = Tab.Page, Size = UDim2.new(1, 0, 0, 34), BackgroundTransparency = 1, ClipsDescendants = false, ZIndex = 5 })
		Container:SetAttribute("SearchText", Config.Name or "Dropdown")
		table.insert(T9ou.ElementsUI, Container)
		
		local Holder = Create("TextButton", { Parent = Container, Size = UDim2.new(1, 0, 0, 34), BackgroundColor3 = Theme.BgPanel, Text = "", AutoButtonColor = false, ZIndex = 6 })
		Corner(Holder, 8)
		local Stroke = Create("UIStroke", { Color = Color3.fromRGB(50, 50, 60), Thickness = 1, Transparency = 0.5, Parent = Holder })

		local Icon = AddIcon(Config.Icon or "list", 14, Theme.TextDim, Holder, UDim2.fromOffset(12, 10))
		local Label = Create("TextLabel", { Parent = Holder, Position = UDim2.fromOffset(34, 0), Size = UDim2.new(1, -110, 1, 0), BackgroundTransparency = 1, Text = Config.Name or "Dropdown", TextColor3 = Theme.TextDim, Font = Theme.Font, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 7 })

		local SelChip = Create("Frame", { Parent = Holder, Position = UDim2.new(1, -118, 0.5, -10), Size = UDim2.fromOffset(84, 20), BackgroundColor3 = Theme.Accent, BackgroundTransparency = 0.85, BorderSizePixel = 0, ZIndex = 7 })
		Corner(SelChip, 6)
		Create("UIStroke", { Color = Theme.Accent, Thickness = 1, Transparency = 0.4, Parent = SelChip })
		local ValueLabel = Create("TextLabel", { Parent = SelChip, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "", TextColor3 = Theme.Accent, Font = Theme.FontBold, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Center, ZIndex = 8 })

		local Arrow = AddIcon("chevron-down", 12, Theme.TextDim, Holder, UDim2.new(1, -22, 0.5, -6))

		local Panel = Create("Frame", { Parent = Container, Position = UDim2.new(0, 0, 0, 40), Size = UDim2.new(1, 0, 0, 0), BackgroundColor3 = Theme.BgElement, BorderSizePixel = 0, Visible = false, ZIndex = 50, ClipsDescendants = true, BackgroundTransparency = 1 })
		Corner(Panel, 10)
		local PanelStroke = Create("UIStroke", { Color = Theme.Accent, Thickness = 1, Transparency = 1, Parent = Panel })
		Create("UIGradient", { Color = ColorSequence.new(Color3.fromRGB(36, 36, 44), Color3.fromRGB(18, 18, 22)), Rotation = 90, Parent = Panel })

		local List = Create("ScrollingFrame", { Parent = Panel, Size = UDim2.new(1, 0, 1, -6), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 2, ScrollBarImageColor3 = Theme.Accent, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y, Position = UDim2.fromOffset(0, 6) })
		Create("UIListLayout", { Parent = List, Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder })
		Create("UIPadding", { Parent = List, PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6) })

		if #Options > 10 then
			local SearchBox = Create("TextBox", { Parent = Panel, Position = UDim2.fromOffset(6, 6), Size = UDim2.new(1, -12, 0, 24), BackgroundColor3 = Theme.BgPanel, Text = "", PlaceholderText = "Search options...", TextColor3 = Theme.TextMain, PlaceholderColor3 = Theme.TextDim, Font = Theme.Font, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left })
			Corner(SearchBox, 4)
			Create("UIPadding", { Parent = SearchBox, PaddingLeft = UDim.new(0, 6) })
			List.Position = UDim2.fromOffset(0, 36)
			List.Size = UDim2.new(1, 0, 1, -42)
		end

		local function UpdateValueLabel()
			if IsMulti then
				if #Selected == 0 then ValueLabel.Text = "None"
				elseif #Selected == 1 then ValueLabel.Text = Selected[1]
				else ValueLabel.Text = Selected[1] .. " +" .. tostring(#Selected - 1) end
			else
				ValueLabel.Text = tostring(Selected)
			end
		end
		UpdateValueLabel()

		local function GetPanelHeight() 
			local base = #Options * 32 + (#Options - 1) * 2 + 12
			if #Options > 10 then base = base + 30 end
			return math.min(base, 200) 
		end
		local open = false
		local rows = {}

		local function ClosePanel()
			if not Panel.Visible then return end
			TweenService:Create(Panel, TweenInfo.new(0.18, Enum.EasingStyle.Quint, Enum.EasingDirection.In), { Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1 }):Play()
			TweenService:Create(PanelStroke, TweenInfo.new(0.18), { Transparency = 1 }):Play()
			TweenService:Create(Container, TweenInfo.new(0.18, Enum.EasingStyle.Quint, Enum.EasingDirection.In), { Size = UDim2.new(1, 0, 0, 34) }):Play()
			TweenService:Create(Arrow, Theme.TweenInfo, { Rotation = 0 }):Play()
			TweenService:Create(Stroke, Theme.TweenInfo, { Color = Color3.fromRGB(50, 50, 60), Transparency = 0.5 }):Play()
			task.delay(0.18, function() Panel.Visible = false end)
			open = false
		end

		local function OpenPanel()
			Panel.Visible = true
			Panel.Size = UDim2.new(1, 0, 0, 0)
			Panel.BackgroundTransparency = 1
			local h = GetPanelHeight()
			TweenService:Create(Panel, TweenInfo.new(0.26, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { Size = UDim2.new(1, 0, 0, h), BackgroundTransparency = 0 }):Play()
			TweenService:Create(PanelStroke, TweenInfo.new(0.26), { Transparency = 0.4 }):Play()
			TweenService:Create(Container, TweenInfo.new(0.26, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { Size = UDim2.new(1, 0, 0, 34 + h + 6) }):Play()
			TweenService:Create(Arrow, Theme.TweenInfo, { Rotation = 180 }):Play()
			TweenService:Create(Stroke, Theme.TweenInfo, { Color = Theme.Accent, Transparency = 0.3 }):Play()
			open = true
		end

		local function Refresh()
			for opt, row in pairs(rows) do
				local isSel
				if IsMulti then isSel = table.find(Selected, opt) ~= nil else isSel = (opt == Selected) end
				TweenService:Create(row.Dot, Theme.TweenInfo, { BackgroundColor3 = isSel and Theme.Accent or Color3.fromRGB(70, 70, 80) }):Play()
				TweenService:Create(row.DotStroke, Theme.TweenInfo, { Color = isSel and Theme.Accent or Color3.fromRGB(90, 90, 100) }):Play()
				TweenService:Create(row.DotInner, Theme.TweenInfo, { BackgroundColor3 = isSel and Color3.new(1,1,1) or Theme.BgElement, BackgroundTransparency = isSel and 0 or 1 }):Play()
				TweenService:Create(row.Label, Theme.TweenInfo, { TextColor3 = isSel and Theme.TextMain or Theme.TextDim }):Play()
				row.Label.Font = isSel and Theme.FontBold or Theme.Font
				TweenService:Create(row.Bar, Theme.TweenInfo, { BackgroundTransparency = isSel and 0 or 1 }):Play()
				TweenService:Create(row.Btn, Theme.TweenInfo, { BackgroundColor3 = isSel and Color3.fromRGB(46, 46, 56) or Color3.fromRGB(34, 34, 40) }):Play()
				if row.Check then TweenService:Create(row.Check, Theme.TweenInfo, { ImageTransparency = isSel and 0 or 1 }):Play() end
			end
		end

		T9ou.Options[Flag] = Selected
		T9ou.Elements[Flag] = function(val)
			Selected = val
			UpdateValueLabel()
			Refresh()
			if Config.Callback then task.spawn(Config.Callback, val) end
		end

		for i, opt in ipairs(Options) do
			local OptBtn = Create("TextButton", { Parent = List, Size = UDim2.new(1, 0, 0, 32), BackgroundColor3 = Color3.fromRGB(34, 34, 40), Text = "", AutoButtonColor = false, ZIndex = 51, LayoutOrder = i })
			Corner(OptBtn, 8)
			local OptStroke = Create("UIStroke", { Color = Color3.fromRGB(44, 44, 54), Thickness = 1, Transparency = 0.6, Parent = OptBtn })

			local AccentBar = Create("Frame", { Parent = OptBtn, Position = UDim2.fromOffset(0, 8), Size = UDim2.fromOffset(3, 16), BackgroundColor3 = Theme.Accent, BorderSizePixel = 0, BackgroundTransparency = 1, ZIndex = 53 })
			Corner(AccentBar, 2)
			local Dot = Create("Frame", { Parent = OptBtn, Position = UDim2.fromOffset(14, 10), Size = UDim2.fromOffset(12, 12), BackgroundColor3 = Color3.fromRGB(70, 70, 80), BorderSizePixel = 0, ZIndex = 52 })
			Corner(Dot, 6)
			local DotStroke = Create("UIStroke", { Color = Color3.fromRGB(90, 90, 100), Thickness = 1.5, Parent = Dot })
			local DotInner = Create("Frame", { Parent = Dot, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(5, 5), BackgroundColor3 = Theme.BgElement, BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 53 })
			Corner(DotInner, 3)
			local Check = AddIcon("check", 12, Theme.Accent, OptBtn, UDim2.new(1, -24, 0.5, -6))
			if Check then Check.ImageTransparency = 1 end
			local OptLabel = Create("TextLabel", { Parent = OptBtn, Position = UDim2.fromOffset(36, 0), Size = UDim2.new(1, -50, 1, 0), BackgroundTransparency = 1, Text = opt, TextColor3 = Theme.TextDim, Font = Theme.Font, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 52 })

			rows[opt] = { Btn = OptBtn, Dot = Dot, DotStroke = DotStroke, DotInner = DotInner, Label = OptLabel, Bar = AccentBar, Check = Check }

			OptBtn.MouseEnter:Connect(function()
				local isSel = IsMulti and (table.find(Selected, opt) ~= nil) or (Selected == opt)
				if isSel then return end
				TweenService:Create(OptBtn, Theme.TweenInfo, { BackgroundColor3 = Theme.BgHover }):Play()
				TweenService:Create(OptStroke, Theme.TweenInfo, { Color = Theme.Accent, Transparency = 0.6 }):Play()
				TweenService:Create(OptLabel, Theme.TweenInfo, { TextColor3 = Theme.TextMain }):Play()
				TweenService:Create(Dot, Theme.TweenInfo, { BackgroundColor3 = Theme.Accent }):Play()
			end)
			OptBtn.MouseLeave:Connect(function()
				local isSel = IsMulti and (table.find(Selected, opt) ~= nil) or (Selected == opt)
				if isSel then return end
				TweenService:Create(OptBtn, Theme.TweenInfo, { BackgroundColor3 = Color3.fromRGB(34, 34, 40) }):Play()
				TweenService:Create(OptStroke, Theme.TweenInfo, { Color = Color3.fromRGB(44, 44, 54), Transparency = 0.6 }):Play()
				TweenService:Create(OptLabel, Theme.TweenInfo, { TextColor3 = Theme.TextDim }):Play()
				TweenService:Create(Dot, Theme.TweenInfo, { BackgroundColor3 = Color3.fromRGB(70, 70, 80) }):Play()
			end)

			OptBtn.MouseButton1Click:Connect(function()
				if IsMulti then
					local index = table.find(Selected, opt)
					if index then table.remove(Selected, index) else table.insert(Selected, opt) end
					T9ou.Options[Flag] = Selected
					UpdateValueLabel()
					Refresh()
					T9ou:AutoSave()
					if Config.Callback then task.spawn(Config.Callback, Selected) end
				else
					Selected = opt
					T9ou.Options[Flag] = Selected
					UpdateValueLabel()
					Refresh()
					ClosePanel()
					T9ou:AutoSave()
					if Config.Callback then task.spawn(Config.Callback, opt) end
				end
			end)
		end
		Refresh()

		Holder.MouseEnter:Connect(function()
			TweenService:Create(Holder, Theme.TweenInfo, { BackgroundColor3 = Theme.BgHover }):Play()
			TweenService:Create(Stroke, Theme.TweenInfo, { Color = Theme.Accent, Transparency = 0.3 }):Play()
			TweenService:Create(Label, Theme.TweenInfo, { TextColor3 = Theme.TextMain }):Play()
		end)
		Holder.MouseLeave:Connect(function()
			if open then return end
			TweenService:Create(Holder, Theme.TweenInfo, { BackgroundColor3 = Theme.BgPanel }):Play()
			TweenService:Create(Stroke, Theme.TweenInfo, { Color = Color3.fromRGB(50, 50, 60), Transparency = 0.5 }):Play()
			TweenService:Create(Label, Theme.TweenInfo, { TextColor3 = Theme.TextDim }):Play()
		end)

		Holder.MouseButton1Click:Connect(function()
			if open then ClosePanel() else OpenPanel() end
		end)
		ApplyDependency(Tab, Container, Container, Config)
	end
	if Tab.BuildQueue then table.insert(Tab.BuildQueue, Build) else Build() end
end

function T9ou:ColorPicker(Tab, Config)
	local function Build()
		local Flag = Config.Flag or Config.Name
		local defaultColor = Config.Default or Color3.fromRGB(255, 255, 255)
		local currentColor = T9ou.Options[Flag] or defaultColor
		if type(currentColor) == "table" then
			currentColor = Color3.new(currentColor.R or currentColor[1] or 1, currentColor.G or currentColor[2] or 1, currentColor.B or currentColor[3] or 1)
		end

		local Holder = Create("TextButton", { Parent = Tab.Page, Size = UDim2.new(1, 0, 0, 32), BackgroundColor3 = Theme.BgPanel, Text = "", AutoButtonColor = false })
		Holder:SetAttribute("SearchText", Config.Name or "ColorPicker")
		table.insert(T9ou.ElementsUI, Holder)
		
		Corner(Holder, 6)
		local Stroke = Create("UIStroke", { Color = Color3.fromRGB(50, 50, 60), Thickness = 1, Transparency = 0.5, Parent = Holder })

		AddIcon(Config.Icon or "palette", 14, Theme.TextDim, Holder, UDim2.fromOffset(10, 9))
		Create("TextLabel", { Parent = Holder, Position = UDim2.fromOffset(32, 0), Size = UDim2.new(1, -70, 1, 0), BackgroundTransparency = 1, Text = Config.Name or "Color", TextColor3 = Theme.TextDim, Font = Theme.Font, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left })

		local ColorPreview = Create("Frame", { Parent = Holder, Position = UDim2.new(1, -42, 0.5, -8), Size = UDim2.fromOffset(32, 16), BackgroundColor3 = currentColor, BorderSizePixel = 0 })
		Corner(ColorPreview, 4)
		Create("UIStroke", { Color = Color3.fromRGB(25, 25, 35), Thickness = 1, Parent = ColorPreview })

		local Panel = Create("Frame", { Parent = Tab.Page, Size = UDim2.new(1, 0, 0, 0), BackgroundColor3 = Theme.BgElement, BorderSizePixel = 0, Visible = false, ClipsDescendants = true })
		Corner(Panel, 8)
		Create("UIStroke", { Color = Theme.Accent, Thickness = 1, Transparency = 0.5, Parent = Panel })
		Create("UIPadding", { Parent = Panel, PaddingTop = UDim.new(0, 8), PaddingBottom = UDim.new(0, 8), PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8) })
		Create("UIListLayout", { Parent = Panel, Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder })

		local open = false
		local function UpdateColor(c)
			currentColor = c
			ColorPreview.BackgroundColor3 = c
			T9ou.Options[Flag] = {R = c.R, G = c.G, B = c.B}
			T9ou:AutoSave()
			if Config.Callback then task.spawn(Config.Callback, T9ou.Options[Flag]) end
		end

		local HueHolder = Create("Frame", { Parent = Panel, Size = UDim2.new(1, 0, 0, 16), BackgroundTransparency = 1 })
		local HueBar = Create("Frame", { Parent = HueHolder, Position = UDim2.fromOffset(0, 4), Size = UDim2.new(1, 0, 0, 8), BackgroundColor3 = Color3.new(1,1,1), BorderSizePixel = 0 })
		Corner(HueBar, 4)
		Create("UIGradient", { Color = ColorSequence.new{
			ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
			ColorSequenceKeypoint.new(1/6, Color3.fromRGB(255, 255, 0)),
			ColorSequenceKeypoint.new(2/6, Color3.fromRGB(0, 255, 0)),
			ColorSequenceKeypoint.new(3/6, Color3.fromRGB(0, 255, 255)),
			ColorSequenceKeypoint.new(4/6, Color3.fromRGB(0, 0, 255)),
			ColorSequenceKeypoint.new(5/6, Color3.fromRGB(255, 0, 255)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
		}, Rotation = 0, Parent = HueBar })

		local h, s, v = currentColor:ToHSV()
		local HueKnob = Create("Frame", { Parent = HueBar, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(h, 0, 0.5, 0), Size = UDim2.fromOffset(12, 16), BackgroundColor3 = Color3.new(1,1,1), BorderSizePixel = 0 })
		Corner(HueKnob, 4)

		local function UpdateHue(mouseX)
			local rel = math.clamp((mouseX - HueBar.AbsolutePosition.X) / HueBar.AbsoluteSize.X, 0, 1)
			HueKnob.Position = UDim2.new(rel, 0, 0.5, 0)
			UpdateColor(Color3.fromHSV(rel, s, v))
		end

		local HueDragArea = Create("TextButton", { Parent = HueHolder, Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "" })
		local draggingHue = false
		HueDragArea.MouseButton1Down:Connect(function() draggingHue = true; UpdateHue(UserInputService:GetMouseLocation().X) end)
		UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then draggingHue = false end end)
		RunService.RenderStepped:Connect(function() if draggingHue then UpdateHue(UserInputService:GetMouseLocation().X) end end)

		local SatHolder = Create("Frame", { Parent = Panel, Size = UDim2.new(1, 0, 0, 16), BackgroundTransparency = 1 })
		local SatBar = Create("Frame", { Parent = SatHolder, Position = UDim2.fromOffset(0, 4), Size = UDim2.new(1, 0, 0, 8), BackgroundColor3 = Color3.fromHSV(h, 1, 1), BorderSizePixel = 0 })
		Corner(SatBar, 4)
		Create("UIGradient", { Color = ColorSequence.new(Color3.fromHSV(h, 0, v), Color3.fromHSV(h, 1, v)), Rotation = 0, Parent = SatBar })
		
		local SatKnob = Create("Frame", { Parent = SatBar, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(s, 0, 0.5, 0), Size = UDim2.fromOffset(12, 16), BackgroundColor3 = Color3.new(1,1,1), BorderSizePixel = 0 })
		Corner(SatKnob, 4)

		local function UpdateSat(mouseX)
			local rel = math.clamp((mouseX - SatBar.AbsolutePosition.X) / SatBar.AbsoluteSize.X, 0, 1)
			SatKnob.Position = UDim2.new(rel, 0, 0.5, 0)
			UpdateColor(Color3.fromHSV(h, rel, v))
		end

		local SatDragArea = Create("TextButton", { Parent = SatHolder, Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "" })
		local draggingSat = false
		SatDragArea.MouseButton1Down:Connect(function() draggingSat = true; UpdateSat(UserInputService:GetMouseLocation().X) end)
		UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then draggingSat = false end end)
		RunService.RenderStepped:Connect(function() if draggingSat then UpdateSat(UserInputService:GetMouseLocation().X) end end)

		local ValHolder = Create("Frame", { Parent = Panel, Size = UDim2.new(1, 0, 0, 16), BackgroundTransparency = 1 })
		local ValBar = Create("Frame", { Parent = ValHolder, Position = UDim2.fromOffset(0, 4), Size = UDim2.new(1, 0, 0, 8), BackgroundColor3 = Color3.fromHSV(h, s, 1), BorderSizePixel = 0 })
		Corner(ValBar, 4)
		Create("UIGradient", { Color = ColorSequence.new(Color3.new(0,0,0), Color3.fromHSV(h, s, 1)), Rotation = 0, Parent = ValBar })

		local ValKnob = Create("Frame", { Parent = ValBar, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(v, 0, 0.5, 0), Size = UDim2.fromOffset(12, 16), BackgroundColor3 = Color3.new(1,1,1), BorderSizePixel = 0 })
		Corner(ValKnob, 4)

		local function UpdateVal(mouseX)
			local rel = math.clamp((mouseX - ValBar.AbsolutePosition.X) / ValBar.AbsoluteSize.X, 0, 1)
			ValKnob.Position = UDim2.new(rel, 0, 0.5, 0)
			UpdateColor(Color3.fromHSV(h, s, rel))
		end

		local ValDragArea = Create("TextButton", { Parent = ValHolder, Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "" })
		local draggingVal = false
		ValDragArea.MouseButton1Down:Connect(function() draggingVal = true; UpdateVal(UserInputService:GetMouseLocation().X) end)
		UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then draggingVal = false end end)
		RunService.RenderStepped:Connect(function() if draggingVal then UpdateVal(UserInputService:GetMouseLocation().X) end end)

		local function Toggle()
			open = not open
			Panel.Visible = open
			if open then
				Panel.Size = UDim2.fromOffset(0, 70)
				TweenService:Create(Panel, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 70)}):Play()
			else
				TweenService:Create(Panel, TweenInfo.new(0.2), {Size = UDim2.fromOffset(0, 70)}):Play()
			end
		end

		Holder.MouseEnter:Connect(function()
			TweenService:Create(Holder, Theme.TweenInfo, {BackgroundColor3 = Theme.BgHover}):Play()
			TweenService:Create(Stroke, Theme.TweenInfo, {Color = Theme.Accent, Transparency = 0.5}):Play()
		end)
		Holder.MouseLeave:Connect(function()
			TweenService:Create(Holder, Theme.TweenInfo, {BackgroundColor3 = Theme.BgPanel}):Play()
			TweenService:Create(Stroke, Theme.TweenInfo, {Color = Color3.fromRGB(50, 50, 60), Transparency = 0.5}):Play()
		end)

		Holder.MouseButton1Click:Connect(Toggle)
		ApplyDependency(Tab, Holder, Holder, Config)
	end
	if Tab.BuildQueue then table.insert(Tab.BuildQueue, Build) else Build() end
end

function T9ou:Keybind(Tab, Config)
	local function Build()
		local Flag = Config.Flag or Config.Name
		local Key = Enum.KeyCode.RightShift
		if T9ou.Options[Flag] then
			pcall(function() Key = Enum.KeyCode[T9ou.Options[Flag]] end)
		elseif Config.Default then
			Key = Config.Default
		end

		local Holder = Create("TextButton", { Parent = Tab.Page, Size = UDim2.new(1, 0, 0, 32), BackgroundColor3 = Theme.BgPanel, Text = "", AutoButtonColor = false })
		Holder:SetAttribute("SearchText", Config.Name or "Keybind")
		table.insert(T9ou.ElementsUI, Holder)
		
		Corner(Holder, 6)
		Create("UIStroke", { Color = Color3.fromRGB(50, 50, 60), Thickness = 1, Transparency = 0.5, Parent = Holder })

		local Icon = AddIcon(Config.Icon or "keyboard", 14, Theme.TextDim, Holder, UDim2.fromOffset(10, 9))
		local Label = Create("TextLabel", { Parent = Holder, Position = UDim2.fromOffset(32, 0), Size = UDim2.new(1, -80, 1, 0), BackgroundTransparency = 1, Text = Config.Name or "Keybind", TextColor3 = Theme.TextDim, Font = Theme.Font, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left })
		local KeyLabel = Create("TextLabel", { Parent = Holder, Position = UDim2.new(1, -60, 0.5, -9), Size = UDim2.fromOffset(50, 18), BackgroundColor3 = Theme.BgElement, Text = Key.Name, TextColor3 = Theme.TextDim, Font = Theme.FontBold, TextSize = 10, AutoButtonColor = false })
		Corner(KeyLabel, 4)

		T9ou.Options[Flag] = Key.Name
		T9ou.Elements[Flag] = function(val)
			pcall(function() Key = Enum.KeyCode[val] end)
			KeyLabel.Text = tostring(val)
		end

		local Listening = false
		Holder.MouseButton1Click:Connect(function()
			Listening = true
			KeyLabel.Text = "..."
			KeyLabel.TextColor3 = Theme.Accent
		end)

		UserInputService.InputBegan:Connect(function(Input, GPE)
			if Listening and not GPE then
				if Input.UserInputType == Enum.UserInputType.Keyboard then
					Key = Input.KeyCode
					KeyLabel.Text = Key.Name
					KeyLabel.TextColor3 = Theme.TextDim
					Listening = false
					T9ou.Options[Flag] = Key.Name
					T9ou:AutoSave()
					if Config.Callback then task.spawn(Config.Callback, Key) end
				end
			elseif not Listening and Input.KeyCode == Key then
				if Config.Callback then task.spawn(Config.Callback, Key) end
			end
		end)
		ApplyDependency(Tab, Holder, Holder, Config)
	end
	if Tab.BuildQueue then table.insert(Tab.BuildQueue, Build) else Build() end
end

function T9ou:Textbox(Tab, Config)
	local function Build()
		local Flag = Config.Flag or Config.Name
		local Text = T9ou.Options[Flag] ~= nil and tostring(T9ou.Options[Flag]) or (Config.Default or "")

		local Holder = Create("Frame", { Parent = Tab.Page, Size = UDim2.new(1, 0, 0, 32), BackgroundColor3 = Theme.BgPanel, BorderSizePixel = 0 })
		Holder:SetAttribute("SearchText", Config.Name or "Textbox")
		table.insert(T9ou.ElementsUI, Holder)
		
		Corner(Holder, 6)
		local Stroke = Create("UIStroke", { Color = Color3.fromRGB(50, 50, 60), Thickness = 1, Transparency = 0.5, Parent = Holder })

		local Icon = AddIcon(Config.Icon or "type", 14, Theme.TextDim, Holder, UDim2.fromOffset(10, 9))
		local Box = Create("TextBox", { Parent = Holder, Position = UDim2.fromOffset(32, 0), Size = UDim2.new(1, -36, 1, 0), BackgroundTransparency = 1, Text = Text, PlaceholderText = Config.Placeholder or "Type here...", TextColor3 = Theme.TextMain, PlaceholderColor3 = Theme.TextDim, Font = Theme.Font, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, ClearTextOnFocus = false })

		T9ou.Options[Flag] = Text
		T9ou.Elements[Flag] = function(val)
			Box.Text = tostring(val)
			T9ou.Options[Flag] = tostring(val)
		end

		Box.Focused:Connect(function() TweenService:Create(Stroke, Theme.TweenInfo, {Color = Theme.Accent, Transparency = 0}):Play() end)
		Box.FocusLost:Connect(function()
			TweenService:Create(Stroke, Theme.TweenInfo, {Color = Color3.fromRGB(50, 50, 60), Transparency = 0.5}):Play()
			T9ou.Options[Flag] = Box.Text
			T9ou:AutoSave()
			if Config.Callback then task.spawn(Config.Callback, Box.Text) end
		end)
		ApplyDependency(Tab, Holder, Holder, Config)
	end
	if Tab.BuildQueue then table.insert(Tab.BuildQueue, Build) else Build() end
end

function T9ou:GroupBox(Tab, Config)
	local GroupTab = { Page = nil, BuildQueue = {}, Build = nil }
	local Open = Config.DefaultOpen ~= false

	local function Setup()
		local Side = Config.Side or "Full"
		local ParentFrame = Tab.Page
		local Width = UDim2.new(1, 0, 0, 34)

		if Side == "Left" then
			ParentFrame = Create("Frame", { Parent = Tab.Page, Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.Y })
			Create("UIListLayout", { Parent = ParentFrame, FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder, VerticalAlignment = Enum.VerticalAlignment.Top })
			Width = UDim2.new(0.5, -4, 0, 34)
			Tab.LastLeftGroupRow = ParentFrame
		elseif Side == "Right" then
			if Tab.LastLeftGroupRow then
				ParentFrame = Tab.LastLeftGroupRow
				Width = UDim2.new(0.5, -4, 0, 34)
			end
		end

		local Holder = Create("Frame", { Parent = ParentFrame, Size = Width, BackgroundColor3 = Theme.BgPanel, BorderSizePixel = 0, ClipsDescendants = true })
		Holder:SetAttribute("SearchText", Config.Name or "Group")
		table.insert(T9ou.ElementsUI, Holder)
		
		Corner(Holder, 8)
		local Stroke = Create("UIStroke", { Color = Color3.fromRGB(50, 50, 60), Thickness = 1, Transparency = 0.5, Parent = Holder })

		local Header = Create("TextButton", { Parent = Holder, Size = UDim2.new(1, 0, 0, 34), BackgroundColor3 = Color3.fromRGB(26, 26, 32), Text = "", AutoButtonColor = false })
		Corner(Header, 8)

		local AccentBar = Create("Frame", { Parent = Header, Position = UDim2.fromOffset(0, 8), Size = UDim2.fromOffset(3, 18), BackgroundColor3 = Theme.Accent, BorderSizePixel = 0 })
		Corner(AccentBar, 2)

		AddIcon(Config.Icon or "folder", 14, Theme.Accent, Header, UDim2.fromOffset(14, 10))
		Create("TextLabel", { Parent = Header, Position = UDim2.fromOffset(36, 0), Size = UDim2.new(1, -70, 1, 0), BackgroundTransparency = 1, Text = Config.Name or "Group", TextColor3 = Theme.TextMain, Font = Theme.FontBold, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left })

		local Arrow = AddIcon("chevron-down", 14, Theme.TextDim, Header, UDim2.new(1, -26, 0.5, -7))

		local Inner = Create("ScrollingFrame", { Parent = Holder, Position = UDim2.fromOffset(0, 34), Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 2, ScrollBarImageColor3 = Theme.Accent, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y })
		Create("UIPadding", { Parent = Inner, PaddingTop = UDim.new(0, 8), PaddingBottom = UDim.new(0, 8), PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 8) })

		local Page = Create("Frame", { Parent = Inner, Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.Y })
		Create("UIListLayout", { Parent = Page, Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder })

		GroupTab.Page = Page
		local Built = false
		GroupTab.Build = function()
			if Built then return end
			Built = true
			for _, func in ipairs(GroupTab.BuildQueue) do func() end
			GroupTab.BuildQueue = {}
		end

		local function TargetHeight()
			local content = Page.AbsoluteSize.Y + 16
			local maxHeight = math.max(120, Tab.Page.AbsoluteSize.Y * 0.6)
			if content > maxHeight then content = maxHeight end
			return content
		end

		local function UpdateSize(animate)
			local contentH = Open and TargetHeight() or 0
			local newSize = (Side ~= "Full") and UDim2.new(0.5, -4, 0, 34 + contentH) or UDim2.new(1, 0, 0, 34 + contentH)
			if animate then
				TweenService:Create(Holder, TweenInfo.new(0.25, Enum.EasingStyle.Quint), { Size = newSize }):Play()
				TweenService:Create(Inner, TweenInfo.new(0.25, Enum.EasingStyle.Quint), { Size = UDim2.new(1, 0, 0, contentH) }):Play()
			else
				Holder.Size = newSize
				Inner.Size = UDim2.new(1, 0, 0, contentH)
			end
		end

		Page:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
			if Open then UpdateSize(false) end
		end)

		Header.MouseEnter:Connect(function()
			TweenService:Create(Header, Theme.TweenInfo, { BackgroundColor3 = Theme.BgHover }):Play()
			TweenService:Create(Stroke, Theme.TweenInfo, { Color = Theme.Accent, Transparency = 0.4 }):Play()
		end)
		Header.MouseLeave:Connect(function()
			TweenService:Create(Header, Theme.TweenInfo, { BackgroundColor3 = Color3.fromRGB(26, 26, 32) }):Play()
			TweenService:Create(Stroke, Theme.TweenInfo, { Color = Color3.fromRGB(50, 50, 60), Transparency = 0.5 }):Play()
		end)

		Header.MouseButton1Click:Connect(function()
			Open = not Open
			GroupTab.Build()
			TweenService:Create(Arrow, Theme.TweenInfo, { Rotation = Open and 0 or -90 }):Play()
			UpdateSize(true)
		end)

		GroupTab.Build()
		Arrow.Rotation = Open and 0 or -90
		UpdateSize(false)
		ApplyDependency(Tab, Holder, Holder, Config)
	end

	if Tab.Build then 
		table.insert(Tab.BuildQueue, Setup) 
	else 
		Setup() 
	end
	
	return GroupTab
end

return T9ou