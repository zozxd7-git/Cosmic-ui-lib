-- Save this as: https://pastebin.com/raw/YourCustomUILib or a GitHub Gist raw file!

local Library = {}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function createInstance(class, props)
    local inst = Instance.new(class)
    for prop, val in pairs(props) do
        inst[prop] = val
    end
    return inst
end

local function makeDraggable(frame)
    local dragToggle, dragInput, dragStart, startPos
    local UserInputService = game:GetService("UserInputService")

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragToggle = true
            dragStart = input.Position
            startPos = frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragToggle = false
                end
            end)
        end
    end)

    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragToggle then
            local delta = input.Position - dragStart
            frame.Position = startPos + UDim2.new(0, delta.X, 0, delta.Y)
        end
    end)
end

function Library:CreateWindow(title)
    local ScreenGui = createInstance("ScreenGui", {
        Parent = LocalPlayer:WaitForChild("PlayerGui"),
        ResetOnSpawn = false,
        Name = "CustomUILib"
    })

    local MainFrame = createInstance("Frame", {
        Size = UDim2.new(0, 500, 0, 350),
        Position = UDim2.new(0.5, -250, 0.5, -175),
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        BackgroundTransparency = 0.2,
        BorderSizePixel = 0,
        Parent = ScreenGui
    })

    local Title = createInstance("TextLabel", {
        Size = UDim2.new(1, 0, 0, 35),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.GothamBold,
        TextSize = 18,
        Parent = MainFrame
    })

    local TabsFrame = createInstance("Frame", {
        Size = UDim2.new(0, 100, 1, -35),
        Position = UDim2.new(0, 0, 0, 35),
        BackgroundColor3 = Color3.fromRGB(40, 40, 40),
        BackgroundTransparency = 0.2,
        BorderSizePixel = 0,
        Parent = MainFrame
    })

    local ContentFrame = createInstance("Frame", {
        Size = UDim2.new(1, -100, 1, -35),
        Position = UDim2.new(0, 100, 0, 35),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Parent = MainFrame
    })

    makeDraggable(MainFrame)

    local Window = {}
    local Tabs = {}

    function Window:CreateTab(name)
        local TabButton = createInstance("TextButton", {
            Size = UDim2.new(1, 0, 0, 30),
            BackgroundColor3 = Color3.fromRGB(60, 60, 60),
            TextColor3 = Color3.fromRGB(255, 255, 255),
            Text = name,
            Font = Enum.Font.Gotham,
            TextSize = 14,
            Parent = TabsFrame
        })

        local TabFrame = createInstance("Frame", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Visible = false,
            Parent = ContentFrame
        })

        local SectionsLayout = createInstance("UIListLayout", {
            Padding = UDim.new(0, 5),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = TabFrame
        })

        TabButton.MouseButton1Click:Connect(function()
            for _, tab in pairs(Tabs) do
                tab.Frame.Visible = false
                tab.Button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            end
            TabFrame.Visible = true
            TabButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        end)

        table.insert(Tabs, { Button = TabButton, Frame = TabFrame })

        local Tab = {}

        function Tab:CreateSection(title)
            local SectionLabel = createInstance("TextLabel", {
                Size = UDim2.new(1, -10, 0, 20),
                BackgroundTransparency = 1,
                Text = "  " .. title,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                Font = Enum.Font.GothamBold,
                TextSize = 16,
                Parent = TabFrame
            })

            local Section = createInstance("Frame", {
                Size = UDim2.new(1, -10, 0, 0),
                BackgroundColor3 = Color3.fromRGB(50, 50, 50),
                BackgroundTransparency = 0.3,
                BorderSizePixel = 0,
                Parent = TabFrame
            })

            local Layout = createInstance("UIListLayout", {
                Padding = UDim.new(0, 5),
                SortOrder = Enum.SortOrder.LayoutOrder,
                Parent = Section
            })

            function Section:CreateButton(text, callback)
                local Button = createInstance("TextButton", {
                    Size = UDim2.new(1, 0, 0, 30),
                    BackgroundColor3 = Color3.fromRGB(70, 130, 180),
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    Text = text,
                    Font = Enum.Font.Gotham,
                    TextSize = 14,
                    Parent = Section
                })
                Button.MouseButton1Click:Connect(callback)
                Section.Size = UDim2.new(1, -10, 0, Section.Size.Y.Offset + 35)
            end

            function Section:CreateToggle(text, callback)
                local Toggle = createInstance("TextButton", {
                    Size = UDim2.new(1, 0, 0, 30),
                    BackgroundColor3 = Color3.fromRGB(100, 100, 100),
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    Text = text .. ": OFF",
                    Font = Enum.Font.Gotham,
                    TextSize = 14,
                    Parent = Section
                })
                local state = false
                Toggle.MouseButton1Click:Connect(function()
                    state = not state
                    Toggle.Text = text .. ": " .. (state and "ON" or "OFF")
                    callback(state)
                end)
                Section.Size = UDim2.new(1, -10, 0, Section.Size.Y.Offset + 35)
            end

            function Section:CreateLabel(text)
                local Label = createInstance("TextLabel", {
                    Size = UDim2.new(1, 0, 0, 20),
                    BackgroundTransparency = 1,
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    Text = text,
                    Font = Enum.Font.Gotham,
                    TextSize = 14,
                    Parent = Section
                })
                Section.Size = UDim2.new(1, -10, 0, Section.Size.Y.Offset + 25)
            end

            return Section
        end

        return Tab
    end

    return Window
end

return Library
