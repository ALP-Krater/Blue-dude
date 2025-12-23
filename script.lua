--- PAGE 2: PLAYER HACKS ---
CreateFeature("Home", Side2, Cont2, true)

-- Fling
local FlingP = CreateFeature("Fling", Side2, Cont2)
local FlingToggle = Instance.new("TextButton")
FlingToggle.Size = UDim2.new(1, 0, 0, 50); FlingToggle.BackgroundColor3 = Color3.fromRGB(0, 40, 150); FlingToggle.Text = "FLING: OFF"; FlingToggle.Parent = FlingP; ApplyPixelStyle(FlingToggle, true, 20)
local flinging = false; local spinVel = nil
FlingToggle.TouchTap:Connect(function()
    flinging = not flinging
    if flinging then
        FlingToggle.BackgroundColor3 = Color3.fromRGB(0, 180, 0); FlingToggle.Text = "FLING: ON"
        spinVel = Instance.new("BodyAngularVelocity", Player.Character.HumanoidRootPart); spinVel.MaxTorque = Vector3.new(1, 1, 1) * math.huge; spinVel.P = math.huge; spinVel.AngularVelocity = Vector3.new(0, 99999, 0)
    else
        FlingToggle.BackgroundColor3 = Color3.fromRGB(0, 40, 150); FlingToggle.Text = "FLING: OFF"; if spinVel then spinVel:Destroy() end
    end
end)

-- Spectator Mode (NEW)
local SpectatorP = CreateFeature("Spectator", Side2, Cont2)
local SpectatorToggle = Instance.new("TextButton")
SpectatorToggle.Size = UDim2.new(1, 0, 0, 50); SpectatorToggle.BackgroundColor3 = Color3.fromRGB(0, 40, 150); SpectatorToggle.Text = "SPECTATOR: OFF"; SpectatorToggle.Parent = SpectatorP; ApplyPixelStyle(SpectatorToggle, true, 20)

-- Camera up and down buttons
local UpButton = Instance.new("TextButton")
UpButton.Size = UDim2.new(0.45, 0, 0, 50)
UpButton.Position = UDim2.new(0.5, -120, 0, 60)
UpButton.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
UpButton.Text = "UP"
UpButton.Parent = SpectatorP
ApplyPixelStyle(UpButton, true, 20)

local DownButton = Instance.new("TextButton")
DownButton.Size = UDim2.new(0.45, 0, 0, 50)
DownButton.Position = UDim2.new(0.5, 120, 0, 60)
DownButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
DownButton.Text = "DOWN"
DownButton.Parent = SpectatorP
ApplyPixelStyle(DownButton, true, 20)

local spectatorMode = false
local cameraHeight = 50 -- Initial height
SpectatorToggle.TouchTap:Connect(function()
    spectatorMode = not spectatorMode
    if spectatorMode then
        SpectatorToggle.BackgroundColor3 = Color3.fromRGB(0, 180, 0); SpectatorToggle.Text = "SPECTATOR: ON"
        -- Anchor the player to prevent movement and make the camera free
        Player.Character:WaitForChild("HumanoidRootPart").Anchored = true
        -- Enable free camera control
        local camera = game.Workspace.CurrentCamera
        camera.CameraType = Enum.CameraType.Scriptable
        camera.CFrame = Player.Character.HumanoidRootPart.CFrame
        -- Disable character controls to keep it stationary
        Player.Character:WaitForChild("Humanoid").PlatformStand = true
    else
        SpectatorToggle.BackgroundColor3 = Color3.fromRGB(0, 40, 150); SpectatorToggle.Text = "SPECTATOR: OFF"
        -- Re-enable character movement and restore normal camera control
        Player.Character:WaitForChild("HumanoidRootPart").Anchored = false
        local camera = game.Workspace.CurrentCamera
        camera.CameraType = Enum.CameraType.Custom
        Player.Character:WaitForChild("Humanoid").PlatformStand = false
    end
end)

-- Up/Down camera movement
UpButton.TouchTap:Connect(function()
    if spectatorMode then
        cameraHeight = cameraHeight + 10 -- Move camera up
        local camera = game.Workspace.CurrentCamera
        camera.CFrame = CFrame.new(camera.CFrame.X, cameraHeight, camera.CFrame.Z)
    end
end)

DownButton.TouchTap:Connect(function()
    if spectatorMode then
        cameraHeight = cameraHeight - 10 -- Move camera down
        local camera = game.Workspace.CurrentCamera
        camera.CFrame = CFrame.new(camera.CFrame.X, cameraHeight, camera.CFrame.Z)
    end
end)

-- Horizontal camera movement logic
local lastTouchPos = nil
UserInputService.TouchStarted:Connect(function(input)
    if spectatorMode then
        lastTouchPos = input.Position.X
    end
end)

UserInputService.TouchMoved:Connect(function(input)
    if spectatorMode and lastTouchPos then
        local deltaX = input.Position.X - lastTouchPos
        local camera = game.Workspace.CurrentCamera
        camera.CFrame = CFrame.new(camera.CFrame.X + deltaX, camera.CFrame.Y, camera.CFrame.Z)
        lastTouchPos = input.Position.X
    end
end)

-- Loops & Toggle Logic
RunService.Stepped:Connect(function()
    if flinging and Player.Character then
        for _, v in pairs(Player.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
    end
end)

-- Mobile-friendly Toggle button for opening/closing the frame
local expanded = true
local ToggleBt = Instance.new("TextButton")
ToggleBt.Size = UDim2.new(0, 50, 0, 50)
ToggleBt.Position = UDim2.new(0, 10, 0, 10)
ToggleBt.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ToggleBt.Text = "-"
ToggleBt.ZIndex = 40
ToggleBt.Parent = MainFrame
ApplyPixelStyle(ToggleBt, true, 25)

ToggleBt.TouchTap:Connect(function()
    expanded = not expanded
    MainFrame:TweenSize(expanded and UDim2.new(0, 420, 0, 280) or UDim2.new(0, 55, 0, 55), "Out", "Quad", 0.2, true)
    ToggleBt.Text = expanded and "-" or "+"
    TitleLabel.Visible, ArrowLeft.Visible, ArrowRight.Visible, PageContainer.Visible = expanded, expanded, expanded, expanded
end)

-- Touch dragging for frame
local dragging, dS, sP
MainFrame.InputBegan:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.Touch) then
        dragging = true
        dS = input.Position
        sP = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.Touch then
        local delta = input.Position - dS
        MainFrame.Position = UDim2.new(sP.X.Scale, sP.X.Offset + delta.X, sP.Y.Scale, sP.Y.Offset + delta.Y)
    end
end)
