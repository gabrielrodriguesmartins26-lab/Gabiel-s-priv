
--[[
    GABIEL'S PRIV
    Slap Battles | Delta Executor
    Versão 1.0
]]

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local Player = Players.LocalPlayer

-- CONFIGURAÇÃO
local IMAGE_ID = "rbxassetid://COLOQUE_O_ID_DA_SUA_IMAGEM"

local old = CoreGui:FindFirstChild("GabielsPriv")
if old then old:Destroy() end

local Gui = Instance.new("ScreenGui")
Gui.Name = "GabielsPriv"
Gui.ResetOnSpawn = false
Gui.Parent = (gethui and gethui()) or CoreGui

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 650, 0, 440)
Main.Position = UDim2.new(0.5, -325, 0.5, -220)
Main.BackgroundColor3 = Color3.fromRGB(3, 9, 25)
Main.BackgroundTransparency = 0.12
Main.BorderSizePixel = 0
Main.Parent = Gui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 15)
Corner.Parent = Main

local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(0, 110, 255)
Stroke.Thickness = 2
Stroke.Parent = Main

-- FUNDO: IMAGEM INTEIRA, SEM QUADRADO
local Background = Instance.new("ImageLabel")
Background.Size = UDim2.fromScale(1, 1)
Background.BackgroundTransparency = 1
Background.Image = IMAGE_ID
Background.ScaleType = Enum.ScaleType.Crop
Background.ImageTransparency = 0.35
Background.ZIndex = 0
Background.Parent = Main

local BGCorner = Instance.new("UICorner")
BGCorner.CornerRadius = UDim.new(0, 15)
BGCorner.Parent = Background

-- CAMADA ESCURA
local Overlay = Instance.new("Frame")
Overlay.Size = UDim2.fromScale(1, 1)
Overlay.BackgroundColor3 = Color3.fromRGB(0, 5, 20)
Overlay.BackgroundTransparency = 0.35
Overlay.BorderSizePixel = 0
Overlay.ZIndex = 1
Overlay.Parent = Main

local OverlayCorner = Instance.new("UICorner")
OverlayCorner.CornerRadius = UDim.new(0, 15)
OverlayCorner.Parent = Overlay

-- CABEÇALHO
local Header = Instance.new("TextLabel")
Header.Size = UDim2.new(1, -80, 0, 55)
Header.Position = UDim2.new(0, 20, 0, 8)
Header.BackgroundTransparency = 1
Header.Text = "♛  Gabiel's Priv"
Header.TextColor3 = Color3.fromRGB(40, 145, 255)
Header.TextSize = 30
Header.Font = Enum.Font.GothamBold
Header.TextXAlignment = Enum.TextXAlignment.Left
Header.ZIndex = 3
Header.Parent = Main

local Subtitle = Instance.new("TextLabel")
Subtitle.Size = UDim2.new(1, -30, 0, 25)
Subtitle.Position = UDim2.new(0, 20, 0, 58)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "Slap Battles • Delta Executor"
Subtitle.TextColor3 = Color3.fromRGB(170, 205, 255)
Subtitle.TextSize = 15
Subtitle.Font = Enum.Font.Gotham
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.ZIndex = 3
Subtitle.Parent = Main

-- BOTÃO FECHAR
local Close = Instance.new("TextButton")
Close.Size = UDim2.new(0, 38, 0, 38)
Close.Position = UDim2.new(1, -50, 0, 12)
Close.Text = "X"
Close.TextSize = 20
Close.TextColor3 = Color3.new(1, 1, 1)
Close.BackgroundColor3 = Color3.fromRGB(0, 75, 200)
Close.ZIndex = 4
Close.Parent = Main

Close.MouseButton1Click:Connect(function()
    Gui:Destroy()
end)

-- OPÇÕES
local Options = {
    "Auto TP Combat",
    "Auto Unlock",
    "Auto Badge",
    "Auto Quest",
    "Auto Farm",
    "Auto Glove",
    "Auto Combat"
}

local States = {}

for i, name in ipairs(Options) do
    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(1, -40, 0, 40)
    Row.Position = UDim2.new(0, 20, 0, 105 + (i-1)*45)
    Row.BackgroundColor3 = Color3.fromRGB(5, 20, 50)
    Row.BackgroundTransparency = 0.12
    Row.BorderSizePixel = 0
    Row.ZIndex = 3
    Row.Parent = Main

    local RC = Instance.new("UICorner")
    RC.CornerRadius = UDim.new(0, 8)
    RC.Parent = Row

    local RS = Instance.new("UIStroke")
    RS.Color = Color3.fromRGB(0, 90, 220)
    RS.Thickness = 1
    RS.Parent = Row

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.Position = UDim2.new(0, 12, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(235, 245, 255)
    Label.TextSize = 16
    Label.Font = Enum.Font.GothamBold
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.ZIndex = 4
    Label.Parent = Row

    local Toggle = Instance.new("TextButton")
    Toggle.Size = UDim2.new(0, 65, 0, 28)
    Toggle.Position = UDim2.new(1, -78, 0.5, -14)
    Toggle.BackgroundColor3 = Color3.fromRGB(45, 55, 75)
    Toggle.Text = "OFF"
    Toggle.TextColor3 = Color3.new(1, 1, 1)
    Toggle.TextSize = 13
    Toggle.Font = Enum.Font.GothamBold
    Toggle.ZIndex = 4
    Toggle.Parent = Row

    local TC = Instance.new("UICorner")
    TC.CornerRadius = UDim.new(1, 0)
    TC.Parent = Toggle

    States[name] = false

    Toggle.MouseButton1Click:Connect(function()
        States[name] = not States[name]

        Toggle.Text = States[name] and "ON" or "OFF"
        Toggle.BackgroundColor3 = States[name]
            and Color3.fromRGB(0, 110, 255)
            or Color3.fromRGB(45, 55, 75)
    end)
end

-- ARRASTAR MENU
local UserInputService = game:GetService("UserInputService")
local dragging, dragStart, startPos

Main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (
        input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch
    ) then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

print("Gabiel's Priv carregado!")
