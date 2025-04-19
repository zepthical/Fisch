local Library = loadstring(game:HttpGetAsync("https://github.com/ActualMasterOogway/Fluent-Renewed/releases/latest/download/Fluent.luau"))()
local SaveManager = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ActualMasterOogway/Fluent-Renewed/master/Addons/SaveManager.luau"))()
local InterfaceManager = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ActualMasterOogway/Fluent-Renewed/master/Addons/InterfaceManager.luau"))()
 
local Window = Library:CreateWindow{
    Title = `Fluent {Library.Version}`,
    SubTitle = "by Cookie Hub ( Zepthical )",
    TabWidth = 160,
    Size = UDim2.fromOffset(830, 525),
    Resize = true, -- Resize this ^ Size according to a 1920x1080 screen, good for mobile users but may look weird on some devices
    MinSize = Vector2.new(470, 380),
    Acrylic = true, -- The blur may be detectable, setting this to false disables blur entirely
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightControl -- Used when theres no MinimizeKeybind
}


local Player = game:GetService("Players")
local LocalPlayer = Player.LocalPlayer
local Char = LocalPlayer.Character
local Humanoid = Char.Humanoid
local VirtualInputManager = game:GetService("VirtualInputManager")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GuiService = game:GetService("GuiService")

local Tabs = {
    Main = Window:CreateTab{
        Title = "Main",
        Icon = "phosphor-users-bold"
    },
    Settings = Window:CreateTab{
        Title = "Settings",
        Icon = "settings"
    }
}

local Options = Library.Options

local function equipitem(tool)
    if tool and tool:IsA("Tool") then
        Humanoid:EquipTool(tool)
    end
end

local function findrod()
    for _, v in pairs(LocalPlayer.Backpack:GetChildren()) do
        if v:IsA("Tool") and v.Name:lower():find("rod") then
            print("Rod found:", v.Name)
            return v
        end
    end
    return nil
end

-- equip rod
local Toggle = Tabs.Main:CreateToggle("EquipRod", {Title = "Auto Equip Rod", Default = false })

local autoEquip = false

Toggle:OnChanged(function(Value)
    autoEquip = Value -- update the flag when toggle is changed

    if autoEquip then
        task.spawn(function()
            while autoEquip do
                local Rod = findrod()
                equipitem(Rod)
                task.wait(0.5)
            end
        end)
    end
end)

local Toggle = Tabs.Main:CreateToggle("Cast", {Title = "Auto Cast", Default = false })

local autoCast = false

Toggle:OnChanged(function(Value)
    autoCast = Value

    if autoCast then
      task.spawn(function()
          while autoCast do
              local Rod = findrod()
              task.wait(0.5)
              Rod.events.cast:FireServer(100,1)
           end
       end)
    end
end)



InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/specific-game")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)


Window:SelectTab(1)

Library:Notify{
    Title = "Fluent",
    Content = "The script has been loaded.",
    Duration = 8
}
