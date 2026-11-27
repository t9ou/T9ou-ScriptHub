local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/i77lhm/Libraries/refs/heads/main/Utopia/Library.lua"))()

local Window = Library:Window({
    Name = "T 9 O U | Arsenal",
    GradientTitle = {
        Enabled = true,
        Start = Color3.fromRGB(255, 255, 255),
        Middle = Color3.fromRGB(0, 251, 255),
        End = Color3.fromRGB(50, 135, 168),
        Speed = 1
    }
})
--=================================
-- Aimbot
--=================================
do
local AimbotKeyMode = "Hold"
local targetpart = {"Head", "Torso", "HumanoidRootPart"}

    local AimbotTab = Window:Page({Name = "Aimbot", Columns = 2})
    
    local AimbotSection = AimbotTab:Section({Name = "Aimbot", Side = 1})
    
    local AimbotSwitch = AimbotSection:Toggle({
        Name = "Enable Aimbot",
        Default = false,
        Flag = "Toggle",
        Risky = true,
        Callback = function(v)
            print("Aimbot:".. tostring(v))
        end
    })

    local AimbotKeyBind = AimbotSection:Label("Aimbot Key", "Left"):Keybind({
        Name = "Aimbot Key",
        Flag = "AimbotKey",
        Default = Enum.KeyCode.E,
        Mode = AimbotKeyMode,
        Callback = function(v) end
    })

    local KeybindMode = AimbotSection:Dropdown({
        Name = "Aimbot Key Mode",
        Flag = "AimbotKeyMode",
        Items = {"Hold", "Toggle"},
        Multi = false,
        Default = "Hold",
        Callback = function(v) 
            AimbotKeyMode = v
            print("Keybind Mode: " .. v)
        end
    })

    local TargetPart = AimbotSection:Dropdown({
        Name = "Target Part:",
        Flag = "TargetPart",
        Items = targetpart,
        Multi = false,
        Default = targetpart,
        Callback = function(v) 
            print("Target Part:" .. tostring(v))
        end
    })

    local AimbotSmoothness = AimbotSection:Slider({
        Name = "Aimbot Smoothness",
        Flag = "AimbotSmoothing",
        Min = 0,
        Default = 0,
        Max = 100,
        Suffix = "%",
        Decimals = 1,
        Callback = function(v) 
            print("Aimbot Smoothness:".. tostring(v))
        end
    })

    local AimbotPrediction = AimbotSection:Slider({
        Name = "Aimbot Prediction",
        Flag = "AimbotPrediction",
        Min = 0,
        Default = 0,
        Max = 100,
        Suffix = "%",
        Decimals = 1,
        Callback = function(v) 
            print("Aimbot Prediction:".. tostring(v))
        end
    })

    local TeamCheck = AimbotSection:Toggle({
        Name = "Team Check",
        Default = false,
        Flag = "TeamCheck",
        Risky = true,
        Callback = function(v) 
            print("Team Check:".. tostring(v))
        end
    })

    local VisibleCheck = AimbotSection:Toggle({
        Name = "Visible Check",
        Default = false,
        Flag = "VisibleCheck",
        Risky = true,
        Callback = function(v) 
            print("Visible Check:".. tostring(v))
        end
    })

    local IgnoreDead = AimbotSection:Toggle({
        Name = "Ignore Dead",
        Default = false,
        Flag = "IgnoreDead",
        Risky = true,
        Callback = function(v) 
            print("Ignore Dead:".. tostring(v))
        end
    })
end