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
    self.TitleLabel.Text = text or self.TitleLabel.Text
end

function UI:CreateTab(name)
    assert(type(name) == "string" and #name > 0, "Tab name required")
    
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
    contentFrame.ScrollBarThickness = 4
    contentFrame.CanvasSize = UDim2.new(0,0,0,0)
    contentFrame.Parent = self.TabContent
    contentFrame.Visible = false
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 10)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = contentFrame
    
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 10)
    padding.PaddingRight = UDim.new(0, 10)
    padding.Parent = contentFrame
    
    local tabObj = {}
    tabObj.Name = name
    tabObj.Button = tabButton
    tabObj.Content = contentFrame
    tabObj.Button:SetAttribute("IsSelected", false)
    
    -- Show/hide functions
    function tabObj:Show()
        contentFrame.Visible = true
        tabButton.BackgroundColor3 = Color3.fromRGB(100, 100, 120)
        tabButton:SetAttribute("IsSelected", true)
    end
    function tabObj:Hide()
        contentFrame.Visible = false
        tabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
        tabButton:SetAttribute("IsSelected", false)
    end
    
    -- Button click switches tab
    tabButton.MouseButton1Click:Connect(function()
        for _, tab in pairs(self.Tabs) do
            tab:Hide()
        end
        tabObj:Show()
        self.CurrentTab = tabObj
    end)
    
    -- Add UI elements creators to the tab object:
    
    function tabObj:AddButton(text)
        assert(type(text) == "string", "Button text required")
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(1, 0, 0, 30)
        button.BackgroundColor3 = Color3.fromRGB(70, 70, 85)
        button.TextColor3 = Color3.new(1, 1, 1)
        button.Font = Enum.Font.SourceSansSemibold
        button.TextSize = 16
        button.Text = text
        button.AutoButtonColor = false
        button.Parent = contentFrame
        
        local corner = Instance.new("UICorner", button)
        corner.CornerRadius = UDim.new(0, 6)
        
        local obj = {}
        function obj:SetCallback(callback)
            assert(type(callback) == "function", "Callback must be function")
            button.MouseButton1Click:Connect(callback)
        end
        return obj
    end
    
    function tabObj:AddToggle(text, default)
        assert(type(text) == "string", "Toggle text required")
        local toggled = default and true or false
        
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 0, 30)
        frame.BackgroundTransparency = 1
        frame.Parent = contentFrame
        
        local label = Instance.new("TextLabel")
        label.Text = text
        label.Size = UDim2.new(0.7, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.new(1, 1, 1)
        label.Font = Enum.Font.SourceSansSemibold
        label.TextSize = 16
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = frame
        
        local toggleBtn = Instance.new("TextButton")
        toggleBtn.Size = UDim2.new(0, 40, 0, 25)
        toggleBtn.Position = UDim2.new(1, -45, 0, 2)
        toggleBtn.BackgroundColor3 = toggled and Color3.fromRGB(0, 150, 136) or Color3.fromRGB(80, 80, 80)
        toggleBtn.Text = toggled and "ON" or "OFF"
        toggleBtn.TextColor3 = Color3.new(1,1,1)
        toggleBtn.Font = Enum.Font.SourceSansSemibold
        toggleBtn.TextSize = 14
        toggleBtn.AutoButtonColor = false
        toggleBtn.Parent = frame
        
        local corner = Instance.new("UICorner", toggleBtn)
        corner.CornerRadius = UDim.new(0, 6)
        
        local obj = {}
        
        function obj:SetCallback(callback)
            assert(type(callback) == "function", "Callback must be function")
            toggleBtn.MouseButton1Click:Connect(function()
                toggled = not toggled
                toggleBtn.BackgroundColor3 = toggled and Color3.fromRGB(0, 150, 136) or Color3.fromRGB(80, 80, 80)
                toggleBtn.Text = toggled and "ON" or "OFF"
                callback(toggled)
            end)
        end
        
        function obj:GetValue()
            return toggled
        end
        
        return obj
    end
    
    function tabObj:AddSlider(text, min, max, default)
        assert(type(text) == "string", "Slider text required")
        assert(type(min) == "number" and type(max) == "number" and min < max, "Invalid min/max")
        
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 0, 40)
        frame.BackgroundTransparency = 1
        frame.Parent = contentFrame
        
        local label = Instance.new("TextLabel")
        label.Text = text
        label.Size = UDim2.new(1, 0, 0, 20)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.new(1, 1, 1)
        label.Font = Enum.Font.SourceSansSemibold
        label.TextSize = 16
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = frame
        
        local sliderFrame = Instance.new("Frame")
        sliderFrame.Size = UDim2.new(1, 0, 0, 10)
        sliderFrame.Position = UDim2.new(0, 0, 0, 25)
        sliderFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
        sliderFrame.Parent = frame
        
        local sliderFill = Instance.new("Frame")
        sliderFill.Size = UDim2.new(((default or min) - min) / (max - min), 0, 1, 0)
        sliderFill.BackgroundColor3 = Color3.fromRGB(0, 150, 136)
        sliderFill.Parent = sliderFrame
        
        local sliderCorner = Instance.new("UICorner")
        sliderCorner.CornerRadius = UDim.new(0, 6)
        sliderCorner.Parent = sliderFrame
        
        local fillCorner = Instance.new("UICorner")
        fillCorner.CornerRadius = UDim.new(0, 6)
        fillCorner.Parent = sliderFill
        
        local dragging = false
        local val = default or min
        
        sliderFrame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                local pos = input.Position.X - sliderFrame.AbsolutePosition.X
                local size = sliderFrame.AbsoluteSize.X
                val = math.clamp(min + (pos / size) * (max - min), min, max)
                sliderFill.Size = UDim2.new((val - min) / (max - min), 0, 1, 0)
                if sliderObj.Callback then sliderObj.Callback(val) end
            end
        end)
        
        sliderFrame.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        
        sliderFrame.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local pos = input.Position.X - sliderFrame.AbsolutePosition.X
                local size = sliderFrame.AbsoluteSize.X
                val = math.clamp(min + (pos / size) * (max - min), min, max)
                sliderFill.Size = UDim2.new((val - min) / (max - min), 0, 1, 0)
                if sliderObj.Callback then sliderObj.Callback(val) end
            end
        end)
        
        local sliderObj = {}
        function sliderObj:SetCallback(callback)
            sliderObj.Callback = callback
        end
        function sliderObj:GetValue()
            return val
        end
        
        return sliderObj
    end
    
    -- Add the tab to the UI tabs list
    table.insert(self.Tabs, tabObj)
    
    -- If first tab, select it automatically
    if #self.Tabs == 1 then
        tabObj:Show()
        self.CurrentTab = tabObj
    end
    
    return tabObj
end

function UI.new()
    return UI:Create()
end

-- ===== Usage example =====
local cosmic = UI.new()
cosmic:SetTitle("My Cosmic UI")

local homeTab = cosmic:CreateTab("Home")

local buttonObj = homeTab:AddButton("Click me!")
buttonObj:SetCallback(function()
    print("Button clicked!")
end)

local toggleObj = homeTab:AddToggle("Enable feature", false)
toggleObj:SetCallback(function(state)
    print("Toggle state:", state)
end)

local sliderObj = homeTab:AddSlider("Volume", 0, 100, 50)
sliderObj:SetCallback(function(val)
    print("Slider value:", val)
end)
