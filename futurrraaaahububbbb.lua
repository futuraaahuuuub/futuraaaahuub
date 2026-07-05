-- Base GUI for Roblox
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local MarketplaceService = game:GetService("MarketplaceService")
local player = Players.LocalPlayer

-- === Scan the current game ===
local gameName = "Unknown game"
local ok0, productInfo = pcall(function()
    return MarketplaceService:GetProductInfo(game.PlaceId)
end)
if ok0 and productInfo then
    gameName = productInfo.Name
end

-- === Main window ===
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FUTURAHUB"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 320, 0, 400)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- === Title bar ===
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 36)
TitleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = TitleBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -40, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "FUTURAHUB"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -33, 0, 3)
CloseBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
MinimizeBtn.Position = UDim2.new(1, -66, 0, 3)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
MinimizeBtn.Text = "_"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextSize = 14
MinimizeBtn.Parent = TitleBar

local MinimizeCorner = Instance.new("UICorner")
MinimizeCorner.CornerRadius = UDim.new(0, 6)
MinimizeCorner.Parent = MinimizeBtn

MinimizeBtn.MouseEnter:Connect(function()
    MinimizeBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
end)

MinimizeBtn.MouseLeave:Connect(function()
    MinimizeBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
end)

-- Red hover only on the close button
local closeDefaultColor = Color3.fromRGB(45, 45, 45)
local closeHoverColor = Color3.fromRGB(220, 60, 60)

CloseBtn.MouseEnter:Connect(function()
    CloseBtn.BackgroundColor3 = closeHoverColor
end)

CloseBtn.MouseLeave:Connect(function()
    CloseBtn.BackgroundColor3 = closeDefaultColor
end)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- === Drag via the title bar only ===
local dragging = false
local dragStart
local startPos

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

-- === Content area ===
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -20, 1, -50)
ContentFrame.Position = UDim2.new(0, 10, 0, 44)
ContentFrame.BackgroundTransparency = 1
ContentFrame.BorderSizePixel = 0
ContentFrame.Parent = MainFrame

local expandedSize = MainFrame.Size
local minimizedSize = UDim2.new(0, expandedSize.X.Offset, 0, 36)
local minimized = false

MinimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    ContentFrame.Visible = not minimized
    MainFrame.Size = minimized and minimizedSize or expandedSize
end)

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Parent = ContentFrame

-- === Section: key system ===
local LINKVERTISE_URL = "https://link-center.net/7196939/eF789xOEkNuz"
local LOOTLABS_URL = "https://lootdest.org/s?4j1vkzjr"

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, 0, 0, 16)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = ""
StatusLabel.TextColor3 = Color3.fromRGB(160, 160, 160)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 11
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.LayoutOrder = 5
StatusLabel.Parent = ContentFrame

local function tryCall(fn, ...)
    if type(fn) ~= "function" then
        return false
    end
    return pcall(fn, ...)
end

local function openKeyLink(url)
    local env = getgenv and getgenv() or {}

    if tryCall(env.setclipboard or setclipboard, url) then
        StatusLabel.Text = "Link copied to clipboard — paste it in your browser."
    else
        StatusLabel.Text = "Couldn't copy the link: " .. url
    end
end

local GetKeyLinkvertiseBtn = Instance.new("TextButton")
GetKeyLinkvertiseBtn.Size = UDim2.new(1, 0, 0, 32)
GetKeyLinkvertiseBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
GetKeyLinkvertiseBtn.Text = "Get Key (Linkvertise)"
GetKeyLinkvertiseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
GetKeyLinkvertiseBtn.Font = Enum.Font.Gotham
GetKeyLinkvertiseBtn.TextSize = 14
GetKeyLinkvertiseBtn.LayoutOrder = 1
GetKeyLinkvertiseBtn.Parent = ContentFrame

local GetKeyLinkvertiseCorner = Instance.new("UICorner")
GetKeyLinkvertiseCorner.CornerRadius = UDim.new(0, 6)
GetKeyLinkvertiseCorner.Parent = GetKeyLinkvertiseBtn

GetKeyLinkvertiseBtn.MouseButton1Click:Connect(function()
    openKeyLink(LINKVERTISE_URL)
end)

local GetKeyLootlabsBtn = Instance.new("TextButton")
GetKeyLootlabsBtn.Size = UDim2.new(1, 0, 0, 32)
GetKeyLootlabsBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
GetKeyLootlabsBtn.Text = "Get Key (Lootlabs)"
GetKeyLootlabsBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
GetKeyLootlabsBtn.Font = Enum.Font.Gotham
GetKeyLootlabsBtn.TextSize = 14
GetKeyLootlabsBtn.LayoutOrder = 2
GetKeyLootlabsBtn.Parent = ContentFrame

local GetKeyLootlabsCorner = Instance.new("UICorner")
GetKeyLootlabsCorner.CornerRadius = UDim.new(0, 6)
GetKeyLootlabsCorner.Parent = GetKeyLootlabsBtn

GetKeyLootlabsBtn.MouseButton1Click:Connect(function()
    openKeyLink(LOOTLABS_URL)
end)

local KeyInput = Instance.new("TextBox")
KeyInput.Size = UDim2.new(1, 0, 0, 32)
KeyInput.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
KeyInput.Text = ""
KeyInput.PlaceholderText = "Insert key"
KeyInput.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyInput.ClearTextOnFocus = false
KeyInput.Font = Enum.Font.Gotham
KeyInput.TextSize = 14
KeyInput.LayoutOrder = 3
KeyInput.Parent = ContentFrame

local KeyInputCorner = Instance.new("UICorner")
KeyInputCorner.CornerRadius = UDim.new(0, 6)
KeyInputCorner.Parent = KeyInput

local VerifyKeyBtn = Instance.new("TextButton")
VerifyKeyBtn.Size = UDim2.new(1, 0, 0, 32)
VerifyKeyBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
VerifyKeyBtn.Text = "Verify Key"
VerifyKeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
VerifyKeyBtn.Font = Enum.Font.Gotham
VerifyKeyBtn.TextSize = 14
VerifyKeyBtn.LayoutOrder = 4
VerifyKeyBtn.Parent = ContentFrame

local VerifyKeyCorner = Instance.new("UICorner")
VerifyKeyCorner.CornerRadius = UDim.new(0, 6)
VerifyKeyCorner.Parent = VerifyKeyBtn

local VALID_KEY = "zDg4z'R9rj3_b1_{ax_8bDzGB2;294-vt=8~,%6$46!{sgNJ|+"

VerifyKeyBtn.MouseButton1Click:Connect(function()
    local enteredKey = KeyInput.Text
    if enteredKey == VALID_KEY then
        StatusLabel.Text = "Key valid — access granted."
    else
        StatusLabel.Text = "Invalid key."
    end
end)

-- === Section: player info ===
local PlayerInfoFrame = Instance.new("Frame")
PlayerInfoFrame.Size = UDim2.new(1, 0, 0, 88)
PlayerInfoFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
PlayerInfoFrame.BorderSizePixel = 0
PlayerInfoFrame.LayoutOrder = 0
PlayerInfoFrame.Parent = ContentFrame

local PlayerInfoCorner = Instance.new("UICorner")
PlayerInfoCorner.CornerRadius = UDim.new(0, 8)
PlayerInfoCorner.Parent = PlayerInfoFrame

local AvatarImage = Instance.new("ImageLabel")
AvatarImage.Size = UDim2.new(0, 54, 0, 54)
AvatarImage.Position = UDim2.new(0, 8, 0, 8)
AvatarImage.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
AvatarImage.Parent = PlayerInfoFrame

local AvatarCorner = Instance.new("UICorner")
AvatarCorner.CornerRadius = UDim.new(1, 0)
AvatarCorner.Parent = AvatarImage

local ok, content = pcall(function()
    return Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
end)
if ok then
    AvatarImage.Image = content
end

local NameLabel = Instance.new("TextLabel")
NameLabel.Size = UDim2.new(1, -74, 0, 20)
NameLabel.Position = UDim2.new(0, 70, 0, 10)
NameLabel.BackgroundTransparency = 1
NameLabel.Text = player.DisplayName
NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
NameLabel.Font = Enum.Font.GothamBold
NameLabel.TextSize = 15
NameLabel.TextXAlignment = Enum.TextXAlignment.Left
NameLabel.Parent = PlayerInfoFrame

local UsernameLabel = Instance.new("TextLabel")
UsernameLabel.Size = UDim2.new(1, -74, 0, 16)
UsernameLabel.Position = UDim2.new(0, 70, 0, 30)
UsernameLabel.BackgroundTransparency = 1
UsernameLabel.Text = "@" .. player.Name
UsernameLabel.TextColor3 = Color3.fromRGB(160, 160, 160)
UsernameLabel.Font = Enum.Font.Gotham
UsernameLabel.TextSize = 13
UsernameLabel.TextXAlignment = Enum.TextXAlignment.Left
UsernameLabel.Parent = PlayerInfoFrame

local IdLabel = Instance.new("TextLabel")
IdLabel.Size = UDim2.new(1, -74, 0, 14)
IdLabel.Position = UDim2.new(0, 70, 0, 48)
IdLabel.BackgroundTransparency = 1
IdLabel.Text = "ID: " .. player.UserId
IdLabel.TextColor3 = Color3.fromRGB(120, 120, 120)
IdLabel.Font = Enum.Font.Gotham
IdLabel.TextSize = 11
IdLabel.TextXAlignment = Enum.TextXAlignment.Left
IdLabel.Parent = PlayerInfoFrame

local GameLabel = Instance.new("TextLabel")
GameLabel.Size = UDim2.new(1, -16, 0, 16)
GameLabel.Position = UDim2.new(0, 8, 0, 66)
GameLabel.BackgroundTransparency = 1
GameLabel.Text = "Game: " .. gameName
GameLabel.TextColor3 = Color3.fromRGB(160, 160, 160)
GameLabel.Font = Enum.Font.GothamBold
GameLabel.TextSize = 12
GameLabel.TextXAlignment = Enum.TextXAlignment.Left
GameLabel.TextTruncate = Enum.TextTruncate.AtEnd
GameLabel.Parent = PlayerInfoFrame
