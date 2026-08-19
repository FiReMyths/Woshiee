--[[
    LINER MOBILE PANEL - FIXED GUI BUILD
    ------------------------------------
    Mobile-friendly Roblox GUI framework.

    Included:
    • Reliable close/open button
    • Floating reopen button
    • Scrollable Home section
    • Aim Assist UI setting
    • ESP UI setting
    • Team Check UI setting
    • Aim strength selector
    • FOV selector + visual FOV circle
    • Distance selector
    • Smooth animations
    • Draggable header
    • Responsive sizing
    • Game touch input is NOT blocked by the background
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then
	return
end

if not UserInputService.TouchEnabled then
	return
end

local PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 10)
if not PlayerGui then
	warn("Liner Mobile Panel: PlayerGui unavailable.")
	return
end

--------------------------------------------------
-- CLEAN PREVIOUS VERSION
--------------------------------------------------

local OldGui = PlayerGui:FindFirstChild("LinerMobilePanel")
if OldGui then
	OldGui:Destroy()
end

local OldBlur = Lighting:FindFirstChild("LinerMobilePanelBlur")
if OldBlur then
	OldBlur:Destroy()
end

--------------------------------------------------
-- SETTINGS
--------------------------------------------------

local Settings = {
	AimEnabled = false,
	ESPEnabled = false,
	TeamCheck = false,

	AimFOV = 180,
	AimStrength = 0.35,
	MaxDistance = 500
}

--------------------------------------------------
-- COLORS
--------------------------------------------------

local C = {
	Background = Color3.fromRGB(15, 15, 21),
	Panel = Color3.fromRGB(22, 22, 30),
	Panel2 = Color3.fromRGB(29, 29, 39),
	Button = Color3.fromRGB(35, 35, 47),
	ButtonHover = Color3.fromRGB(46, 46, 61),
	Accent = Color3.fromRGB(145, 96, 255),
	AccentDark = Color3.fromRGB(103, 68, 184),
	On = Color3.fromRGB(35, 94, 65),
	Text = Color3.fromRGB(245, 245, 250),
	SubText = Color3.fromRGB(145, 145, 160),
	Stroke = Color3.fromRGB(75, 75, 95),
	Danger = Color3.fromRGB(185, 55, 70)
}

--------------------------------------------------
-- HELPERS
--------------------------------------------------

local function Tween(Object, Time, Style, Direction, Properties)
	local Info = TweenInfo.new(
		Time,
		Style or Enum.EasingStyle.Quad,
		Direction or Enum.EasingDirection.Out
	)

	local Animation = TweenService:Create(Object, Info, Properties)
	Animation:Play()
	return Animation
end

local function Corner(Object, Radius)
	local Item = Instance.new("UICorner")
	Item.CornerRadius = UDim.new(0, Radius)
	Item.Parent = Object
	return Item
end

local function Stroke(Object, Color, Thickness, Transparency)
	local Item = Instance.new("UIStroke")
	Item.Color = Color
	Item.Thickness = Thickness or 1
	Item.Transparency = Transparency or 0
	Item.Parent = Object
	return Item
end

--------------------------------------------------
-- BLUR
--------------------------------------------------

local Blur = Instance.new("BlurEffect")
Blur.Name = "LinerMobilePanelBlur"
Blur.Size = 0
Blur.Parent = Lighting

--------------------------------------------------
-- SCREEN GUI
--------------------------------------------------

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LinerMobilePanel"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 999
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

--------------------------------------------------
-- NON-BLOCKING BACKGROUND
--------------------------------------------------

local Overlay = Instance.new("Frame")
Overlay.Name = "Overlay"
Overlay.Size = UDim2.fromScale(1, 1)
Overlay.BackgroundColor3 = Color3.new(0, 0, 0)
Overlay.BackgroundTransparency = 1
Overlay.BorderSizePixel = 0

-- CRITICAL:
-- The overlay is visual only.
-- It does NOT capture touch input.
Overlay.Active = false
Overlay.Selectable = false
Overlay.ZIndex = 1
Overlay.Parent = ScreenGui

--------------------------------------------------
-- MAIN PANEL
--------------------------------------------------

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.Position = UDim2.fromScale(0.5, 0.5)
Main.Size = UDim2.fromOffset(310, 440)
Main.BackgroundColor3 = C.Panel
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Active = true
Main.ZIndex = 10
Main.Parent = ScreenGui

Corner(Main, 18)
Stroke(Main, C.Stroke, 1, 0.25)

local Scale = Instance.new("UIScale")
Scale.Scale = 1
Scale.Parent = Main

--------------------------------------------------
-- RESPONSIVE SIZE
--------------------------------------------------

local function UpdateSize()
	local Camera = workspace.CurrentCamera
	if not Camera then
		return
	end

	local Viewport = Camera.ViewportSize

	local Width
	local Height

	if Viewport.X <= 500 then
		Width = math.min(Viewport.X - 28, 370)
		Height = math.min(Viewport.Y - 70, 520)
	else
		Width = math.min(Viewport.X * 0.58, 650)
		Height = math.min(Viewport.Y * 0.70, 650)
	end

	Main.Size = UDim2.fromOffset(
		math.max(280, Width),
		math.max(360, Height)
	)
end

UpdateSize()

if workspace.CurrentCamera then
	workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(UpdateSize)
end

--------------------------------------------------
-- HEADER
--------------------------------------------------

local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 60)
Header.BackgroundColor3 = C.Panel2
Header.BorderSizePixel = 0
Header.Active = true
Header.ZIndex = 20
Header.Parent = Main

Corner(Header, 18)

local HeaderFix = Instance.new("Frame")
HeaderFix.Size = UDim2.new(1, 0, 0, 18)
HeaderFix.Position = UDim2.new(0, 0, 1, -18)
HeaderFix.BackgroundColor3 = C.Panel2
HeaderFix.BorderSizePixel = 0
HeaderFix.ZIndex = 20
HeaderFix.Parent = Header

local Logo = Instance.new("Frame")
Logo.Size = UDim2.fromOffset(34, 34)
Logo.Position = UDim2.fromOffset(12, 13)
Logo.BackgroundColor3 = C.Accent
Logo.BorderSizePixel = 0
Logo.ZIndex = 22
Logo.Parent = Header

Corner(Logo, 10)

local LogoText = Instance.new("TextLabel")
LogoText.Size = UDim2.fromScale(1, 1)
LogoText.BackgroundTransparency = 1
LogoText.Text = "L"
LogoText.TextColor3 = C.Text
LogoText.TextSize = 17
LogoText.Font = Enum.Font.GothamBold
LogoText.TextXAlignment = Enum.TextXAlignment.Center
LogoText.TextYAlignment = Enum.TextYAlignment.Center
LogoText.ZIndex = 23
LogoText.Parent = Logo

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -115, 0, 23)
Title.Position = UDim2.fromOffset(55, 7)
Title.BackgroundTransparency = 1
Title.Text = "LinerExploit"
Title.TextColor3 = C.Text
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 22
Title.Parent = Header

local Subtitle = Instance.new("TextLabel")
Subtitle.Size = UDim2.new(1, -115, 0, 17)
Subtitle.Position = UDim2.fromOffset(55, 31)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "Mobile Developer Panel"
Subtitle.TextColor3 = C.SubText
Subtitle.TextSize = 10
Subtitle.Font = Enum.Font.Gotham
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.ZIndex = 22
Subtitle.Parent = Header

local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.AnchorPoint = Vector2.new(1, 0.5)
CloseButton.Position = UDim2.new(1, -10, 0.5, 0)
CloseButton.Size = UDim2.fromOffset(38, 38)
CloseButton.BackgroundColor3 = C.Button
CloseButton.BorderSizePixel = 0
CloseButton.Text = "×"
CloseButton.TextColor3 = C.Text
CloseButton.TextSize = 23
CloseButton.Font = Enum.Font.GothamBold
CloseButton.AutoButtonColor = false
CloseButton.Active = true
CloseButton.ZIndex = 30
CloseButton.Parent = Header

Corner(CloseButton, 10)

--------------------------------------------------
-- SCROLLABLE HOME
--------------------------------------------------

local Container = Instance.new("ScrollingFrame")
Container.Name = "Home"
Container.Position = UDim2.new(0, 10, 0, 70)
Container.Size = UDim2.new(1, -20, 1, -80)
Container.BackgroundTransparency = 1
Container.BorderSizePixel = 0
Container.Active = true
Container.Selectable = false
Container.ScrollingEnabled = true
Container.ScrollingDirection = Enum.ScrollingDirection.Y
Container.ScrollBarThickness = 3
Container.ScrollBarImageColor3 = C.Accent
Container.CanvasSize = UDim2.fromOffset(0, 0)
Container.ZIndex = 15
Container.Parent = Main

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 7)
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Parent = Container

local Padding = Instance.new("UIPadding")
Padding.PaddingBottom = UDim.new(0, 12)
Padding.Parent = Container

Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	Container.CanvasSize = UDim2.fromOffset(
		0,
		Layout.AbsoluteContentSize.Y + 15
	)
end)

--------------------------------------------------
-- SECTION
--------------------------------------------------

local Section = Instance.new("TextLabel")
Section.Size = UDim2.new(1, 0, 0, 24)
Section.BackgroundTransparency = 1
Section.Text = "HOME"
Section.TextColor3 = C.SubText
Section.TextSize = 10
Section.Font = Enum.Font.GothamBold
Section.TextXAlignment = Enum.TextXAlignment.Left
Section.LayoutOrder = 1
Section.ZIndex = 17
Section.Parent = Container

--------------------------------------------------
-- BUTTON CREATOR
--------------------------------------------------

local function CreateButton(Text)
	local Button = Instance.new("TextButton")

	Button.Size = UDim2.new(1, -2, 0, 43)
	Button.BackgroundColor3 = C.Button
	Button.BorderSizePixel = 0
	Button.Text = Text
	Button.TextColor3 = C.Text
	Button.TextSize = 11
	Button.Font = Enum.Font.GothamMedium
	Button.TextXAlignment = Enum.TextXAlignment.Left
	Button.AutoButtonColor = false
	Button.Active = true
	Button.LayoutOrder = 2
	Button.ZIndex = 18
	Button.Parent = Container

	Corner(Button, 10)

	local LeftPadding = Instance.new("UIPadding")
	LeftPadding.PaddingLeft = UDim.new(0, 13)
	LeftPadding.Parent = Button

	Button.Activated:Connect(function()
		Tween(Button, 0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {
			BackgroundColor3 = C.ButtonHover
		})

		task.delay(0.10, function()
			if Button.Parent then
				Tween(Button, 0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {
					BackgroundColor3 = C.Button
				})
			end
		end)
	end)

	return Button
end

--------------------------------------------------
-- HOME CONTROLS
--------------------------------------------------

local AimButton = CreateButton("🎯  AIM ASSIST     OFF")
local ESPButton = CreateButton("👁  ESP             OFF")
local TeamButton = CreateButton("👥  TEAM CHECK     OFF")
local StrengthButton = CreateButton("⚡  AIM: MEDIUM")
local FOVButton = CreateButton("⭕  FOV: 180")
local DistanceButton = CreateButton("📏  DISTANCE: 500")

--------------------------------------------------
-- STATUS
--------------------------------------------------

local StatusCard = Instance.new("Frame")
StatusCard.Size = UDim2.new(1, -2, 0, 82)
StatusCard.BackgroundColor3 = C.Panel2
StatusCard.BorderSizePixel = 0
StatusCard.LayoutOrder = 20
StatusCard.ZIndex = 18
StatusCard.Parent = Container

Corner(StatusCard, 12)
Stroke(StatusCard, C.Stroke, 1, 0.4)

local StatusTitle = Instance.new("TextLabel")
StatusTitle.Size = UDim2.new(1, -20, 0, 20)
StatusTitle.Position = UDim2.fromOffset(10, 8)
StatusTitle.BackgroundTransparency = 1
StatusTitle.Text = "STATUS"
StatusTitle.TextColor3 = C.Text
StatusTitle.TextSize = 11
StatusTitle.Font = Enum.Font.GothamBold
StatusTitle.TextXAlignment = Enum.TextXAlignment.Left
StatusTitle.ZIndex = 19
StatusTitle.Parent = StatusCard

local StatusText = Instance.new("TextLabel")
StatusText.Size = UDim2.new(1, -20, 0, 35)
StatusText.Position = UDim2.fromOffset(10, 32)
StatusText.BackgroundTransparency = 1
StatusText.Text = "●  READY\nTouch controls active"
StatusText.TextColor3 = Color3.fromRGB(100, 220, 145)
StatusText.TextSize = 10
StatusText.Font = Enum.Font.Gotham
StatusText.TextXAlignment = Enum.TextXAlignment.Left
StatusText.TextYAlignment = Enum.TextYAlignment.Top
StatusText.ZIndex = 19
StatusText.Parent = StatusCard

--------------------------------------------------
-- AIM STRENGTH
--------------------------------------------------

local Strengths = {
	{Name = "WEAK", Value = 0.10},
	{Name = "LIGHT", Value = 0.20},
	{Name = "MEDIUM", Value = 0.35},
	{Name = "STRONG", Value = 0.55},
	{Name = "LOCK", Value = 1}
}

local StrengthIndex = 3

StrengthButton.Activated:Connect(function()
	StrengthIndex += 1

	if StrengthIndex > #Strengths then
		StrengthIndex = 1
	end

	local Data = Strengths[StrengthIndex]

	Settings.AimStrength = Data.Value
	StrengthButton.Text = "⚡  AIM: " .. Data.Name
	StatusText.Text = "●  READY\nAim strength: " .. Data.Name
end)

--------------------------------------------------
-- TOGGLES
--------------------------------------------------

local function UpdateToggle(Button, Label, Enabled)
	if Enabled then
		Button.Text = Label .. "     ON"

		Tween(Button, 0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {
			BackgroundColor3 = C.On
		})
	else
		Button.Text = Label .. "     OFF"

		Tween(Button, 0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {
			BackgroundColor3 = C.Button
		})
	end
end

AimButton.Activated:Connect(function()
	Settings.AimEnabled = not Settings.AimEnabled

	UpdateToggle(
		AimButton,
		"🎯  AIM ASSIST",
		Settings.AimEnabled
	)

	StatusText.Text =
		"●  READY\nAim Assist setting: "
		.. (Settings.AimEnabled and "ON" or "OFF")
end)

ESPButton.Activated:Connect(function()
	Settings.ESPEnabled = not Settings.ESPEnabled

	UpdateToggle(
		ESPButton,
		"👁  ESP",
		Settings.ESPEnabled
	)

	StatusText.Text =
		"●  READY\nESP setting: "
		.. (Settings.ESPEnabled and "ON" or "OFF")
end)

TeamButton.Activated:Connect(function()
	Settings.TeamCheck = not Settings.TeamCheck

	UpdateToggle(
		TeamButton,
		"👥  TEAM CHECK",
		Settings.TeamCheck
	)

	StatusText.Text =
		"●  READY\nTeam Check: "
		.. (Settings.TeamCheck and "ON" or "OFF")
end)

--------------------------------------------------
-- FOV
--------------------------------------------------

local FOVValues = {
	100,
	140,
	180,
	240,
	300
}

FOVButton.Activated:Connect(function()
	local Index = table.find(FOVValues, Settings.AimFOV) or 3

	Index += 1

	if Index > #FOVValues then
		Index = 1
	end

	Settings.AimFOV = FOVValues[Index]

	FOVButton.Text = "⭕  FOV: " .. Settings.AimFOV
	StatusText.Text = "●  READY\nFOV: " .. Settings.AimFOV
end)

--------------------------------------------------
-- DISTANCE
--------------------------------------------------

local DistanceValues = {
	100,
	250,
	500,
	1000
}

DistanceButton.Activated:Connect(function()
	local Index = table.find(
		DistanceValues,
		Settings.MaxDistance
	) or 3

	Index += 1

	if Index > #DistanceValues then
		Index = 1
	end

	Settings.MaxDistance = DistanceValues[Index]

	DistanceButton.Text =
		"📏  DISTANCE: " ..
		Settings.MaxDistance

	StatusText.Text =
		"●  READY\nDistance: " ..
		Settings.MaxDistance
end)

--------------------------------------------------
-- FOV CIRCLE
--------------------------------------------------

local FOVCircle = Instance.new("Frame")
FOVCircle.Name = "FOVCircle"
FOVCircle.AnchorPoint = Vector2.new(0.5, 0.5)
FOVCircle.Position = UDim2.fromScale(0.5, 0.5)
FOVCircle.Size = UDim2.fromOffset(360, 360)
FOVCircle.BackgroundTransparency = 1
FOVCircle.BorderSizePixel = 0
FOVCircle.Active = false
FOVCircle.Visible = false
FOVCircle.ZIndex = 2
FOVCircle.Parent = ScreenGui

Corner(FOVCircle, 999)

Stroke(
	FOVCircle,
	Color3.fromRGB(90, 175, 255),
	2,
	0.25
)

--------------------------------------------------
-- FLOATING OPEN BUTTON
--------------------------------------------------

local OpenButton = Instance.new("TextButton")
OpenButton.Name = "OpenButton"
OpenButton.AnchorPoint = Vector2.new(1, 0.5)
OpenButton.Position = UDim2.fromScale(0.95, 0.5)
OpenButton.Size = UDim2.fromOffset(54, 54)
OpenButton.BackgroundColor3 = C.Accent
OpenButton.BorderSizePixel = 0
OpenButton.Text = "☰"
OpenButton.TextColor3 = C.Text
OpenButton.TextSize = 22
OpenButton.Font = Enum.Font.GothamBold
OpenButton.AutoButtonColor = false
OpenButton.Active = true
OpenButton.Visible = false
OpenButton.ZIndex = 100
OpenButton.Parent = ScreenGui

Corner(OpenButton, 17)

Stroke(
	OpenButton,
	Color3.fromRGB(215, 190, 255),
	1,
	0.35
)

--------------------------------------------------
-- OPEN / CLOSE
--------------------------------------------------

local IsOpen = true
local IsAnimating = false

local function OpenGui()
	if IsAnimating or IsOpen then
		return
	end

	IsAnimating = true
	IsOpen = true

	OpenButton.Visible = false
	Main.Visible = true

	Scale.Scale = 0.82
	Main.Position = UDim2.fromScale(0.5, 0.53)

	Tween(
		Scale,
		0.30,
		Enum.EasingStyle.Back,
		Enum.EasingDirection.Out,
		{Scale = 1}
	)

	Tween(
		Main,
		0.30,
		Enum.EasingStyle.Back,
		Enum.EasingDirection.Out,
		{Position = UDim2.fromScale(0.5, 0.5)}
	)

	Tween(
		Overlay,
		0.25,
		Enum.EasingStyle.Quad,
		Enum.EasingDirection.Out,
		{BackgroundTransparency = 0.65}
	)

	Tween(
		Blur,
		0.25,
		Enum.EasingStyle.Quad,
		Enum.EasingDirection.Out,
		{Size = 6}
	)

	task.delay(0.32, function()
		IsAnimating = false
	end)
end

local function CloseGui()
	if IsAnimating or not IsOpen then
		return
	end

	IsAnimating = true
	IsOpen = false

	Tween(
		Scale,
		0.18,
		Enum.EasingStyle.Quad,
		Enum.EasingDirection.In,
		{Scale = 0.82}
	)

	Tween(
		Main,
		0.18,
		Enum.EasingStyle.Quad,
		Enum.EasingDirection.In,
		{Position = UDim2.fromScale(0.5, 0.53)}
	)

	Tween(
		Overlay,
		0.18,
		Enum.EasingStyle.Quad,
		Enum.EasingDirection.Out,
		{BackgroundTransparency = 1}
	)

	Tween(
		Blur,
		0.18,
		Enum.EasingStyle.Quad,
		Enum.EasingDirection.Out,
		{Size = 0}
	)

	task.delay(0.19, function()
		Main.Visible = false
		OpenButton.Visible = true
		IsAnimating = false
	end)
end

CloseButton.Activated:Connect(CloseGui)
OpenButton.Activated:Connect(OpenGui)

--------------------------------------------------
-- CLOSE BUTTON FEEDBACK
--------------------------------------------------

CloseButton.MouseEnter:Connect(function()
	Tween(
		CloseButton,
		0.12,
		Enum.EasingStyle.Quad,
		Enum.EasingDirection.Out,
		{BackgroundColor3 = C.Danger}
	)
end)

CloseButton.MouseLeave:Connect(function()
	Tween(
		CloseButton,
		0.12,
		Enum.EasingStyle.Quad,
		Enum.EasingDirection.Out,
		{BackgroundColor3 = C.Button}
	)
end)

--------------------------------------------------
-- DRAGGABLE HEADER
--------------------------------------------------

local Dragging = false
local DragStart
local StartPosition

Header.InputBegan:Connect(function(Input)
	if Input.UserInputType == Enum.UserInputType.Touch
		or Input.UserInputType == Enum.UserInputType.MouseButton1 then

		Dragging = true
		DragStart = Input.Position
		StartPosition = Main.Position
	end
end)

UserInputService.InputChanged:Connect(function(Input)
	if not Dragging then
		return
	end

	if Input.UserInputType == Enum.UserInputType.Touch
		or Input.UserInputType == Enum.UserInputType.MouseMovement then

		local Delta = Input.Position - DragStart

		Main.Position = UDim2.new(
			StartPosition.X.Scale,
			StartPosition.X.Offset + Delta.X,
			StartPosition.Y.Scale,
			StartPosition.Y.Offset + Delta.Y
		)
	end
end)

UserInputService.InputEnded:Connect(function(Input)
	if Input.UserInputType == Enum.UserInputType.Touch
		or Input.UserInputType == Enum.UserInputType.MouseButton1 then

		Dragging = false
	end
end)

--------------------------------------------------
-- FOV DISPLAY
--------------------------------------------------

task.spawn(function()
	while ScreenGui.Parent do
		FOVCircle.Visible = Settings.AimEnabled

		if Settings.AimEnabled then
			FOVCircle.Size = UDim2.fromOffset(
				Settings.AimFOV * 2,
				Settings.AimFOV * 2
			)
		end

		task.wait(0.08)
	end
end)

--------------------------------------------------
-- START OPEN
--------------------------------------------------

Main.Visible = true
OpenButton.Visible = false
Overlay.BackgroundTransparency = 1
Blur.Size = 0
Scale.Scale = 0.82
IsOpen = false

OpenGui()

print("[Liner Mobile Panel] Loaded successfully.")
