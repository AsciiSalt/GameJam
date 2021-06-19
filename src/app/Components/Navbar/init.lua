local Roact = require(script.Parent.Parent.Parent.Roact)
local RoactRodux = require(script.Parent.Parent.Parent.RoactRodux)
local Actions = require(script.Parent.Parent.Parent.Actions)

local Navbar = Roact.Component:extend("Navbar")

local function updateButtonsToCurrentPage(nav, UIPageLayout)
    if not UIPageLayout then return end

    local currentPage = UIPageLayout.CurrentPage
    if currentPage.Name == "SettingsFrame" then
        nav.updateSettingsPressed(Color3.fromRGB(129, 194, 214))
    else
        nav.updateSettingsPressed(Color3.fromRGB(255, 255, 255))
    end
    if currentPage.Name == "InfoFrame" then
        nav.updateInfoPressed(Color3.fromRGB(129, 194, 214))
    else
        nav.updateInfoPressed(Color3.fromRGB(255, 255, 255))
    end 
end

local function route(nav, UIPageLayout, name)
    if name == "info" then
        UIPageLayout:JumpToIndex(0)
    elseif name == "time" then
        UIPageLayout:JumpToIndex(1)
    end
    updateButtonsToCurrentPage(nav, UIPageLayout)
end

function Navbar:init()
    self.SettingsButton = Roact.createRef()
    --
    self.settingsPressed, self.updateSettingsPressed = Roact.createBinding(Color3.fromRGB(255,255,255));
    self.infoPressed, self.updateInfoPressed = Roact.createBinding(Color3.fromRGB(255,255,255));
    --
    self.hoverSettings, self.updateHoverSettings = Roact.createBinding(0)
    self.hoverInfo, self.updateHoverInfo = Roact.createBinding(0)
end

function Navbar:render()
    return Roact.createElement("Frame", {
        Size = UDim2.new(1,0,0,100),
        Position = UDim2.new(0,0,0,-100),
        BackgroundTransparency = 1,
        [Roact.Ref] = self.props.navbar
    }, {
        UIGridLayout = Roact.createElement('UIGridLayout', {
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
            CellSize = UDim2.fromOffset(80, 80)
        }),
        UIPadding = Roact.createElement('UIPadding', {
            PaddingTop = UDim.new(0,15),
            PaddingRight = UDim.new(0,15)
        }),
        SettingsButton = Roact.createElement("ImageButton", {
            Size = UDim2.new(0,65,0,65),
            Position = UDim2.new(1,-70, 0, 5),
            Image = "rbxassetid://6967020365",
            BackgroundTransparency = 1,
            ImageColor3 = self.settingsPressed:map(function(value: Color3)
                return value
            end),
            ImageTransparency = self.hoverSettings:map(function(value: number)
                return value
            end),
            [Roact.Event.MouseEnter] = function(rbx, x, y)
                self.updateHoverSettings(0.8)
            end,
            [Roact.Event.MouseLeave] = function(rbx, x, y)
                self.updateHoverSettings(0)
            end,
            [Roact.Event.Activated] = function(rbx)
                local UIPageLayout = self.props.UIPageLayout:getValue()
                if not UIPageLayout then
                    return
                end

                if self.props.selectTheme == 1 then
                    self.props.changeTheme(2)
                else
                    self.props.changeTheme(1)
                end
                --[[ Too lazy to finish settings page. Ill probably do it later..
                if (UIPageLayout.CurrentPage.Name ~= "SettingsFrame") then
                    route(self, UIPageLayout, "settings")
                else
                    route(self, UIPageLayout, "time")
                end
                ]]
            end,
            [Roact.Ref] = self.SettingsButton
        }),
        InfoButton = Roact.createElement("ImageButton", {
            Size = UDim2.new(0,65,0,65),
            Position = UDim2.new(1,-70, 0, 5),
            Image = "rbxassetid://6294110112",
            BackgroundTransparency = 1,
            ImageColor3 = self.infoPressed:map(function(value: Color3)
                return value
            end),
            ImageTransparency = self.hoverInfo:map(function(value: number)
                return value
            end),
            [Roact.Event.MouseEnter] = function(rbx, x, y)
                self.updateHoverInfo(0.8)
            end,
            [Roact.Event.MouseLeave] = function(rbx, x, y)
                self.updateHoverInfo(0)
            end,
            [Roact.Event.Activated] = function(rbx)
                local UIPageLayout = self.props.UIPageLayout:getValue()
                if not UIPageLayout then
                    return
                end
                if (UIPageLayout.CurrentPage.Name ~= "InfoFrame") then
                    route(self, UIPageLayout, "info")
                else
                    route(self, UIPageLayout, "time")
                end
            end,
            [Roact.Ref] = self.InfoButton
        })
    })
end

local function mapStateToProps(state, props)
	return {
		selectTheme = state.selectTheme
	}
end

local function mapDispatchToProps(dispatch)
	return {
		changeTheme = function(theme)
            dispatch(Actions.selectTheme(theme))
        end,
	}
end

return RoactRodux.connect(mapStateToProps, mapDispatchToProps)(Navbar)