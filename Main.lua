--[[
    GABIEL'S PRIV
    Slap Battles | Interface
    Revisao: 1.1

    Esta versao corrige a interface:
    - Remove completamente a imagem de fundo e o IMAGE_ID.
    - Mantem o tema azul neon/preto.
    - Usa lista rolavel para caber em telas pequenas.
    - Permite arrastar o menu pelo cabecalho.
    - Fecha e limpa a interface anterior antes de abrir.
    - Os botoes ON/OFF controlam estados locais da interface.

    IMPORTANTE:
    Os botoes ainda NAO executam Auto Farm, Auto Badge, Auto Quest,
    Auto Unlock, Auto TP ou Auto Combat. Cada funcao precisa de uma
    implementacao propria e compativel com o jogo. Esta base nao finge
    que essas automacoes estao implementadas.
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
if not player then
    warn("Gabiel's Priv: jogador local nao encontrado.")
    return
end

-- Escolhe um local apropriado para a interface.
local function getGuiParent()
    if typeof(gethui) == "function" then
        local ok, hui = pcall(gethui)
        if ok and hui then
            return hui
        end
    end

    local playerGui = player:FindFirstChildOfClass("PlayerGui")
    if playerGui then
        return playerGui
    end

    return game:GetService("CoreGui")
end

local guiParent = getGuiParent()

-- Remove uma versao anterior.
local oldGui = guiParent:FindFirstChild("GabielsPriv")
if oldGui then
    oldGui:Destroy()
end

local COLORS = {
    background = Color3.fromRGB(5, 10, 25),
    panel = Color3.fromRGB(8, 22, 48),
    row = Color3.fromRGB(10, 29, 61),
    blue = Color3.fromRGB(0, 145, 255),
    blueLight = Color3.fromRGB(80, 185, 255),
    text = Color3.fromRGB(240, 247, 255),
    muted = Color3.fromRGB(160, 190, 225),
    off = Color3.fromRGB(55, 66, 86),
    green = Color3.fromRGB(20, 165, 105),
}

local gui = Instance.new("ScreenGui")
gui.Name = "GabielsPriv"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.DisplayOrder = 999
gui.Parent = guiParent

local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.new(0, 390, 0, 430)
main.Position = UDim2.new(0.5, -195, 0.5, -215)
main.BackgroundColor3 = COLORS.background
main.BorderSizePixel = 0
main.ClipsDescendants = true
main.Parent = gui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 14)
mainCorner.Parent = main

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = COLORS.blue
mainStroke.Thickness = 2
mainStroke.Transparency = 0.08
mainStroke.Parent = main

local sizeConstraint = Instance.new("UISizeConstraint")
sizeConstraint.MinSize = Vector2.new(290, 330)
sizeConstraint.MaxSize = Vector2.new(500, 560)
sizeConstraint.Parent = main

-- Fundo simples, sem imagem.
local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 88)
header.BackgroundColor3 = COLORS.panel
header.BorderSizePixel = 0
header.Parent = main

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 14)
headerCorner.Parent = header

local headerCover = Instance.new("Frame")
headerCover.Size = UDim2.new(1, 0, 0, 16)
headerCover.Position = UDim2.new(0, 0, 1, -16)
headerCover.BackgroundColor3 = COLORS.panel
headerCover.BorderSizePixel = 0
headerCover.Parent = header

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, -72, 0, 38)
title.Position = UDim2.new(0, 18, 0, 10)
title.BackgroundTransparency = 1
title.Text = "Gabiel's Priv"
title.TextColor3 = COLORS.blueLight
title.TextSize = 25
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, -36, 0, 22)
subtitle.Position = UDim2.new(0, 19, 0, 49)
subtitle.BackgroundTransparency = 1
subtitle.Text = "Slap Battles  •  Interface"
subtitle.TextColor3 = COLORS.muted
subtitle.TextSize = 13
subtitle.Font = Enum.Font.Gotham
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Parent = header

local close = Instance.new("TextButton")
close.Name = "Close"
close.Size = UDim2.new(0, 34, 0, 34)
close.Position = UDim2.new(1, -46, 0, 12)
close.BackgroundColor3 = Color3.fromRGB(150, 35, 55)
close.BorderSizePixel = 0
close.Text = "X"
close.TextColor3 = COLORS.text
close.TextSize = 16
close.Font = Enum.Font.GothamBold
close.AutoButtonColor = true
close.Parent = header

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 9)
closeCorner.Parent = close

close.Activated:Connect(function()
    gui:Destroy()
end)

local status = Instance.new("TextLabel")
status.Name = "Status"
status.Size = UDim2.new(1, -32, 0, 26)
status.Position = UDim2.new(0, 16, 0, 94)
status.BackgroundTransparency = 1
status.Text = "Interface carregada • automacoes nao configuradas"
status.TextColor3 = COLORS.muted
status.TextSize = 11
status.Font = Enum.Font.Gotham
status.TextXAlignment = Enum.TextXAlignment.Left
status.TextTruncate = Enum.TextTruncate.AtEnd
status.Parent = main

local list = Instance.new("ScrollingFrame")
list.Name = "Options"
list.Size = UDim2.new(1, -28, 1, -137)
list.Position = UDim2.new(0, 14, 0, 125)
list.BackgroundTransparency = 1
list.BorderSizePixel = 0
list.ScrollBarThickness = 4
list.ScrollBarImageColor3 = COLORS.blue
list.CanvasSize = UDim2.new(0, 0, 0, 0)
list.AutomaticCanvasSize = Enum.AutomaticSize.Y
list.ScrollingDirection = Enum.ScrollingDirection.Y
list.Parent = main

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 9)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = list

local listPadding = Instance.new("UIPadding")
listPadding.PaddingTop = UDim.new(0, 3)
listPadding.PaddingBottom = UDim.new(0, 8)
listPadding.PaddingLeft = UDim.new(0, 2)
listPadding.PaddingRight = UDim.new(0, 6)
listPadding.Parent = list

local options = {
    "Auto TP Combat",
    "Auto Unlock",
    "Auto Badge",
    "Auto Quest",
    "Auto Farm",
    "Auto Glove",
    "Auto Combat",
}

local states = {}

-- Ponto de integracao para funcoes futuras.
-- Os estados mudam, mas nenhuma acao dentro do jogo e executada aqui.
local function onToggleChanged(optionName, enabled)
    status.Text = optionName .. (enabled and ": ON" or ": OFF")
    status.TextColor3 = enabled and COLORS.blueLight or COLORS.muted
end

for index, optionName in ipairs(options) do
    states[optionName] = false

    local row = Instance.new("Frame")
    row.Name = "Option_" .. tostring(index)
    row.Size = UDim2.new(1, -4, 0, 46)
    row.BackgroundColor3 = COLORS.row
    row.BorderSizePixel = 0
    row.LayoutOrder = index
    row.Parent = list

    local rowCorner = Instance.new("UICorner")
    rowCorner.CornerRadius = UDim.new(0, 9)
    rowCorner.Parent = row

    local rowStroke = Instance.new("UIStroke")
    rowStroke.Color = COLORS.blue
    rowStroke.Thickness = 1
    rowStroke.Transparency = 0.65
    rowStroke.Parent = row

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -105, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = optionName
    label.TextColor3 = COLORS.text
    label.TextSize = 14
    label.Font = Enum.Font.GothamSemibold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextTruncate = Enum.TextTruncate.AtEnd
    label.Parent = row

    local toggle = Instance.new("TextButton")
    toggle.Name = "Toggle"
    toggle.Size = UDim2.new(0, 70, 0, 29)
    toggle.Position = UDim2.new(1, -82, 0.5, -14)
    toggle.BackgroundColor3 = COLORS.off
    toggle.BorderSizePixel = 0
    toggle.Text = "OFF"
    toggle.TextColor3 = COLORS.text
    toggle.TextSize = 12
    toggle.Font = Enum.Font.GothamBold
    toggle.AutoButtonColor = true
    toggle.Parent = row

    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(1, 0)
    toggleCorner.Parent = toggle

    toggle.Activated:Connect(function()
        states[optionName] = not states[optionName]
        local enabled = states[optionName]

        toggle.Text = enabled and "ON" or "OFF"
        toggle.BackgroundColor3 = enabled and COLORS.green or COLORS.off
        rowStroke.Transparency = enabled and 0.15 or 0.65

        onToggleChanged(optionName, enabled)
    end)
end

-- Arrastar somente pelo cabecalho, para nao atrapalhar os botoes.
local dragging = false
local dragInput
local dragStart
local startPosition

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPosition = main.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end
end)

-- Ajusta o tamanho em telas menores.
local function fitToScreen()
    local camera = workspace.CurrentCamera
    if not camera then
        return
    end

    local viewport = camera.ViewportSize
    local width = math.min(390, math.max(290, viewport.X - 24))
    local height = math.min(430, math.max(330, viewport.Y - 48))

    main.Size = UDim2.fromOffset(width, height)
    main.Position = UDim2.new(0.5, -width / 2, 0.5, -height / 2)
end

fitToScreen()

if workspace.CurrentCamera then
    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(fitToScreen)
end

print("Gabiel's Priv: interface carregada.")
