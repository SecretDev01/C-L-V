local UILibrary = {}

repeat
    task.wait(1)
until game:IsLoaded()

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local TextService = game:GetService("TextService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local LocalPlayer = game.Players.LocalPlayer

if CoreGui:FindFirstChild("VGXMODHUB") and CoreGui:FindFirstChild("ScreenGui") then
    CoreGui.VGXMODHUB:Destroy()
    CoreGui.ScreenGui:Destroy()
end

local Themes = {
    ["Red"]        = { Primary = Color3.fromRGB(255, 30, 50),   Dark = Color3.fromRGB(90, 10, 20) },
    ["Cyan"]       = { Primary = Color3.fromRGB(40, 230, 255),  Dark = Color3.fromRGB(10, 80, 115) },
    ["Blue"]       = { Primary = Color3.fromRGB(40, 155, 255),  Dark = Color3.fromRGB(10, 80, 115) },
    ["DarkBlue"]   = { Primary = Color3.fromRGB(50, 30, 255),   Dark = Color3.fromRGB(20, 10, 90) },
    ["Green"]      = { Primary = Color3.fromRGB(70, 255, 205),  Dark = Color3.fromRGB(20, 90, 90) },
    ["LightGreen"] = { Primary = Color3.fromRGB(205, 255, 205), Dark = Color3.fromRGB(70, 90, 70) },
    ["Purple"]     = { Primary = Color3.fromRGB(205, 125, 255), Dark = Color3.fromRGB(60, 20, 95) },
    ["Zinc"]       = { Primary = Color3.fromRGB(30, 30, 30),    Dark = Color3.fromRGB(10, 10, 10) }
}

local selectedTheme = Themes[_G.Theme] or { Primary = Color3.fromRGB(110, 110, 120), Dark = Color3.fromRGB(20, 20, 30) }
_G.Primary = selectedTheme.Primary
_G.Dark = selectedTheme.Dark

local ToggleGui = Instance.new("ScreenGui")
ToggleGui.Parent = CoreGui
ToggleGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local FloatingButton = Instance.new("ImageButton")
FloatingButton.Parent = ToggleGui
FloatingButton.Position = UDim2.new(0, 10, 0, 10)
FloatingButton.Size = UDim2.new(0, 50, 0, 50)
FloatingButton.Draggable = true
FloatingButton.BackgroundColor3 = _G.Dark
FloatingButton.ImageColor3 = _G.Primary
FloatingButton.ImageTransparency = 0.1
FloatingButton.BackgroundTransparency = 0.1
FloatingButton.Image = "rbxassetid://13940080072"

local FloatingStroke = Instance.new("UIStroke")
FloatingStroke.Color = _G.Primary
FloatingStroke.Thickness = 1
FloatingStroke.Parent = FloatingButton

local FloatingCorner = Instance.new("UICorner")
FloatingCorner.CornerRadius = UDim.new(0, 5)
FloatingCorner.Parent = FloatingButton

FloatingButton.MouseButton1Click:Connect(function()
    local mainHub = CoreGui:FindFirstChild("VGXMODHUB")
    if mainHub then
        mainHub.Enabled = not mainHub.Enabled
    end
end)

local function makeElementDraggable(dragTrigger, frameToDrag)
    local dragToggle, dragStart, startPos
    local dragInput

    local function updateDrag(input)
        local delta = input.Position - dragStart
        local targetPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        TweenService:Create(frameToDrag, TweenInfo.new(0.15), {Position = targetPos}):Play()
    end

    dragTrigger.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragToggle = true
            dragStart = input.Position
            startPos = frameToDrag.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragToggle = false
                end
            end)
        end
    end)

    dragTrigger.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragToggle then
            updateDrag(input)
        end
    end)
end

function UILibrary.Window(_, versionText)
    local firstTabInitialized = false
    local activePageName = ""
    local toggleKeybind = Enum.KeyCode.RightControl

    local AlertGui = Instance.new("ScreenGui")
    AlertGui.Name = "AlertFrame"
    AlertGui.Parent = CoreGui
    AlertGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

    local MainGui = Instance.new("ScreenGui")
    MainGui.Name = "VGXMODHUB"
    MainGui.Parent = CoreGui
    MainGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "Main"
    MainFrame.Parent = MainGui
    MainFrame.ClipsDescendants = true
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.BackgroundColor3 = _G.Dark
    MainFrame.BackgroundTransparency = 0.1
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    MainFrame:TweenSize(UDim2.new(0, 524, 0, 332), "Out", "Quad", 0.4, true)

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = _G.Primary
    MainStroke.Thickness = 1
    MainStroke.Parent = MainFrame

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 5)
    MainCorner.Parent = MainFrame

    local ResizeButton = Instance.new("Frame")
    ResizeButton.Name = "DragButton"
    ResizeButton.Parent = MainFrame
    ResizeButton.Position = UDim2.new(1, 5, 1, 5)
    ResizeButton.AnchorPoint = Vector2.new(1, 1)
    ResizeButton.Size = UDim2.new(0, 15, 0, 15)
    ResizeButton.BackgroundColor3 = _G.Primary
    ResizeButton.BackgroundTransparency = 0.1
    ResizeButton.ZIndex = 10

    local ResizeCorner = Instance.new("UICorner")
    ResizeCorner.CornerRadius = UDim.new(0, 99)
    ResizeCorner.Parent = ResizeButton

    local TopBar = Instance.new("Frame")
    TopBar.Name = "Top"
    TopBar.Parent = MainFrame
    TopBar.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    TopBar.Size = UDim2.new(1, 0, 0, 40)
    TopBar.BackgroundTransparency = 1

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "ttittles"
    TitleLabel.Parent = TopBar
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0, 15, 0.5, 0)
    TitleLabel.AnchorPoint = Vector2.new(0, 0.5)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = "VGXMOD HUB |"
    TitleLabel.TextSize = 15
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

    local titleSize = TextService:GetTextSize(TitleLabel.Text, TitleLabel.TextSize, TitleLabel.Font, Vector2.new(math.huge, math.huge))
    TitleLabel.Size = UDim2.new(0, titleSize.X, 0, 25)

    local VersionLabel = Instance.new("TextLabel")
    VersionLabel.Name = "patch"
    VersionLabel.Parent = TitleLabel
    VersionLabel.BackgroundTransparency = 1
    VersionLabel.Position = UDim2.new(1, 5, 0.5, 0)
    VersionLabel.Font = Enum.Font.Gotham
    VersionLabel.AnchorPoint = Vector2.new(0, 0.5)
    VersionLabel.Text = versionText
    VersionLabel.TextSize = 15
    VersionLabel.TextColor3 = _G.Primary

    local versionSize = TextService:GetTextSize(VersionLabel.Text, VersionLabel.TextSize, VersionLabel.Font, Vector2.new(math.huge, math.huge))
    VersionLabel.Size = UDim2.new(0, versionSize.X, 0, 25)

    local HideButton = Instance.new("ImageButton")
    HideButton.Name = "Hide"
    HideButton.Parent = TopBar
    HideButton.BackgroundTransparency = 1
    HideButton.AnchorPoint = Vector2.new(1, 0.5)
    HideButton.Position = UDim2.new(1, -10, 0.5, 0)
    HideButton.Size = UDim2.new(0, 25, 0, 25)
    HideButton.Image = "rbxassetid://7743878857"
    HideButton.ImageColor3 = Color3.fromRGB(245, 245, 245)

    local HideCorner = Instance.new("UICorner")
    HideCorner.CornerRadius = UDim.new(0, 3)
    HideCorner.Parent = HideButton

    HideButton.MouseButton1Click:Connect(function()
        MainGui.Enabled = not MainGui.Enabled
    end)

    local TopBarSeparator = Instance.new("Frame")
    TopBarSeparator.Name = "SepBot"
    TopBarSeparator.Parent = TopBar
    TopBarSeparator.BackgroundColor3 = _G.Primary
    TopBarSeparator.BorderSizePixel = 0
    TopBarSeparator.AnchorPoint = Vector2.new(0.5, 1)
    TopBarSeparator.Position = UDim2.new(0.5, 0, 1, 0)
    TopBarSeparator.Size = UDim2.new(1, 0, 0, 1)

    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "Tab"
    TabContainer.Parent = MainFrame
    TabContainer.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    TabContainer.Position = UDim2.new(0, 8, 0, 45)
    TabContainer.BackgroundTransparency = 1
    TabContainer.Size = UDim2.new(0, 148, 0, 275)

    local TabScroll = Instance.new("ScrollingFrame")
    TabScroll.Name = "ScrollTab"
    TabScroll.Parent = TabContainer
    TabScroll.Active = true
    TabScroll.BackgroundTransparency = 1
    TabScroll.Size = UDim2.new(1, 0, 1, 0)
    TabScroll.ScrollBarThickness = 0
    TabScroll.ScrollingDirection = Enum.ScrollingDirection.Y

    local TabContainerCorner = Instance.new("UICorner")
    TabContainerCorner.CornerRadius = UDim.new(0, 5)
    TabContainerCorner.Parent = TabContainer

    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.Parent = TabScroll
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabListLayout.Padding = UDim.new(0, 2)

    local TabPadding = Instance.new("UIPadding")
    TabPadding.Parent = TabScroll

    local PageContainer = Instance.new("Frame")
    PageContainer.Name = "Page"
    PageContainer.Parent = MainFrame
    PageContainer.BackgroundColor3 = _G.Dark
    PageContainer.Position = UDim2.new(0, 166, 0, 45)
    PageContainer.Size = UDim2.new(0, 350, 0, 275)
    PageContainer.BackgroundTransparency = 1

    local PageContainerCorner = Instance.new("UICorner")
    PageContainerCorner.CornerRadius = UDim.new(0, 3)
    PageContainerCorner.Parent = PageContainer

    local MainPageFrame = Instance.new("Frame")
    MainPageFrame.Name = "MainPage"
    MainPageFrame.Parent = PageContainer
    MainPageFrame.ClipsDescendants = true
    MainPageFrame.BackgroundTransparency = 1
    MainPageFrame.Size = UDim2.new(1, 0, 1, 0)

    local PageListFolder = Instance.new("Folder")
    PageListFolder.Name = "PageList"
    PageListFolder.Parent = MainPageFrame

    local PageLayout = Instance.new("UIPageLayout")
    PageLayout.Parent = PageListFolder
    PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    PageLayout.EasingDirection = Enum.EasingDirection.InOut
    PageLayout.EasingStyle = Enum.EasingStyle.Quad
    PageLayout.FillDirection = Enum.FillDirection.Vertical
    PageLayout.Padding = UDim.new(0, 10)
    PageLayout.TweenTime = 0
    PageLayout.GamepadInputEnabled = false
    PageLayout.ScrollWheelInputEnabled = false
    PageLayout.TouchInputEnabled = false

    makeElementDraggable(TopBar, MainFrame)

    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.Insert then
            MainGui.Enabled = not MainGui.Enabled
        end
    end)

    local isResizing = false
    ResizeButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isResizing = true
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isResizing = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if isResizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            MainFrame.Size = UDim2.new(0, math.clamp(input.Position.X - MainFrame.AbsolutePosition.X, 524, math.huge), 0, math.clamp(input.Position.Y - MainFrame.AbsolutePosition.Y, 322, math.huge))
            PageContainer.Size = UDim2.new(0, math.clamp(input.Position.X - PageContainer.AbsolutePosition.X - 8, 350, math.huge), 0, math.clamp(input.Position.Y - PageContainer.AbsolutePosition.Y - 8, 270, math.huge))
            TabContainer.Size = UDim2.new(0, 148, 0, math.clamp(input.Position.Y - TabContainer.AbsolutePosition.Y - 8, 270, math.huge))
        end
    end)

    return {
        Tab = function(_, tabName, iconAssetId)
            local TabButton = Instance.new("TextButton")
            TabButton.Name = tabName .. "Server"
            TabButton.Parent = TabScroll
            TabButton.Text = ""
            TabButton.BackgroundColor3 = _G.Primary
            TabButton.BackgroundTransparency = 1
            TabButton.Size = UDim2.new(1, 0, 0, 35)
            TabButton.Font = Enum.Font.GothamSemibold
            TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            TabButton.TextSize = 12
            TabButton.TextTransparency = 0.9

            local SelectedIndicator = Instance.new("Frame")
            SelectedIndicator.Name = "SelectedTab"
            SelectedIndicator.Parent = TabButton
            SelectedIndicator.BackgroundColor3 = _G.Primary
            SelectedIndicator.Size = UDim2.new(0, 3, 0, 0)
            SelectedIndicator.Position = UDim2.new(0, 0, 0.5, 0)
            SelectedIndicator.AnchorPoint = Vector2.new(0, 0.5)
            SelectedIndicator.ZIndex = 4

            local IndicatorCorner = Instance.new("UICorner")
            IndicatorCorner.CornerRadius = UDim.new(0, 100)
            IndicatorCorner.Parent = SelectedIndicator

            local TabTitle = Instance.new("TextLabel")
            TabTitle.Name = "Title"
            TabTitle.Parent = TabButton
            TabTitle.BackgroundTransparency = 1
            TabTitle.Position = UDim2.new(0, 30, 0.5, 0)
            TabTitle.Size = UDim2.new(0, 100, 0, 30)
            TabTitle.Font = Enum.Font.GothamSemibold
            TabTitle.Text = tabName
            TabTitle.AnchorPoint = Vector2.new(0, 0.5)
            TabTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            TabTitle.TextTransparency = 0.4
            TabTitle.TextSize = 13
            TabTitle.TextXAlignment = Enum.TextXAlignment.Left

            local TabIcon = Instance.new("ImageLabel")
            TabIcon.Name = "IDK"
            TabIcon.Parent = TabButton
            TabIcon.BackgroundTransparency = 1
            TabIcon.ImageTransparency = 0.3
            TabIcon.Position = UDim2.new(0, 7, 0.5, 0)
            TabIcon.Size = UDim2.new(0, 15, 0, 15)
            TabIcon.AnchorPoint = Vector2.new(0, 0.5)
            TabIcon.Image = iconAssetId

            local TabButtonCorner = Instance.new("UICorner")
            TabButtonCorner.CornerRadius = UDim.new(0, 5)
            TabButtonCorner.Parent = TabButton

            local PageScroll = Instance.new("ScrollingFrame")
            PageScroll.Name = tabName .. "_Page"
            PageScroll.Parent = PageListFolder
            PageScroll.Active = true
            PageScroll.BackgroundColor3 = _G.Dark
            PageScroll.BackgroundTransparency = 1
            PageScroll.Size = UDim2.new(1, 0, 1, 0)
            PageScroll.ScrollBarThickness = 0
            PageScroll.ScrollingDirection = Enum.ScrollingDirection.Y

            local PageScrollCorner = Instance.new("UICorner")
            PageScrollCorner.CornerRadius = UDim.new(0, 5)
            PageScrollCorner.Parent = MainPageFrame

            local PagePadding = Instance.new("UIPadding")
            PagePadding.Parent = PageScroll

            local PageListLayout = Instance.new("UIListLayout")
            PageListLayout.Padding = UDim.new(0, 3)
            PageListLayout.Parent = PageScroll
            PageListLayout.SortOrder = Enum.SortOrder.LayoutOrder

            TabButton.MouseButton1Click:Connect(function()
                for _, element in pairs(TabScroll:GetChildren()) do
                    if element:IsA("TextButton") then
                        TweenService:Create(element, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
                        TweenService:Create(element.SelectedTab, TweenInfo.new(0, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 3, 0, 0)}):Play()
                        TweenService:Create(element.IDK, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageTransparency = 0.4}):Play()
                        TweenService:Create(element.Title, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0.4}):Play()
                    end
                end

                TweenService:Create(TabButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.8}):Play()
                TweenService:Create(SelectedIndicator, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 3, 0, 15)}):Play()
                TweenService:Create(TabIcon, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageTransparency = 0}):Play()
                TweenService:Create(TabTitle, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()

                activePageName = string.gsub(TabButton.Name, "Server", "") .. "_Page"
                local targetPage = PageListFolder:FindFirstChild(activePageName)
                if targetPage then
                    PageLayout:JumpTo(targetPage)
                end
            end)

            if not firstTabInitialized then
                for _, element in pairs(TabScroll:GetChildren()) do
                    if element:IsA("TextButton") then
                        TweenService:Create(element, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
                        TweenService:Create(element.SelectedTab, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 3, 0, 15)}):Play()
                        TweenService:Create(element.IDK, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageTransparency = 0.4}):Play()
                        TweenService:Create(element.Title, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0.4}):Play()
                    end
                end

                TweenService:Create(TabButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.8}):Play()
                TweenService:Create(SelectedIndicator, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 3, 0, 15)}):Play()
                TweenService:Create(TabIcon, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageTransparency = 0}):Play()
                TweenService:Create(TabTitle, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
                
                PageLayout:JumpToIndex(1)
                firstTabInitialized = true
            end

            RunService.Stepped:Connect(function()
                pcall(function()
                    PageScroll.CanvasSize = UDim2.new(0, 0, 0, PageListLayout.AbsoluteContentSize.Y)
                    TabScroll.CanvasSize = UDim2.new(0, 0, 0, TabListLayout.AbsoluteContentSize.Y)
                end)
            end)

            function UILibrary.Alert(_, messageText)
                if CoreGui:FindFirstChild("AlertFrame") then
                    local alertContainer = CoreGui.AlertFrame
                    if alertContainer:FindFirstChild("Frame") then
                        alertContainer.Frame:Destroy()
                    end
                end

                local ToastFrame = Instance.new("Frame")
                ToastFrame.Name = "Frame"
                ToastFrame.Parent = CoreGui.AlertFrame
                ToastFrame.BackgroundColor3 = _G.Dark
                ToastFrame.BackgroundTransparency = 0.1
                ToastFrame.Position = UDim2.new(1, 0, 0, 0)
                ToastFrame.Size = UDim2.new(0, 200, 0, 60)

                local ToastStroke = Instance.new("UIStroke")
                ToastStroke.Color = _G.Primary
                ToastStroke.Thickness = 1
                ToastStroke.Parent = ToastFrame

                local ToastIcon = Instance.new("ImageLabel")
                ToastIcon.Name = "Icon"
                ToastIcon.Parent = ToastFrame
                ToastIcon.BackgroundTransparency = 1
                ToastIcon.Position = UDim2.new(0, 8, 0, 8)
                ToastIcon.Size = UDim2.new(0, 45, 0, 45)
                ToastIcon.Image = "rbxassetid://13940080072"

                local HubText = Instance.new("TextLabel")
                HubText.Parent = ToastFrame
                HubText.BackgroundTransparency = 1
                HubText.Position = UDim2.new(0, 55, 0, 14)
                HubText.Size = UDim2.new(0, 10, 0, 20)
                HubText.Font = Enum.Font.GothamBold
                HubText.Text = "VGXMOD Hub"
                HubText.TextColor3 = Color3.fromRGB(255, 255, 255)
                HubText.TextSize = 16
                HubText.TextXAlignment = Enum.TextXAlignment.Left

                local InfoText = Instance.new("TextLabel")
                InfoText.Parent = ToastFrame
                InfoText.BackgroundTransparency = 1
                InfoText.Position = UDim2.new(0, 55, 0, 33)
                InfoText.Size = UDim2.new(0, 10, 0, 10)
                InfoText.Font = Enum.Font.GothamSemibold
                InfoText.TextTransparency = 0.3
                InfoText.Text = messageText
                InfoText.TextColor3 = Color3.fromRGB(200, 200, 200)
                InfoText.TextSize = 12
                InfoText.TextXAlignment = Enum.TextXAlignment.Left

                local ToastCorner = Instance.new("UICorner")
                ToastCorner.CornerRadius = UDim.new(0, 5)
                ToastCorner.Parent = ToastFrame

                ToastFrame:TweenPosition(UDim2.new(1, -195, 0, 0), "Out", "Quad", 0.4, true)
                task.wait(2)
                ToastFrame:TweenPosition(UDim2.new(1, 0, 0, 0), "Out", "Quad", 0.5, true)
                task.wait(0.6)
                ToastFrame:Destroy()
            end

            return {
                Button = function(_, buttonText, callback)
                    local ButtonFrame = Instance.new("Frame")
                    ButtonFrame.Name = "Button"
                    ButtonFrame.Parent = PageScroll
                    ButtonFrame.BackgroundColor3 = _G.Primary
                    ButtonFrame.BackgroundTransparency = 0.8
                    ButtonFrame.Size = UDim2.new(1, 0, 0, 36)

                    local ButtonFrameCorner = Instance.new("UICorner")
                    ButtonFrameCorner.CornerRadius = UDim.new(0, 5)
                    ButtonFrameCorner.Parent = ButtonFrame

                    local RealButton = Instance.new("TextButton")
                    RealButton.Name = "TextButton"
                    RealButton.Parent = ButtonFrame
                    RealButton.BackgroundColor3 = _G.Primary
                    RealButton.AnchorPoint = Vector2.new(1, 0.5)
                    RealButton.Position = UDim2.new(1, -10, 0.5, 0)
                    RealButton.Size = UDim2.new(0, 22, 0, 22)
                    RealButton.Font = Enum.Font.GothamSemibold
                    RealButton.Text = ""
                    RealButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                    RealButton.TextSize = 13

                    local ButtonIcon = Instance.new("ImageLabel")
                    ButtonIcon.Name = "ImageLabel"
                    ButtonIcon.Parent = RealButton
                    ButtonIcon.BackgroundColor3 = _G.Primary
                    ButtonIcon.BackgroundTransparency = 1
                    ButtonIcon.AnchorPoint = Vector2.new(0.5, 0.5)
                    ButtonIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
                    ButtonIcon.Size = UDim2.new(0, 15, 0, 15)
                    ButtonIcon.Image = "rbxassetid://10723375250"
                    ButtonIcon.ImageTransparency = 0.2
                    ButtonIcon.ImageColor3 = Color3.fromRGB(245, 245, 245)

                    local RealButtonCorner = Instance.new("UICorner")
                    RealButtonCorner.CornerRadius = UDim.new(0, 4)
                    RealButtonCorner.Parent = RealButton

                    local ButtonLabel = Instance.new("TextLabel")
                    ButtonLabel.Name = "TextLabel"
                    ButtonLabel.Parent = ButtonFrame
                    ButtonLabel.BackgroundTransparency = 1
                    ButtonLabel.AnchorPoint = Vector2.new(0, 0.5)
                    ButtonLabel.Position = UDim2.new(0, 15, 0.5, 0)
                    ButtonLabel.Size = UDim2.new(1, 0, 1, 0)
                    ButtonLabel.Font = Enum.Font.GothamSemibold
                    ButtonLabel.Text = buttonText
                    ButtonLabel.TextXAlignment = Enum.TextXAlignment.Left
                    ButtonLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                    ButtonLabel.TextSize = 13

                    local OverlayFrame = Instance.new("Frame")
                    OverlayFrame.Name = "Black"
                    OverlayFrame.Parent = ButtonFrame
                    OverlayFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                    OverlayFrame.BackgroundTransparency = 1
                    OverlayFrame.BorderSizePixel = 0
                    OverlayFrame.Size = UDim2.new(1, 0, 0, 33)

                    local OverlayCorner = Instance.new("UICorner")
                    OverlayCorner.CornerRadius = UDim.new(0, 5)
                    OverlayCorner.Parent = OverlayFrame

                    RealButton.MouseButton1Click:Connect(function()
                        callback()
                    end)
                end,

                Toggle = function(_, toggleLabelText, defaultState, descText, callback)
                    local isToggled = defaultState or false
                    _G.TrueColor = _G.Primary

                    local ToggleButton = Instance.new("TextButton")
                    ToggleButton.Name = "Button"
                    ToggleButton.Parent = PageScroll
                    ToggleButton.BackgroundColor3 = _G.Primary
                    ToggleButton.BackgroundTransparency = 0.8
                    ToggleButton.Size = UDim2.new(1, 0, 0, 46)
                    ToggleButton.AutoButtonColor = false
                    ToggleButton.Font = Enum.Font.SourceSans
                    ToggleButton.Text = ""
                    ToggleButton.TextSize = 11

                    local ToggleCorner = Instance.new("UICorner")
                    ToggleCorner.CornerRadius = UDim.new(0, 5)
                    ToggleCorner.Parent = ToggleButton

                    local MainToggleLabel = Instance.new("TextLabel")
                    MainToggleLabel.Parent = ToggleButton
                    MainToggleLabel.BackgroundTransparency = 1
                    MainToggleLabel.Size = UDim2.new(1, 0, 0, 35)
                    MainToggleLabel.Font = Enum.Font.GothamSemibold
                    MainToggleLabel.Text = toggleLabelText
                    MainToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                    MainToggleLabel.TextSize = 13
                    MainToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
                    MainToggleLabel.AnchorPoint = Vector2.new(0, 0.5)

                    local SubToggleLabel = Instance.new("TextLabel")
                    SubToggleLabel.Parent = MainToggleLabel
                    SubToggleLabel.BackgroundTransparency = 1
                    SubToggleLabel.Size = UDim2.new(0, 280, 0, 16)
                    SubToggleLabel.Font = Enum.Font.Gotham
                    SubToggleLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
                    SubToggleLabel.TextSize = 10
                    SubToggleLabel.TextXAlignment = Enum.TextXAlignment.Left

                    if descText then
                        SubToggleLabel.Text = descText
                        MainToggleLabel.Position = UDim2.new(0, 15, 0.5, -5)
                        SubToggleLabel.Position = UDim2.new(0, 0, 0, 22)
                    else
                        MainToggleLabel.Position = UDim2.new(0, 15, 0.5, 0)
                        SubToggleLabel.Visible = false
                    end

                    local SwitchTrackFrame = Instance.new("Frame")
                    SwitchTrackFrame.Name = "ToggleFrame"
                    SwitchTrackFrame.Parent = ToggleButton
                    SwitchTrackFrame.BackgroundColor3 = _G.Dark
                    SwitchTrackFrame.BackgroundTransparency = 1
                    SwitchTrackFrame.Position = UDim2.new(1, -10, 0.5, 0)
                    SwitchTrackFrame.Size = UDim2.new(0, 35, 0, 20)
                    SwitchTrackFrame.AnchorPoint = Vector2.new(1, 0.5)

                    local SwitchTrackCorner = Instance.new("UICorner")
                    SwitchTrackCorner.CornerRadius = UDim.new(0, 10)
                    SwitchTrackCorner.Parent = SwitchTrackFrame

                    local InteractorButton = Instance.new("TextButton")
                    InteractorButton.Name = "ToggleImage"
                    InteractorButton.Parent = SwitchTrackFrame
                    InteractorButton.BackgroundColor3 = _G.Dark
                    InteractorButton.Size = UDim2.new(1, 0, 1, 0)
                    InteractorButton.Text = ""
                    InteractorButton.AutoButtonColor = false

                    local SwitchStroke = Instance.new("UIStroke")
                    SwitchStroke.Color = _G.Primary
                    SwitchStroke.Thickness = 1
                    SwitchStroke.Parent = SwitchTrackFrame

                    local InteractorCorner = Instance.new("UICorner")
                    InteractorCorner.CornerRadius = UDim.new(0, 10)
                    InteractorCorner.Parent = InteractorButton

                    local CircleNode = Instance.new("Frame")
                    CircleNode.Name = "Circle"
                    CircleNode.Parent = InteractorButton
                    CircleNode.BackgroundColor3 = _G.Primary
                    CircleNode.Position = UDim2.new(0, 3, 0.5, 0)
                    CircleNode.Size = UDim2.new(0, 14, 0, 14)
                    CircleNode.AnchorPoint = Vector2.new(0, 0.5)

                    local CircleCorner = Instance.new("UICorner")
                    CircleCorner.CornerRadius = UDim.new(0, 10)
                    CircleCorner.Parent = CircleNode

                    local function updateToggleVisuals(state)
                        if not state then
                            SwitchStroke.Thickness = 1
                            CircleNode:TweenPosition(UDim2.new(0, 3, 0.5, 0), "Out", "Sine", 0.2, true)
                            TweenService:Create(CircleNode, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = _G.Primary}):Play()
                            TweenService:Create(InteractorButton, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = _G.Dark}):Play()
                        else
                            SwitchStroke.Thickness = 0
                            CircleNode:TweenPosition(UDim2.new(0, 18, 0.5, 0), "Out", "Sine", 0.2, true)
                            TweenService:Create(CircleNode, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = _G.Dark}):Play()
                            TweenService:Create(InteractorButton, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = _G.Primary}):Play()
                        end
                    end

                    InteractorButton.MouseButton1Click:Connect(function()
                        isToggled = not isToggled
                        updateToggleVisuals(isToggled)
                        pcall(callback, isToggled)
                    end)

                    if isToggled == true then
                        updateToggleVisuals(true)
                        pcall(callback, true)
                    end
                end,

                Dropdown = function(_, dropTitleText, itemsTable, defaultItem, callback)
                    local isDropdownOpen = false

                    local DropdownBase = Instance.new("Frame")
                    DropdownBase.Name = "Dropdown"
                    DropdownBase.Parent = PageScroll
                    DropdownBase.BackgroundColor3 = _G.Primary
                    DropdownBase.BackgroundTransparency = 0.8
                    DropdownBase.Size = UDim2.new(1, 0, 0, 40)

                    local DropdownBaseCorner = Instance.new("UICorner")
                    DropdownBaseCorner.CornerRadius = UDim.new(0, 5)
                    DropdownBaseCorner.Parent = DropdownBase

                    local DropdownTitleLabel = Instance.new("TextLabel")
                    DropdownTitleLabel.Name = "DropTitle"
                    DropdownTitleLabel.Parent = DropdownBase
                    DropdownTitleLabel.BackgroundColor3 = _G.Primary
                    DropdownTitleLabel.BackgroundTransparency = 1
                    DropdownTitleLabel.Size = UDim2.new(1, 0, 0, 30)
                    DropdownTitleLabel.Font = Enum.Font.GothamSemibold
                    DropdownTitleLabel.Text = dropTitleText
                    DropdownTitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                    DropdownTitleLabel.TextSize = 13
                    DropdownTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
                    DropdownTitleLabel.Position = UDim2.new(0, 15, 0, 5)

                    local SelectionTriggerButton = Instance.new("TextButton")
                    SelectionTriggerButton.Name = "SelectItems"
                    SelectionTriggerButton.Parent = DropdownBase
                    SelectionTriggerButton.BackgroundColor3 = _G.Dark
                    SelectionTriggerButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                    SelectionTriggerButton.BackgroundTransparency = 0.1
                    SelectionTriggerButton.Position = UDim2.new(1, -5, 0, 5)
                    SelectionTriggerButton.Size = UDim2.new(0, 100, 0, 30)
                    SelectionTriggerButton.AnchorPoint = Vector2.new(1, 0)
                    SelectionTriggerButton.Font = Enum.Font.GothamMedium
                    SelectionTriggerButton.TextSize = 9
                    SelectionTriggerButton.Text = defaultItem and ("   " .. defaultItem) or "   Select Items"
                    SelectionTriggerButton.ClipsDescendants = true
                    SelectionTriggerButton.TextXAlignment = Enum.TextXAlignment.Left

                    local SelectionTriggerCorner = Instance.new("UICorner")
                    SelectionTriggerCorner.CornerRadius = UDim.new(0, 5)
                    SelectionTriggerCorner.Parent = SelectionTriggerButton

                    local DropdownContentFrame = Instance.new("Frame")
                    DropdownContentFrame.Name = "DropdownFrameScroll"
                    DropdownContentFrame.Parent = DropdownBase
                    DropdownContentFrame.BackgroundColor3 = _G.Dark
                    DropdownContentFrame.ClipsDescendants = true
                    DropdownContentFrame.Size = UDim2.new(1, -10, 0, 100)
                    DropdownContentFrame.Position = UDim2.new(0, 5, 0, 40)
                    DropdownContentFrame.Visible = false

                    local ContentFrameCorner = Instance.new("UICorner")
                    ContentFrameCorner.CornerRadius = UDim.new(0, 5)
                    ContentFrameCorner.Parent = DropdownContentFrame

                    local DropdownScroll = Instance.new("ScrollingFrame")
                    DropdownScroll.Name = "DropScroll"
                    DropdownScroll.Parent = DropdownContentFrame
                    DropdownScroll.ScrollingDirection = Enum.ScrollingDirection.Y
                    DropdownScroll.Active = true
                    DropdownScroll.BackgroundTransparency = 1
                    DropdownScroll.BorderSizePixel = 0
                    DropdownScroll.Position = UDim2.new(0, 0, 0, 10)
                    DropdownScroll.Size = UDim2.new(1, 0, 0, 80)
                    DropdownScroll.ScrollBarThickness = 3
                    DropdownScroll.ZIndex = 3

                    local DropdownScrollCorner = Instance.new("UICorner")
                    DropdownScrollCorner.CornerRadius = UDim.new(0, 5)
                    DropdownScrollCorner.Parent = DropdownScroll

                    local DropdownPadding = Instance.new("UIPadding")
                    DropdownPadding.PaddingLeft = UDim.new(0, 10)
                    DropdownPadding.PaddingRight = UDim.new(0, 10)
                    DropdownPadding.Parent = DropdownScroll

                    local DropdownListLayout = Instance.new("UIListLayout")
                    DropdownListLayout.Parent = DropdownScroll
                    DropdownListLayout.SortOrder = Enum.SortOrder.LayoutOrder
                    DropdownListLayout.Padding = UDim.new(0, 1)

                    local function createDropdownRowItem(itemValue)
                        local RowButton = Instance.new("TextButton")
                        RowButton.Name = "Item"
                        RowButton.Parent = DropdownScroll
                        RowButton.BackgroundColor3 = _G.Primary
                        RowButton.BackgroundTransparency = 1
                        RowButton.Size = UDim2.new(1, 0, 0, 30)
                        RowButton.Font = Enum.Font.GothamSemibold
                        RowButton.Text = tostring(itemValue)
                        RowButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                        RowButton.TextSize = 11
                        RowButton.TextTransparency = 0.5
                        RowButton.TextXAlignment = Enum.TextXAlignment.Left
                        RowButton.ZIndex = 4

                        local RowPadding = Instance.new("UIPadding")
                        RowPadding.PaddingLeft = UDim.new(0, 8)
                        RowPadding.Parent = RowButton

                        local RowCorner = Instance.new("UICorner")
                        RowCorner.CornerRadius = UDim.new(0, 5)
                        RowCorner.Parent = RowButton

                        local ActiveLineIndicator = Instance.new("Frame")
                        ActiveLineIndicator.Name = "SelectedItems"
                        ActiveLineIndicator.Parent = RowButton
                        ActiveLineIndicator.BackgroundColor3 = _G.Primary
                        ActiveLineIndicator.BackgroundTransparency = 1
                        ActiveLineIndicator.Size = UDim2.new(0, 3, 0.4, 0)
                        ActiveLineIndicator.Position = UDim2.new(0, -8, 0.5, 0)
                        ActiveLineIndicator.AnchorPoint = Vector2.new(0, 0.5)
                        ActiveLineIndicator.ZIndex = 4

                        local ActiveIndicatorCorner = Instance.new("UICorner")
                        ActiveIndicatorCorner.CornerRadius = UDim.new(0, 999)
                        ActiveIndicatorCorner.Parent = ActiveLineIndicator

                        RowButton.MouseEnter:Connect(function()
                            TweenService:Create(RowButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0, BackgroundTransparency = 0.8}):Play()
                            TweenService:Create(ActiveLineIndicator, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()
                        end)

                        RowButton.MouseLeave:Connect(function()
                            TweenService:Create(RowButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0.5, BackgroundTransparency = 1}):Play()
                            TweenService:Create(ActiveLineIndicator, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
                        end)

                        RowButton.MouseButton1Click:Connect(function()
                            isDropdownOpen = false
                            SelectionTriggerButton.ClipsDescendants = true
                            TweenService:Create(DropdownContentFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, -10, 0, 0), Visible = false}):Play()
                            
                            callback(RowButton.Text)
                            SelectionTriggerButton.Text = "   " .. RowButton.Text
                            TweenService:Create(DropdownBase, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 40)}):Play()
                        end)
                    end

                    for _, item in pairs(itemsTable) do
                        createDropdownRowItem(item)
                    end

                    DropdownScroll.CanvasSize = UDim2.new(0, 0, 0, DropdownListLayout.AbsoluteContentSize.Y)

                    SelectionTriggerButton.MouseButton1Click:Connect(function()
                        isDropdownOpen = not isDropdownOpen
                        if not isDropdownOpen then
                            TweenService:Create(DropdownContentFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, -10, 0, 0), Visible = false}):Play()
                            TweenService:Create(DropdownBase, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 40)}):Play()
                        else
                            TweenService:Create(DropdownContentFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, -10, 0, 100), Visible = true}):Play()
                            TweenService:Create(DropdownBase, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 145)}):Play()
                        end
                    end)

                    return {
                        Add = function(_, newItemValue)
                            createDropdownRowItem(newItemValue)
                        end,
                        Clear = function(_)
                            SelectionTriggerButton.Text = "   Select Items"
                            isDropdownOpen = false
                            DropdownContentFrame.Visible = false
                            for _, child in pairs(DropdownScroll:GetChildren()) do
                                if child:IsA("TextButton") then
                                    child:Destroy()
                                end
                            end
                        end
                    }
                end,

                Slider = function(_, sliderTitleText, minValue, maxValue, defaultVal, callback)
                    local SliderBase = Instance.new("Frame")
                    SliderBase.Name = "Slider"
                    SliderBase.Parent = PageScroll
                    SliderBase.BackgroundTransparency = 1
                    SliderBase.Size = UDim2.new(1, 0, 0, 45)

                    local SliderBaseCorner = Instance.new("UICorner")
                    SliderBaseCorner.CornerRadius = UDim.new(0, 5)
                    SliderBaseCorner.Parent = SliderBase

                    local SliderInnerFrame = Instance.new("Frame")
                    SliderInnerFrame.Name = "sliderr"
                    SliderInnerFrame.Parent = SliderBase
                    SliderInnerFrame.BackgroundColor3 = _G.Primary
                    SliderInnerFrame.BackgroundTransparency = 0.8
                    SliderInnerFrame.Size = UDim2.new(1, 0, 0, 45)

                    local SliderInnerCorner = Instance.new("UICorner")
                    SliderInnerCorner.CornerRadius = UDim.new(0, 5)
                    SliderInnerCorner.Parent = SliderInnerFrame

                    local SliderTitleLabel = Instance.new("TextLabel")
                    SliderTitleLabel.Parent = SliderInnerFrame
                    SliderTitleLabel.BackgroundTransparency = 1
                    SliderTitleLabel.Position = UDim2.new(0, 15, 0.5, 0)
                    SliderTitleLabel.Size = UDim2.new(1, 0, 0, 30)
                    SliderTitleLabel.Font = Enum.Font.GothamSemibold
                    SliderTitleLabel.Text = sliderTitleText
                    SliderTitleLabel.AnchorPoint = Vector2.new(0, 0.5)
                    SliderTitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                    SliderTitleLabel.TextSize = 13
                    SliderTitleLabel.TextXAlignment = Enum.TextXAlignment.Left

                    local TrackBarBase = Instance.new("Frame")
                    TrackBarBase.Name = "bar"
                    TrackBarBase.Parent = SliderInnerFrame
                    TrackBarBase.BackgroundColor3 = _G.Primary
                    TrackBarBase.Size = UDim2.new(0, 100, 0, 4)
                    TrackBarBase.Position = UDim2.new(1, -10, 0.5, 10)
                    TrackBarBase.BackgroundTransparency = 0.8
                    TrackBarBase.AnchorPoint = Vector2.new(1, 0.5)

                    local TrackBarFill = Instance.new("Frame")
                    TrackBarFill.Name = "bar1"
                    TrackBarFill.Parent = TrackBarBase
                    TrackBarFill.BackgroundColor3 = _G.Dark
                    TrackBarFill.Size = UDim2.new(defaultVal / maxValue, 0, 0, 4)

                    local TrackBarFillCorner = Instance.new("UICorner")
                    TrackBarFillCorner.CornerRadius = UDim.new(0, 5)
                    TrackBarFillCorner.Parent = TrackBarFill

                    local TrackBarBaseCorner = Instance.new("UICorner")
                    TrackBarBaseCorner.CornerRadius = UDim.new(0, 5)
                    TrackBarBaseCorner.Parent = TrackBarBase

                    local SliderPinHead = Instance.new("Frame")
                    SliderPinHead.Name = "circlebar"
                    SliderPinHead.Parent = TrackBarFill
                    SliderPinHead.BackgroundColor3 = _G.Dark
                    SliderPinHead.Position = UDim2.new(1, 0, 0, -5)
                    SliderPinHead.AnchorPoint = Vector2.new(0.5, 0)
                    SliderPinHead.Size = UDim2.new(0, 13, 0, 13)

                    local PinHeadCorner = Instance.new("UICorner")
                    PinHeadCorner.CornerRadius = UDim.new(0, 100)
                    PinHeadCorner.Parent = SliderPinHead

                    local ValueInputBox = Instance.new("TextBox")
                    ValueInputBox.Parent = SliderInnerFrame
                    ValueInputBox.BackgroundColor3 = _G.Dark
                    ValueInputBox.BackgroundTransparency = 0.1
                    ValueInputBox.Font = Enum.Font.Code
                    ValueInputBox.Size = UDim2.new(0, 35, 0, 15)
                    ValueInputBox.AnchorPoint = Vector2.new(1, 0.5)
                    ValueInputBox.Position = UDim2.new(1, -10, 0.5, -10)
                    ValueInputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
                    ValueInputBox.TextSize = 9
                    ValueInputBox.Text = defaultVal
                    ValueInputBox.TextTransparency = 0.1
                    ValueInputBox.ClearTextOnFocus = false
                    ValueInputBox.TextXAlignment = Enum.TextXAlignment.Center

                    local ValueInputCorner = Instance.new("UICorner")
                    ValueInputCorner.CornerRadius = UDim.new(0, 3)
                    ValueInputCorner.Parent = ValueInputBox

                    local currentSliderValue = defaultVal or minValue
                    pcall(function()
                        callback(currentSliderValue)
                    end)

                    local isSliding = false
                    SliderPinHead.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                            isSliding = true
                        end
                    end)

                    TrackBarBase.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                            isSliding = true
                        end
                    end)

                    UserInputService.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                            isSliding = false
                        end
                    end)

                    UserInputService.InputChanged:Connect(function(input)
                        if isSliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                            currentSliderValue = math.floor((tonumber(maxValue) - tonumber(minValue)) / 100 * TrackBarFill.AbsoluteSize.X + tonumber(minValue)) or 0
                            pcall(function()
                                callback(currentSliderValue)
                            end)

                            ValueInputBox.Text = currentSliderValue
                            TrackBarFill.Size = UDim2.new(0, math.clamp(input.Position.X - TrackBarFill.AbsolutePosition.X, 0, 100), 0, 4)
                            SliderPinHead.Position = UDim2.new(0, math.clamp(input.Position.X - TrackBarFill.AbsolutePosition.X - 5, 0, 100), 0, -5)
                        end
                    end)

                    ValueInputBox.FocusLost:Connect(function()
                        local typedVal = tonumber(ValueInputBox.Text) or minValue
                        if typedVal > maxValue then
                            typedVal = maxValue
                        elseif typedVal < minValue then
                            typedVal = minValue
                        end

                        ValueInputBox.Text = typedVal
                        TrackBarFill.Size = UDim2.new((typedVal - minValue) / (maxValue - minValue), 0, 0, 4)
                        SliderPinHead.Position = UDim2.new(1, 0, 0, -5)

                        currentSliderValue = typedVal
                        pcall(callback, currentSliderValue)
                    end)
                end,

                Textbox = function(_, textboxLabelText, placeholderText, callback)
                    local TextboxBase = Instance.new("Frame")
                    (void)(placeholderText)
                    TextboxBase.Name = "Textbox"
                    TextboxBase.Parent = PageScroll
                    TextboxBase.BackgroundColor3 = _G.Primary
                    TextboxBase.BackgroundTransparency = 0.8
                    TextboxBase.Size = UDim2.new(1, 0, 0, 35)

                    local TextboxBaseCorner = Instance.new("UICorner")
                    TextboxBaseCorner.CornerRadius = UDim.new(0, 5)
                    TextboxBaseCorner.Parent = TextboxBase

                    local TextboxLabel = Instance.new("TextLabel")
                    TextboxLabel.Name = "TextboxLabel"
                    TextboxLabel.Parent = TextboxBase
                    TextboxLabel.BackgroundColor3 = _G.Primary
                    TextboxLabel.BackgroundTransparency = 1
                    TextboxLabel.Position = UDim2.new(0, 15, 0.5, 0)
                    TextboxLabel.Text = textboxLabelText
                    TextboxLabel.Size = UDim2.new(1, 0, 0, 35)
                    TextboxLabel.Font = Enum.Font.GothamSemibold
                    TextboxLabel.AnchorPoint = Vector2.new(0, 0.5)
                    TextboxLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                    TextboxLabel.TextSize = 13
                    TextboxLabel.TextXAlignment = Enum.TextXAlignment.Left

                    local ActualInputBox = Instance.new("TextBox")
                    ActualInputBox.Name = "RealTextbox"
                    ActualInputBox.Parent = TextboxBase
                    ActualInputBox.BackgroundColor3 = _G.Dark
                    ActualInputBox.BackgroundTransparency = 0.1
                    ActualInputBox.Position = UDim2.new(1, -5, 0.5, 0)
                    ActualInputBox.AnchorPoint = Vector2.new(1, 0.5)
                    ActualInputBox.Size = UDim2.new(0, 80, 0, 25)
                    ActualInputBox.Font = Enum.Font.GothamSemibold
                    ActualInputBox.Text = ""
                    ActualInputBox.TextColor3 = Color3.fromRGB(225, 225, 225)
                    ActualInputBox.TextSize = 11
                    ActualInputBox.ClipsDescendants = true

                    ActualInputBox.FocusLost:Connect(function()
                        callback(ActualInputBox.Text)
                    end)

                    local InputBoxCorner = Instance.new("UICorner")
                    InputBoxCorner.CornerRadius = UDim.new(0, 5)
                    InputBoxCorner.Parent = ActualInputBox
                end,

                Label = function(_, initialText)
                    local LabelObj = Instance.new("TextLabel")
                    local LabelMethods = {}

                    LabelObj.Name = "Label"
                    LabelObj.Parent = PageScroll
                    LabelObj.BackgroundTransparency = 1
                    LabelObj.Size = UDim2.new(1, 0, 0, 20)
                    LabelObj.Font = Enum.Font.GothamSemibold
                    LabelObj.TextColor3 = Color3.fromRGB(225, 225, 225)
                    LabelObj.TextSize = 13
                    LabelObj.Text = initialText
                    LabelObj.TextXAlignment = Enum.TextXAlignment.Left

                    local LabelPadding = Instance.new("UIPadding")
                    LabelPadding.PaddingLeft = UDim.new(0, 2)
                    LabelPadding.Parent = LabelObj

                    function LabelMethods.Set(_, updatedText)
                        LabelObj.Text = updatedText
                    end

                    return LabelMethods
                end,

                Seperator = function(_, labelString)
                    local SeparatorBase = Instance.new("Frame")
                    SeparatorBase.Name = "Seperator"
                    SeparatorBase.Parent = PageScroll
                    SeparatorBase.BackgroundTransparency = 1
                    SeparatorBase.Size = UDim2.new(1, 0, 0, 36)

                    local SeparatorLabel = Instance.new("TextLabel")
                    SeparatorLabel.Name = "Sep2"
                    SeparatorLabel.Parent = SeparatorBase
                    SeparatorLabel.BackgroundTransparency = 1
                    SeparatorLabel.AnchorPoint = Vector2.new(0.5, 1)
                    SeparatorLabel.Position = UDim2.new(0.5, 0, 0, 30)
                    SeparatorLabel.Size = UDim2.new(1, 0, 0, 36)
                    SeparatorLabel.Font = Enum.Font.GothamBold
                    SeparatorLabel.Text = labelString
                    SeparatorLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                    SeparatorLabel.TextSize = 14

                    local LineGraphic = Instance.new("Frame")
                    LineGraphic.Name = "Sep3"
                    LineGraphic.Parent = SeparatorBase
                    LineGraphic.BackgroundColor3 = _G.Primary
                    LineGraphic.BorderSizePixel = 0
                    LineGraphic.AnchorPoint = Vector2.new(0.5, 0.5)
                    LineGraphic.Position = UDim2.new(0.5, 0, 0, 25)

                    local textDimensions = TextService:GetTextSize(SeparatorLabel.Text, SeparatorLabel.TextSize, SeparatorLabel.Font, Vector2.new(math.huge, math.huge))
                    LineGraphic.Size = UDim2.new(0, textDimensions.X * 0.7, 0, 3)

                    local LineGraphicCorner = Instance.new("UICorner")
                    LineGraphicCorner.CornerRadius = UDim.new(0, math.huge)
                    LineGraphicCorner.Parent = LineGraphic
                end,

                Line = function(_)
                    local FrameLineWrapper = Instance.new("Frame")
                    FrameLineWrapper.Name = "Linee"
                    FrameLineWrapper.Parent = PageScroll
                    FrameLineWrapper.BackgroundTransparency = 1
                    FrameLineWrapper.Position = UDim2.new(0, 0, 0.12, 0)
                    FrameLineWrapper.Size = UDim2.new(1, 0, 0, 20)

                    local InnerLineElement = Instance.new("Frame")
                    InnerLineElement.Name = "Line"
                    InnerLineElement.Parent = FrameLineWrapper
                    InnerLineElement.BackgroundColor3 = Color3.new(125, 125, 125)
                    InnerLineElement.BorderSizePixel = 0
                    InnerLineElement.Position = UDim2.new(0, 0, 0, 10)
                    InnerLineElement.Size = UDim2.new(1, 0, 0, 1)

                    local UI_Gradient = Instance.new("UIGradient")
                    UI_Gradient.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, _G.Dark),
                        ColorSequenceKeypoint.new(0.4, _G.Primary),
                        ColorSequenceKeypoint.new(0.5, _G.Primary),
                        ColorSequenceKeypoint.new(0.6, _G.Primary),
                        ColorSequenceKeypoint.new(1, _G.Dark),
                    })
                    UI_Gradient.Parent = InnerLineElement
                end
            }
        end
    end
end

return UILibrary
