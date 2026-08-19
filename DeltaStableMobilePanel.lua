local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

if not UserInputService.TouchEnabled then
	return
end

local Camera = workspace.CurrentCamera
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local Settings = {
	AimEnabled = false,
	ESPEnabled = false,
	TeamCheck = false,

	AimFOV = 180,
	AimStrength = 0.35,
	MaxDistance = 500,
	AimPart = "Head"
}

local CurrentTarget = nil

--------------------------------------------------
-- GUI
--------------------------------------------------

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MobileDeveloperTools"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = PlayerGui

local Main = Instance.new("Frame")
Main.Size = UDim2.fromOffset(280, 370)
Main.Position = UDim2.new(0, 20, 0.5, -185)
Main.BackgroundColor3 = Color3.fromRGB(17, 17, 23)
Main.BorderSizePixel = 0
Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 16)
MainCorner.Parent = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(65, 65, 85)
MainStroke.Thickness = 1
MainStroke.Parent = Main

--------------------------------------------------
-- Header
--------------------------------------------------

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 58)
Header.BackgroundTransparency = 1
Header.Parent = Main

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -65, 0, 30)
Title.Position = UDim2.fromOffset(13, 7)
Title.BackgroundTransparency = 1
Title.Text = "LinerExploit"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 17
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local Subtitle = Instance.new("TextLabel")
Subtitle.Size = UDim2.new(1, -65, 0, 18)
Subtitle.Position = UDim2.fromOffset(13, 34)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "Aim Assist • ESP"
Subtitle.TextColor3 = Color3.fromRGB(135, 135, 150)
Subtitle.TextSize = 10
Subtitle.Font = Enum.Font.Gotham
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.Parent = Header

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.fromOffset(42, 42)
CloseButton.Position = UDim2.new(1, -50, 0, 8)
CloseButton.BackgroundColor3 = Color3.fromRGB(32, 32, 42)
CloseButton.Text = "×"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 24
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = Header

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 11)
CloseCorner.Parent = CloseButton

--------------------------------------------------
-- Floating Open Button
--------------------------------------------------

local OpenButton = Instance.new("TextButton")
OpenButton.Size = UDim2.fromOffset(55, 55)
OpenButton.Position = UDim2.new(0, 20, 0.5, -27)
OpenButton.BackgroundColor3 = Color3.fromRGB(25, 25, 34)
OpenButton.Text = "☰"
OpenButton.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenButton.TextSize = 23
OpenButton.Font = Enum.Font.GothamBold
OpenButton.Visible = false
OpenButton.Parent = ScreenGui

local OpenCorner = Instance.new("UICorner")
OpenCorner.CornerRadius = UDim.new(1, 0)
OpenCorner.Parent = OpenButton

local OpenStroke = Instance.new("UIStroke")
OpenStroke.Color = Color3.fromRGB(70, 70, 90)
OpenStroke.Thickness = 1
OpenStroke.Parent = OpenButton

--------------------------------------------------
-- Content
--------------------------------------------------

local Container = Instance.new("Frame")
Container.Size = UDim2.new(1, -20, 1, -68)
Container.Position = UDim2.fromOffset(10, 62)
Container.BackgroundTransparency = 1
Container.Parent = Main

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 7)
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Parent = Container

local function CreateButton(Text)
	local Button = Instance.new("TextButton")

	Button.Size = UDim2.new(1, 0, 0, 40)
	Button.BackgroundColor3 = Color3.fromRGB(29, 29, 39)
	Button.BorderSizePixel = 0

	Button.Text = Text
	Button.TextColor3 = Color3.fromRGB(225, 225, 235)
	Button.TextSize = 12
	Button.Font = Enum.Font.GothamMedium

	Button.AutoButtonColor = false
	Button.Parent = Container

	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 9)
	Corner.Parent = Button

	return Button
end

local AimButton = CreateButton("🎯  AIM ASSIST     OFF")
local ESPButton = CreateButton("👁  ESP             OFF")
local TeamButton = CreateButton("👥  TEAM CHECK     OFF")
local StrengthButton = CreateButton("⚡  AIM: MEDIUM")
local FOVButton = CreateButton("⭕  FOV: 180")
local DistanceButton = CreateButton("📏  DISTANCE: 500")

--------------------------------------------------
-- Close / Open
--------------------------------------------------

CloseButton.Activated:Connect(function()
	Main.Visible = false
	OpenButton.Visible = true
end)

OpenButton.Activated:Connect(function()
	Main.Visible = true
	OpenButton.Visible = false
end)

--------------------------------------------------
-- Aim Strength
--------------------------------------------------

local Strengths = {
	{
		Name = "WEAK",
		Value = 0.10
	},
	{
		Name = "LIGHT",
		Value = 0.20
	},
	{
		Name = "MEDIUM",
		Value = 0.35
	},
	{
		Name = "STRONG",
		Value = 0.55
	},
	{
		Name = "LOCK",
		Value = 1
	}
}

local StrengthIndex = 3

local function UpdateStrength()
	local Data = Strengths[StrengthIndex]

	Settings.AimStrength = Data.Value

	StrengthButton.Text =
		"⚡  AIM: " .. Data.Name
end

StrengthButton.Activated:Connect(function()

	StrengthIndex += 1

	if StrengthIndex > #Strengths then
		StrengthIndex = 1
	end

	UpdateStrength()
end)

--------------------------------------------------
-- Buttons
--------------------------------------------------

local function UpdateButton(Button, Label, Enabled)

	if Enabled then
		Button.Text = Label .. "     ON"
		Button.BackgroundColor3 =
			Color3.fromRGB(35, 90, 65)
	else
		Button.Text = Label .. "     OFF"
		Button.BackgroundColor3 =
			Color3.fromRGB(29, 29, 39)
	end
end

AimButton.Activated:Connect(function()

	Settings.AimEnabled = not Settings.AimEnabled

	if not Settings.AimEnabled then
		CurrentTarget = nil
	end

	UpdateButton(
		AimButton,
		"🎯  AIM ASSIST",
		Settings.AimEnabled
	)
end)

ESPButton.Activated:Connect(function()

	Settings.ESPEnabled = not Settings.ESPEnabled

	UpdateButton(
		ESPButton,
		"👁  ESP",
		Settings.ESPEnabled
	)
end)

--------------------------------------------------
-- TEAM CHECK
--------------------------------------------------

TeamButton.Activated:Connect(function()

	Settings.TeamCheck = not Settings.TeamCheck

	if CurrentTarget and
		Settings.TeamCheck and
		CurrentTarget.Team ~= nil and
		LocalPlayer.Team ~= nil and
		CurrentTarget.Team == LocalPlayer.Team then

		CurrentTarget = nil
	end

	UpdateButton(
		TeamButton,
		"👥  TEAM CHECK",
		Settings.TeamCheck
	)
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

	local Index =
		table.find(FOVValues, Settings.AimFOV) or 3

	Index += 1

	if Index > #FOVValues then
		Index = 1
	end

	Settings.AimFOV =
		FOVValues[Index]

	FOVButton.Text =
		"⭕  FOV: " .. Settings.AimFOV
end)

--------------------------------------------------
-- Distance
--------------------------------------------------

local DistanceValues = {
	100,
	250,
	500,
	1000
}

DistanceButton.Activated:Connect(function()

	local Index =
		table.find(
			DistanceValues,
			Settings.MaxDistance
		) or 3

	Index += 1

	if Index > #DistanceValues then
		Index = 1
	end

	Settings.MaxDistance =
		DistanceValues[Index]

	DistanceButton.Text =
		"📏  DISTANCE: " ..
		Settings.MaxDistance
end)

--------------------------------------------------
-- FOV Circle
--------------------------------------------------

local FOVCircle = Instance.new("Frame")

FOVCircle.Size =
	UDim2.fromOffset(
		Settings.AimFOV * 2,
		Settings.AimFOV * 2
	)

FOVCircle.AnchorPoint =
	Vector2.new(0.5, 0.5)

FOVCircle.Position =
	UDim2.fromScale(0.5, 0.5)

FOVCircle.BackgroundTransparency = 1
FOVCircle.Visible = false
FOVCircle.Parent = ScreenGui

local FOVCorner = Instance.new("UICorner")
FOVCorner.CornerRadius =
	UDim.new(1, 0)

FOVCorner.Parent = FOVCircle

local FOVStroke = Instance.new("UIStroke")
FOVStroke.Color =
	Color3.fromRGB(80, 170, 255)

FOVStroke.Thickness = 2
FOVStroke.Transparency = 0.25
FOVStroke.Parent = FOVCircle

--------------------------------------------------
-- Drag Main Window
--------------------------------------------------

local Dragging = false
local DragStart
local StartPosition

Header.InputBegan:Connect(function(Input)

	if Input.UserInputType ==
		Enum.UserInputType.Touch then

		Dragging = true

		DragStart = Input.Position
		StartPosition = Main.Position

		Input.Changed:Connect(function()

			if Input.UserInputState ==
				Enum.UserInputState.End then

				Dragging = false
			end
		end)
	end
end)

UserInputService.InputChanged:Connect(function(Input)

	if Dragging and
		Input.UserInputType ==
		Enum.UserInputType.Touch then

		local Delta =
			Input.Position - DragStart

		Main.Position = UDim2.new(
			StartPosition.X.Scale,
			StartPosition.X.Offset + Delta.X,
			StartPosition.Y.Scale,
			StartPosition.Y.Offset + Delta.Y
		)
	end
end)

--------------------------------------------------
-- Character
--------------------------------------------------

local function GetCharacter(Player)

	if not Player or
		not Player.Character then

		return nil
	end

	local Character = Player.Character

	local Humanoid =
		Character:FindFirstChildOfClass(
			"Humanoid"
		)

	local Root =
		Character:FindFirstChild(
			"HumanoidRootPart"
		)

	local Head =
		Character:FindFirstChild(
			Settings.AimPart
		)

	if not Humanoid or
		Humanoid.Health <= 0 or
		not Root or
		not Head then

		return nil
	end

	return Character,
		Humanoid,
		Root,
		Head
end

--------------------------------------------------
-- Team Detection
--------------------------------------------------

local function IsSameTeam(Player)

	if not Settings.TeamCheck then
		return false
	end

	-- IMPORTANT:
	-- nil == nil would otherwise make every
	-- unassigned player look like a teammate.

	if LocalPlayer.Team == nil then
		return false
	end

	if Player.Team == nil then
		return false
	end

	return Player.Team == LocalPlayer.Team
end

--------------------------------------------------
-- Target Validation
--------------------------------------------------

local function IsValidTarget(Player)

	if not Player or
		Player == LocalPlayer or
		not Player.Parent then

		return false
	end

	if IsSameTeam(Player) then
		return false
	end

	local Character,
		Humanoid,
		Root,
		Head = GetCharacter(Player)

	if not Character then
		return false
	end

	local LocalCharacter =
		LocalPlayer.Character

	if not LocalCharacter then
		return false
	end

	local LocalRoot =
		LocalCharacter:FindFirstChild(
			"HumanoidRootPart"
		)

	if not LocalRoot then
		return false
	end

	local Distance =
		(Root.Position -
			LocalRoot.Position).Magnitude

	return Distance <=
		Settings.MaxDistance
end

--------------------------------------------------
-- Find Target
--------------------------------------------------

local function FindNewTarget()

	local BestTarget = nil

	local BestDistance =
		Settings.AimFOV

	local Viewport =
		Camera.ViewportSize

	local Center =
		Vector2.new(
			Viewport.X / 2,
			Viewport.Y / 2
		)

	for _, Player in
		ipairs(Players:GetPlayers()) do

		if IsValidTarget(Player) then

			local Character,
				Humanoid,
				Root,
				Head =
				GetCharacter(Player)

			local ScreenPosition,
				Visible =
				Camera:WorldToViewportPoint(
					Head.Position
				)

			if Visible and
				ScreenPosition.Z > 0 then

				local Point =
					Vector2.new(
						ScreenPosition.X,
						ScreenPosition.Y
					)

				local Distance =
					(Point - Center).Magnitude

				if Distance <
					BestDistance then

					BestDistance =
						Distance

					BestTarget =
						Player
				end
			end
		end
	end

	return BestTarget
end

--------------------------------------------------
-- Sticky Aim
--------------------------------------------------

RunService.RenderStepped:Connect(function()

	if not Settings.AimEnabled then

		CurrentTarget = nil
		FOVCircle.Visible = false

		return
	end

	FOVCircle.Visible = true

	FOVCircle.Size =
		UDim2.fromOffset(
			Settings.AimFOV * 2,
			Settings.AimFOV * 2
		)

	if not IsValidTarget(CurrentTarget) then

		CurrentTarget =
			FindNewTarget()
	end

	if not CurrentTarget then
		return
	end

	local Character,
		Humanoid,
		Root,
		Head =
		GetCharacter(CurrentTarget)

	if not Head then

		CurrentTarget = nil

		return
	end

	local CameraPosition =
		Camera.CFrame.Position

	local Desired =
		CFrame.lookAt(
			CameraPosition,
			Head.Position
		)

	Camera.CFrame =
		Camera.CFrame:Lerp(
			Desired,
			Settings.AimStrength
		)
end)

--------------------------------------------------
-- ESP
--------------------------------------------------

local ESP = {}

local function CreateESP(Player)

	if Player == LocalPlayer or
		ESP[Player] then

		return
	end

	local Billboard =
		Instance.new("BillboardGui")

	Billboard.Name =
		"MobileESP"

	Billboard.Size =
		UDim2.fromOffset(160, 70)

	Billboard.StudsOffset =
		Vector3.new(0, 3, 0)

	Billboard.AlwaysOnTop = true
	Billboard.Enabled = false
	Billboard.Parent = ScreenGui

	local Name =
		Instance.new("TextLabel")

	Name.Size =
		UDim2.new(1, 0, 0, 20)

	Name.BackgroundTransparency = 1
	Name.TextColor3 =
		Color3.fromRGB(255, 255, 255)

	Name.TextStrokeTransparency = 0.4
	Name.TextSize = 13
	Name.Font =
		Enum.Font.GothamBold

	Name.Parent = Billboard

	local Health =
		Instance.new("TextLabel")

	Health.Size =
		UDim2.new(1, 0, 0, 18)

	Health.Position =
		UDim2.fromOffset(0, 20)

	Health.BackgroundTransparency = 1

	Health.TextColor3 =
		Color3.fromRGB(100, 255, 130)

	Health.TextStrokeTransparency = 0.4
	Health.TextSize = 11
	Health.Font =
		Enum.Font.Gotham

	Health.Parent = Billboard

	local Distance =
		Instance.new("TextLabel")

	Distance.Size =
		UDim2.new(1, 0, 0, 18)

	Distance.Position =
		UDim2.fromOffset(0, 38)

	Distance.BackgroundTransparency = 1

	Distance.TextColor3 =
		Color3.fromRGB(180, 200, 255)

	Distance.TextStrokeTransparency = 0.4
	Distance.TextSize = 11
	Distance.Font =
		Enum.Font.Gotham

	Distance.Parent = Billboard

	ESP[Player] = {
		Billboard = Billboard,
		Name = Name,
		Health = Health,
		Distance = Distance
	}
end

local function RemoveESP(Player)

	if ESP[Player] then

		ESP[Player].Billboard:Destroy()
		ESP[Player] = nil
	end

	if CurrentTarget == Player then
		CurrentTarget = nil
	end
end

for _, Player in
	ipairs(Players:GetPlayers()) do

	CreateESP(Player)
end

Players.PlayerAdded:Connect(CreateESP)
Players.PlayerRemoving:Connect(RemoveESP)

RunService.RenderStepped:Connect(function()

	for Player, Object in
		pairs(ESP) do

		if not Settings.ESPEnabled then

			Object.Billboard.Enabled = false

			continue
		end

		if not IsValidTarget(Player) then

			Object.Billboard.Enabled = false

			continue
		end

		local Character,
			Humanoid,
			Root,
			Head =
			GetCharacter(Player)

		local LocalCharacter =
			LocalPlayer.Character

		local LocalRoot =
			LocalCharacter and
			LocalCharacter:FindFirstChild(
				"HumanoidRootPart"
			)

		if not LocalRoot then

			Object.Billboard.Enabled = false

			continue
		end

		local Distance =
			(Root.Position -
				LocalRoot.Position).Magnitude

		Object.Billboard.Adornee =
			Head

		Object.Billboard.Enabled = true

		Object.Name.Text =
			Player.DisplayName

		local HealthPercent =
			math.floor(
				(Humanoid.Health /
					Humanoid.MaxHealth) * 100
			)

		Object.Health.Text =
			"HP: " ..
			math.max(
				0,
				HealthPercent
			) ..
			"%"

		Object.Distance.Text =
			math.floor(Distance) ..
			" studs"
	end
end)

UpdateStrength()-- CLEANUP
pcall(function()
	local oldGui = PlayerGui:FindFirstChild("DeltaStableMobilePanel")
	if oldGui then oldGui:Destroy() end
end)

pcall(function()
	local oldBlur = Lighting:FindFirstChild("DeltaStableMobileBlur")
	if oldBlur then oldBlur:Destroy() end
end)

-- COLORS
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

-- TWEEN INFO
local FAST = TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local MEDIUM = TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local OPEN_INFO = TweenInfo.new(0.42, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local CLOSE_INFO = TweenInfo.new(0.24, Enum.EasingStyle.Quart, Enum.EasingDirection.In)

-- HELPERS
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

-- SCREEN GUI
local Gui = Instance.new("ScreenGui")
Gui.Name = "DeltaStableMobilePanel"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.DisplayOrder = 500
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.Parent = PlayerGui

-- BLUR
local Blur = Instance.new("BlurEffect")
Blur.Name = "DeltaStableMobileBlur"
Blur.Size = 0
Blur.Parent = Lighting

-- DIM
local Dim = Instance.new("Frame")
Dim.Name = "Dim"
Dim.Size = UDim2.fromScale(1, 1)
Dim.BackgroundColor3 = Color3.new(0, 0, 0)
Dim.BackgroundTransparency = 1
Dim.BorderSizePixel = 0
Dim.Active = true
Dim.ZIndex = 1
Dim.Parent = Gui

-- SCALE
local MainScale = Instance.new("UIScale")
MainScale.Scale = 1

-- MAIN
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

-- RESPONSIVE SIZE
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

-- HEADER
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

-- LOGO
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

-- TITLE
local Title = Label(Header, "Delta Panel", 16, COLOR.Text, Enum.Font.GothamBold)
Title.Position = UDim2.new(0, 57, 0, 8)
Title.Size = UDim2.new(1, -115, 0, 21)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 12

-- SUBTITLE
local Subtitle = Label(Header, "Mobile interface", 10, COLOR.SubText, Enum.Font.Gotham)
Subtitle.Position = UDim2.new(0, 57, 0, 30)
Subtitle.Size = UDim2.new(1, -115, 0, 16)
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.ZIndex = 12

-- CLOSE BUTTON
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

-- BODY
local Body = Instance.new("Frame")
Body.Name = "Body"
Body.Position = UDim2.new(0, 12, 0, 69)
Body.Size = UDim2.new(1, -24, 1, -81)
Body.BackgroundTransparency = 1
Body.Active = true
Body.ZIndex = 8
Body.Parent = Main

-- TAB BAR
local Tabs = Instance.new("Frame")
Tabs.Size = UDim2.new(1, 0, 0, 40)
Tabs.BackgroundColor3 = COLOR.Background
Tabs.BorderSizePixel = 0
Tabs.Active = true
Tabs.ZIndex = 10
Tabs.Parent = Body
Corner(Tabs, 11)

-- TAB CREATOR
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

-- PAGE CONTAINER
local PageContainer = Instance.new("Frame")
PageContainer.Position = UDim2.new(0, 0, 0, 50)
PageContainer.Size = UDim2.new(1, 0, 1, -50)
PageContainer.BackgroundTransparency = 1
PageContainer.ClipsDescendants = true
PageContainer.Active = true
PageContainer.ZIndex = 20
PageContainer.Parent = Body

-- PAGE CREATOR
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

-- CARD
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

-- HOME
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

-- HOME ACTION CARD
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

-- HOME EXTRA CARD
local HomeExtra = CreateCard(HomePage, 278, 270)

local HomeExtraTitle = Label(HomeExtra, "Interface Features", 14, COLOR.Text, Enum.Font.GothamBold)
HomeExtraTitle.Position = UDim2.new(0, 14, 0, 12)
HomeExtraTitle.Size = UDim2.new(1, -28, 0, 20)
HomeExtraTitle.TextXAlignment = Enum.TextXAlignment.Left
HomeExtraTitle.ZIndex = 24

local HomeExtraText = Label(
	HomeExtra,
	"• Smooth open / close animation\n\n"
		.. "• Scrollable mobile pages\n\n"
		.. "• Touch-friendly controls\n\n"
		.. "• Draggable header\n\n"
		.. "• Floating reopen button\n\n"
		.. "• Responsive panel sizing\n\n"
		.. "• No full-screen touch blocker",
	11,
	COLOR.SubText
)
HomeExtraText.Position = UDim2.new(0, 14, 0, 45)
HomeExtraText.Size = UDim2.new(1, -28, 0, 210)
HomeExtraText.TextXAlignment = Enum.TextXAlignment.Left
HomeExtraText.TextYAlignment = Enum.TextYAlignment.Top
HomeExtraText.ZIndex = 24

-- SETTINGS
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

-- TOGGLE
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
	-- Reserved for future customization.
end)

CreateToggle(SettingsCard, 196, "Touch-Friendly Mode", true, function(_state)
	-- The GUI itself already consumes its own touches.
	-- Nothing is placed over the rest of the game.
end)

-- SETTINGS EXTRA
local SettingsExtra = CreateCard(SettingsPage, 300, 270)

local SettingsExtraTitle = Label(SettingsExtra, "Mobile Controls", 14, COLOR.Text, Enum.Font.GothamBold)
SettingsExtraTitle.Position = UDim2.new(0, 14, 0, 12)
SettingsExtraTitle.Size = UDim2.new(1, -28, 0, 20)
SettingsExtraTitle.TextXAlignment = Enum.TextXAlignment.Left
SettingsExtraTitle.ZIndex = 24

local SettingsExtraText = Label(
	SettingsExtra,
	"Swipe inside a page to scroll.\n\n"
		.. "Drag the header to move the panel.\n\n"
		.. "Tap the floating button to reopen it.\n\n"
		.. "Swipes outside the panel are left alone, "
		.. "so normal game camera controls continue working.",
	11,
	COLOR.SubText
)
SettingsExtraText.Position = UDim2.new(0, 14, 0, 45)
SettingsExtraText.Size = UDim2.new(1, -28, 0, 190)
SettingsExtraText.TextWrapped = true
SettingsExtraText.TextXAlignment = Enum.TextXAlignment.Left
SettingsExtraText.TextYAlignment = Enum.TextYAlignment.Top
SettingsExtraText.ZIndex = 24

-- INFO
local InfoCard = CreateCard(InfoPage, 6, 260)

local InfoTitle = Label(InfoCard, "About Delta Panel", 15, COLOR.Text, Enum.Font.GothamBold)
InfoTitle.Position = UDim2.new(0, 14, 0, 12)
InfoTitle.Size = UDim2.new(1, -28, 0, 22)
InfoTitle.TextXAlignment = Enum.TextXAlignment.Left
InfoTitle.ZIndex = 24

local InfoText = Label(
	InfoCard,
	"Mobile UI framework\n\n"
		.. "✓ Responsive layout\n\n"
		.. "✓ Smooth transitions\n\n"
		.. "✓ Scrollable pages\n\n"
		.. "✓ Touch-friendly buttons\n\n"
		.. "✓ Draggable header\n\n"
		.. "✓ No invisible full-screen blocker",
	11,
	COLOR.SubText
)
InfoText.Position = UDim2.new(0, 14, 0, 48)
InfoText.Size = UDim2.new(1, -28, 0, 195)
InfoText.TextXAlignment = Enum.TextXAlignment.Left
InfoText.TextYAlignment = Enum.TextYAlignment.Top
InfoText.ZIndex = 24

-- INFO EXTRA
local InfoExtra = CreateCard(InfoPage, 275, 210)

local InfoExtraTitle = Label(InfoExtra, "Status", 14, COLOR.Text, Enum.Font.GothamBold)
InfoExtraTitle.Position = UDim2.new(0, 14, 0, 12)
InfoExtraTitle.Size = UDim2.new(1, -28, 0, 20)
InfoExtraTitle.TextXAlignment = Enum.TextXAlignment.Left
InfoExtraTitle.ZIndex = 24

local InfoStatus = Label(
	InfoExtra,
	"● GUI LOADED\n\n"
		.. "● SCROLL ENABLED\n\n"
		.. "● TOUCH INPUT ACTIVE\n\n"
		.. "● CAMERA INPUT OUTSIDE GUI PRESERVED",
	11,
	COLOR.Success,
	Enum.Font.GothamMedium
)
InfoStatus.Position = UDim2.new(0, 14, 0, 48)
InfoStatus.Size = UDim2.new(1, -28, 0, 140)
InfoStatus.TextXAlignment = Enum.TextXAlignment.Left
InfoStatus.TextYAlignment = Enum.TextYAlignment.Top
InfoStatus.ZIndex = 24

-- TAB SWITCHER
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

HomeTab.MouseButton1Click:Connect(function()
	SelectTab("Home")
end)

SettingsTab.MouseButton1Click:Connect(function()
	SelectTab("Settings")
end)

InfoTab.MouseButton1Click:Connect(function()
	SelectTab("Info")
end)

-- FLOATING BUTTON
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

-- DRAGGING
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

-- OPEN / CLOSE
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

-- BUTTON EVENTS
Floating.MouseButton1Click:Connect(function()
	if IsOpen then
		CloseGui()
	else
		OpenGui()
	end
end)

Close.MouseButton1Click:Connect(function()
	CloseGui()
end)

-- BUTTON ANIMATIONS
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

-- INITIAL TAB
SelectTab("Home")

-- STARTUP
Main.Visible = true
Floating.Visible = false
Dim.BackgroundTransparency = 1
Blur.Size = 0

task.wait(0.05)
OpenGui()

print("[Delta Panel] Stable mobile GUI loaded.")
