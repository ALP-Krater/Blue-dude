-- ================= GUI =================

local ScreenGui = Instance.new("ScreenGui", parent)

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0,0,0,0)
Main.Position = UDim2.new(0.5,-300,0.5,-150)
Main.BackgroundColor3 = Color3.fromRGB(255,140,0) -- ORANGE background
Main.BorderSizePixel = 0
Main.Visible = false
Instance.new("UICorner", Main).CornerRadius = UDim.new(0.1,0)
local mainStroke = Instance.new("UIStroke", Main)
mainStroke.Color = Color3.new(0,0,0) -- black stroke

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1,0,0,36)
Title.BackgroundTransparency = 1
Title.Text = "Goon Lagoon Gui"
Title.Font = Enum.Font.Arcade
Title.TextScaled = true
Title.TextColor3 = Color3.new(0,0,0)

-- Sidebar
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0,60,1,-50)
Sidebar.Position = UDim2.new(0,10,0,45)
Sidebar.BackgroundColor3 = Color3.fromRGB(0,0,0) -- black
Sidebar.BorderSizePixel = 0
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0.1,0)
Instance.new("UIStroke", Sidebar).Color = Color3.new(0,0,0)

-- Pages holder
local Pages = Instance.new("Frame", Main)
Pages.Size = UDim2.new(1,-90,1,-60)
Pages.Position = UDim2.new(0,80,0,50)
Pages.BackgroundTransparency = 1

-- ================= PART SELECT HOVER =================

local selectionHighlight

local function activatePartSelect(mouse)
	if not selectionHighlight then
		selectionHighlight = Instance.new("Highlight")
		selectionHighlight.FillColor = Color3.fromRGB(255,255,0) -- yellow hover
		selectionHighlight.OutlineColor = Color3.new(0,0,0)
		selectionHighlight.FillTransparency = 0.5
		selectionHighlight.OutlineTransparency = 0
		selectionHighlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	end

	local hoverConnection
	hoverConnection = RunService.Heartbeat:Connect(function()
		if selectingPart and mouse.Target and mouse.Target:IsA("BasePart") then
			selectionHighlight.Adornee = mouse.Target
			selectionHighlight.Parent = mouse.Target
		else
			selectionHighlight.Adornee = nil
		end
	end)

	local clickConnection
	clickConnection = mouse.Button1Down:Connect(function()
		if selectingPart and mouse.Target and mouse.Target:IsA("BasePart") then
			partBox.Text = mouse.Target.Name
			partNameQuery = mouse.Target.Name
			partOn = true
			partToggleBtn.Text = "ON"
			selectingPart = false
			partSelectBtn.Text = "Select"
			selectionHighlight.Adornee = nil
			hoverConnection:Disconnect()
			clickConnection:Disconnect()
		end
	end)
end

partSelectBtn.MouseButton1Click:Connect(function()
	selectingPart = not selectingPart
	partSelectBtn.Text = selectingPart and "SELECTING" or "Select"
	if selectingPart then
		local mouse = LocalPlayer:GetMouse()
		activatePartSelect(mouse)
	end
end)
