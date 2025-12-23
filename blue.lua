local Player = game.Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Cleanup
if CoreGui:FindFirstChild("BlueDudeUltimate") then
    CoreGui:FindFirstChild("BlueDudeUltimate"):Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BlueDudeUltimate"
ScreenGui.Parent = CoreGui

-- Style Utility
local function ApplyPixelStyle(obj, isText, customSize)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = obj
    if isText then
        obj.Font = Enum.Font.Arcade
        obj.TextColor3 = Color3.fromRGB(255, 255, 255)
        obj.TextSize = customSize or 18
    end
end

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 420, 0, 280)
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -140)
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 85, 255)
MainFrame.Active = true
MainFrame.ClipsDescendants = true 
MainFrame.Parent = ScreenGui
ApplyPixelStyle(MainFrame)

local Stroke = Instance.new("UIStroke")
Stroke.Thickness = 3
Stroke.Color = Color3.fromRGB(0, 0, 0)
Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
Stroke.Parent = MainFrame

-- Title
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0, 40)
TitleLabel.Position = UDim2.new(0, 0, 0, 10)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Blue Dude Gui"
TitleLabel.Parent = MainFrame
ApplyPixelStyle(TitleLabel, true, 22)

-- Navigation Arrows
local ArrowRight = Instance.new("TextButton")
ArrowRight.Size = UDim2.new(0, 30, 0, 30)
ArrowRight.Position = UDim2.new(1, -40, 0, 10)
ArrowRight.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ArrowRight.Text = ">"
ArrowRight.ZIndex = 35
ArrowRight.Parent = MainFrame
ApplyPixelStyle(ArrowRight, true, 20)

local ArrowLeft = Instance.new("TextButton")
ArrowLeft.Size = UDim2.new(0, 30, 0, 30)
ArrowLeft.Position = UDim2.new(1, -75, 0, 10)
ArrowLeft.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ArrowLeft.Text = "<"
ArrowLeft.ZIndex = 35
ArrowLeft.Parent = MainFrame
ApplyPixelStyle(ArrowLeft, true, 20)

-- Page Container
local PageContainer = Instance.new("Frame")
PageContainer.Size = UDim2.new(2, 0, 1, -60)
PageContainer.Position = UDim2.new(0, 0, 0, 60)
PageContainer.BackgroundTransparency = 1
PageContainer.Parent = MainFrame

local function CreateMasterPage(pos)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(0.5, 0, 1, 0)
    f.Position = UDim2.new(pos, 0, 0, 0)
    f.BackgroundTransparency = 1
    f.Parent = PageContainer
    return f
end

local MasterPage1 = CreateMasterPage(0)
local MasterPage2 = CreateMasterPage(0.5)

-- CATEGORY HEADERS
local function CreateCategoryHeader(text, parent)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0, 120, 0, 25)
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(255, 255, 0)
    lbl.Parent = parent
    ApplyPixelStyle(lbl, true, 12)
end

CreateCategoryHeader("Part Hacks", MasterPage1)
CreateCategoryHeader("Player Hacks", MasterPage2)

-- LAYOUT SETUP
local function SetupPageLayout(master)
    local side = Instance.new("ScrollingFrame")
    side.Size = UDim2.new(0, 120, 1, -40)
    side.Position = UDim2.new(0, 10, 0, 30)
    side.BackgroundTransparency = 1
    side.BorderSizePixel = 0
    side.ScrollBarThickness = 2
    side.AutomaticCanvasSize = Enum.AutomaticSize.Y
    side.Parent = master
    Instance.new("UIListLayout", side).Padding = UDim.new(0, 8)

    local cont = Instance.new("ScrollingFrame")
    cont.Size = UDim2.new(1, -150, 1, -20)
    cont.Position = UDim2.new(0, 140, 0, 10)
    cont.BackgroundTransparency = 1
    cont.BorderSizePixel = 0
    cont.ScrollBarThickness = 4
    cont.AutomaticCanvasSize = Enum.AutomaticSize.Y 
    cont.Parent = master
    return side, cont
end

local Side1, Cont1 = SetupPageLayout(MasterPage1)
local Side2, Cont2 = SetupPageLayout(MasterPage2)

-- Sliding Page Logic
local currentPage = 1
local function UpdatePage()
    PageContainer:TweenPosition(currentPage == 1 and UDim2.new(0, 0, 0, 60) or UDim2.new(-1, 0, 0, 60), "Out", "Quad", 0.3, true)
end
ArrowRight.MouseButton1Click:Connect(function() currentPage = 2 UpdatePage() end)
ArrowLeft.MouseButton1Click:Connect(function() currentPage = 1 UpdatePage() end)

-- Feature Creator
local allFeaturePages = {}
local function CreateFeature(name, sideParent, contParent, isHome)
    local Page = Instance.new("Frame")
    Page.Size = UDim2.new(1, 0, 0, 0)
    Page.AutomaticSize = Enum.AutomaticSize.Y
    Page.BackgroundTransparency = 1
    Page.Visible = isHome or false
    Page.Parent = contParent
    
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, -5, 0, 40)
    Btn.BackgroundColor3 = Color3.fromRGB(0, 40, 150)
    Btn.Text = name
    Btn.Parent = sideParent
    ApplyPixelStyle(Btn, true, 12)
    
    Btn.MouseButton1Click:Connect(function()
        for _, p in pairs(allFeaturePages) do
            if p.Parent == contParent then p.Visible = false end
        end
        Page.Visible = true
    end)
    table.insert(allFeaturePages, Page)
    return Page
end

--- PAGE 1: PART HACKS ---
CreateFeature("Home", Side1, Cont1, true)

-- Part Tp
local TpP = CreateFeature("Part Tp", Side1, Cont1)
Instance.new("UIListLayout", TpP).Padding = UDim.new(0, 12)
local TpIn = Instance.new("TextBox")
TpIn.Size = UDim2.new(1, 0, 0, 50); TpIn.BackgroundColor3 = Color3.fromRGB(0,0,0); TpIn.PlaceholderText = "Part Name..."; TpIn.Parent = TpP; ApplyPixelStyle(TpIn, true, 20)
local TpBt = Instance.new("TextButton")
TpBt.Size = UDim2.new(1, 0, 0, 50); TpBt.BackgroundColor3 = Color3.fromRGB(0, 180, 0); TpBt.Text = "TELEPORT"; TpBt.Parent = TpP; ApplyPixelStyle(TpBt, true, 22)
TpBt.MouseButton1Click:Connect(function()
    local parts = {}
    for _, v in pairs(workspace:GetDescendants()) do if v:IsA("BasePart") and v.Name:lower() == TpIn.Text:lower() then table.insert(parts, v) end end
    if #parts > 0 then Player.Character.HumanoidRootPart.CFrame = parts[math.random(1, #parts)].CFrame * CFrame.new(0, 3, 0) end
end)

-- Part Name
local PnP = CreateFeature("Part Name", Side1, Cont1)
Instance.new("UIListLayout", PnP).Padding = UDim.new(0, 12)
local SelB = Instance.new("TextButton")
SelB.Size = UDim2.new(1, 0, 0, 50); SelB.BackgroundColor3 = Color3.fromRGB(0,0,0); SelB.Text = "SELECT"; SelB.Parent = PnP; ApplyPixelStyle(SelB, true, 22)
local ResT = Instance.new("TextBox")
ResT.Size = UDim2.new(1, 0, 0, 50); ResT.BackgroundColor3 = Color3.fromRGB(0,0,0); ResT.Text = "Result here..."; ResT.Parent = PnP; ApplyPixelStyle(ResT, true, 20)
local selecting = false
SelB.MouseButton1Click:Connect(function() selecting = not selecting; SelB.BackgroundColor3 = selecting and Color3.fromRGB(255,0,0) or Color3.fromRGB(0,0,0); SelB.Text = selecting and "READY..." or "SELECT" end)
UserInputService.InputBegan:Connect(function(input)
    if selecting and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
        local ray = workspace.CurrentCamera:ViewportPointToRay(input.Position.X, input.Position.Y)
        local hitPart = workspace:FindPartOnRay(Ray.new(ray.Origin, ray.Direction * 1000))
        if hitPart then ResT.Text = hitPart.Name; selecting = false; SelB.BackgroundColor3 = Color3.fromRGB(0,0,0); SelB.Text = "SELECT" end
    end
end)

-- Part Esp
local EspP = CreateFeature("Part Esp", Side1, Cont1)
Instance.new("UIListLayout", EspP).Padding = UDim.new(0, 12)
local EspIn = Instance.new("TextBox")
EspIn.Size = UDim2.new(1, 0, 0, 50); EspIn.BackgroundColor3 = Color3.fromRGB(0,0,0); EspIn.PlaceholderText = "Part Name..."; EspIn.Parent = EspP; ApplyPixelStyle(EspIn, true, 20)
local EspBt = Instance.new("TextButton")
EspBt.Size = UDim2.new(1, 0, 0, 50); EspBt.BackgroundColor3 = Color3.fromRGB(0, 180, 0); EspBt.Text = "ESP"; EspBt.Parent = EspP; ApplyPixelStyle(EspBt, true, 22)
local StopEsp = Instance.new("TextButton")
StopEsp.Size = UDim2.new(1, 0, 0, 50); StopEsp.BackgroundColor3 = Color3.fromRGB(200, 0, 0); StopEsp.Text = "STOP ESP"; StopEsp.Parent = EspP; ApplyPixelStyle(StopEsp, true, 22)
local hTable = {}
EspBt.MouseButton1Click:Connect(function()
    for _, h in pairs(hTable) do h:Destroy() end hTable = {}
    for _, v in pairs(workspace:GetDescendants()) do if v:IsA("BasePart") and v.Name:lower() == EspIn.Text:lower() then local h = Instance.new("Highlight", v); h.FillColor = Color3.fromRGB(0,255,0); table.insert(hTable, h) end end
end)
StopEsp.MouseButton1Click:Connect(function() for _, h in pairs(hTable) do h:Destroy() end hTable = {} end)

--- PAGE 2: PLAYER HACKS ---
CreateFeature("Home", Side2, Cont2, true)

-- Fling
local FlingP = CreateFeature("Fling", Side2, Cont2)
local FlingToggle = Instance.new("TextButton")
FlingToggle.Size = UDim2.new(1, 0, 0, 50); FlingToggle.BackgroundColor3 = Color3.fromRGB(0, 40, 150); FlingToggle.Text = "FLING: OFF"; FlingToggle.Parent = FlingP; ApplyPixelStyle(FlingToggle, true, 20)
local flinging = false; local spinVel = nil
FlingToggle.MouseButton1Click:Connect(function()
    flinging = not flinging
    if flinging then
        FlingToggle.BackgroundColor3 = Color3.fromRGB(0, 180, 0); FlingToggle.Text = "FLING: ON"
        spinVel = Instance.new("BodyAngularVelocity", Player.Character.HumanoidRootPart); spinVel.MaxTorque = Vector3.new(1, 1, 1) * math.huge; spinVel.P = math.huge; spinVel.AngularVelocity = Vector3.new(0, 99999, 0)
    else
        FlingToggle.BackgroundColor3 = Color3.fromRGB(0, 40, 150); FlingToggle.Text = "FLING: OFF"; if spinVel then spinVel:Destroy() end
    end
end)

-- Player TP
local PlyTpP = CreateFeature("Player Tp", Side2, Cont2)
Instance.new("UIListLayout", PlyTpP).Padding = UDim.new(0, 12)
local PlyInput = Instance.new("TextBox")
PlyInput.Size = UDim2.new(1, 0, 0, 50); PlyInput.BackgroundColor3 = Color3.fromRGB(0,0,0); PlyInput.PlaceholderText = "User Name..."; PlyInput.Parent = PlyTpP; ApplyPixelStyle(PlyInput, true, 20)
local PlyBtn = Instance.new("TextButton")
PlyBtn.Size = UDim2.new(1, 0, 0, 50); PlyBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 0); PlyBtn.Text = "TELEPORT"; PlyBtn.Parent = PlyTpP; ApplyPixelStyle(PlyBtn, true, 22)
PlyBtn.MouseButton1Click:Connect(function()
    local target = PlyInput.Text:lower()
    for _, v in pairs(game.Players:GetPlayers()) do
        if v.Name:lower():find(target) or v.DisplayName:lower():find(target) then
            if v.Character and v.Character:FindFirstChild("HumanoidRootPart") then Player.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0); break end
        end
    end
end)

-- Player ESP
local PlyEspP = CreateFeature("Player Esp", Side2, Cont2)
Instance.new("UIListLayout", PlyEspP).Padding = UDim.new(0, 12)
local EspUserIn = Instance.new("TextBox")
EspUserIn.Size = UDim2.new(1, 0, 0, 50); EspUserIn.BackgroundColor3 = Color3.fromRGB(0,0,0); EspUserIn.PlaceholderText = "Name or 'all'..."; EspUserIn.Parent = PlyEspP; ApplyPixelStyle(EspUserIn, true, 20)
local EspToggleBtn = Instance.new("TextButton")
EspToggleBtn.Size = UDim2.new(1, 0, 0, 50); EspToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 40, 150); EspToggleBtn.Text = "ESP: OFF"; EspToggleBtn.Parent = PlyEspP; ApplyPixelStyle(EspToggleBtn, true, 22)
local pEspActive = false; local pEspTable = {}
EspToggleBtn.MouseButton1Click:Connect(function()
    pEspActive = not pEspActive
    if pEspActive then
        EspToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 0); EspToggleBtn.Text = "ESP: ON"
        local target = EspUserIn.Text:lower()
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= Player and (target == "all" or v.Name:lower():find(target) or v.DisplayName:lower():find(target)) then
                if v.Character then
                    local h = Instance.new("Highlight", v.Character)
                    h.FillColor = Color3.fromRGB(255, 120, 0)
                    h.FillTransparency = 0.5; table.insert(pEspTable, h)
                end
            end
        end
    else
        EspToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 40, 150); EspToggleBtn.Text = "ESP: OFF"
        for _, h in pairs(pEspTable) do if h then h:Destroy() end end pEspTable = {}
    end
end)

-- SPC Feature (New Left GUI on Page 2)
local SPCFeature = CreateFeature("SPC", Side2, Cont2)
Instance.new("UIListLayout", SPCFeature).Padding = UDim.new(0, 12)

local SPCInput = Instance.new("TextBox")
SPCInput.Size = UDim2.new(1, 0, 0, 50)
SPCInput.BackgroundColor3 = Color3.fromRGB(0,0,0)
SPCInput.PlaceholderText = "Enter player name..."
SPCInput.Parent = SPCFeature
ApplyPixelStyle(SPCInput, true, 20)

local SPCToggle = Instance.new("TextButton")
SPCToggle.Size = UDim2.new(1, 0, 0, 50)
SPCToggle.BackgroundColor3 = Color3.fromRGB(0, 40, 150)
SPCToggle.Text = "ESP: OFF"
SPCToggle.Parent = SPCFeature
ApplyPixelStyle(S
