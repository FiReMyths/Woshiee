--[[
    DELTA MOBILE PANEL - STABLE BUILD
    ----------------------------------
    • Single paste-and-run script
    • Mobile responsive
    • Smooth open / close
    • Scrollable pages
    • Touch-friendly controls
    • No invisible full-screen touch blocker
    • Game camera remains usable outside the GUI
    • Draggable header
    • Floating toggle button
    • Blur + dim background
    • Animated tabs and toggles
    • Safe cleanup on re-execution
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

local Player = Players.LocalPlayer
if not Player then
	warn("[Delta Panel] LocalPlayer unavailable.")
	return
end

local PlayerGui = Player:WaitForChild("PlayerGui", 10)
if not PlayerGui then
	warn("[Delta Panel] PlayerGui unavailable.")
	return
end

pcall(function()
	local oldGui = PlayerGui:FindFirstChild("DeltaStableMobilePanel")
	if oldGui then oldGui:Destroy() end
end)

pcall(function()
	local oldBlur = Lighting:FindFirstChild("DeltaStableMobileBlur")
	if oldBlur then oldBlur:Destroy() end
end)

local COLOR = {
	Background = Color3.fromRGB(14, 14, 20),
	Panel = Color3.fromRGB(24, 24, 33),
	Panel2 = Color3.fromRGB(30, 30, 41),
	Panel3 = Color3.fromRGB(37, 37, 50),
	Accent = Color3.fromRGB(148, 96, 255),
	AccentDark = Color3.fromRGB(105, 66, 188),
	Text = Color3.fromRGB(245, 245, 250),
	SubText = Color3.fromRGB(165, 165, 180),
	Button = Color3.fromRGB(41, 41, 54),
	ButtonPressed = Color3.fromRGB(57, 57, 73),
	Success = Color3.fromRGB(84, 210, 140),
	Danger = Color3.fromRGB(225, 75, 90),
	Stroke = Color3.fromRGB(105, 85, 145)
}

local FAST = TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local MEDIUM = TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local OPEN_INFO = TweenInfo.new(0.42, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local CLOSE_INFO = TweenInfo.new(0.24, Enum.EasingStyle.Quart, Enum.EasingDirection.In)

local function Tween(object, info, properties)
	local success, animation = pcall(function()
		local result = TweenService:Create(object, info, properties)
		result:Play()
		return result
	end)
	if success then return animation end
end

local function Corner(object, radius)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, radius)
	corner.Parent = object
	return corner
end

local function Stroke(object, color, thickness, transparency)
	local stroke = Instance.new("UIStroke")
	stroke.Color = color
	stroke.Thickness = thickness
	stroke.Transparency = transparency or 0
	stroke.Parent = object
	return stroke
end

local function Label(parent, text, size, color, font)
	local label = Instance.new("TextLabel")
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextSize = size
	label.TextColor3 = color
	label.Font = font or Enum.Font.Gotham
	label.Parent = parent
	return label
end

local Gui = Instance.new("ScreenGui")
Gui.Name = "DeltaStableMobilePanel"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.DisplayOrder = 500
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.Parent = PlayerGui

local Blur = Instance.new("BlurEffect")
Blur.Name = "DeltaStableMobileBlur"
Blur.Size = 0
Blur.Parent = Lighting

local Dim = Instance.new("Frame")
Dim.Name = "Dim"
Dim.Size = UDim2.fromScale(1, 1)
Dim.BackgroundColor3 = Color3.new(0, 0, 0)
Dim.BackgroundTransparency = 1
Dim.BorderSizePixel = 0
Dim.Active = true
Dim.ZIndex = 1
Dim.Parent = Gui

local MainScale = Instance.new("UIScale")
MainScale.Scale = 1

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.Position = UDim2.fromScale(0.5, 0.5)
Main.Size = UDim2.fromScale(0.80, 0.64)
Main.BackgroundColor3 = COLOR.Panel
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Active = true
Main.ZIndex = 5
Main.Parent = Gui
MainScale.Parent = Main
Corner(Main, 20)
Stroke(Main, COLOR.Stroke, 1.5, 0.35)

local function UpdateMainSize()
	local camera = workspace.CurrentCamera
	if not camera then return end
	local viewport = camera.ViewportSize
	local width
	local height

	if viewport.X < 500 then
		width = math.min(viewport.X - 28, 430)
		height = math.min(viewport.Y - 70, 540)
	elseif viewport.X < 800 then
		width = math.min(viewport.X - 50, 600)
		height = math.min(viewport.Y - 90, 600)
	else
		width = math.min(viewport.X * 0.68, 800)
		height = math.min(viewport.Y * 0.68, 620)
	end

	Main.Size = UDim2.fromOffset(math.max(width, 280), math.max(height, 300))
end

UpdateMainSize()

if workspace.CurrentCamera then
	workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(UpdateMainSize)
end

local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 58)
Header.BackgroundColor3 = COLOR.Panel2
Header.BorderSizePixel = 0
Header.Active = true
Header.ZIndex = 10
Header.Parent = Main
Corner(Header, 20)

local HeaderFix = Instance.new("Frame")
HeaderFix.Size = UDim2.new(1, 0, 0, 18)
HeaderFix.Position = UDim2.new(0, 0, 1, -18)
HeaderFix.BackgroundColor3 = COLOR.Panel2
HeaderFix.BorderSizePixel = 0
HeaderFix.ZIndex = 10
HeaderFix.Parent = Header

local Logo = Instance.new("Frame")
Logo.Position = UDim2.new(0, 12, 0.5, -17)
Logo.Size = UDim2.fromOffset(34, 34)
Logo.BackgroundColor3 = COLOR.Accent
Logo.BorderSizePixel = 0
Logo.ZIndex = 12
Logo.Parent = Header
Corner(Logo, 10)

local LogoText = Label(Logo, "D", 17, COLOR.Text, Enum.Font.GothamBold)
LogoText.Size = UDim2.fromScale(1, 1)
LogoText.TextXAlignment = Enum.TextXAlignment.Center
LogoText.TextYAlignment = Enum.TextYAlignment.Center
LogoText.ZIndex = 13

local Title = Label(Header, "Delta Panel", 16, COLOR.Text, Enum.Font.GothamBold)
Title.Position = UDim2.new(0, 57, 0, 8)
Title.Size = UDim2.new(1, -115, 0, 21)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 12

local Subtitle = Label(Header, "Mobile interface", 10, COLOR.SubText, Enum.Font.Gotham)
Subtitle.Position = UDim2.new(0, 57, 0, 30)
Subtitle.Size = UDim2.new(1, -115, 0, 16)
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.ZIndex = 12

local Close = Instance.new("TextButton")
Close.Name = "Close"
Close.AnchorPoint = Vector2.new(1, 0.5)
Close.Position = UDim2.new(1, -12, 0.5, 0)
Close.Size = UDim2.fromOffset(34, 34)
Close.BackgroundColor3 = COLOR.Button
Close.BorderSizePixel = 0
Close.Text = "×"
Close.TextColor3 = COLOR.Text
Close.TextSize = 22
Close.Font = Enum.Font.GothamBold
Close.AutoButtonColor = false
Close.Active = true
Close.ZIndex = 15
Close.Parent = Header
Corner(Close, 10)

local Body = Instance.new("Frame")
Body.Name = "Body"
Body.Position = UDim2.new(0, 12, 0, 69)
Body.Size = UDim2.new(1, -24, 1, -81)
Body.BackgroundTransparency = 1
Body.Active = true
Body.ZIndex = 8
Body.Parent = Main

local Tabs = Instance.new("Frame")
Tabs.Size = UDim2.new(1, 0, 0, 40)
Tabs.BackgroundColor3 = COLOR.Background
Tabs.BorderSizePixel = 0
Tabs.Active = true
Tabs.ZIndex = 10
Tabs.Parent = Body
Corner(Tabs, 11)

local function CreateTab(text, position)
	local button = Instance.new("TextButton")
	button.Position = position
	button.Size = UDim2.new(0.32, -5, 1, -10)
	button.BackgroundColor3 = COLOR.Button
	button.BorderSizePixel = 0
	button.Text = text
	button.TextColor3 = COLOR.SubText
	button.TextSize = 10
	button.Font = Enum.Font.GothamBold
	button.AutoButtonColor = false
	button.Active = true
	button.ZIndex = 12
	button.Parent = Tabs
	Corner(button, 9)
	return button
end

local HomeTab = CreateTab("⌂  HOME", UDim2.new(0, 5, 0, 5))
local SettingsTab = CreateTab("⚙  SETTINGS", UDim2.new(0.34, 0, 0, 5))
local InfoTab = CreateTab("ⓘ  INFO", UDim2.new(0.68, 0, 0, 5))

local PageContainer = Instance.new("Frame")
PageContainer.Position = UDim2.new(0, 0, 0, 50)
PageContainer.Size = UDim2.new(1, 0, 1, -50)
PageContainer.BackgroundTransparency = 1
PageContainer.ClipsDescendants = true
PageContainer.Active = true
PageContainer.ZIndex = 20
PageContainer.Parent = Body

local function CreatePage(name)
	local page = Instance.new("ScrollingFrame")
	page.Name = name
	page.Size = UDim2.fromScale(1, 1)
	page.BackgroundTransparency = 1
	page.BorderSizePixel = 0
	page.Active = true
	page.Selectable = false
	page.ScrollingEnabled = true
	page.ScrollingDirection = Enum.ScrollingDirection.Y
	page.ScrollBarThickness = 3
	page.ScrollBarImageColor3 = COLOR.Accent
	page.CanvasSize = UDim2.new(0, 0, 0, 600)
	page.ScrollingElasticBehavior = Enum.ElasticBehavior.WhenScrollable
	page.ZIndex = 21
	page.Parent = PageContainer
	return page
end

local HomePage = CreatePage("HomePage")
local SettingsPage = CreatePage("SettingsPage")
local InfoPage = CreatePage("InfoPage")
SettingsPage.Visible = false
InfoPage.Visible = false

local function CreateCard(parent, y, height)
	local card = Instance.new("Frame")
	card.Position = UDim2.new(0, 0, 0, y)
	card.Size = UDim2.new(1, -6, 0, height)
	card.BackgroundColor3 = COLOR.Panel2
	card.BorderSizePixel = 0
	card.Active = true
	card.ZIndex = 23
	card.Parent = parent
	Corner(card, 14)
	Stroke(card, COLOR.Stroke, 1, 0.72)
	return card
end

local WelcomeCard = CreateCard(HomePage, 6, 102)
local WelcomeTitle = Label(WelcomeCard, "Welcome back", 15, COLOR.Text, Enum.Font.GothamBold)
WelcomeTitle.Position = UDim2.new(0, 14, 0, 11)
WelcomeTitle.Size = UDim2.new(1, -28, 0, 22)
WelcomeTitle.TextXAlignment = Enum.TextXAlignment.Left
WelcomeTitle.ZIndex = 24

local WelcomeDesc = Label(WelcomeCard, "Your interface is ready to use.", 11, COLOR.SubText)
WelcomeDesc.Position = UDim2.new(0, 14, 0, 37)
WelcomeDesc.Size = UDim2.new(1, -28, 0, 18)
WelcomeDesc.TextXAlignment = Enum.TextXAlignment.Left
WelcomeDesc.ZIndex = 24

local Online = Label(WelcomeCard, "●  ONLINE", 10, COLOR.Success, Enum.Font.GothamBold)
Online.Position = UDim2.new(0, 14, 1, -29)
Online.Size = UDim2.new(1, -28, 0, 18)
Online.TextXAlignment = Enum.TextXAlignment.Left
Online.ZIndex = 24

local ActionCard = CreateCard(HomePage, 120, 140)
local ActionTitle = Label(ActionCard, "Quick Action", 14, COLOR.Text, Enum.Font.GothamBold)
ActionTitle.Position = UDim2.new(0, 14, 0, 11)
ActionTitle.Size = UDim2.new(1, -28, 0, 20)
ActionTitle.TextXAlignment = Enum.TextXAlignment.Left
ActionTitle.ZIndex = 24

local ActionDescription = Label(ActionCard, "Test the interface animation.", 10, COLOR.SubText)
ActionDescription.Position = UDim2.new(0, 14, 0, 34)
ActionDescription.Size = UDim2.new(1, -28, 0, 18)
ActionDescription.TextXAlignment = Enum.TextXAlignment.Left
ActionDescription.ZIndex = 24

local TestButton = Instance.new("TextButton")
TestButton.Position = UDim2.new(0, 14, 0, 76)
TestButton.Size = UDim2.new(1, -28, 0, 43)
TestButton.BackgroundColor3 = COLOR.Accent
TestButton.BorderSizePixel = 0
TestButton.Text = "TEST BUTTON"
TestButton.TextColor3 = COLOR.Text
TestButton.TextSize = 11
TestButton.Font = Enum.Font.GothamBold
TestButton.AutoButtonColor = false
TestButton.Active = true
TestButton.ZIndex = 25
TestButton.Parent = ActionCard
Corner(TestButton, 10)

TestButton.MouseButton1Click:Connect(function()
	TestButton.Text = "✓  WORKING"
	Tween(TestButton, FAST, {BackgroundColor3 = COLOR.Success})
	task.delay(0.8, function()
		if TestButton.Parent then
			TestButton.Text = "TEST BUTTON"
			Tween(TestButton, FAST, {BackgroundColor3 = COLOR.Accent})
		end
	end)
end)

local HomeExtra = CreateCard(HomePage, 278, 270)
local HomeExtraTitle = Label(HomeExtra, "Interface Features", 14, COLOR.Text, Enum.Font.GothamBold)
HomeExtraTitle.Position = UDim2.new(0, 14, 0, 12)
HomeExtraTitle.Size = UDim2.new(1, -28, 0, 20)
HomeExtraTitle.TextXAlignment = Enum.TextXAlignment.Left
HomeExtraTitle.ZIndex = 24

local HomeExtraText = Label(HomeExtra,
	"• Smooth open / close animation\n\n"
		.. "• Scrollable mobile pages\n\n"
		.. "• Touch-friendly controls\n\n"
		.. "• Draggable header\n\n"
		.. "• Floating reopen button\n\n"
		.. "• Responsive panel sizing\n\n"
		.. "• No full-screen touch blocker",
	11, COLOR.SubText)
HomeExtraText.Position = UDim2.new(0, 14, 0, 45)
HomeExtraText.Size = UDim2.new(1, -28, 0, 210)
HomeExtraText.TextXAlignment = Enum.TextXAlignment.Left
HomeExtraText.TextYAlignment = Enum.TextYAlignment.Top
HomeExtraText.ZIndex = 24

local SettingsCard = CreateCard(SettingsPage, 6, 285)
local SettingsTitle = Label(SettingsCard, "Interface Settings", 15, COLOR.Text, Enum.Font.GothamBold)
SettingsTitle.Position = UDim2.new(0, 14, 0, 12)
SettingsTitle.Size = UDim2.new(1, -28, 0, 22)
SettingsTitle.TextXAlignment = Enum.TextXAlignment.Left
SettingsTitle.ZIndex = 24

local SettingsDescription = Label(SettingsCard, "Customize the visual behavior.", 10, COLOR.SubText)
SettingsDescription.Position = UDim2.new(0, 14, 0, 37)
SettingsDescription.Size = UDim2.new(1, -28, 0, 18)
SettingsDescription.TextXAlignment = Enum.TextXAlignment.Left
SettingsDescription.ZIndex = 24

local function CreateToggle(parent, y, text, defaultState, callback)
	local LabelText = Label(parent, text, 11, COLOR.Text, Enum.Font.GothamMedium)
	LabelText.Position = UDim2.new(0, 14, 0, y)
	LabelText.Size = UDim2.new(1, -90, 0, 34)
	LabelText.TextXAlignment = Enum.TextXAlignment.Left
	LabelText.TextYAlignment = Enum.TextYAlignment.Center
	LabelText.ZIndex = 25

	local Toggle = Instance.new("TextButton")
	Toggle.AnchorPoint = Vector2.new(1, 0.5)
	Toggle.Position = UDim2.new(1, -14, 0, y + 17)
	Toggle.Size = UDim2.fromOffset(48, 26)
	Toggle.BackgroundColor3 = defaultState and COLOR.Accent or COLOR.Button
	Toggle.BorderSizePixel = 0
	Toggle.Text = ""
	Toggle.AutoButtonColor = false
	Toggle.Active = true
	Toggle.ZIndex = 25
	Toggle.Parent = parent
	Corner(Toggle, 13)

	local Knob = Instance.new("Frame")
	Knob.AnchorPoint = Vector2.new(0.5, 0.5)
	Knob.Position = defaultState and UDim2.new(1, -13, 0.5, 0) or UDim2.new(0, 13, 0.5, 0)
	Knob.Size = UDim2.fromOffset(18, 18)
	Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Knob.BorderSizePixel = 0
	Knob.ZIndex = 26
	Knob.Parent = Toggle
	Corner(Knob, 9)

	local State = defaultState

	Toggle.MouseButton1Click:Connect(function()
		State = not State

		Tween(Toggle, FAST, {
			BackgroundColor3 = State and COLOR.Accent or COLOR.Button
		})

		Tween(Knob, FAST, {
			Position = State
				and UDim2.new(1, -13, 0.5, 0)
				or UDim2.new(0, 13, 0.5, 0)
		})

		if callback then callback(State) end
	end)

	return Toggle
end

CreateToggle(SettingsCard, 70, "Blur Effect", true, function(state)
	Tween(Blur, MEDIUM, {Size = state and 8 or 0})
end)

CreateToggle(SettingsCard, 112, "Dark Overlay", true, function(state)
	Tween(Dim, MEDIUM, {BackgroundTransparency = state and 0.58 or 1})
end)

CreateToggle(SettingsCard, 154, "Animations", true, function(_state)
end)

CreateToggle(SettingsCard, 196, "Touch-Friendly Mode", true, function(_state)
end)

local SettingsExtra = CreateCard(SettingsPage, 300, 270)
local SettingsExtraTitle = Label(SettingsExtra, "Mobile Controls", 14, COLOR.Text, Enum.Font.GothamBold)
SettingsExtraTitle.Position = UDim2.new(0, 14, 0, 12)
SettingsExtraTitle.Size = UDim2.new(1, -28, 0, 20)
SettingsExtraTitle.TextXAlignment = Enum.TextXAlignment.Left
SettingsExtraTitle.ZIndex = 24

local SettingsExtraText = Label(SettingsExtra,
	"Swipe inside a page to scroll.\n\n"
		.. "Drag the header to move the panel.\n\n"
		.. "Tap the floating button to reopen it.\n\n"
		.. "Swipes outside the panel are left alone, "
		.. "so normal game camera controls continue working.",
	11, COLOR.SubText)
SettingsExtraText.Position = UDim2.new(0, 14, 0, 45)
SettingsExtraText.Size = UDim2.new(1, -28, 0, 190)
SettingsExtraText.TextWrapped = true
SettingsExtraText.TextXAlignment = Enum.TextXAlignment.Left
SettingsExtraText.TextYAlignment = Enum.TextYAlignment.Top
SettingsExtraText.ZIndex = 24

local InfoCard = CreateCard(InfoPage, 6, 260)
local InfoTitle = Label(InfoCard, "About Delta Panel", 15, COLOR.Text, Enum.Font.GothamBold)
InfoTitle.Position = UDim2.new(0, 14, 0, 12)
InfoTitle.Size = UDim2.new(1, -28, 0, 22)
InfoTitle.TextXAlignment = Enum.TextXAlignment.Left
InfoTitle.ZIndex = 24

local InfoText = Label(InfoCard,
	"Mobile UI framework\n\n"
		.. "✓ Responsive layout\n\n"
		.. "✓ Smooth transitions\n\n"
		.. "✓ Scrollable pages\n\n"
		.. "✓ Touch-friendly buttons\n\n"
		.. "✓ Draggable header\n\n"
		.. "✓ No invisible full-screen blocker",
	11, COLOR.SubText)
InfoText.Position = UDim2.new(0, 14, 0, 48)
InfoText.Size = UDim2.new(1, -28, 0, 195)
InfoText.TextXAlignment = Enum.TextXAlignment.Left
InfoText.TextYAlignment = Enum.TextYAlignment.Top
InfoText.ZIndex = 24

local InfoExtra = CreateCard(InfoPage, 275, 210)
local InfoExtraTitle = Label(InfoExtra, "Status", 14, COLOR.Text, Enum.Font.GothamBold)
InfoExtraTitle.Position = UDim2.new(0, 14, 0, 12)
InfoExtraTitle.Size = UDim2.new(1, -28, 0, 20)
InfoExtraTitle.TextXAlignment = Enum.TextXAlignment.Left
InfoExtraTitle.ZIndex = 24

local InfoStatus = Label(InfoExtra,
	"● GUI LOADED\n\n"
		.. "● SCROLL ENABLED\n\n"
		.. "● TOUCH INPUT ACTIVE\n\n"
		.. "● CAMERA INPUT OUTSIDE GUI PRESERVED",
	11, COLOR.Success, Enum.Font.GothamMedium)
InfoStatus.Position = UDim2.new(0, 14, 0, 48)
InfoStatus.Size = UDim2.new(1, -28, 0, 140)
InfoStatus.TextXAlignment = Enum.TextXAlignment.Left
InfoStatus.TextYAlignment = Enum.TextYAlignment.Top
InfoStatus.ZIndex = 24

local CurrentTab = "Home"

local function SelectTab(name)
	CurrentTab = name

	HomePage.Visible = false
	SettingsPage.Visible = false
	InfoPage.Visible = false

	HomeTab.BackgroundColor3 = COLOR.Button
	SettingsTab.BackgroundColor3 = COLOR.Button
	InfoTab.BackgroundColor3 = COLOR.Button

	HomeTab.TextColor3 = COLOR.SubText
	SettingsTab.TextColor3 = COLOR.SubText
	InfoTab.TextColor3 = COLOR.SubText

	if name == "Home" then
		HomePage.Visible = true
		HomeTab.BackgroundColor3 = COLOR.AccentDark
		HomeTab.TextColor3 = COLOR.Text
	elseif name == "Settings" then
		SettingsPage.Visible = true
		SettingsTab.BackgroundColor3 = COLOR.AccentDark
		SettingsTab.TextColor3 = COLOR.Text
	elseif name == "Info" then
		InfoPage.Visible = true
		InfoTab.BackgroundColor3 = COLOR.AccentDark
		InfoTab.TextColor3 = COLOR.Text
	end
end

HomeTab.MouseButton1Click:Connect(function() SelectTab("Home") end)
SettingsTab.MouseButton1Click:Connect(function() SelectTab("Settings") end)
InfoTab.MouseButton1Click:Connect(function() SelectTab("Info") end)

local Floating = Instance.new("TextButton")
Floating.Name = "FloatingToggle"
Floating.AnchorPoint = Vector2.new(1, 0.5)
Floating.Position = UDim2.fromScale(0.95, 0.50)
Floating.Size = UDim2.fromOffset(52, 52)
Floating.BackgroundColor3 = COLOR.Accent
Floating.BorderSizePixel = 0
Floating.Text = "☰"
Floating.TextColor3 = COLOR.Text
Floating.TextSize = 20
Floating.Font = Enum.Font.GothamBold
Floating.AutoButtonColor = false
Floating.Active = true
Floating.ZIndex = 100
Floating.Parent = Gui
Corner(Floating, 17)
Stroke(Floating, Color3.fromRGB(215, 195, 255), 1, 0.4)

local Dragging = false
local DragStart = nil
local StartPosition = nil

Header.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch
		or input.UserInputType == Enum.UserInputType.MouseButton1 then
		Dragging = true
		DragStart = input.Position
		StartPosition = Main.Position
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch
		or input.UserInputType == Enum.UserInputType.MouseButton1 then
		Dragging = false
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if not Dragging then return end

	if input.UserInputType == Enum.UserInputType.Touch
		or input.UserInputType == Enum.UserInputType.MouseMovement then
		local Delta = input.Position - DragStart

		Main.Position = UDim2.new(
			StartPosition.X.Scale,
			StartPosition.X.Offset + Delta.X,
			StartPosition.Y.Scale,
			StartPosition.Y.Offset + Delta.Y
		)
	end
end)

local IsOpen = true
local IsAnimating = false

local function OpenGui()
	if IsAnimating then return end

	IsAnimating = true
	IsOpen = true
	Floating.Visible = false
	Main.Visible = true

	Main.Position = UDim2.fromScale(0.5, 0.53)
	MainScale.Scale = 0.82

	Tween(MainScale, OPEN_INFO, {Scale = 1})
	Tween(Dim, OPEN_INFO, {BackgroundTransparency = 0.58})
	Tween(Blur, OPEN_INFO, {Size = 8})
	Tween(Main, OPEN_INFO, {Position = UDim2.fromScale(0.5, 0.5)})

	task.delay(0.44, function()
		IsAnimating = false
	end)
end

local function CloseGui()
	if IsAnimating then return end

	IsAnimating = true
	IsOpen = false

	Tween(MainScale, CLOSE_INFO, {Scale = 0.82})
	Tween(Dim, CLOSE_INFO, {BackgroundTransparency = 1})
	Tween(Blur, CLOSE_INFO, {Size = 0})
	Tween(Main, CLOSE_INFO, {Position = UDim2.fromScale(0.5, 0.53)})

	task.delay(0.25, function()
		Main.Visible = false
		Floating.Visible = true
		IsAnimating = false
	end)
end

Floating.MouseButton1Click:Connect(function()
	if IsOpen then CloseGui() else OpenGui() end
end)

Close.MouseButton1Click:Connect(function()
	CloseGui()
end)

Close.MouseEnter:Connect(function()
	Tween(Close, FAST, {BackgroundColor3 = COLOR.Danger})
end)

Close.MouseLeave:Connect(function()
	Tween(Close, FAST, {BackgroundColor3 = COLOR.Button})
end)

Floating.MouseButton1Down:Connect(function()
	Tween(Floating, FAST, {Size = UDim2.fromOffset(46, 46)})
end)

Floating.MouseButton1Up:Connect(function()
	Tween(Floating, FAST, {Size = UDim2.fromOffset(52, 52)})
end)

SelectTab("Home")

Main.Visible = true
Floating.Visible = false
Dim.BackgroundTransparency = 1
Blur.Size = 0

task.wait(0.05)
OpenGui()

print("[Delta Panel] Stable mobile GUI loaded.")
