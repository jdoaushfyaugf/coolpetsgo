-- Example Usage of Flera UI Library (No Key System)
local Flera = loadstring(game:HttpGet("https://raw.githubusercontent.com/jdoaushfyaugf/FleraUI/main/Flera.lua"))()

local mainWindow = Flera:CreateWindow({
    Title = "Test",
    ImageId = nil, -- No image
    KeyEnabled = false, -- Disable key system
    RequiredScriptName = "Testing" -- Replace with the required script name
})

local tab1 = mainWindow:AddTab("Tab 1")
tab1:AddButton("Button 1", function()
    print("Button 1 clicked!")
end)

tab1:AddSlider("Walkspeed", {
    Min = 0,
    Max = 100,
    Default = 0,
    Callback = function(value)
        print("Slider value: ", value)
    end
})

local tab2 = mainWindow:AddTab("Tab 2")
tab2:AddButton("Button 2", function()
    print("Button 2 clicked!")
end)