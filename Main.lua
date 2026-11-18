--[[
    GABIEL'S PRIV v2.0 - Interface + progress toolkit
    Roblox experience: Slap Battles
    Local owner label: NaboColorido

    This release provides UI, local preferences, glove/badge checklists,
    favorites, and a local diagnostics panel. It does NOT claim to unlock
    badges/gloves, farm slaps, teleport, or attack players automatically.
    Client-side username checks are cosmetic and are NOT secure authorization.
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local OWNER_USERNAME = "NaboColorido"
local IS_OWNER = LocalPlayer ~= nil and string.lower(LocalPlayer.Name) == string.lower(OWNER_USERNAME)

local ParentGui = (gethui and gethui()) or CoreGui
local old = ParentGui:FindFirstChild("GabielsPriv")
if old then old:Destroy() end

local C = {
    bg = Color3.fromRGB(7, 11, 21), panel = Color3.fromRGB(13, 21, 37),
    panel2 = Color3.fromRGB(19, 31, 52), panel3 = Color3.fromRGB(25, 42, 68),
    blue = Color3.fromRGB(39, 143, 255), cyan = Color3.fromRGB(72, 211, 255),
    white = Color3.fromRGB(239, 246, 255), muted = Color3.fromRGB(143, 164, 193),
    green = Color3.fromRGB(67, 211, 145), gold = Color3.fromRGB(255, 203, 91),
    red = Color3.fromRGB(245, 100, 115),
}
local function new(class, props, parent)
    local o = Instance.new(class)
    for k,v in pairs(props or {}) do o[k] = v end
    o.Parent = parent
    return o
end
local function round(o, n)
    new("UICorner", {CornerRadius = UDim.new(0,n or 10)}, o)
end
local function outline(o, color, alpha)
    new("UIStroke", {Color=color or C.blue, Thickness=1, Transparency=alpha or .35}, o)
end
local function label(parent, text, size, color, font)
    return new("TextLabel", {BackgroundTransparency=1, Text=text, TextColor3=color or C.white,
        TextSize=size or 12, Font=font or Enum.Font.Gotham, TextXAlignment=Enum.TextXAlignment.Left,
        TextYAlignment=Enum.TextYAlignment.Center, TextWrapped=true}, parent)
end

local Gui = new("ScreenGui", {Name="GabielsPriv", ResetOnSpawn=false, ZIndexBehavior=Enum.ZIndexBehavior.Sibling}, ParentGui)
local Main = new("Frame", {Name="Main", Size=UDim2.new(0,720,0,480), Position=UDim2.new(.5,-360,.5,-240),
    BackgroundColor3=C.bg, BorderSizePixel=0, ClipsDescendants=true}, Gui)
round(Main,18); outline(Main,C.blue,.12)
new("Frame", {Size=UDim2.new(1,0,0,4), BackgroundColor3=C.cyan, BorderSizePixel=0}, Main)
local Header = new("Frame", {Size=UDim2.new(1,0,0,74), BackgroundColor3=C.panel, BorderSizePixel=0}, Main)
local title = label(Header,"♛  GABIEL'S PRIV",25,C.cyan,Enum.Font.GothamBlack)
title.Position=UDim2.new(0,18,0,7); title.Size=UDim2.new(0,400,0,34)
local sub = label(Header,"SLAP BATTLES  •  V2.0  •  MOBILE FRIENDLY",10,C.muted,Enum.Font.GothamMedium)
sub.Position=UDim2.new(0,21,0,42); sub.Size=UDim2.new(0,420,0,18)
local status = new("TextLabel", {AnchorPoint=Vector2.new(1,0), Position=UDim2.new(1,-62,0,20), Size=UDim2.new(0,112,0,27),
    BackgroundColor3=IS_OWNER and Color3.fromRGB(20,65,55) or C.panel2, Text=IS_OWNER and "OWNER MODE" or "PLAYER MODE",
    TextColor3=IS_OWNER and C.green or C.muted, TextSize=10, Font=Enum.Font.GothamBold}, Header)
round(status,8)
local Close = new("TextButton", {AnchorPoint=Vector2.new(1,0), Position=UDim2.new(1,-12,0,16), Size=UDim2.new(0,36,0,36),
    BackgroundColor3=Color3.fromRGB(65,34,49), Text="×", TextColor3=C.white, TextSize=24, Font=Enum.Font.GothamBold}, Header)
round(Close,9)

local Sidebar = new("ScrollingFrame", {Position=UDim2.new(0,12,0,86), Size=UDim2.new(0,176,1,-98), BackgroundColor3=C.panel,
    BorderSizePixel=0, ScrollBarThickness=3, ScrollBarImageColor3=C.blue, CanvasSize=UDim2.new(), AutomaticCanvasSize=Enum.AutomaticSize.Y}, Main)
round(Sidebar,13)
new("UIPadding", {PaddingTop=UDim.new(0,10),PaddingLeft=UDim.new(0,7),PaddingRight=UDim.new(0,7),PaddingBottom=UDim.new(0,10)}, Sidebar)
new("UIListLayout", {Padding=UDim.new(0,7),SortOrder=Enum.SortOrder.LayoutOrder}, Sidebar)
local Content = new("ScrollingFrame", {Position=UDim2.new(0,198,0,86), Size=UDim2.new(1,-210,1,-98), BackgroundColor3=C.panel,
    BorderSizePixel=0, ScrollBarThickness=4, ScrollBarImageColor3=C.blue, CanvasSize=UDim2.new(), AutomaticCanvasSize=Enum.AutomaticSize.Y}, Main)
round(Content,13)
new("UIPadding", {PaddingTop=UDim.new(0,13),PaddingBottom=UDim.new(0,14),PaddingLeft=UDim.new(0,13),PaddingRight=UDim.new(0,13)}, Content)
local ContentLayout = new("UIListLayout", {Padding=UDim.new(0,8),SortOrder=Enum.SortOrder.LayoutOrder}, Content)

local categories = {
 {name="Dashboard",icon="⌂"}, {name="Glove Catalog",icon="🧤"}, {name="Badge Checklist",icon="🏆"},
 {name="Combat Tools",icon="⚔"}, {name="Farm & Quests",icon="✦"}, {name="Favorites",icon="★"}, {name="Settings",icon="⚙"},
}
if IS_OWNER then table.insert(categories,{name="OWNER",icon="♛"}) end
local state, favorites, completed = {}, {}, {}
local selected = "Dashboard"
local render

local function clear()
    for _,v in ipairs(Content:GetChildren()) do
        if v:IsA("GuiObject") and v ~= ContentLayout then v:Destroy() end
    end
end
local function section(head, detail)
    local f=new("Frame",{Size=UDim2.new(1,0,0,54),BackgroundTransparency=1},Content)
    local a=label(f,head,20,C.white,Enum.Font.GothamBold); a.Size=UDim2.new(1,0,0,28)
    local b=label(f,detail or "",10,C.muted); b.Position=UDim2.new(0,0,0,29); b.Size=UDim2.new(1,0,0,18)
end
local function info(text, tint)
    local f=new("Frame",{Size=UDim2.new(1,0,0,48),BackgroundColor3=C.panel2,BorderSizePixel=0},Content); round(f,9)
    local t=label(f,text,10,tint or C.muted); t.Position=UDim2.new(0,11,0,4); t.Size=UDim2.new(1,-22,1,-8)
end
local function row(titleText, detail, kind, key)
    local f=new("Frame",{Size=UDim2.new(1,0,0,62),BackgroundColor3=C.panel2,BorderSizePixel=0},Content); round(f,10); outline(f,C.panel3,.4)
    local t=label(f,titleText,12,C.white,Enum.Font.GothamBold); t.Position=UDim2.new(0,11,0,6); t.Size=UDim2.new(1,-145,0,22)
    local d=label(f,detail or "",9,C.muted); d.Position=UDim2.new(0,11,0,30); d.Size=UDim2.new(1,-145,0,25)
    local btn=new("TextButton",{AnchorPoint=Vector2.new(1,.5),Position=UDim2.new(1,-9,.5,0),Size=UDim2.new(0,112,0,31),
        BackgroundColor3=C.panel3,Text="",TextColor3=C.white,TextSize=10,Font=Enum.Font.GothamBold},f); round(btn,8)
    local function paint()
        if kind=="check" then btn.Text=completed[key] and "✓ DONE" or "MARK DONE"; btn.BackgroundColor3=completed[key] and Color3.fromRGB(24,86,64) or C.panel3
        elseif kind=="favorite" then btn.Text=favorites[key] and "★ SAVED" or "☆ FAVORITE"; btn.BackgroundColor3=favorites[key] and Color3.fromRGB(83,65,28) or C.panel3
        else btn.Text=state[key] and "ON" or "OFF"; btn.BackgroundColor3=state[key] and C.blue or C.panel3 end
    end
    paint()
    btn.MouseButton1Click:Connect(function()
        if kind=="check" then completed[key]=not completed[key]
        elseif kind=="favorite" then favorites[key]=not favorites[key]
        else
            state[key]=not state[key]
            if key=="reset_checklists" and state[key] then
                completed={}
                state[key]=false
            elseif key=="owner_reset" and state[key] and IS_OWNER then
                completed={}; favorites={}; state={}
            end
        end
        paint()
    end)
end

-- Known glove names gathered from the project discussion; this is a starter catalogue, not a claim of every current in-game glove.
local gloveNames = {
 "Combat","Hitman","Bob","Detonator","Alchemist","Elude","Fish","Trap","Bomb","Chair",
 "Catseye","Doorkeeper","Camera","Sand","Shellbert","Avatar","Be The Glove","Retro","Recall","Terrain",
 "Poltergeist","Harvester","Revenant","Berserk","Charge","Chain","Confusion","Counter","Duelist","Lure",
}
local badgeNames = {"Bob","Detonator","Alchemist","Elude","Fish","Trap","Bomb","Chair","Catseye","Doorkeeper","Camera","Sand","Shellbert","Avatar","Be The Glove","Project: Facsimile"}

render = function(name)
    selected=name; clear()
    if name=="Dashboard" then
        section("Welcome to Gabiel's Priv","Your Slap Battles companion")
        info("Player: "..(LocalPlayer and LocalPlayer.Name or "Unknown").."  •  Build: 2.0",C.cyan)
        info("This hub includes local checklists, favorites and interface settings. Unlocks and gameplay actions are not automated in this build.")
        row("Glove catalogue","Browse gloves and save favorites","toggle","dashboard_catalog")
        row("Badge checklist","Track badges and challenge requirements","toggle","dashboard_badges")
        row("Floating button","Use the GP button to reopen this menu","toggle","floating_enabled")
    elseif name=="Glove Catalog" then
        section("Glove Catalog","Browse, track and favorite gloves")
        info("The list is a starter catalogue. Use the in-game requirements to earn each glove; this checklist cannot grant unlocks.",C.gold)
        for _,g in ipairs(gloveNames) do row(g,"Progress tracker • not an automatic unlock","check","glove:"..g); row("Favorite: "..g,"Save this glove to your favorites","favorite",g) end
    elseif name=="Badge Checklist" then
        section("Badge Checklist","Track badge challenges")
        info("Mark a badge complete only after the game awards it. Challenge completion is not simulated here.",C.gold)
        for _,b in ipairs(badgeNames) do row(b,"Badge progress checklist","check","badge:"..b) end
    elseif name=="Combat Tools" then
        section("Combat Tools","Practice and personal interface options")
        info("No auto-targeting, auto-attacking or player manipulation is included. These switches are local preferences only.",C.gold)
        row("Combat HUD","Show a local combat status preference","toggle","combat_hud")
        row("Safe Mode","Local reminder to avoid unwanted interactions","toggle","safe_mode")
        row("Target notes","Enable personal target notes","toggle","target_notes")
    elseif name=="Farm & Quests" then
        section("Farm & Quests","Track your own progress")
        info("No AFK farming, server hopping, teleporting or automatic quest completion is performed.",C.gold)
        for _,q in ipairs({"Daily Quest","Event Quest","Slap milestones","Candy Corn event","Server event checklist"}) do row(q,"Personal progress checklist","check","quest:"..q) end
    elseif name=="Favorites" then
        section("Favorites","Your saved gloves")
        local count=0
        for _,g in ipairs(gloveNames) do if favorites[g] then row(g,"Saved glove","favorite",g); count=count+1 end end
        if count==0 then info("No favorites yet. Open Glove Catalog and tap ☆ FAVORITE.") end
    elseif name=="Settings" then
        section("Settings","Interface preferences")
        row("Compact UI","Local preference placeholder","toggle","compact_ui")
        row("Animations","Local preference placeholder","toggle","animations")
        row("Show floating button","Controls the GP reopen button","toggle","floating_enabled")
        row("Reset checklists","Clear locally tracked completion marks","toggle","reset_checklists")
    elseif name=="OWNER" then
        if not IS_OWNER then info("Access denied.",C.red); return end
        section("OWNER PANEL","Local owner tools • "..OWNER_USERNAME)
        info("Owner status was checked on this client only. It is not secure server authorization.",C.gold)
        row("Diagnostics","Show local build/identity status","toggle","owner_diagnostics")
        row("Owner tools visibility","Local display preference","toggle","owner_tools")
        row("Reset local preferences","Clear local toggles and checklists","toggle","owner_reset")
    end
end

for _,cat in ipairs(categories) do
    local b=new("TextButton",{Size=UDim2.new(1,0,0,38),BackgroundColor3=C.panel2,Text=cat.icon.."   "..cat.name,
        TextColor3=cat.name=="OWNER" and C.gold or C.white,TextSize=11,Font=Enum.Font.GothamBold},Sidebar); round(b,9)
    b.MouseButton1Click:Connect(function()
        render(cat.name)
        for _,x in ipairs(Sidebar:GetChildren()) do if x:IsA("TextButton") then x.BackgroundColor3=(x==b) and Color3.fromRGB(25,67,112) or C.panel2 end end
    end)
end

local Floating=new("TextButton",{Name="GabielsPrivReopen",AnchorPoint=Vector2.new(0,1),Position=UDim2.new(0,18,1,-22),Size=UDim2.new(0,54,0,54),
    BackgroundColor3=C.blue,Text="GP",TextColor3=C.white,TextSize=18,Font=Enum.Font.GothamBlack,Visible=false},Gui); round(Floating,18); outline(Floating,C.cyan,0)
Close.MouseButton1Click:Connect(function()
    Main.Visible=false
    Floating.Visible=(state.floating_enabled ~= false)
end)
Floating.MouseButton1Click:Connect(function() Main.Visible=true; Floating.Visible=false end)

-- Drag header on desktop and touch devices.
do
    local dragging, dragInput, dragStart, startPos=false,nil,nil,nil
    Header.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            dragging=true; dragStart=input.Position; startPos=Main.Position
            input.Changed:Connect(function() if input.UserInputState==Enum.UserInputState.End then dragging=false end end)
        end
    end)
    Header.InputChanged:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch then dragInput=input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input==dragInput then
            local delta=input.Position-dragStart
            Main.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y)
        end
    end)
end

render("Dashboard")
for _,b in ipairs(Sidebar:GetChildren()) do if b:IsA("TextButton") and b.Text:find("Dashboard",1,true) then b.BackgroundColor3=Color3.fromRGB(25,67,112) end end
Main.BackgroundTransparency=1
TweenService:Create(Main,TweenInfo.new(.25,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{BackgroundTransparency=0}):Play()
print("Gabiel's Priv v2.0 loaded | local owner label: "..tostring(IS_OWNER))
