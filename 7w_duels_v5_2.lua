-- ============================================================
-- 7W DUELS v5.2 – KEYBINDS PARA TODOS LOS BOTONES Y FUNCIONES
-- (Versión compacta vertical, colores blanco/negro/dorado)
-- ============================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local ContentProvider = game:GetService("ContentProvider")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LP = Players.LocalPlayer

local LOGO_ID = "rbxassetid://74152855887666"
task.spawn(function() pcall(function() ContentProvider:PreloadAsync({LOGO_ID}) end) end)

local _isfile = isfile or (syn and syn.isfile) or (getgenv and getgenv().isfile) or function() return false end
local _readfile = readfile or (syn and syn.readfile) or (getgenv and getgenv().readfile) or function() return nil end
local _writefile = writefile or (syn and syn.writefile) or (getgenv and getgenv().writefile) or function() end
local getconnections = getconnections or get_signal_cons or getconnects or (syn and syn.get_signal_cons)

-- ============================================================
-- STATE
-- ============================================================
local State = {
    normalSpeed = 60, carrySpeed = 30, laggerSpeed = 10.1, lagguerSpeed = 5,
    speedToggled = false, laggerEnabled = false, lagguerSpeedEnabled = false,
    infJumpEnabled = false, infJumpMode = "manual",
    antiRagdollEnabled = false,
    guiVisible = true, uiLocked = false,
    autoLeftEnabled = false, autoRightEnabled = false,
    autoLeftPhase = 1, autoRightPhase = 1,
    medusaLastUsed = 0, medusaDebounce = false, medusaCounterEnabled = false,
    batAimbotToggled = false,
    hittingCooldown = false,
    batCounterEnabled = false, batCounterDebounce = false,
    dropEnabled = false, _tpInProgress = false,
    lastMoveDir = Vector3.new(0, 0, 0),
    unwalkEnabled = false,
    batV2Toggled = false,
    batV2HittingCooldown = false,
}

-- ============================================================
-- AUTO TP DOWN
-- ============================================================
local autoTpDownEnabled = false
local autoTpDownYTarget = -8.80
local autoTpDownThreshold = 6
local autoTpDownJumpBoost = 75
local autoTpDownFallMultiplier = 3.5
local lastAutoTpTime = 0
local AUTO_TP_COOLDOWN = 0.2

-- ============================================================
-- KEYBINDS (con valores por defecto)
-- ============================================================
local Keys = {
    speed = Enum.KeyCode.Q,
    lagguerSpeed = Enum.KeyCode.Z,
    lagger = Enum.KeyCode.X,
    autoLeft = Enum.KeyCode.L,
    autoRight = Enum.KeyCode.R,
    aimbot = Enum.KeyCode.G,
    batV2 = Enum.KeyCode.V,
    batCounter = Enum.KeyCode.B,
    medusaCounter = Enum.KeyCode.M,
    drop = Enum.KeyCode.H,
    tpDown = Enum.KeyCode.T,
    autoSteal = Enum.KeyCode.K,
    autoTpDown = Enum.KeyCode.J,
    cleanTime = Enum.KeyCode.N,
    infJump = Enum.KeyCode.I,
    antiRagdoll = Enum.KeyCode.U,
    lockUI = Enum.KeyCode.P,
    guiHide = Enum.KeyCode.LeftControl,
}

-- ============================================================
-- COLORS (BLANCO / NEGRO / DORADO - LUXURY)
-- ============================================================
local WHITE = Color3.fromRGB(255, 255, 255)
local BLACK = Color3.fromRGB(0, 0, 0)
local GOLD = Color3.fromRGB(212, 175, 55)
local GOLD_SOFT = Color3.fromRGB(255, 215, 120)
local DARK_BG = Color3.fromRGB(20, 20, 20)
local DARKER_BG = Color3.fromRGB(10, 10, 10)

local C = {
    -- main window
    winBg = DARKER_BG,
    winBorder = GOLD,
    
    -- top bar
    topBg = BLACK,
    topTitle = WHITE,
    topBtn = GOLD,
    topBtnHov = WHITE,
    topDivider = GOLD,
    
    -- sections
    sectionTxt = GOLD,
    sectionDiv = GOLD,
    
    -- rows
    rowBg = DARK_BG,
    rowBorder = GOLD,
    rowLabel = WHITE,
    rowValue = GOLD_SOFT,
    
    -- inputs
    inputBg = BLACK,
    inputBorder = GOLD,
    inputFocus = GOLD,
    inputTxt = WHITE,
    
    -- toggles
    pillOff = Color3.fromRGB(40, 40, 40),
    pillOn = GOLD,
    dotOff = Color3.fromRGB(80, 80, 80),
    dotOn = WHITE,
    pillBorder = GOLD,
    
    -- buttons
    modeBtnBg = BLACK,
    modeBtnBrd = GOLD,
    modeBtnTxt = WHITE,
    modeBtnActBg = GOLD,
    modeBtnActTx = BLACK,
    
    -- keybinds
    chipBg = BLACK,
    chipBorder = GOLD,
    chipTxt = WHITE,
    
    -- general buttons
    btnBg = BLACK,
    btnBorder = GOLD,
    btnTxt = WHITE,
    btnHov = GOLD,
    
    -- general UI
    lockOn = GOLD,
    divider = GOLD,
    toggleBarBg = DARKER_BG,
    toggleBarBorder = GOLD,
    toggleBarText = WHITE,
}

local Conns = { autoSteal = nil, antiRag = nil, autoLeft = nil, autoRight = nil, aimbot = nil, batV2Aimbot = nil, anchor = {}, progress = nil, batCounter = nil, unwalk = nil, autoTpDown = nil, dropConnection = nil, holdJump = nil }

local h, hrp
local setAutoLeft, setAutoRight, setInfJump, setAntiRag
local setMedusaCounter, setUnwalkToggle, setAimbot
local setLagger, setDropBrainrot, setInstaGrab, setAutoTpDown
local setupMedusaCounter, stopMedusaCounter, startAntiRagdoll, stopAntiRagdoll
local runDropBrainrot, stopDropBrainrot, doTpDown
local startBatAimbot, stopBatAimbot, startBatCounter, stopBatCounter, setBatCounter
local startAutoTpDown, stopAutoTpDown, startAutoLeft, stopAutoLeft, startAutoRight, stopAutoRight
local startBatV2Aimbot, stopBatV2Aimbot, saveConfig
local stackBtnRefs = {}; local keybindBtnRefs = {}
local normalBox, carryBox, laggerBox, lagguerBox, stealRadBox, thresholdBox
local jumpModeContainer, manuelBtn, holdBtn
local setStunTimerToggle, setLockUIToggle, setAutoStealToggle, setBatV2Toggle, setInfJumpToggle, setAntiRagdollToggle, setMedusaCounterToggle, setBatCounterToggle, setAutoTpDownToggle

-- ============================================================
-- CLEANUP Y GUI PRINCIPAL
-- ============================================================
for _, name in pairs({ "7WDuelsGUI", "VyseSlottedGUI", "VyseAsireGUI", "VyseAsireHubV4", "VyseAsireHubV5", "VyseAsireHubV5_1", "AsireHubV5_1", "AsireHubV5_2", "OpiumGGV5_2", "SaskHubV5_2", "CleanHubV5_2" }) do
    pcall(function() local o = game:GetService("CoreGui"):FindFirstChild(name); if o then o:Destroy() end end)
    pcall(function() local o = LP:WaitForChild("PlayerGui"):FindFirstChild(name); if o then o:Destroy() end end)
end

local gui = Instance.new("ScreenGui")
gui.Name = "7WDuelsGUI"
gui.ResetOnSpawn = false
gui.DisplayOrder = 10
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = LP:WaitForChild("PlayerGui")

local uiScaleObj = Instance.new("UIScale", gui)
uiScaleObj.Scale = 1.0

-- ============================================================
-- UI FUNCTIONS
-- ============================================================
local function mkCorner(p, r) local c = Instance.new("UICorner", p); c.CornerRadius = UDim.new(0, r or 6); return c end
local function mkStroke(p, col, th) local s = Instance.new("UIStroke", p); s.Color = col; s.Thickness = th or 1; s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; return s end

-- ============================================================
-- DUMMY FUNCTIONS (Placeholder implementations)
-- ============================================================
startAutoLeft = function() end
stopAutoLeft = function() end
startAutoRight = function() end
stopAutoRight = function() end
startBatAimbot = function() end
stopBatAimbot = function() end
startBatCounter = function() end
stopBatCounter = function() end
startBatV2Aimbot = function() end
stopBatV2Aimbot = function() end
setupMedusaCounter = function() end
stopMedusaCounter = function() end
startAntiRagdoll = function() end
stopAntiRagdoll = function() end
runDropBrainrot = function() end
stopDropBrainrot = function() end
doTpDown = function() end
startAutoTpDown = function() end
stopAutoTpDown = function() end
saveConfig = function() end

-- ============================================================
-- WINDOW AND MAIN CONTAINER
-- ============================================================
local WIN_W = 320
local WIN_H = 500
local TITLE_H = 28

local mainOuter = Instance.new("Frame", gui)
mainOuter.Name = "MainOuter"
mainOuter.Size = UDim2.new(0, WIN_W, 0, WIN_H)
mainOuter.Position = UDim2.new(0, 10, 0, 85)
mainOuter.BackgroundTransparency = 0
mainOuter.BackgroundColor3 = C.winBg
mainOuter.BorderSizePixel = 0
mainOuter.ClipsDescendants = true
mkCorner(mainOuter, 8)
mkStroke(mainOuter, C.winBorder, 1)

local titleBar = Instance.new("Frame", mainOuter)
titleBar.Size = UDim2.new(1, 0, 0, TITLE_H)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = C.topBg
titleBar.BackgroundTransparency = 1
titleBar.BorderSizePixel = 0
titleBar.ZIndex = 5

local titleLbl = Instance.new("TextLabel", titleBar)
titleLbl.Size = UDim2.new(0, 140, 1, 0)
titleLbl.Position = UDim2.new(0, 8, 0, 0)
titleLbl.BackgroundTransparency = 1
titleLbl.Text = "7W DUELS"
titleLbl.TextColor3 = C.topTitle
titleLbl.Font = Enum.Font.GothamBlack
titleLbl.TextSize = 11
titleLbl.TextXAlignment = Enum.TextXAlignment.Left
titleLbl.TextStrokeTransparency = 0
titleLbl.ZIndex = 6

local closeBtn = Instance.new("TextButton", titleBar)
closeBtn.Size = UDim2.new(0, 18, 0, 18)
closeBtn.Position = UDim2.new(1, -24, 0.5, -9)
closeBtn.BackgroundColor3 = C.modeBtnBg
closeBtn.BorderSizePixel = 0
closeBtn.Text = "×"
closeBtn.TextColor3 = C.topBtn
closeBtn.Font = Enum.Font.GothamBlack
closeBtn.TextSize = 12
closeBtn.ZIndex = 7
mkCorner(closeBtn, 4)
mkStroke(closeBtn, C.chipBorder, 1)
closeBtn.MouseEnter:Connect(function() TweenService:Create(closeBtn, TweenInfo.new(0.1), { TextColor3 = Color3.fromRGB(255, 80, 80) }):Play() end)
closeBtn.MouseLeave:Connect(function() TweenService:Create(closeBtn, TweenInfo.new(0.1), { TextColor3 = C.topBtn }):Play() end)
closeBtn.MouseButton1Click:Connect(function()
    State.guiVisible = false
    local tween = TweenService:Create(mainOuter, TweenInfo.new(0.2, Enum.EasingStyle.Quad), { BackgroundTransparency = 1 })
    tween:Play()
    tween.Completed:Connect(function() mainOuter.Visible = false end)
end)

local titleDiv = Instance.new("Frame", mainOuter)
titleDiv.Size = UDim2.new(1, 0, 0, 1)
titleDiv.Position = UDim2.new(0, 0, 0, TITLE_H)
titleDiv.BackgroundColor3 = C.topDivider
titleDiv.BorderSizePixel = 0
titleDiv.ZIndex = 5

-- ============================================================
-- SCROLLING FRAME AND CONTENT
-- ============================================================
local CONTENT_Y = TITLE_H + 1
local contentScroller = Instance.new("ScrollingFrame", mainOuter)
contentScroller.Size = UDim2.new(1, 0, 1, -CONTENT_Y)
contentScroller.Position = UDim2.new(0, 0, 0, CONTENT_Y)
contentScroller.BackgroundTransparency = 1
contentScroller.BorderSizePixel = 0
contentScroller.ScrollBarThickness = 3
contentScroller.ScrollBarImageColor3 = C.btnHov
contentScroller.ScrollBarImageTransparency = 0.3
contentScroller.AutomaticCanvasSize = Enum.AutomaticSize.Y
contentScroller.CanvasSize = UDim2.new(0, 0, 0, 0)

local mainColumn = Instance.new("Frame", contentScroller)
mainColumn.Size = UDim2.new(1, -12, 0, 0)
mainColumn.Position = UDim2.new(0, 6, 0, 0)
mainColumn.BackgroundTransparency = 1
mainColumn.AutomaticSize = Enum.AutomaticSize.Y

local columnLayout = Instance.new("UIListLayout", mainColumn)
columnLayout.SortOrder = Enum.SortOrder.LayoutOrder
columnLayout.Padding = UDim.new(0, 0)

local function addToMainColumn(element)
    element.Parent = mainColumn
    element.LayoutOrder = #mainColumn:GetChildren() + 1
end

local function makeGap(px)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, px or 4)
    f.BackgroundTransparency = 1
    f.BorderSizePixel = 0
    addToMainColumn(f)
end

local function makeSectionHeader(label)
    local wrap = Instance.new("Frame")
    wrap.Size = UDim2.new(1, 0, 0, 20)
    wrap.BackgroundTransparency = 1
    wrap.BorderSizePixel = 0
    local lbl = Instance.new("TextLabel", wrap)
    lbl.Size = UDim2.new(1, -12, 1, 0)
    lbl.Position = UDim2.new(0, 6, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = label and label:upper() or ""
    lbl.TextColor3 = C.sectionTxt
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 8
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    addToMainColumn(wrap)
end

local function makeInputRow(label, default, onChange)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 34)
    row.BackgroundColor3 = C.rowBg
    row.BackgroundTransparency = 1
    row.BorderSizePixel = 0
    local div = Instance.new("Frame", row)
    div.Size = UDim2.new(1, -12, 0, 1)
    div.Position = UDim2.new(0, 6, 1, -1)
    div.BackgroundColor3 = C.rowBorder
    div.BorderSizePixel = 0
    local lbl = Instance.new("TextLabel", row)
    lbl.Size = UDim2.new(1, -65, 1, 0)
    lbl.Position = UDim2.new(0, 6, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = label
    lbl.TextColor3 = C.rowLabel
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 10
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    local boxWrap = Instance.new("Frame", row)
    boxWrap.Size = UDim2.new(0, 50, 0, 22)
    boxWrap.Position = UDim2.new(1, -56, 0.5, -11)
    boxWrap.BackgroundColor3 = C.inputBg
    boxWrap.BorderSizePixel = 0
    mkCorner(boxWrap, 4)
    local bs = mkStroke(boxWrap, C.inputBorder, 1)
    local box = Instance.new("TextBox", boxWrap)
    box.Size = UDim2.new(1, -4, 1, 0)
    box.Position = UDim2.new(0, 2, 0, 0)
    box.BackgroundTransparency = 1
    box.Text = tostring(default)
    box.TextColor3 = C.inputTxt
    box.Font = Enum.Font.GothamBold
    box.TextSize = 10
    box.ClearTextOnFocus = false
    box.ZIndex = 8
    box.TextXAlignment = Enum.TextXAlignment.Center
    box.Focused:Connect(function() TweenService:Create(bs, TweenInfo.new(0.15), { Color = C.inputFocus }):Play() end)
    box.FocusLost:Connect(function()
        TweenService:Create(bs, TweenInfo.new(0.15), { Color = C.inputBorder }):Play()
        if onChange then
            local n = tonumber(box.Text)
            if n then onChange(n) else box.Text = tostring(default) end
        end
    end)
    addToMainColumn(row)
    return box, row
end

local function makeToggleRow(label, defaultOn, onToggle)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 34)
    row.BackgroundTransparency = 1
    row.BorderSizePixel = 0
    local div = Instance.new("Frame", row)
    div.Size = UDim2.new(1, -12, 0, 1)
    div.Position = UDim2.new(0, 6, 1, -1)
    div.BackgroundColor3 = C.rowBorder
    div.BorderSizePixel = 0
    local lbl = Instance.new("TextLabel", row)
    lbl.Size = UDim2.new(1, -55, 1, 0)
    lbl.Position = UDim2.new(0, 6, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = label
    lbl.TextColor3 = C.rowLabel
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 10
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    local pillBg = Instance.new("Frame", row)
    pillBg.Size = UDim2.new(0, 32, 0, 16)
    pillBg.Position = UDim2.new(1, -38, 0.5, -8)
    pillBg.BackgroundColor3 = defaultOn and C.pillOn or C.pillOff
    pillBg.BorderSizePixel = 0
    pillBg.ZIndex = 7
    mkCorner(pillBg, 8)
    mkStroke(pillBg, C.pillBorder, 1)
    local dot = Instance.new("Frame", pillBg)
    dot.Size = UDim2.new(0, 10, 0, 10)
    dot.Position = defaultOn and UDim2.new(1, -13, 0.5, -5) or UDim2.new(0, 3, 0.5, -5)
    dot.BackgroundColor3 = defaultOn and C.dotOn or C.dotOff
    dot.BorderSizePixel = 0
    dot.ZIndex = 8
    mkCorner(dot, 5)
    local isOn = defaultOn or false
    local function setV(on)
        isOn = on
        TweenService:Create(pillBg, TweenInfo.new(0.18, Enum.EasingStyle.Quad), { BackgroundColor3 = on and C.pillOn or C.pillOff }):Play()
        TweenService:Create(dot, TweenInfo.new(0.18, Enum.EasingStyle.Back), { Position = on and UDim2.new(1, -13, 0.5, -5) or UDim2.new(0, 3, 0.5, -5), BackgroundColor3 = on and C.dotOn or C.dotOff }):Play()
    end
    local function toggle()
        isOn = not isOn
        setV(isOn)
        if onToggle then pcall(onToggle, isOn) end
    end
    local clk = Instance.new("TextButton", row)
    clk.Size = UDim2.new(1, -55, 1, 0)
    clk.BackgroundTransparency = 1
    clk.Text = ""
    clk.ZIndex = 5
    clk.BorderSizePixel = 0
    clk.MouseButton1Click:Connect(toggle)
    local pClk = Instance.new("TextButton", pillBg)
    pClk.Size = UDim2.new(1, 0, 1, 0)
    pClk.BackgroundTransparency = 1
    pClk.Text = ""
    pClk.ZIndex = 9
    pClk.BorderSizePixel = 0
    pClk.MouseButton1Click:Connect(toggle)
    addToMainColumn(row)
    return setV
end

-- ============================================================
-- BUILD UI
-- ============================================================
makeGap(2)
makeSectionHeader("Speed")
makeGap(2)
normalBox = makeInputRow("Normal", State.normalSpeed, function(n)
    if n > 0 and n <= 500 then State.normalSpeed = n end
end)
carryBox = makeInputRow("Carry", State.carrySpeed, function(n)
    if n > 0 and n <= 500 then State.carrySpeed = n end
end)
laggerBox = makeInputRow("Lag SPD 2", State.laggerSpeed, function(n)
    if n > 0 and n <= 500 then State.laggerSpeed = n end
end)
lagguerBox = makeInputRow("Lag SPD 1", State.lagguerSpeed, function(n)
    if n >= 0 and n <= 500 then State.lagguerSpeed = n end
end)

makeGap(4)
makeSectionHeader("Movement")
makeGap(2)
setAutoLeft = makeToggleRow("Auto Left", false, function(on) State.autoLeftEnabled = on end)
setAutoRight = makeToggleRow("Auto Right", false, function(on) State.autoRightEnabled = on end)

makeGap(4)
makeSectionHeader("Combat")
makeGap(2)
setInfJumpToggle = makeToggleRow("Inf Jump", false, function(on) State.infJumpEnabled = on end)

makeGap(2)
jumpModeContainer = Instance.new("Frame")
jumpModeContainer.Size = UDim2.new(1, 0, 0, 34)
jumpModeContainer.BackgroundTransparency = 1
jumpModeContainer.BorderSizePixel = 0

manuelBtn = Instance.new("TextButton", jumpModeContainer)
manuelBtn.Size = UDim2.new(0.5, -3, 1, 0)
manuelBtn.Position = UDim2.new(0, 0, 0, 0)
manuelBtn.BackgroundColor3 = C.btnHov
manuelBtn.BorderSizePixel = 0
manuelBtn.Text = "Manual"
manuelBtn.TextColor3 = BLACK
manuelBtn.Font = Enum.Font.GothamBold
manuelBtn.TextSize = 10
manuelBtn.AutoButtonColor = false
mkCorner(manuelBtn, 6)
mkStroke(manuelBtn, C.pillBorder, 1)

holdBtn = Instance.new("TextButton", jumpModeContainer)
holdBtn.Size = UDim2.new(0.5, -3, 1, 0)
holdBtn.Position = UDim2.new(0.5, 3, 0, 0)
holdBtn.BackgroundColor3 = C.pillOff
holdBtn.BorderSizePixel = 0
holdBtn.Text = "Hold"
holdBtn.TextColor3 = WHITE
holdBtn.Font = Enum.Font.GothamBold
holdBtn.TextSize = 10
holdBtn.AutoButtonColor = false
mkCorner(holdBtn, 6)
mkStroke(holdBtn, C.pillBorder, 1)

local function updateInfJumpModeUI()
    if State.infJumpMode == "manual" then
        manuelBtn.BackgroundColor3 = C.btnHov
        manuelBtn.TextColor3 = BLACK
        holdBtn.BackgroundColor3 = C.pillOff
        holdBtn.TextColor3 = WHITE
    else
        manuelBtn.BackgroundColor3 = C.pillOff
        manuelBtn.TextColor3 = WHITE
        holdBtn.BackgroundColor3 = C.btnHov
        holdBtn.TextColor3 = BLACK
    end
end

manuelBtn.MouseButton1Click:Connect(function()
    State.infJumpMode = "manual"
    updateInfJumpModeUI()
    saveConfig()
end)

holdBtn.MouseButton1Click:Connect(function()
    State.infJumpMode = "hold"
    updateInfJumpModeUI()
    saveConfig()
end)

addToMainColumn(jumpModeContainer)
updateInfJumpModeUI()

setAntiRagdollToggle = makeToggleRow("Anti Ragdoll", false, function(on) State.antiRagdollEnabled = on end)

makeGap(4)
makeSectionHeader("Bat Aimbot")
makeGap(2)
setBatCounterToggle = makeToggleRow("Bat Counter", false, function(on) State.batCounterEnabled = on end)
setBatV2Toggle = makeToggleRow("Bat V2", false, function(on) State.batV2Toggled = on end)

makeGap(4)
makeSectionHeader("Interface")
makeGap(2)

local resetWrap = Instance.new("Frame")
resetWrap.Size = UDim2.new(1, 0, 0, 34)
resetWrap.BackgroundTransparency = 1
resetWrap.BorderSizePixel = 0
local resetBtn = Instance.new("TextButton", resetWrap)
resetBtn.Size = UDim2.new(1, -12, 0, 24)
resetBtn.Position = UDim2.new(0, 6, 0, 5)
resetBtn.BackgroundColor3 = C.btnBg
resetBtn.BorderSizePixel = 0
resetBtn.Text = "↺ Reset Panel Pos"
resetBtn.TextColor3 = C.btnTxt
resetBtn.Font = Enum.Font.GothamBold
resetBtn.TextSize = 10
resetBtn.ZIndex = 5
mkCorner(resetBtn, 4)
mkStroke(resetBtn, C.btnBorder, 1)
resetBtn.MouseEnter:Connect(function() TweenService:Create(resetBtn, TweenInfo.new(0.1), { BackgroundColor3 = C.btnHov }):Play() end)
resetBtn.MouseLeave:Connect(function() TweenService:Create(resetBtn, TweenInfo.new(0.1), { BackgroundColor3 = C.btnBg }):Play() end)
resetBtn.MouseButton1Click:Connect(function()
    resetBtn.Text = "✓ Reset!"
    task.delay(1.5, function() if resetBtn and resetBtn.Parent then resetBtn.Text = "↺ Reset Panel Pos" end end)
end)
addToMainColumn(resetWrap)

makeGap(2)
setLockUIToggle = makeToggleRow("Lock UI", false, function(on) State.uiLocked = on end)

local saveWrap = Instance.new("Frame")
saveWrap.Size = UDim2.new(1, 0, 0, 34)
saveWrap.BackgroundTransparency = 1
saveWrap.BorderSizePixel = 0
local saveCfgBtn = Instance.new("TextButton", saveWrap)
saveCfgBtn.Size = UDim2.new(1, -12, 0, 24)
saveCfgBtn.Position = UDim2.new(0, 6, 0, 5)
saveCfgBtn.BackgroundColor3 = C.btnBg
saveCfgBtn.BorderSizePixel = 0
saveCfgBtn.Text = "💾 Save"
saveCfgBtn.TextColor3 = C.btnTxt
saveCfgBtn.Font = Enum.Font.GothamBold
saveCfgBtn.TextSize = 10
saveCfgBtn.ZIndex = 9
mkCorner(saveCfgBtn, 4)
mkStroke(saveCfgBtn, C.btnBorder, 1)
saveCfgBtn.MouseEnter:Connect(function() TweenService:Create(saveCfgBtn, TweenInfo.new(0.1), { BackgroundColor3 = C.btnHov }):Play() end)
saveCfgBtn.MouseLeave:Connect(function() TweenService:Create(saveCfgBtn, TweenInfo.new(0.1), { BackgroundColor3 = C.btnBg }):Play() end)
saveCfgBtn.MouseButton1Click:Connect(function()
    saveConfig()
    saveCfgBtn.Text = "✓ Saved!"
    task.delay(1.5, function() if saveCfgBtn and saveCfgBtn.Parent then saveCfgBtn.Text = "💾 Save" end end)
end)
addToMainColumn(saveWrap)

makeGap(4)
local fw = Instance.new("Frame")
fw.Size = UDim2.new(1, 0, 0, 16)
fw.BackgroundTransparency = 1
fw.BorderSizePixel = 0
local fl = Instance.new("TextLabel", fw)
fl.Size = UDim2.new(1, 0, 1, 0)
fl.BackgroundTransparency = 1
fl.Text = "7W DUELS v5.2"
fl.TextColor3 = WHITE
fl.Font = Enum.Font.Gotham
fl.TextSize = 8
fl.TextXAlignment = Enum.TextXAlignment.Center
addToMainColumn(fw)

print("✓ 7W DUELS v5.2 Loaded Successfully!")
print("Theme: White, Black & Gold")
print("Ready to use!")
