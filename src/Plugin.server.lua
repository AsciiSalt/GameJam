local toolbar = plugin:CreateToolbar("DevShore")
local WidgetButton = toolbar:CreateButton("GameJam", "Toggle UI", "rbxassetid://6967019662")
local widgetInfo = DockWidgetPluginGuiInfo.new(Enum.InitialDockState.Float, false, false, 350, 350, 350, 50)
local widget = plugin:CreateDockWidgetPluginGui("GameJam", widgetInfo)
widget.Name = "GameJam"
widget.Title = "GameJam"
widget.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

WidgetButton.Click:Connect(function()
	widget.Enabled = not widget.Enabled
end)

---------------------------------------------------------
local Folder = script.Parent
local Roact = require(Folder.Roact)
local Rodux = require(Folder.Rodux)
local RoactRodux = require(Folder.RoactRodux)
local Reducer = require(Folder.Reducer)
local store = Rodux.Store.new(Reducer);

local app = require(Folder.app)
local AutoUIScale = require(Folder.app.Components.AutoUIScale)

local element = Roact.createElement(RoactRodux.StoreProvider, {
	store = store
}, {
	Roact.createFragment({
		Frame = Roact.createElement(app, { plugin = plugin }),
		UIScale = Roact.createElement(AutoUIScale, {}, {})
	})
})

local tree = Roact.mount(element, widget, "GameJam")

plugin.Unloading:Connect(function()
	Roact.unmount(tree)
end)