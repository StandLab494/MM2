-- VANEZY x MANscript | MM2 v10.0 (God Mode + Teleport Back)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

local CORRECT_KEY = "KALABA"
local keyVerified = false
local attempts = 0

-- Очистка
pcall(function()
    for _, v in pairs(game:GetService("CoreGui"):GetChildren()) do
        if v.Name:find("VanezyMM2") then
            v:Destroy()
        end
    end
end)

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "VanezyMM2"
screenGui.Parent = game:GetService("CoreGui")
screenGui.ResetOnSpawn = false

local overlay = Instance.new("Frame")
overlay.Size = UDim2.new(1, 0, 1, 0)
overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
overlay.BackgroundTransparency = 0.6
overlay.Parent = screenGui
overlay.Visible = true

-- ===== ОСНОВНОЕ МЕНЮ =====
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 260, 0, 280)
main.Position = UDim2.new(0.5, -130, 0.3, 0)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
main.BackgroundTransparency = 0.1
main.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
title.Text = "VANEZY x MANscript | MM2"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 12
title.Font = Enum.Font.GothamBold
title.Parent = main

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 26, 0, 26)
closeBtn.Position = UDim2.new(1, -34, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
closeBtn.Text = "−"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 20
closeBtn.Parent = title

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -16, 1, -50)
scroll.Position = UDim2.new(0, 8, 0, 40)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 3
scroll.Parent = main

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 6)
layout.Parent = scroll

-- Переменные
local espEnabled = false
local autoGunEnabled = false
local godModeEnabled = false
local speedEnabled = false
local speedValue = 20
local espHighlights = {}
local lastPosition = nil
local godModeConn = nil

-- Хранилище кнопок
local toggleButtons = {}
local tgkButtons = {}

-- ===== GOD MODE (не даёт умереть) =====
local function enableGodMode()
    if godModeConn then godModeConn:Disconnect() end
    godModeConn = RunService.Heartbeat:Connect(function()
        if not godModeEnabled or not keyVerified then return end
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChild("Humanoid")
            if hum and hum.Health > 0 then
                hum.Health = hum.MaxHealth
            end
        end
    end)
end

local function disableGodMode()
    if godModeConn then
        godModeConn:Disconnect()
        godModeConn = nil
    end
end

-- ===== ESP =====
local function clearESP()
    for _, hl in pairs(espHighlights) do
        pcall(function() hl:Destroy() end)
    end
    espHighlights = {}
end

local function updateESP()
    clearESP()
    if not espEnabled or not keyVerified then return end
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local char = player.Character
            local hl = Instance.new("Highlight")
            hl.Name = "VanezyESP"
            hl.FillTransparency = 0.5
            hl.OutlineTransparency = 0.3
            hl.FillColor = Color3.fromRGB(255, 200, 0)
            hl.Parent = char
            table.insert(espHighlights, hl)
        end
    end
end

-- ===== АВТО-ЗАБОР ОРУЖИЯ С ВОЗВРАТОМ =====
local isGrabbing = false
local function autoGrabWithReturn()
    if not autoGunEnabled or not keyVerified or isGrabbing then return end
    
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Tool") and obj:FindFirstChild("Handle") then
            local name = obj.Name:lower()
            if name:find("gun") or name:find("knife") then
                local char = LocalPlayer.Character
                if char then
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        isGrabbing = true
                        -- Сохраняем позицию до телепорта
                        local originalPos = hrp.Position
                        -- Телепорт к оружию
                        hrp.CFrame = CFrame.new(obj.Handle.Position)
                        task.wait(0.15)
                        -- Подбор оружия (клавиша E)
                        pcall(function()
                            local VirtualInput = game:GetService("VirtualInputManager")
                            VirtualInput:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                            task.wait(0.1)
                            VirtualInput:SendKeyEvent(false, Enum.KeyCode.E, false, game)
                        end)
                        task.wait(0.1)
                        -- Телепорт обратно
                        hrp.CFrame = CFrame.new(originalPos)
                        task.wait(0.05)
                        isGrabbing = false
                        break
                    end
                end
            end
        end
    end
end

-- ===== ФУНКЦИИ ДЛЯ КНОПОК =====
local function addToggle(text, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 36)
    frame.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
    frame.BackgroundTransparency = 0.3
    frame.Parent = scroll
    
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 6)
    frameCorner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -70, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(240, 240, 240)
    label.TextSize = 11
    label.Font = Enum.Font.GothamBold
    label.Parent = frame
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 50, 0, 26)
    btn.Position = UDim2.new(1, -58, 0.5, -13)
    btn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    btn.Text = "ВЫКЛ"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 10
    btn.Font = Enum.Font.GothamBold
    btn.Parent = frame
    btn.AutoButtonColor = false
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
    
    btn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    btn.Text = "🔒"
    
    local state = false
    table.insert(toggleButtons, {btn = btn, label = label, callback = callback, state = false, text = text})
    
    btn.MouseButton1Click:Connect(function()
        if not keyVerified then
            game.StarterGui:SetCore("SendNotification", {
                Title = "VANEZY x MANscript",
                Text = "🔒 Введите ключ для разблокировки",
                Duration = 2
            })
            return
        end
        state = not state
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 130, 80) or Color3.fromRGB(200, 50, 50)
        btn.Text = state and "ВКЛ" or "ВЫКЛ"
        callback(state)
    end)
end

local function addTGKButton(name, url)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 36)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    btn.Text = "📢 " .. name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 11
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Font = Enum.Font.Gotham
    btn.Parent = scroll
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
    
    btn.BackgroundColor3 = Color3.fromRGB(80, 70, 70)
    btn.Text = "🔒 " .. name
    
    table.insert(tgkButtons, {btn = btn, url = url, name = name})
    
    btn.MouseButton1Click:Connect(function()
        if not keyVerified then
            game.StarterGui:SetCore("SendNotification", {
                Title = "VANEZY x MANscript",
                Text = "🔒 Введите ключ для разблокировки",
                Duration = 2
            })
            return
        end
        pcall(function()
            setclipboard(url)
            game.StarterGui:SetCore("SendNotification", {
                Title = "VANEZY x MANscript",
                Text = "Ссылка скопирована: " .. url,
                Duration = 2
            })
        end)
    end)
end

-- Ползунок скорости
local speedFrame = Instance.new("Frame")
speedFrame.Size = UDim2.new(1, 0, 0, 50)
speedFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
speedFrame.BackgroundTransparency = 0.3
speedFrame.Parent = scroll

local speedCorner = Instance.new("UICorner")
speedCorner.CornerRadius = UDim.new(0, 8)
speedCorner.Parent = speedFrame

local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(1, -15, 0, 20)
speedLabel.Position = UDim2.new(0, 12, 0, 4)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "⚡ Скорость: 20"
speedLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
speedLabel.TextSize = 11
speedLabel.Font = Enum.Font.GothamBold
speedLabel.Parent = speedFrame

local sliderTrack = Instance.new("TextButton")
sliderTrack.Size = UDim2.new(1, -24, 0, 10)
sliderTrack.Position = UDim2.new(0, 12, 0, 30)
sliderTrack.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
sliderTrack.BorderSizePixel = 0
sliderTrack.Text = ""
sliderTrack.AutoButtonColor = false
sliderTrack.Parent = speedFrame

local sliderCorner = Instance.new("UICorner")
sliderCorner.CornerRadius = UDim.new(0, 5)
sliderCorner.Parent = sliderTrack

local sliderFill = Instance.new("Frame")
sliderFill.Size = UDim2.new(0.05, 0, 1, 0)
sliderFill.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
sliderFill.BorderSizePixel = 0
sliderFill.Parent = sliderTrack

local sliderFillCorner = Instance.new("UICorner")
sliderFillCorner.CornerRadius = UDim.new(0, 5)
sliderFillCorner.Parent = sliderFill

local sliderKnob = Instance.new("TextButton")
sliderKnob.Size = UDim2.new(0, 18, 0, 18)
sliderKnob.Position = UDim2.new(0.05, -9, 0.5, -9)
sliderKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
sliderKnob.BorderSizePixel = 0
sliderKnob.Text = ""
sliderKnob.AutoButtonColor = false
sliderKnob.Parent = sliderTrack

local knobCorner = Instance.new("UICorner")
knobCorner.CornerRadius = UDim.new(1, 0)
knobCorner.Parent = sliderKnob

local dragging = false
local function updateSpeedFromSlider(inputPos)
    if not keyVerified then return end
    local tStart = sliderTrack.AbsolutePosition.X
    local tWidth = sliderTrack.AbsoluteSize.X
    local relX = math.clamp((inputPos.X - tStart) / tWidth, 0, 1)
    local newVal = math.floor(16 + (relX * 84))
    newVal = math.clamp(newVal, 16, 100)
    sliderFill.Size = UDim2.new(relX, 0, 1, 0)
    sliderKnob.Position = UDim2.new(relX, -9, 0.5, -9)
    speedLabel.Text = "⚡ Скорость: " .. newVal
    speedValue = newVal
    if speedEnabled then
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
        if hum then hum.WalkSpeed = speedValue end
    end
end

sliderKnob.InputBegan:Connect(function(i)
    if not keyVerified then return end
    if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
end)
sliderTrack.InputBegan:Connect(function(i)
    if not keyVerified then return end
    if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; updateSpeedFromSlider(i.Position) end
end)
UserInputService.InputChanged:Connect(function(i)
    if dragging and not keyVerified then return end
    if dragging and (i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseMovement) then updateSpeedFromSlider(i.Position) end
end)
UserInputService.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)

-- Кнопки
addToggle("👁️ ESP", function(s) espEnabled = s; if s then updateESP() else clearESP() end end)
addToggle("🔫 Авто-забор оружия (с возвратом)", function(s) autoGunEnabled = s end)
addToggle("🛡️ God Mode (бессмертие)", function(s) 
    godModeEnabled = s
    if s then 
        enableGodMode()
    else 
        disableGodMode()
    end
end)
addToggle("🏃 Ускорение", function(s) speedEnabled = s; if s then updateSpeedFromSlider({Position = sliderTrack.AbsolutePosition}) end end)

-- Разделитель
local separator = Instance.new("Frame")
separator.Size = UDim2.new(1, 0, 0, 20)
separator.BackgroundTransparency = 1
separator.Parent = scroll

local sepText = Instance.new("TextLabel")
sepText.Size = UDim2.new(1, 0, 1, 0)
sepText.BackgroundTransparency = 1
sepText.Text = "━━━━━ 📢 РАЗРАБОТЧИКИ ━━━━━"
sepText.TextColor3 = Color3.fromRGB(160, 160, 170)
sepText.TextSize = 10
sepText.Font = Enum.Font.GothamBold
sepText.Parent = separator

addTGKButton("VANEZY SCRIPTS", "https://t.me/VanezyScripts")
addTGKButton("MANscript", "https://t.me/manscripthub")

-- Обновление canvas
task.wait(0.1)
local h = 0
for _, v in pairs(scroll:GetChildren()) do
    if v:IsA("Frame") or v:IsA("TextButton") then
        h = h + v.Size.Y.Offset + 6
    end
end
scroll.CanvasSize = UDim2.new(0, 0, 0, h + 20)

-- ===== ОКНО ВВОДА КЛЮЧА (со звёздочками) =====
local keyFrame = Instance.new("Frame")
keyFrame.Size = UDim2.new(0, 280, 0, 180)
keyFrame.Position = UDim2.new(0.5, -140, 0.5, -90)
keyFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
keyFrame.BackgroundTransparency = 0.1
keyFrame.Parent = screenGui

local keyCorner = Instance.new("UICorner")
keyCorner.CornerRadius = UDim.new(0, 16)
keyCorner.Parent = keyFrame

local keyTitle = Instance.new("TextLabel")
keyTitle.Size = UDim2.new(1, 0, 0, 45)
keyTitle.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
keyTitle.Text = "🔐 ВВЕДИТЕ КЛЮЧ"
keyTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
keyTitle.TextSize = 15
keyTitle.Font = Enum.Font.GothamBold
keyTitle.Parent = keyFrame

local keyInput = Instance.new("TextBox")
keyInput.Size = UDim2.new(0.8, 0, 0, 38)
keyInput.Position = UDim2.new(0.1, 0, 0.35, 0)
keyInput.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
keyInput.Text = ""
keyInput.PlaceholderText = "Введите ключ"
keyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
keyInput.PlaceholderColor3 = Color3.fromRGB(150, 150, 170)
keyInput.TextSize = 13
keyInput.Font = Enum.Font.Gotham
keyInput.BorderSizePixel = 0
keyInput.Parent = keyFrame

keyInput:GetPropertyChangedSignal("Text"):Connect(onKeyInputChange)

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 8)
inputCorner.Parent = keyInput

local submitBtn = Instance.new("TextButton")
submitBtn.Size = UDim2.new(0.8, 0, 0, 40)
submitBtn.Position = UDim2.new(0.1, 0, 0.7, 0)
submitBtn.BackgroundColor3 = Color3.fromRGB(0, 130, 80)
submitBtn.Text = "РАЗБЛОКИРОВАТЬ"
submitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
submitBtn.TextSize = 13
submitBtn.Font = Enum.Font.GothamBold
submitBtn.BorderSizePixel = 0
submitBtn.Parent = keyFrame

local submitCorner = Instance.new("UICorner")
submitCorner.CornerRadius = UDim.new(0, 8)
submitCorner.Parent = submitBtn

local errorLabel = Instance.new("TextLabel")
errorLabel.Size = UDim2.new(0.8, 0, 0, 22)
errorLabel.Position = UDim2.new(0.1, 0, 0.58, 0)
errorLabel.BackgroundTransparency = 1
errorLabel.Text = ""
errorLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
errorLabel.TextSize = 11
errorLabel.Font = Enum.Font.Gotham
errorLabel.Visible = false
errorLabel.Parent = keyFrame

local function showError(text)
    errorLabel.Text = text
    errorLabel.Visible = true
    task.delay(1.5, function()
        errorLabel.Visible = false
    end)
end

local function unlockAll()
    keyVerified = true
    for _, item in ipairs(toggleButtons) do
        item.btn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        item.btn.Text = "ВЫКЛ"
    end
    for _, item in ipairs(tgkButtons) do
        item.btn.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
        item.btn.Text = "📢 " .. item.name
    end
    TweenService:Create(keyFrame, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
    TweenService:Create(overlay, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
    task.wait(0.2)
    keyFrame.Visible = false
    overlay.Visible = false
    game.StarterGui:SetCore("SendNotification", {
        Title = "VANEZY x MANscript",
        Text = "✅ Функции разблокированы!",
        Duration = 2
    })
end

submitBtn.MouseButton1Click:Connect(function()
    local inputKey = string.upper(string.gsub(keyInput.Text, "[^%w]", ""))
    if inputKey == CORRECT_KEY then
        unlockAll()
    else
        attempts = attempts + 1
        if attempts >= 3 then
            showError("❌ Лимит попыток! Перезапустите скрипт")
            submitBtn.Visible = false
            keyInput.Visible = false
        else
            showError("❌ Неверный ключ! Осталось: " .. (3 - attempts))
        end
    end
end)

keyInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local inputKey = string.upper(string.gsub(keyInput.Text, "[^%w]", ""))
        if inputKey == CORRECT_KEY then
            unlockAll()
        else
            attempts = attempts + 1
            if attempts >= 3 then
                showError("❌ Лимит попыток! Перезапустите скрипт")
                submitBtn.Visible = false
                keyInput.Visible = false
            else
                showError("❌ Неверный ключ! Осталось: " .. (3 - attempts))
            end
        end
    end
end)

-- Анимация
keyFrame.BackgroundTransparency = 1
keyFrame.Position = UDim2.new(0.5, -140, 0.5, -110)
TweenService:Create(keyFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
    BackgroundTransparency = 0.1,
    Position = UDim2.new(0.5, -140, 0.5, -90)
}):Play()

-- Фоновые циклы
task.spawn(function()
    while true do
        if keyVerified then
            if espEnabled then updateESP() end
            if autoGunEnabled then autoGrabWithReturn() end
            if speedEnabled then
                local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
                if hum then hum.WalkSpeed = speedValue end
            end
        end
        task.wait(0.3)
    end
end)

Players.PlayerAdded:Connect(function() if espEnabled and keyVerified then task.wait(0.5); updateESP() end end)
Players.PlayerRemoving:Connect(function() if espEnabled and keyVerified then updateESP() end end)
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.2)
    if speedEnabled and keyVerified then
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
        if hum then hum.WalkSpeed = speedValue end
    end
    if espEnabled and keyVerified then task.wait(0.5); updateESP() end
    if godModeEnabled and keyVerified then enableGodMode() end
end)

-- Перетаскивание меню
local dragWin = false
local dragStart = nil
local frameStart = nil

title.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
        dragWin = true
        dragStart = i.Position
        frameStart = main.Position
    end
end)

UserInputService.InputChanged:Connect(function(i)
    if dragWin and (i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseMovement) then
        local delta = i.Position - dragStart
        main.Position = UDim2.new(frameStart.X.Scale, frameStart.X.Offset + delta.X, frameStart.Y.Scale, frameStart.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then dragWin = false end
end)

-- Сворачивание
local minimized = false
local fullSize = main.Size
local fullPos = main.Position

closeBtn.MouseButton1Click:Connect(function()
    if minimized then
        minimized = false
        main.Size = fullSize
        main.Position = fullPos
        closeBtn.Text = "−"
        scroll.Visible = true
    else
        minimized = true
        main.Size = UDim2.new(0, 60, 0, 35)
        main.Position = UDim2.new(1, -70, 0, 60)
        closeBtn.Text = "+"
        scroll.Visible = false
    end
end)

print("VANEZY x MANscript v10.0 | Ожидание ключа...")
