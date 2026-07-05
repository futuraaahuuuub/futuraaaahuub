-- Base GUI for Roblox
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local MarketplaceService = game:GetService("MarketplaceService")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
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
ScreenGui.Enabled = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local hubGuiRef = nil

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

-- === Saved key persistence ===
local KEY_FOLDER = "FuturaHub"
local KEY_FILE = "FuturaHub/key.txt"

local function saveKey(key)
    if isfolder and makefolder and not isfolder(KEY_FOLDER) then
        makefolder(KEY_FOLDER)
    end
    tryCall(writefile, KEY_FILE, key)
end

local function loadSavedKey()
    local ok, result = tryCall(readfile, KEY_FILE)
    if ok and result and result ~= "" then
        return result
    end
    return nil
end

local function deleteSavedKey()
    tryCall(delfile, KEY_FILE)
end

local function openKeyLink(url)
    local env = getgenv and getgenv() or {}

    if tryCall(env.setclipboard or setclipboard, url) then
        StatusLabel.Text = "Link copied to clipboard — paste it in your browser."
        StatusLabel.TextColor3 = Color3.fromRGB(160, 160, 160)
    else
        StatusLabel.Text = "Couldn't copy the link: " .. url
        StatusLabel.TextColor3 = Color3.fromRGB(220, 60, 60)
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
        StatusLabel.Text = "Correct Key"
        StatusLabel.TextColor3 = Color3.fromRGB(60, 200, 100)
        saveKey(enteredKey)
        task.wait(0.4)
        ScreenGui.Enabled = false
        if hubGuiRef then
            hubGuiRef.Enabled = true
        else
            openHub()
        end
    else
        StatusLabel.Text = "Wrong Key"
        StatusLabel.TextColor3 = Color3.fromRGB(220, 60, 60)
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

-- === Hub window (opens after a valid key) ===
function openHub()
    local HubGui = Instance.new("ScreenGui")
    HubGui.Name = "FUTURAHUB_MAIN"
    HubGui.ResetOnSpawn = false
    HubGui.Parent = player:WaitForChild("PlayerGui")

    hubGuiRef = HubGui

    local minSize = Vector2.new(420, 300)

    local Hub = Instance.new("Frame")
    Hub.Name = "Hub"
    Hub.Size = UDim2.new(0, 520, 0, 360)
    Hub.Position = UDim2.new(0.5, -260, 0.5, -180)
    Hub.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Hub.BorderSizePixel = 0
    Hub.Active = true
    Hub.Parent = HubGui

    local HubCorner = Instance.new("UICorner")
    HubCorner.CornerRadius = UDim.new(0, 8)
    HubCorner.Parent = Hub

    -- Title bar
    local HubTitleBar = Instance.new("Frame")
    HubTitleBar.Size = UDim2.new(1, 0, 0, 36)
    HubTitleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    HubTitleBar.BorderSizePixel = 0
    HubTitleBar.Parent = Hub

    local HubTitleCorner = Instance.new("UICorner")
    HubTitleCorner.CornerRadius = UDim.new(0, 8)
    HubTitleCorner.Parent = HubTitleBar

    local HubTitle = Instance.new("TextLabel")
    HubTitle.Size = UDim2.new(1, -80, 1, 0)
    HubTitle.Position = UDim2.new(0, 10, 0, 0)
    HubTitle.BackgroundTransparency = 1
    HubTitle.Text = "FUTURAHUB"
    HubTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    HubTitle.Font = Enum.Font.GothamBold
    HubTitle.TextSize = 16
    HubTitle.TextXAlignment = Enum.TextXAlignment.Left
    HubTitle.Parent = HubTitleBar

    local HubCloseBtn = Instance.new("TextButton")
    HubCloseBtn.Size = UDim2.new(0, 30, 0, 30)
    HubCloseBtn.Position = UDim2.new(1, -33, 0, 3)
    HubCloseBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    HubCloseBtn.Text = "X"
    HubCloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    HubCloseBtn.Font = Enum.Font.GothamBold
    HubCloseBtn.TextSize = 14
    HubCloseBtn.Parent = HubTitleBar

    local HubCloseCorner = Instance.new("UICorner")
    HubCloseCorner.CornerRadius = UDim.new(0, 6)
    HubCloseCorner.Parent = HubCloseBtn

    HubCloseBtn.MouseEnter:Connect(function()
        HubCloseBtn.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
    end)
    HubCloseBtn.MouseLeave:Connect(function()
        HubCloseBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    end)
    HubCloseBtn.MouseButton1Click:Connect(function()
        HubGui:Destroy()
        if hubGuiRef == HubGui then
            hubGuiRef = nil
        end
    end)

    local HubMinimizeBtn = Instance.new("TextButton")
    HubMinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
    HubMinimizeBtn.Position = UDim2.new(1, -66, 0, 3)
    HubMinimizeBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    HubMinimizeBtn.Text = "_"
    HubMinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    HubMinimizeBtn.Font = Enum.Font.GothamBold
    HubMinimizeBtn.TextSize = 14
    HubMinimizeBtn.Parent = HubTitleBar

    local HubMinimizeCorner = Instance.new("UICorner")
    HubMinimizeCorner.CornerRadius = UDim.new(0, 6)
    HubMinimizeCorner.Parent = HubMinimizeBtn

    HubMinimizeBtn.MouseEnter:Connect(function()
        HubMinimizeBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    end)
    HubMinimizeBtn.MouseLeave:Connect(function()
        HubMinimizeBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    end)

    -- Drag via title bar
    local hubDragging, hubDragStart, hubStartPos = false, nil, nil
    HubTitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            hubDragging = true
            hubDragStart = input.Position
            hubStartPos = Hub.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    hubDragging = false
                end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if hubDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - hubDragStart
            Hub.Position = UDim2.new(
                hubStartPos.X.Scale, hubStartPos.X.Offset + delta.X,
                hubStartPos.Y.Scale, hubStartPos.Y.Offset + delta.Y
            )
        end
    end)

    -- Body: sidebar + content
    local Body = Instance.new("Frame")
    Body.Size = UDim2.new(1, 0, 1, -36)
    Body.Position = UDim2.new(0, 0, 0, 36)
    Body.BackgroundTransparency = 1
    Body.Parent = Hub

    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 130, 1, 0)
    Sidebar.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = Body

    local SidebarList = Instance.new("UIListLayout")
    SidebarList.Padding = UDim.new(0, 6)
    SidebarList.SortOrder = Enum.SortOrder.LayoutOrder
    SidebarList.Parent = Sidebar

    local SidebarPad = Instance.new("UIPadding")
    SidebarPad.PaddingTop = UDim.new(0, 10)
    SidebarPad.PaddingLeft = UDim.new(0, 8)
    SidebarPad.PaddingRight = UDim.new(0, 8)
    SidebarPad.Parent = Sidebar

    -- Content column (right of sidebar)
    local ContentCol = Instance.new("Frame")
    ContentCol.Size = UDim2.new(1, -130, 1, 0)
    ContentCol.Position = UDim2.new(0, 130, 0, 0)
    ContentCol.BackgroundTransparency = 1
    ContentCol.Parent = Body

    -- Persistent player info strip, top margin of every category
    local HubPlayerInfo = Instance.new("Frame")
    HubPlayerInfo.Size = UDim2.new(1, -20, 0, 60)
    HubPlayerInfo.Position = UDim2.new(0, 10, 0, 10)
    HubPlayerInfo.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    HubPlayerInfo.BorderSizePixel = 0
    HubPlayerInfo.Parent = ContentCol

    local HubPlayerInfoCorner = Instance.new("UICorner")
    HubPlayerInfoCorner.CornerRadius = UDim.new(0, 8)
    HubPlayerInfoCorner.Parent = HubPlayerInfo

    local HubAvatar = Instance.new("ImageLabel")
    HubAvatar.Size = UDim2.new(0, 40, 0, 40)
    HubAvatar.Position = UDim2.new(0, 10, 0, 10)
    HubAvatar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    HubAvatar.Image = AvatarImage.Image
    HubAvatar.Parent = HubPlayerInfo

    local HubAvatarCorner = Instance.new("UICorner")
    HubAvatarCorner.CornerRadius = UDim.new(1, 0)
    HubAvatarCorner.Parent = HubAvatar

    local HubName = Instance.new("TextLabel")
    HubName.Size = UDim2.new(1, -110, 0, 18)
    HubName.Position = UDim2.new(0, 58, 0, 8)
    HubName.BackgroundTransparency = 1
    HubName.Text = player.DisplayName .. " (@" .. player.Name .. ")"
    HubName.TextColor3 = Color3.fromRGB(255, 255, 255)
    HubName.Font = Enum.Font.GothamBold
    HubName.TextSize = 14
    HubName.TextXAlignment = Enum.TextXAlignment.Left
    HubName.TextTruncate = Enum.TextTruncate.AtEnd
    HubName.Parent = HubPlayerInfo

    local HubMeta = Instance.new("TextLabel")
    HubMeta.Size = UDim2.new(1, -110, 0, 16)
    HubMeta.Position = UDim2.new(0, 58, 0, 28)
    HubMeta.BackgroundTransparency = 1
    HubMeta.Text = "ID: " .. player.UserId .. "  |  " .. gameName
    HubMeta.TextColor3 = Color3.fromRGB(150, 150, 150)
    HubMeta.Font = Enum.Font.Gotham
    HubMeta.TextSize = 11
    HubMeta.TextXAlignment = Enum.TextXAlignment.Left
    HubMeta.TextTruncate = Enum.TextTruncate.AtEnd
    HubMeta.Parent = HubPlayerInfo

    -- Category pages container (below player info)
    local Pages = Instance.new("Frame")
    Pages.Size = UDim2.new(1, -20, 1, -80)
    Pages.Position = UDim2.new(0, 10, 0, 80)
    Pages.BackgroundTransparency = 1
    Pages.Parent = ContentCol

    -- === Misc feature state (walkspeed/jumppower, noclip, teleports) ===
    local function getCharacterParts()
        local character = player.Character
        if not character then return nil, nil, nil end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        local root = character:FindFirstChild("HumanoidRootPart")
        return character, humanoid, root
    end

    local currentWalkSpeed = 16
    local currentJumpPower = 50
    local noclipEnabled = false
    local clickTpEnabled = false
    local waypoints = {}

    local function applyMovementStats()
        local _, humanoid = getCharacterParts()
        if humanoid then
            humanoid.WalkSpeed = currentWalkSpeed
            humanoid.UseJumpPower = true
            humanoid.JumpPower = currentJumpPower
        end
    end

    player.CharacterAdded:Connect(function()
        task.wait(0.5)
        applyMovementStats()
    end)
    applyMovementStats()

    RunService.Stepped:Connect(function()
        if not noclipEnabled then return end
        local character = player.Character
        if not character then return end
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end)

    local mouse = player:GetMouse()
    mouse.Button1Down:Connect(function()
        if not clickTpEnabled then return end
        local _, _, root = getCharacterParts()
        if root and mouse.Hit then
            root.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 3, 0))
        end
    end)

    -- Slider widget: draggable knob over a track
    local function createSlider(parent, layoutOrder, labelText, min, max, default, callback)
        local container = Instance.new("Frame")
        container.Size = UDim2.new(1, 0, 0, 46)
        container.BackgroundTransparency = 1
        container.LayoutOrder = layoutOrder
        container.Parent = parent

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 0, 18)
        label.BackgroundTransparency = 1
        label.Text = labelText .. ": " .. tostring(default)
        label.TextColor3 = Color3.fromRGB(220, 220, 220)
        label.Font = Enum.Font.Gotham
        label.TextSize = 12
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = container

        local track = Instance.new("Frame")
        track.Size = UDim2.new(1, 0, 0, 6)
        track.Position = UDim2.new(0, 0, 0, 28)
        track.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        track.BorderSizePixel = 0
        track.Parent = container

        local trackCorner = Instance.new("UICorner")
        trackCorner.CornerRadius = UDim.new(1, 0)
        trackCorner.Parent = track

        local pctDefault = (default - min) / (max - min)

        local fill = Instance.new("Frame")
        fill.Size = UDim2.new(pctDefault, 0, 1, 0)
        fill.BackgroundColor3 = Color3.fromRGB(90, 150, 255)
        fill.BorderSizePixel = 0
        fill.Parent = track

        local fillCorner = Instance.new("UICorner")
        fillCorner.CornerRadius = UDim.new(1, 0)
        fillCorner.Parent = fill

        local knob = Instance.new("Frame")
        knob.Size = UDim2.new(0, 12, 0, 12)
        knob.AnchorPoint = Vector2.new(0.5, 0.5)
        knob.Position = UDim2.new(pctDefault, 0, 0.5, 0)
        knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        knob.BorderSizePixel = 0
        knob.ZIndex = 2
        knob.Parent = track

        local knobCorner = Instance.new("UICorner")
        knobCorner.CornerRadius = UDim.new(1, 0)
        knobCorner.Parent = knob

        local knobBtn = Instance.new("TextButton")
        knobBtn.Size = UDim2.new(0, 20, 0, 20)
        knobBtn.AnchorPoint = Vector2.new(0.5, 0.5)
        knobBtn.Position = UDim2.new(0.5, 0, 0.5, 0)
        knobBtn.BackgroundTransparency = 1
        knobBtn.Text = ""
        knobBtn.ZIndex = 3
        knobBtn.Parent = knob

        local dragging = false

        local function setFromPercent(pct)
            pct = math.clamp(pct, 0, 1)
            fill.Size = UDim2.new(pct, 0, 1, 0)
            knob.Position = UDim2.new(pct, 0, 0.5, 0)
            local value = math.floor(min + pct * (max - min) + 0.5)
            label.Text = labelText .. ": " .. tostring(value)
            callback(value)
        end

        knobBtn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
            end
        end)

        track.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                local pct = (input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X
                setFromPercent(pct)
                dragging = true
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local pct = (input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X
                setFromPercent(pct)
            end
        end)

        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)

        local function setValue(value)
            setFromPercent((value - min) / (max - min))
        end

        return {Frame = container, SetValue = setValue}
    end

    -- Toggle button widget
    local function createToggle(parent, layoutOrder, labelText, default, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 32)
        btn.BackgroundColor3 = default and Color3.fromRGB(60, 150, 90) or Color3.fromRGB(45, 45, 45)
        btn.Text = labelText .. (default and ": ON" or ": OFF")
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 13
        btn.LayoutOrder = layoutOrder
        btn.Parent = parent

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = btn

        local state = default

        local function setValue(newState)
            state = newState
            btn.BackgroundColor3 = state and Color3.fromRGB(60, 150, 90) or Color3.fromRGB(45, 45, 45)
            btn.Text = labelText .. (state and ": ON" or ": OFF")
            callback(state)
        end

        btn.MouseButton1Click:Connect(function()
            setValue(not state)
        end)

        return {Frame = btn, SetValue = setValue}
    end

    -- Handles shared between the Misc widgets and the Config manager
    local walkSpeedHandle, jumpPowerHandle, noclipHandle, clickTpHandle
    local confirmingHop = false
    local hopToken = 0

    local function populateMisc(page)
        for _, child in ipairs(page:GetChildren()) do
            if child:IsA("TextLabel") then
                child:Destroy()
            end
        end

        walkSpeedHandle = createSlider(page, 1, "WalkSpeed", 16, 300, currentWalkSpeed, function(value)
            currentWalkSpeed = value
            applyMovementStats()
        end)

        jumpPowerHandle = createSlider(page, 2, "JumpPower", 50, 300, currentJumpPower, function(value)
            currentJumpPower = value
            applyMovementStats()
        end)

        noclipHandle = createToggle(page, 3, "Noclip", false, function(state)
            noclipEnabled = state
        end)

        clickTpHandle = createToggle(page, 4, "Click TP", false, function(state)
            clickTpEnabled = state
        end)

        -- === Players sub-section: teleport to / spectate other players ===
        local PlayersSection = Instance.new("Frame")
        PlayersSection.Name = "PlayersSection"
        PlayersSection.Size = UDim2.new(1, 0, 0, 0)
        PlayersSection.AutomaticSize = Enum.AutomaticSize.Y
        PlayersSection.BackgroundTransparency = 1
        PlayersSection.LayoutOrder = 5
        PlayersSection.Parent = page

        local PlayersSectionLayout = Instance.new("UIListLayout")
        PlayersSectionLayout.Padding = UDim.new(0, 6)
        PlayersSectionLayout.SortOrder = Enum.SortOrder.LayoutOrder
        PlayersSectionLayout.Parent = PlayersSection

        local PlayersLabel = Instance.new("TextLabel")
        PlayersLabel.Size = UDim2.new(1, 0, 0, 18)
        PlayersLabel.BackgroundTransparency = 1
        PlayersLabel.Text = "Players"
        PlayersLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
        PlayersLabel.Font = Enum.Font.GothamBold
        PlayersLabel.TextSize = 13
        PlayersLabel.TextXAlignment = Enum.TextXAlignment.Left
        PlayersLabel.LayoutOrder = 1
        PlayersLabel.Parent = PlayersSection

        local PlayersList = Instance.new("Frame")
        PlayersList.Name = "PlayersList"
        PlayersList.Size = UDim2.new(1, 0, 0, 0)
        PlayersList.AutomaticSize = Enum.AutomaticSize.Y
        PlayersList.BackgroundTransparency = 1
        PlayersList.LayoutOrder = 2
        PlayersList.Parent = PlayersSection

        local PlayersListLayout = Instance.new("UIListLayout")
        PlayersListLayout.Padding = UDim.new(0, 6)
        PlayersListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        PlayersListLayout.Parent = PlayersList

        local NoPlayersLabel = Instance.new("TextLabel")
        NoPlayersLabel.Size = UDim2.new(1, 0, 0, 18)
        NoPlayersLabel.BackgroundTransparency = 1
        NoPlayersLabel.Text = "No other players in this server"
        NoPlayersLabel.TextColor3 = Color3.fromRGB(140, 140, 140)
        NoPlayersLabel.Font = Enum.Font.Gotham
        NoPlayersLabel.TextSize = 12
        NoPlayersLabel.TextXAlignment = Enum.TextXAlignment.Left
        NoPlayersLabel.LayoutOrder = -1
        NoPlayersLabel.Parent = PlayersList

        local spectating = nil
        local playerRows = {}

        local function updateEmptyState()
            NoPlayersLabel.Visible = (next(playerRows) == nil)
        end

        local function stopSpectate()
            local camera = workspace.CurrentCamera
            if camera then
                local _, ownHumanoid = getCharacterParts()
                camera.CameraType = Enum.CameraType.Custom
                camera.CameraSubject = ownHumanoid
            end
            if spectating and playerRows[spectating] then
                playerRows[spectating].spectateBtn.Text = "Spectate"
                playerRows[spectating].spectateBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            end
            spectating = nil
        end

        local function startSpectate(targetPlayer)
            local targetCharacter = targetPlayer.Character
            local targetHumanoid = targetCharacter and targetCharacter:FindFirstChildOfClass("Humanoid")
            if not targetHumanoid then return end

            stopSpectate()

            local camera = workspace.CurrentCamera
            camera.CameraType = Enum.CameraType.Custom
            camera.CameraSubject = targetHumanoid
            spectating = targetPlayer

            if playerRows[targetPlayer] then
                playerRows[targetPlayer].spectateBtn.Text = "Stop"
                playerRows[targetPlayer].spectateBtn.BackgroundColor3 = Color3.fromRGB(220, 150, 60)
            end
        end

        local function addPlayerRow(targetPlayer)
            local row = Instance.new("Frame")
            row.Size = UDim2.new(1, 0, 0, 30)
            row.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            row.Parent = PlayersList

            local rowCorner = Instance.new("UICorner")
            rowCorner.CornerRadius = UDim.new(0, 6)
            rowCorner.Parent = row

            local nameLabel = Instance.new("TextLabel")
            nameLabel.Size = UDim2.new(1, -122, 1, 0)
            nameLabel.Position = UDim2.new(0, 8, 0, 0)
            nameLabel.BackgroundTransparency = 1
            nameLabel.Text = targetPlayer.DisplayName
            nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            nameLabel.Font = Enum.Font.Gotham
            nameLabel.TextSize = 12
            nameLabel.TextXAlignment = Enum.TextXAlignment.Left
            nameLabel.TextTruncate = Enum.TextTruncate.AtEnd
            nameLabel.Parent = row

            local tpBtn = Instance.new("TextButton")
            tpBtn.Size = UDim2.new(0, 54, 0, 22)
            tpBtn.Position = UDim2.new(1, -116, 0.5, -11)
            tpBtn.BackgroundColor3 = Color3.fromRGB(60, 150, 90)
            tpBtn.Text = "TP"
            tpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            tpBtn.Font = Enum.Font.GothamBold
            tpBtn.TextSize = 12
            tpBtn.Parent = row

            local tpCorner = Instance.new("UICorner")
            tpCorner.CornerRadius = UDim.new(0, 6)
            tpCorner.Parent = tpBtn

            local spectateBtn = Instance.new("TextButton")
            spectateBtn.Size = UDim2.new(0, 58, 0, 22)
            spectateBtn.Position = UDim2.new(1, -58, 0.5, -11)
            spectateBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            spectateBtn.Text = "Spectate"
            spectateBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            spectateBtn.Font = Enum.Font.GothamBold
            spectateBtn.TextSize = 11
            spectateBtn.Parent = row

            local spectateCorner = Instance.new("UICorner")
            spectateCorner.CornerRadius = UDim.new(0, 6)
            spectateCorner.Parent = spectateBtn

            playerRows[targetPlayer] = {row = row, spectateBtn = spectateBtn}
            updateEmptyState()

            tpBtn.MouseButton1Click:Connect(function()
                local _, _, root = getCharacterParts()
                local targetRoot = targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                if root and targetRoot then
                    root.CFrame = targetRoot.CFrame + Vector3.new(0, 3, 0)
                end
            end)

            spectateBtn.MouseButton1Click:Connect(function()
                if spectating == targetPlayer then
                    stopSpectate()
                else
                    startSpectate(targetPlayer)
                end
            end)
        end

        local function removePlayerRow(targetPlayer)
            local entry = playerRows[targetPlayer]
            if entry then
                entry.row:Destroy()
                playerRows[targetPlayer] = nil
            end
            if spectating == targetPlayer then
                stopSpectate()
            end
            updateEmptyState()
        end

        for _, otherPlayer in ipairs(Players:GetPlayers()) do
            if otherPlayer ~= player then
                addPlayerRow(otherPlayer)
            end
        end

        updateEmptyState()

        Players.PlayerAdded:Connect(function(otherPlayer)
            if otherPlayer ~= player then
                addPlayerRow(otherPlayer)
            end
        end)

        Players.PlayerRemoving:Connect(function(otherPlayer)
            removePlayerRow(otherPlayer)
        end)

        local ServerHopBtn = Instance.new("TextButton")
        ServerHopBtn.Size = UDim2.new(1, 0, 0, 32)
        ServerHopBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        ServerHopBtn.Text = "Server Hop"
        ServerHopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        ServerHopBtn.Font = Enum.Font.Gotham
        ServerHopBtn.TextSize = 13
        ServerHopBtn.LayoutOrder = 8
        ServerHopBtn.Parent = page

        local ServerHopCorner = Instance.new("UICorner")
        ServerHopCorner.CornerRadius = UDim.new(0, 6)
        ServerHopCorner.Parent = ServerHopBtn

        ServerHopBtn.MouseButton1Click:Connect(function()
            if confirmingHop then
                confirmingHop = false
                ServerHopBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                ServerHopBtn.Text = "Server Hop"
                pcall(function()
                    TeleportService:Teleport(game.PlaceId, player)
                end)
            else
                confirmingHop = true
                hopToken = hopToken + 1
                local myToken = hopToken
                ServerHopBtn.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
                ServerHopBtn.Text = "Click again to confirm"
                task.delay(2, function()
                    if confirmingHop and hopToken == myToken then
                        confirmingHop = false
                        ServerHopBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                        ServerHopBtn.Text = "Server Hop"
                    end
                end)
            end
        end)

        local waypointRow = Instance.new("Frame")
        waypointRow.Size = UDim2.new(1, 0, 0, 32)
        waypointRow.BackgroundTransparency = 1
        waypointRow.LayoutOrder = 6
        waypointRow.Parent = page

        local waypointNameInput = Instance.new("TextBox")
        waypointNameInput.Size = UDim2.new(1, -84, 1, 0)
        waypointNameInput.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        waypointNameInput.PlaceholderText = "Teleport waypoint name"
        waypointNameInput.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
        waypointNameInput.Text = ""
        waypointNameInput.TextColor3 = Color3.fromRGB(255, 255, 255)
        waypointNameInput.ClearTextOnFocus = false
        waypointNameInput.Font = Enum.Font.Gotham
        waypointNameInput.TextSize = 13
        waypointNameInput.Parent = waypointRow

        local waypointNameCorner = Instance.new("UICorner")
        waypointNameCorner.CornerRadius = UDim.new(0, 6)
        waypointNameCorner.Parent = waypointNameInput

        local addWaypointBtn = Instance.new("TextButton")
        addWaypointBtn.Size = UDim2.new(0, 78, 1, 0)
        addWaypointBtn.Position = UDim2.new(1, -78, 0, 0)
        addWaypointBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        addWaypointBtn.Text = "Add"
        addWaypointBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        addWaypointBtn.Font = Enum.Font.Gotham
        addWaypointBtn.TextSize = 13
        addWaypointBtn.Parent = waypointRow

        local addWaypointCorner = Instance.new("UICorner")
        addWaypointCorner.CornerRadius = UDim.new(0, 6)
        addWaypointCorner.Parent = addWaypointBtn

        local waypointList = Instance.new("Frame")
        waypointList.Name = "WaypointList"
        waypointList.Size = UDim2.new(1, 0, 0, 0)
        waypointList.AutomaticSize = Enum.AutomaticSize.Y
        waypointList.BackgroundTransparency = 1
        waypointList.LayoutOrder = 7
        waypointList.Parent = page

        local waypointListLayout = Instance.new("UIListLayout")
        waypointListLayout.Padding = UDim.new(0, 6)
        waypointListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        waypointListLayout.Parent = waypointList

        local waypointOrder = 0

        local function addWaypointRow(waypointData)
            waypointOrder = waypointOrder + 1

            local row = Instance.new("Frame")
            row.Size = UDim2.new(1, 0, 0, 30)
            row.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            row.LayoutOrder = waypointOrder
            row.Parent = waypointList

            local rowCorner = Instance.new("UICorner")
            rowCorner.CornerRadius = UDim.new(0, 6)
            rowCorner.Parent = row

            local nameLabel = Instance.new("TextLabel")
            nameLabel.Size = UDim2.new(1, -84, 1, 0)
            nameLabel.Position = UDim2.new(0, 8, 0, 0)
            nameLabel.BackgroundTransparency = 1
            nameLabel.Text = waypointData.name
            nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            nameLabel.Font = Enum.Font.Gotham
            nameLabel.TextSize = 12
            nameLabel.TextXAlignment = Enum.TextXAlignment.Left
            nameLabel.TextTruncate = Enum.TextTruncate.AtEnd
            nameLabel.Parent = row

            local tpBtn = Instance.new("TextButton")
            tpBtn.Size = UDim2.new(0, 36, 0, 22)
            tpBtn.Position = UDim2.new(1, -78, 0.5, -11)
            tpBtn.BackgroundColor3 = Color3.fromRGB(60, 150, 90)
            tpBtn.Text = "TP"
            tpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            tpBtn.Font = Enum.Font.GothamBold
            tpBtn.TextSize = 12
            tpBtn.Parent = row

            local tpCorner = Instance.new("UICorner")
            tpCorner.CornerRadius = UDim.new(0, 6)
            tpCorner.Parent = tpBtn

            local delBtn = Instance.new("TextButton")
            delBtn.Size = UDim2.new(0, 36, 0, 22)
            delBtn.Position = UDim2.new(1, -38, 0.5, -11)
            delBtn.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
            delBtn.Text = "Del"
            delBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            delBtn.Font = Enum.Font.GothamBold
            delBtn.TextSize = 12
            delBtn.Parent = row

            local delCorner = Instance.new("UICorner")
            delCorner.CornerRadius = UDim.new(0, 6)
            delCorner.Parent = delBtn

            tpBtn.MouseButton1Click:Connect(function()
                local _, _, root = getCharacterParts()
                if root then
                    root.CFrame = CFrame.new(waypointData.position)
                end
            end)

            delBtn.MouseButton1Click:Connect(function()
                for idx, wp in ipairs(waypoints) do
                    if wp == waypointData then
                        table.remove(waypoints, idx)
                        break
                    end
                end
                row:Destroy()
            end)
        end

        addWaypointBtn.MouseButton1Click:Connect(function()
            local _, _, root = getCharacterParts()
            if not root then return end
            local name = waypointNameInput.Text
            if name == "" then
                name = "Waypoint " .. tostring(#waypoints + 1)
            end
            local waypointData = {name = name, position = root.Position}
            table.insert(waypoints, waypointData)
            addWaypointRow(waypointData)
            waypointNameInput.Text = ""
        end)
    end

    -- === Main tab (game-specific script library placeholder) ===
    local function populateMain(page)
        for _, child in ipairs(page:GetChildren()) do
            if child:IsA("TextLabel") then
                child:Destroy()
            end
        end

        local ErrorLabel = Instance.new("TextLabel")
        ErrorLabel.Size = UDim2.new(1, 0, 0, 18)
        ErrorLabel.BackgroundTransparency = 1
        ErrorLabel.Text = "Game library error"
        ErrorLabel.TextColor3 = Color3.fromRGB(220, 60, 60)
        ErrorLabel.Font = Enum.Font.GothamBold
        ErrorLabel.TextSize = 14
        ErrorLabel.TextXAlignment = Enum.TextXAlignment.Left
        ErrorLabel.LayoutOrder = 1
        ErrorLabel.Parent = page

        local ErrorDetail = Instance.new("TextLabel")
        ErrorDetail.Size = UDim2.new(1, 0, 0, 48)
        ErrorDetail.BackgroundTransparency = 1
        ErrorDetail.Text = "No script library was found for \"" .. gameName .. "\". Your key may not be valid for this game, or support hasn't been added yet."
        ErrorDetail.TextWrapped = true
        ErrorDetail.TextColor3 = Color3.fromRGB(160, 160, 160)
        ErrorDetail.Font = Enum.Font.Gotham
        ErrorDetail.TextSize = 12
        ErrorDetail.TextXAlignment = Enum.TextXAlignment.Left
        ErrorDetail.TextYAlignment = Enum.TextYAlignment.Top
        ErrorDetail.LayoutOrder = 2
        ErrorDetail.Parent = page

        local ChangeKeyBtn = Instance.new("TextButton")
        ChangeKeyBtn.Size = UDim2.new(1, 0, 0, 32)
        ChangeKeyBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        ChangeKeyBtn.Text = "Try a different key"
        ChangeKeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        ChangeKeyBtn.Font = Enum.Font.Gotham
        ChangeKeyBtn.TextSize = 13
        ChangeKeyBtn.LayoutOrder = 3
        ChangeKeyBtn.Parent = page

        local ChangeKeyCorner = Instance.new("UICorner")
        ChangeKeyCorner.CornerRadius = UDim.new(0, 6)
        ChangeKeyCorner.Parent = ChangeKeyBtn

        ChangeKeyBtn.MouseEnter:Connect(function()
            ChangeKeyBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        end)
        ChangeKeyBtn.MouseLeave:Connect(function()
            ChangeKeyBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        end)

        ChangeKeyBtn.MouseButton1Click:Connect(function()
            deleteSavedKey()
            HubGui.Enabled = false
            ScreenGui.Enabled = true
            KeyInput.Text = ""
            StatusLabel.Text = "Enter a new key"
            StatusLabel.TextColor3 = Color3.fromRGB(160, 160, 160)
        end)
    end

    -- === Config manager (save/load/delete widget settings as files) ===
    local function populateConfig(page)
        for _, child in ipairs(page:GetChildren()) do
            if child:IsA("TextLabel") then
                child:Destroy()
            end
        end

        local CONFIG_FOLDER = "FuturaHub/configs"

        local function ensureFolder()
            if isfolder and makefolder and not isfolder(CONFIG_FOLDER) then
                makefolder(CONFIG_FOLDER)
            end
        end
        ensureFolder()

        local function gatherSettings()
            return {
                WalkSpeed = currentWalkSpeed,
                JumpPower = currentJumpPower,
                Noclip = noclipEnabled,
                ClickTP = clickTpEnabled,
            }
        end

        local function applySettings(data)
            if data.WalkSpeed and walkSpeedHandle then walkSpeedHandle.SetValue(data.WalkSpeed) end
            if data.JumpPower and jumpPowerHandle then jumpPowerHandle.SetValue(data.JumpPower) end
            if data.Noclip ~= nil and noclipHandle then noclipHandle.SetValue(data.Noclip) end
            if data.ClickTP ~= nil and clickTpHandle then clickTpHandle.SetValue(data.ClickTP) end
        end

        local configRow = Instance.new("Frame")
        configRow.Size = UDim2.new(1, 0, 0, 32)
        configRow.BackgroundTransparency = 1
        configRow.LayoutOrder = 1
        configRow.Parent = page

        local configNameInput = Instance.new("TextBox")
        configNameInput.Size = UDim2.new(1, -84, 1, 0)
        configNameInput.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        configNameInput.PlaceholderText = "Config name"
        configNameInput.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
        configNameInput.Text = ""
        configNameInput.TextColor3 = Color3.fromRGB(255, 255, 255)
        configNameInput.ClearTextOnFocus = false
        configNameInput.Font = Enum.Font.Gotham
        configNameInput.TextSize = 13
        configNameInput.Parent = configRow

        local configNameCorner = Instance.new("UICorner")
        configNameCorner.CornerRadius = UDim.new(0, 6)
        configNameCorner.Parent = configNameInput

        local saveConfigBtn = Instance.new("TextButton")
        saveConfigBtn.Size = UDim2.new(0, 78, 1, 0)
        saveConfigBtn.Position = UDim2.new(1, -78, 0, 0)
        saveConfigBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        saveConfigBtn.Text = "Save"
        saveConfigBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        saveConfigBtn.Font = Enum.Font.Gotham
        saveConfigBtn.TextSize = 13
        saveConfigBtn.Parent = configRow

        local saveConfigCorner = Instance.new("UICorner")
        saveConfigCorner.CornerRadius = UDim.new(0, 6)
        saveConfigCorner.Parent = saveConfigBtn

        local configStatus = Instance.new("TextLabel")
        configStatus.Size = UDim2.new(1, 0, 0, 16)
        configStatus.BackgroundTransparency = 1
        configStatus.Text = ""
        configStatus.TextColor3 = Color3.fromRGB(160, 160, 160)
        configStatus.Font = Enum.Font.Gotham
        configStatus.TextSize = 11
        configStatus.TextXAlignment = Enum.TextXAlignment.Left
        configStatus.LayoutOrder = 2
        configStatus.Parent = page

        local configList = Instance.new("Frame")
        configList.Name = "ConfigList"
        configList.Size = UDim2.new(1, 0, 0, 0)
        configList.AutomaticSize = Enum.AutomaticSize.Y
        configList.BackgroundTransparency = 1
        configList.LayoutOrder = 3
        configList.Parent = page

        local configListLayout = Instance.new("UIListLayout")
        configListLayout.Padding = UDim.new(0, 6)
        configListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        configListLayout.Parent = configList

        local configOrder = 0

        local function addConfigRow(configName)
            configOrder = configOrder + 1

            local row = Instance.new("Frame")
            row.Size = UDim2.new(1, 0, 0, 30)
            row.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            row.LayoutOrder = configOrder
            row.Parent = configList

            local rowCorner = Instance.new("UICorner")
            rowCorner.CornerRadius = UDim.new(0, 6)
            rowCorner.Parent = row

            local nameLabel = Instance.new("TextLabel")
            nameLabel.Size = UDim2.new(1, -84, 1, 0)
            nameLabel.Position = UDim2.new(0, 8, 0, 0)
            nameLabel.BackgroundTransparency = 1
            nameLabel.Text = configName
            nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            nameLabel.Font = Enum.Font.Gotham
            nameLabel.TextSize = 12
            nameLabel.TextXAlignment = Enum.TextXAlignment.Left
            nameLabel.TextTruncate = Enum.TextTruncate.AtEnd
            nameLabel.Parent = row

            local loadBtn = Instance.new("TextButton")
            loadBtn.Size = UDim2.new(0, 36, 0, 22)
            loadBtn.Position = UDim2.new(1, -78, 0.5, -11)
            loadBtn.BackgroundColor3 = Color3.fromRGB(60, 150, 90)
            loadBtn.Text = "Load"
            loadBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            loadBtn.Font = Enum.Font.GothamBold
            loadBtn.TextSize = 11
            loadBtn.Parent = row

            local loadCorner = Instance.new("UICorner")
            loadCorner.CornerRadius = UDim.new(0, 6)
            loadCorner.Parent = loadBtn

            local delBtn = Instance.new("TextButton")
            delBtn.Size = UDim2.new(0, 36, 0, 22)
            delBtn.Position = UDim2.new(1, -38, 0.5, -11)
            delBtn.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
            delBtn.Text = "Del"
            delBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            delBtn.Font = Enum.Font.GothamBold
            delBtn.TextSize = 12
            delBtn.Parent = row

            local delCorner = Instance.new("UICorner")
            delCorner.CornerRadius = UDim.new(0, 6)
            delCorner.Parent = delBtn

            loadBtn.MouseButton1Click:Connect(function()
                local path = CONFIG_FOLDER .. "/" .. configName .. ".json"
                local ok, result = tryCall(readfile, path)
                if ok and result then
                    local okDecode, data = pcall(function()
                        return HttpService:JSONDecode(result)
                    end)
                    if okDecode then
                        applySettings(data)
                        configStatus.Text = "Loaded \"" .. configName .. "\""
                        configStatus.TextColor3 = Color3.fromRGB(60, 200, 100)
                    else
                        configStatus.Text = "Failed to parse \"" .. configName .. "\""
                        configStatus.TextColor3 = Color3.fromRGB(220, 60, 60)
                    end
                else
                    configStatus.Text = "Failed to read \"" .. configName .. "\""
                    configStatus.TextColor3 = Color3.fromRGB(220, 60, 60)
                end
            end)

            delBtn.MouseButton1Click:Connect(function()
                local path = CONFIG_FOLDER .. "/" .. configName .. ".json"
                tryCall(delfile, path)
                row:Destroy()
            end)
        end

        local function refreshConfigList()
            for _, child in ipairs(configList:GetChildren()) do
                if child:IsA("Frame") then
                    child:Destroy()
                end
            end
            if listfiles then
                local ok, files = pcall(listfiles, CONFIG_FOLDER)
                if ok then
                    for _, filePath in ipairs(files) do
                        local fileName = filePath:match("([^/\\]+)%.json$")
                        if fileName then
                            addConfigRow(fileName)
                        end
                    end
                end
            end
        end

        saveConfigBtn.MouseButton1Click:Connect(function()
            local name = configNameInput.Text
            if name == "" then
                configStatus.Text = "Enter a config name first"
                configStatus.TextColor3 = Color3.fromRGB(220, 60, 60)
                return
            end
            ensureFolder()
            local path = CONFIG_FOLDER .. "/" .. name .. ".json"
            local okEncode, encoded = pcall(function()
                return HttpService:JSONEncode(gatherSettings())
            end)
            if okEncode and tryCall(writefile, path, encoded) then
                configStatus.Text = "Saved \"" .. name .. "\""
                configStatus.TextColor3 = Color3.fromRGB(60, 200, 100)
                configNameInput.Text = ""
                refreshConfigList()
            else
                configStatus.Text = "Failed to save (executor may not support file I/O)"
                configStatus.TextColor3 = Color3.fromRGB(220, 60, 60)
            end
        end)

        refreshConfigList()
    end

    local categories = {"gameName", "Misc", "Config"}
    local pageFrames = {}
    local sidebarButtons = {}

    local function buildPage(name)
        local page = Instance.new("ScrollingFrame")
        page.Name = name .. "Page"
        page.Size = UDim2.new(1, 0, 1, 0)
        page.BackgroundTransparency = 1
        page.BorderSizePixel = 0
        page.ScrollBarThickness = 4
        page.CanvasSize = UDim2.new(0, 0, 0, 0)
        page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        page.Visible = false
        page.Parent = Pages

        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, 8)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Parent = page

        local placeholder = Instance.new("TextLabel")
        placeholder.Size = UDim2.new(1, 0, 0, 24)
        placeholder.BackgroundTransparency = 1
        placeholder.Text = name .. " — no features yet"
        placeholder.TextColor3 = Color3.fromRGB(140, 140, 140)
        placeholder.Font = Enum.Font.Gotham
        placeholder.TextSize = 13
        placeholder.TextXAlignment = Enum.TextXAlignment.Left
        placeholder.Parent = page

        return page
    end

    local function selectCategory(name)
        for catName, frame in pairs(pageFrames) do
            frame.Visible = (catName == name)
        end
        for catName, btn in pairs(sidebarButtons) do
            btn.BackgroundColor3 = (catName == name) and Color3.fromRGB(55, 55, 55) or Color3.fromRGB(40, 40, 40)
        end
    end

    for i, cat in ipairs(categories) do
        local displayName = (cat == "gameName") and gameName or cat
        local internalName = (cat == "gameName") and "Main" or cat

        local page = buildPage(displayName)
        pageFrames[internalName] = page

        if internalName == "Main" then
            populateMain(page)
        elseif internalName == "Misc" then
            populateMisc(page)
        elseif internalName == "Config" then
            populateConfig(page)
        end

        local btn = Instance.new("TextButton")
        btn.Name = internalName .. "Btn"
        btn.Size = UDim2.new(1, 0, 0, 32)
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        btn.Text = displayName
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 13
        btn.TextTruncate = Enum.TextTruncate.AtEnd
        btn.LayoutOrder = i
        btn.Parent = Sidebar

        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = btn

        sidebarButtons[internalName] = btn

        btn.MouseButton1Click:Connect(function()
            selectCategory(internalName)
        end)
    end

    selectCategory("Misc")

    -- Minimize (collapses body, keeps title bar)
    local hubExpandedSize = Hub.Size
    local hubMinimizedSize = UDim2.new(0, hubExpandedSize.X.Offset, 0, 36)
    local hubMinimized = false
    HubMinimizeBtn.MouseButton1Click:Connect(function()
        hubMinimized = not hubMinimized
        Body.Visible = not hubMinimized
        Hub.Size = hubMinimized and hubMinimizedSize or hubExpandedSize
    end)

    -- === Resize grip (bottom-right corner) ===
    local ResizeGrip = Instance.new("TextButton")
    ResizeGrip.Name = "ResizeGrip"
    ResizeGrip.Size = UDim2.new(0, 18, 0, 18)
    ResizeGrip.Position = UDim2.new(1, -18, 1, -18)
    ResizeGrip.BackgroundTransparency = 1
    ResizeGrip.Text = ""
    ResizeGrip.AutoButtonColor = false
    ResizeGrip.ZIndex = 5
    ResizeGrip.Parent = Hub

    local GripIcon = Instance.new("Frame")
    GripIcon.Size = UDim2.new(0, 10, 0, 10)
    GripIcon.Position = UDim2.new(1, -13, 1, -13)
    GripIcon.BackgroundTransparency = 1
    GripIcon.ZIndex = 5
    GripIcon.Parent = ResizeGrip

    for i = 1, 3 do
        local line = Instance.new("Frame")
        line.BackgroundColor3 = Color3.fromRGB(140, 140, 140)
        line.BorderSizePixel = 0
        line.Size = UDim2.new(0, (i * 3), 0, 2)
        line.Position = UDim2.new(1, -(i * 3), 1, -2)
        line.AnchorPoint = Vector2.new(0, 0)
        line.ZIndex = 5
        line.Rotation = 0
        line.Parent = GripIcon
    end

    local resizing = false
    local resizeStart, resizeStartSize

    ResizeGrip.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            resizing = true
            resizeStart = input.Position
            resizeStartSize = Hub.Size
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    resizing = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - resizeStart
            local newWidth = math.max(minSize.X, resizeStartSize.X.Offset + delta.X)
            local newHeight = math.max(minSize.Y, resizeStartSize.Y.Offset + delta.Y)
            Hub.Size = UDim2.new(0, newWidth, 0, newHeight)
            hubExpandedSize = Hub.Size
        end
    end)
end

-- === Auto-login with a saved key ===
local savedKey = loadSavedKey()
if savedKey == VALID_KEY then
    openHub()
else
    ScreenGui.Enabled = true
end
