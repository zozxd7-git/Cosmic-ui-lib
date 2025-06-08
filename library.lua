local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local UI = {}
UI.__index = UI

function UI:Create()
    local self = setmetatable({}, UI)
    
    local player = Players.LocalPlayer
    local gui = Instance.new("ScreenGui")
    gui.Name = "CosmicUI"
    gui.ResetOnSpawn = false
    gui.Parent = player:WaitForChild("PlayerGui")
    
    self.Gui = gui
    
    -- Main Frame
    local frame = Instance.new("Frame")
    frame.Name = "MainFrame"
    frame.Size = UDim2.new(0, 500, 0, 400)
    frame.Position = UDim2.new(0.5, -250, 0.5, -200)
    frame.BackgroundColor3 = Color3.fromRGB(32, 32, 35)
    frame.ClipsDescendants = true
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.Parent = gui
    
    -- Rounded corners
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 16)
    corner.Parent = frame
    
    -- Drop shadow (lighter and smaller)
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "DropShadow"
    shadow.BackgroundTransparency = 1
    shadow.Size = UDim2.new(1, 24, 1, 24)
    shadow.Position = UDim2.new(0, -12, 0, -12)
    shadow.Image = "rbxassetid://1316045217" -- subtle shadow
    shadow.ImageColor3 = Color3.new(0, 0, 0)
    shadow.ImageTransparency = 0.85
    shadow.Parent = frame
    
    -- Make shadow behind frame contents
    shadow.ZIndex = 0
    frame.ZIndex = 1
    
    -- Top Bar (invisible but draggable & holds buttons)
    local topBar = Instance.new("Frame")
    topBar.Name = "TopBar"
    topBar.BackgroundTransparency = 1
    topBar.Size = UDim2.new(1, 0, 0, 30)
    topBar.Position = UDim2.new(0, 0, 0, 0)
    topBar.Parent = frame
    
    -- Close Button (X)
    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "CloseButton"
    closeBtn.Text = "X"
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -35, 0, 0)
    closeBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    closeBtn.TextColor3 = Color3.new(1, 1, 1)
    closeBtn.Font = Enum.Font.SourceSansBold
    closeBtn.TextSize = 20
    closeBtn.AutoButtonColor = false
    closeBtn.Parent = topBar
    
    local closeCorner = Instance.new("UICorner", closeBtn)
    closeCorner.CornerRadius = UDim.new(0, 6)
    
    -- Minimize Button (-)
    local minBtn = Instance.new("TextButton")
    minBtn.Name = "MinimizeButton"
    minBtn.Text = "-"
    minBtn.Size = UDim2.new(0, 30, 0, 30)
    minBtn.Position = UDim2.new(1, -70, 0, 0)
    minBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    minBtn.TextColor3 = Color3.new(1, 1, 1)
    minBtn.Font = Enum.Font.SourceSansBold
    minBtn.TextSize = 30
    minBtn.AutoButtonColor = false
    minBtn.Parent = topBar
    
    local minCorner = Instance.new("UICorner", minBtn)
    minCorner.CornerRadius = UDim.new(0, 6)
    
    -- Title Text
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Text = "Cosmic UI"
    title.Font = Enum.Font.SourceSansBold
    title.TextSize = 20
    title.TextColor3 = Color3.new(1,1,1)
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(0.7, 0, 1, 0)
    title.Position = UDim2.new(0, 20, 0, 0)
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = topBar
    
    self.Frame = frame
    self.TopBar = topBar
    self.TitleLabel = title
    
    -- Container for tabs buttons (left side)
    local tabsList = Instance.new("Frame")
    tabsList.Name = "TabsList"
    tabsList.BackgroundColor3 = Color3.fromRGB(20, 20, 23)
    tabsList.Size = UDim2.new(0, 120, 1, -30)
    tabsList.Position = UDim2.new(0, 0, 0, 30)
    tabsList.Parent = frame
    
    local tabsLayout = Instance.new("UIListLayout")
    tabsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabsLayout.Parent = tabsList
    tabsLayout.Padding = UDim.new(0, 6)
    
    -- Container for tab content
    local tabContent = Instance.new("Frame")
    tabContent.Name = "TabContent"
    tabContent.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    tabContent.Size = UDim2.new(1, -120, 1, -30)
    tabContent.Position = UDim2.new(0, 120, 0, 30)
    tabContent.Parent = frame
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 16)
    tabCorner.Parent = tabContent
    
    self.TabsList = tabsList
    self.TabsLayout = tabsLayout
    self.TabContent = tabContent
    
    self.Tabs = {}
    self.CurrentTab = nil
    
    -- Drag logic
    local dragging, dragInput, dragStart, startPos
    topBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    topBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    -- Minimize toggle
    local minimized = false
    minBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            frame:TweenSize(UDim2.new(0, 500, 0, 30), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true)
            tabContent.Visible = false
            tabsList.Visible = false
        else
            frame:TweenSize(UDim2.new(0, 500, 0, 400), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true)
            tabContent.Visible = true
            tabsList.Visible = true
        end
    end)
    
    -- Close button closes the GUI instantly
    closeBtn.MouseButton1Click:Connect(function()
        gui:Destroy()
    end)
    
    return self
end

function UI:SetTitle(text)
    self.TitleLabel.Text = text
end

function UI:CreateTab(name)
    assert(name, "Tab name required")
    
    local tabButton = Instance.new("TextButton")
    tabButton.Text = name
    tabButton.Size = UDim2.new(1, -12, 0, 30)
    tabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    tabButton.TextColor3 = Color3.new(1,1,1)
    tabButton.Font = Enum.Font.SourceSansBold
    tabButton.TextSize = 16
    tabButton.AutoButtonColor = false
    tabButton.Parent = self.TabsList
    
    local corner = Instance.new("UICorner", tabButton)
    corner.CornerRadius = UDim.new(0, 6)
    
    local contentFrame = Instance.new("ScrollingFrame")
    contentFrame.Size = UDim2.new(1, 0, 1, 0)
    contentFrame.BackgroundTransparency = 1
    contentFrame.ScrollBarThickness = 6
    contentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    contentFrame.Parent = self.TabContent
    contentFrame.Visible = false
    
    local layout = Instance.new("UIListLayout", contentFrame)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 6)
    
    -- Update canvas size on content change
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        contentFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
    end)
    
    local tabObj = {}
    tabObj.Name = name
    tabObj.Button = tabButton
    tabObj.Content = contentFrame
    
    -- Tab controls methods:
    function tabObj:Show()
        contentFrame.Visible = true
        tabButton.BackgroundColor3 = Color3.fromRGB(70, 70, 75)
    end
    
    function tabObj:Hide()
        contentFrame.Visible = false
        tabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    end
    
    -- Add controls:
    function tabObj:CreateButton(text)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(1, -20, 0, 30)
        b.BackgroundColor3 = Color3.fromRGB(65, 65, 70)
        b.TextColor3 = Color3.new(1,1,1)
        b.Font = Enum.Font.SourceSansSemibold
        b.TextSize = 16
        b.AutoButtonColor = false
        b.Text = text
        b.Parent = contentFrame
        
        local corner = Instance.new("UICorner", b)
        corner.CornerRadius = UDim.new(0, 6)
        
        local callback = function() end
        b.MouseEnter:Connect(function()
            TweenService:Create(b, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(80,80,85)}):Play()
        end)
        b.MouseLeave:Connect(function()
            TweenService:Create(b, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(65,65,70)}):Play()
        end)
        b.MouseButton1Click:Connect(function()
            callback()
        end)
        
        local obj = {}
        function obj:SetCallback(func)
            callback = func or function() end
        end
        
        return obj
    end
    
    function tabObj:CreateToggle(name, default)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -20, 0, 30)
        frame.BackgroundTransparency = 1
        frame.Parent = contentFrame
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.75, 0, 1, 0)
        label.Position = UDim2.new(0, 5, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = name
        label.TextColor3 = Color3.new(1,1,1)
        label.Font = Enum.Font.SourceSansSemibold
        label.TextSize = 16
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = frame
        
        local toggleBtn = Instance.new("TextButton")
        toggleBtn.Size = UDim2.new(0, 30, 0, 24)
        toggleBtn.Position = UDim2.new(1, -35, 0, 3)
        toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
        toggleBtn.TextColor3 = Color3.new(1,1,1)
        toggleBtn.Font = Enum.Font.SourceSansBold
        toggleBtn.TextSize = 20
        toggleBtn.Text = default and "✔" or "✘"
        toggleBtn.AutoButtonColor = false
        toggleBtn.Parent = frame
        
        local corner = Instance.new("UICorner", toggleBtn)
        corner.CornerRadius = UDim.new(0, 6)
        
        local val = default
        local callback = function() end
        
        toggleBtn.MouseButton1Click:Connect(function()
            val = not val
            toggleBtn.Text = val and "✔" or "✘"
            callback(val)
        end)
        
        local obj = {}
        function obj:SetCallback(func)
            callback = func or function() end
        end
        function obj:GetValue()
            return val
        end
        
        return obj
    end
    
    function tabObj:CreateSlider(name, min, max, default)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -20, 0, 50)
        frame.BackgroundTransparency = 1
        frame.Parent = contentFrame
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 0, 20)
        label.BackgroundTransparency = 1
        label.Text = name
        label.TextColor3 = Color3.new(1,1,1)
        label.Font = Enum.Font.SourceSansSemibold
        label.TextSize = 16
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = frame
        
        local sliderFrame = Instance.new("Frame")
        sliderFrame.Size = UDim2.new(1, -10, 0, 20)
        sliderFrame.Position = UDim2.new(0, 5, 0, 25)
        sliderFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
        sliderFrame.Parent = frame
        
        local sliderCorner = Instance.new("UICorner")
        sliderCorner.CornerRadius = UDim.new(0, 6)
        sliderCorner.Parent = sliderFrame
        
        local fill = Instance.new("Frame")
        fill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
        fill.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
        fill.Parent = sliderFrame
        
        local fillCorner = Instance.new("UICorner")
        fillCorner.CornerRadius = UDim.new(0, 6)
        fillCorner.Parent = fill
        
        local valueLabel = Instance.new("TextLabel")
        valueLabel.Size = UDim2.new(0, 40, 1, 0)
        valueLabel.Position = UDim2.new(1, 5, 0, 0)
        valueLabel.BackgroundTransparency = 1
        valueLabel.Text = tostring(default)
        valueLabel.TextColor3 = Color3.new(1,1,1)
        valueLabel.Font = Enum.Font.SourceSansSemibold
        valueLabel.TextSize = 16
        valueLabel.Parent = frame
        
        local dragging = false
        local callback = function() end
        local val = default
        
        sliderFrame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                local function move(inputMove)
                    local pos = inputMove.Position.X - sliderFrame.AbsolutePosition.X
                    pos = math.clamp(pos, 0, sliderFrame.AbsoluteSize.X)
                    local percent = pos / sliderFrame.AbsoluteSize.X
                    val = math.floor(min + (max - min)*percent + 0.5)
                    fill.Size = UDim2.new(percent, 0, 1, 0)
                    valueLabel.Text = tostring(val)
                    callback(val)
                end
                
                move(input)
                
                local conn
                conn = UserInputService.InputChanged:Connect(function(inputMove)
                    if dragging and inputMove.UserInputType == Enum.UserInputType.MouseMovement then
                        move(inputMove)
                    end
                end)
                
                UserInputService.InputEnded:Connect(function(inputEnd)
                    if inputEnd.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                        conn:Disconnect()
                    end
                end)
            end
        end)
        
        local obj = {}
        function obj:SetCallback(func)
            callback = func or function() end
        end
        function obj:GetValue()
            return val
        end
        
        return obj
    end
    
    function tabObj:CreateLabel(text)
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -20, 0, 20)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.new(1,1,1)
        label.Font = Enum.Font.SourceSansSemibold
        label.TextSize = 16
        label.Text = text
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = contentFrame
        
        local obj = {}
        function obj:SetText(newText)
            label.Text = newText
        end
        return obj
    end
    
    -- Tab switching logic:
    tabButton.MouseButton1Click:Connect(function()
        for _, tab in pairs(self.Tabs) do
            tab:Hide()
        end
        tabObj:Show()
        self.CurrentTab = tabObj
    end)
    
    -- Add to UI tabs list and auto-select first tab
    table.insert(self.Tabs, tabObj)
    if #self.Tabs == 1 then
        tabObj:Show()
        self.CurrentTab = tabObj
    end
    
    return tabObj
end

-- Create and return the UI instance
function UI.new()
    local instance = UI:Create()
    return instance
end

return UI
