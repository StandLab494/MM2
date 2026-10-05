-- =====================================================
--          KEY SYSTEM - The Strongest Battlegrounds
-- =====================================================

-- 🔑 КЛЮЧ
local VALID_KEYS = {
    ["ScriptDelta"] = true,
}

-- ⚙️ НАСТРОЙКИ
local SAVE_KEY = true
local KEY_FILE = "sumit_key.txt"

-- =====================================================
--          GUI ДЛЯ ВВОДА КЛЮЧА
-- =====================================================

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

-- Проверка сохранённого ключа
if SAVE_KEY and isfile and isfile(KEY_FILE) then
    local savedKey = readfile(KEY_FILE)
    if VALID_KEYS[savedKey] then
        print("[Key System] Сохранённый ключ валиден, загружаем меню...")
    end
end

-- Создаём окно ввода ключа
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KeySystem"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 400, 0, 220)
Frame.Position = UDim2.new(0.5, -200, 0.5, -110)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 12)
Corner.Parent = Frame

local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(120, 80, 255)
Stroke.Thickness = 2
Stroke.Parent = Frame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Position = UDim2.new(0, 0, 0, 10)
Title.BackgroundTransparency = 1
Title.Text = "🔑 KEY SYSTEM"
Title.TextColor3 = Color3.fromRGB(180, 140, 255)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = Frame

local Subtitle = Instance.new("TextLabel")
Subtitle.Size = UDim2.new(1, -20, 0, 20)
Subtitle.Position = UDim2.new(0, 10, 0, 55)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "Введите ключ для доступа"
Subtitle.TextColor3 = Color3.fromRGB(200, 200, 200)
Subtitle.TextScaled = true
Subtitle.Font = Enum.Font.Gotham
Subtitle.Parent = Frame

local TextBox = Instance.new("TextBox")
TextBox.Size = UDim2.new(1, -40, 0, 40)
TextBox.Position = UDim2.new(0, 20, 0, 90)
TextBox.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
TextBox.BorderSizePixel = 0
TextBox.Text = ""
TextBox.PlaceholderText = "Введите ключ..."
TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
TextBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 140)
TextBox.Font = Enum.Font.Gotham
TextBox.TextSize = 16
TextBox.ClearTextOnFocus = false
TextBox.Parent = Frame

local BoxCorner = Instance.new("UICorner")
BoxCorner.CornerRadius = UDim.new(0, 8)
BoxCorner.Parent = TextBox

local Button = Instance.new("TextButton")
Button.Size = UDim2.new(1, -40, 0, 40)
Button.Position = UDim2.new(0, 20, 0, 145)
Button.BackgroundColor3 = Color3.fromRGB(120, 80, 255)
Button.BorderSizePixel = 0
Button.Text = "ПОДТВЕРДИТЬ"
Button.TextColor3 = Color3.fromRGB(255, 255, 255)
Button.Font = Enum.Font.GothamBold
Button.TextSize = 16
Button.Parent = Frame

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 8)
BtnCorner.Parent = Button

local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1, -20, 0, 20)
Status.Position = UDim2.new(0, 10, 1, -25)
Status.BackgroundTransparency = 1
Status.Text = ""
Status.TextColor3 = Color3.fromRGB(255, 100, 100)
Status.TextScaled = true
Status.Font = Enum.Font.Gotham
Status.Parent = Frame

-- =====================================================
--          МЕНЮ
-- =====================================================

local function loadMenu()
    local Library = loadstring(game:HttpGet("https://pastebin.com/raw/vff1bQ9F"))()
    local Window = Library.CreateLib("The Strongest Battlegrounds - SumitScripts", "DarkTheme")

    local Tab = Window:NewTab("Credits")
    local Section = Tab:NewSection("Owner - SumitScripts")
    local Section = Tab:NewSection("Modded By SumitScripts")
    local Section = Tab:NewSection("Like For More Updates")
    local Section = Tab:NewSection("Hello Fix Bugs Report In Discord")
    local Section = Tab:NewSection("Anyways Goodbye Enjoy The Script")

    local Tab = Window:NewTab("Main")
    local Section = Tab:NewSection("The Strongest Battlegrounds")

    Section:NewButton("Infinity Yield", "Speed, fly, jump etc", function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
        print("Infinity Yield загружен")
    end)

    Section:NewButton("Aimbot", "Привязка прицела к игрокам", function()
        loadstring(game:HttpGet("https://pastebin.com/raw/1Gp9c57U"))()
        print("Aimbot загружен")
    end)

    Section:NewButton("Killer Hub (обновленная)", "Без клавиш, скорость, ранг", function()
        loadstring(game:HttpGet("https://pastefy.app/74w2zF6p/raw", true))()
        print("Killer Hub загружен")
    end)

    Section:NewSlider("WalkSpeed", "Увеличивает скорость бега", 500, 0, function(s)
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChildOfClass("Humanoid") then
            char.Humanoid.WalkSpeed = s
        end
    end)

    Section:NewSlider("JumpPower", "Увеличивает силу прыжка", 500, 0, function(s)
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChildOfClass("Humanoid") then
            char.Humanoid.UseJumpPower = true
            char.Humanoid.JumpPower = s
        end
    end)

    Section:NewButton("infjump (fly)", "Бесконечный прыжок", function()
        local infjmp = true
        game:GetService("UserInputService").jumpRequest:Connect(function()
            if infjmp then
                local char = game.Players.LocalPlayer.Character
                if char and char:FindFirstChildOfClass("Humanoid") then
                    char:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
                end
            end
        end)
        print("infjump активирован")
    end)
end

-- =====================================================
--          ЛОГИКА ПРОВЕРКИ КЛЮЧА
-- =====================================================

Button.MouseButton1Click:Connect(function()
    local inputKey = TextBox.Text

    if VALID_KEYS[inputKey] then
        Status.TextColor3 = Color3.fromRGB(100, 255, 100)
        Status.Text = "✅ Ключ верный! Загрузка..."
        Button.Text = "ЗАГРУЗКА..."
        Button.BackgroundColor3 = Color3.fromRGB(80, 200, 80)

        if SAVE_KEY and writefile then
            pcall(function()
                writefile(KEY_FILE, inputKey)
            end)
        end

        task.wait(0.7)
        ScreenGui:Destroy()
        loadMenu()
    else
        Status.TextColor3 = Color3.fromRGB(255, 100, 100)
        Status.Text = "❌ Неверный ключ! Попробуйте снова."
        TextBox.Text = ""

        local origPos = Frame.Position
        for i = 1, 6 do
            Frame.Position = origPos + UDim2.new(0, (i % 2 == 0 and 10 or -10), 0, 0)
            task.wait(0.05)
        end
        Frame.Position = origPos
    end
end)

TextBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        Button:Activate()
    end
end)
