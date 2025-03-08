-- Flera UI Library (Full Code)
local Flera = {}

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

-- Utility Functions
local function CreateInstance(className, properties)
    local instance = Instance.new(className)
    for property, value in pairs(properties) do
        instance[property] = value
    end
    return instance
end

local function ApplyRoundCorners(instance, cornerRadius)
    local corner = CreateInstance("UICorner", {
        CornerRadius = UDim.new(cornerRadius, 0),
        Parent = instance
    })
end

-- Key System
local function FetchKeyFromPastebin(url)
    local success, key = pcall(function()
        return HttpService:GetAsync(url)
    end)
    return success and key or nil
end

local function ValidateKey(inputKey, validKey)
    return inputKey == validKey
end

-- Required Script Name Check
local function CheckScriptName(requiredName)
    local scriptName = debug.info(1, "n")
    return scriptName == requiredName
end

-- Fade Animation
local function FadeIn(instance)
    instance.Visible = true
    local tween = TweenService:Create(instance, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0.2
    })
    tween:Play()
end

local function FadeOut(instance, callback)
    local tween = TweenService:Create(instance, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundTransparency = 1
    })
    tween:Play()
    tween.Completed:Connect(function()
        instance.Visible = false
        if callback then
            callback()
        end
    })
end

-- Main Window Function
function Flera:CreateWindow(options)
    local window = {}
    options = options or {}
    local title = options.Title or "Flera UI"
    local imageId = options.ImageId
    local keyEnabled = options.KeyEnabled or false
    local keyUrl = options.KeyUrl or ""
    local requiredScriptName = options.RequiredScriptName or ""

    -- Check Required Script Name
    if requiredScriptName ~= "" and not CheckScriptName(requiredScriptName) then
        warn("Access denied. This script is only for: " .. requiredScriptName)
        return
    end

    -- Key System
    if keyEnabled then
        local validKey = FetchKeyFromPastebin(keyUrl)
        if not validKey then
            warn("Failed to fetch key from Pastebin.")
            return
        end

        local inputKey = game:GetService("TextService"):Prompt("Enter Key", "Please enter the key to access the UI.")
        if not ValidateKey(inputKey, validKey) then
            warn("Invalid key. Access denied.")
            return
        end
    end

    -- Create ScreenGui
    local screenGui = CreateInstance("ScreenGui", {
        Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    })

    -- Create Main Frame
    local mainFrame = CreateInstance("Frame", {
        Size = UDim2.new(0, 400, 0, 500),
        Position = UDim2.new(0.5, -200, 0.5, -250),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        BackgroundTransparency = 1,
        Visible = false,
        Parent = screenGui
    })
    ApplyRoundCorners(mainFrame, 0.1)

    -- Title Bar
    local titleBar = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundColor3 = Color3.fromRGB(20, 20, 20),
        BackgroundTransparency = 1,
        Parent = mainFrame
    })
    ApplyRoundCorners(titleBar, 0.1)

    local titleLabel = CreateInstance("TextLabel", {
        Text = title,
        Size = UDim2.new(1, -60, 1, 0),
        Position = UDim2.new(0, 5, 0, 0),
        BackgroundTransparency = 1,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.SourceSansBold,
        TextSize = 18,
        Parent = titleBar
    })

    -- Minify Button
    local minifyButton = CreateInstance("TextButton", {
        Text = "-",
        Size = UDim2.new(0, 25, 0, 25),
        Position = UDim2.new(1, -55, 0.5, -12.5),
        BackgroundColor3 = Color3.fromRGB(40, 40, 40),
        BackgroundTransparency = 1,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.SourceSansBold,
        Parent = titleBar
    })
    ApplyRoundCorners(minifyButton, 0.5)

    -- Close Button
    local closeButton = CreateInstance("TextButton", {
        Text = "X",
        Size = UDim2.new(0, 25, 0, 25),
        Position = UDim2.new(1, -25, 0.5, -12.5),
        BackgroundColor3 = Color3.fromRGB(255, 50, 50),
        BackgroundTransparency = 1,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.SourceSansBold,
        Parent = titleBar
    })
    ApplyRoundCorners(closeButton, 0.5)

    -- Image (Optional)
    if imageId and type(imageId) == "string" then
        local image = CreateInstance("ImageLabel", {
            Size = UDim2.new(1, 0, 0, 100),
            Position = UDim2.new(0, 0, 0, 30),
            BackgroundTransparency = 1,
            Image = imageId,
            Parent = mainFrame
        })
        ApplyRoundCorners(image, 0.1)
    end

    -- Tab Container
    local tabContainer = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 1, -40),
        Position = UDim2.new(0, 0, 0, imageId and 130 or 40),
        BackgroundTransparency = 1,
        Parent = mainFrame
    })

    -- Tab Buttons
    local tabButtons = {}

    -- Draggable Window
    local dragging = false
    local dragStartPos
    local startPos

    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStartPos = Vector2.new(input.Position.X, input.Position.Y)
            startPos = mainFrame.Position
        end
    end)

    titleBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = Vector2.new(input.Position.X, input.Position.Y) - dragStartPos
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    -- Minify/Close Functionality
    local isMinified = false
    local originalSize = mainFrame.Size

    minifyButton.MouseButton1Click:Connect(function()
        if isMinified then
            mainFrame.Size = originalSize
            tabContainer.Visible = true
        else
            mainFrame.Size = UDim2.new(0, 400, 0, 30)
            tabContainer.Visible = false
        end
        isMinified = not isMinified
    end)

    closeButton.MouseButton1Click:Connect(function()
        FadeOut(mainFrame, function()
            screenGui.Enabled = false
        end)
    end)

    -- Reopen UI with Left Shift
    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.LeftShift then
            screenGui.Enabled = true
            FadeIn(mainFrame)
        end
    end)

    -- Initial Fade In
    FadeIn(mainFrame)

    function window:AddTab(name)
        local tab = {}
        local tabButton = CreateInstance("TextButton", {
            Text = name,
            Size = UDim2.new(0, 80, 0, 30),
            Position = UDim2.new(0, (#tabButtons * 85), 0, 0),
            BackgroundColor3 = Color3.fromRGB(40, 40, 40),
            BackgroundTransparency = 0.2,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            Font = Enum.Font.SourceSansBold,
            Parent = mainFrame
        })
        ApplyRoundCorners(tabButton, 0.2)

        local tabFrame = CreateInstance("Frame", {
            Size = UDim2.new(1, 0, 1, 0),
            Position = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1,
            Visible = false,
            Parent = tabContainer
        })

        table.insert(tabButtons, tabButton)

        tabButton.MouseButton1Click:Connect(function()
            for _, frame in ipairs(tabContainer:GetChildren()) do
                if frame:IsA("Frame") then
                    frame.Visible = false
                end
            end
            tabFrame.Visible = true
        end)

        -- Add Button Function
        function tab:AddButton(text, callback)
            local button = CreateInstance("TextButton", {
                Text = text,
                Size = UDim2.new(0.9, 0, 0, 40),
                Position = UDim2.new(0.05, 0, 0, (#tabFrame:GetChildren() - 1) * 45),
                BackgroundColor3 = Color3.fromRGB(50, 50, 50),
                BackgroundTransparency = 0.2,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                Font = Enum.Font.SourceSansBold,
                Parent = tabFrame
            })
            ApplyRoundCorners(button, 0.2)

            button.MouseButton1Click:Connect(callback)
        end

        -- Add Slider Function
        function tab:AddSlider(text, options)
            local slider = CreateInstance("Frame", {
                Size = UDim2.new(0.9, 0, 0, 50),
                Position = UDim2.new(0.05, 0, 0, (#tabFrame:GetChildren() - 1) * 55),
                BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                BackgroundTransparency = 0.2,
                Parent = tabFrame
            })
            ApplyRoundCorners(slider, 0.2)

            local sliderText = CreateInstance("TextLabel", {
                Text = text,
                Size = UDim2.new(1, 0, 0.5, 0),
                BackgroundTransparency = 1,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                Font = Enum.Font.SourceSansBold,
                Parent = slider
            })

            local sliderBar = CreateInstance("Frame", {
                Size = UDim2.new(1, -10, 0.3, 0),
                Position = UDim2.new(0, 5, 0.6, 0),
                BackgroundColor3 = Color3.fromRGB(30, 30, 30),
                Parent = slider
            })
            ApplyRoundCorners(sliderBar, 0.5)

            local sliderFill = CreateInstance("Frame", {
                Size = UDim2.new(0, 0, 1, 0),
                BackgroundColor3 = Color3.fromRGB(100, 100, 100),
                Parent = sliderBar
            })
            ApplyRoundCorners(sliderFill, 0.5)

            local sliderValue = CreateInstance("TextLabel", {
                Text = tostring(options.Default or 0),
                Size = UDim2.new(1, 0, 0.5, 0),
                Position = UDim2.new(0, 0, 0.5, 0),
                BackgroundTransparency = 1,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                Font = Enum.Font.SourceSansBold,
                Parent = slider
            })

            local dragging = false
            sliderBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                end
            end)

            sliderBar.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local xOffset = math.clamp(input.Position.X - sliderBar.AbsolutePosition.X, 0, sliderBar.AbsoluteSize.X)
                    local percent = xOffset / sliderBar.AbsoluteSize.X
                    local value = math.floor(options.Min + (options.Max - options.Min) * percent)
                    sliderFill.Size = UDim2.new(percent, 0, 1, 0)
                    sliderValue.Text = tostring(value)
                    if options.Callback then
                        options.Callback(value)
                    end
                end
            end)
        end

        return tab
    end

    return window
end

return Flera