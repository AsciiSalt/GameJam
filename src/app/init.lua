local TweenService = game:GetService('TweenService')
local HttpService = game:GetService('HttpService')
local Roact = require(script.Parent.Roact)
local RoactRodux = require(script.Parent.RoactRodux)

local App = Roact.PureComponent:extend("App")
local Components = {
    TimeDisplay = require(script.Components.TimeDisplay),
    InfoFrame = require(script.Components.InfoFrame),
    Navbar = require(script.Components.Navbar)
}

local url = "https://devshore-gamejam.alexop1000.repl.co/"
local poll = true
local updateTime = 5 -- how long to wait to update data from api.
local defaultObjective = [[Your <font color="rgb(255,100,255)">task</font> should be displayed here.]]
function App:init()
    self:setState({
        startDate = nil,
        concludeDate = nil,
        objective = defaultObjective
    })
    self.UIPageLayout = Roact.createRef()
    self.navbar = Roact.createRef()
end

function App:render()
    local startDate = self.state.startDate
    local concludeDate = self.state.concludeDate

    return Roact.createElement("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(39, 39, 39)
    },{
        Navbar = Roact.createElement(Components.Navbar, {
            UIPageLayout = self.UIPageLayout,
            navbar = self.navbar
        }),
        Pages = Roact.createElement('Frame', {
            Size = UDim2.fromScale(1,1),
            BackgroundTransparency = 1,
            [Roact.Event.MouseEnter] = function(rbx, x, y)
                if self.tweenOpen.PlaybackState == Enum.PlaybackState.Playing then 
                    return 
                end
                self.tweenOpen:Play()
            end,
            [Roact.Event.MouseLeave] = function(rbx, x, y)
                if self.tweenClose.PlaybackState == Enum.PlaybackState.Playing then 
                    return 
                end
                self.tweenClose:Play()
            end
        }, {
            InfoFrame = Roact.createElement(Components.InfoFrame, {objective = self.state.objective}),
            TimeDisplay = Roact.createElement(Components.TimeDisplay, {
                startDate = startDate,
                concludeDate = concludeDate,
                displayTheme = self.props.selectTheme
            }),
            UIPageLayout = Roact.createElement("UIPageLayout", {
                TweenTime = 0.25,
                Animated = false,
                FillDirection = Enum.FillDirection.Vertical,
                EasingStyle = Enum.EasingStyle.Sine,
                EasingDirection = Enum.EasingDirection.InOut,
                ScrollWheelInputEnabled = false,
                SortOrder = Enum.SortOrder.LayoutOrder,
                [Roact.Ref] = self.UIPageLayout
            })
        })
    })
end

function App:didMount()
    self.UIPageLayout:getValue():JumpToIndex(1); -- Set current page to the timer on startup.
    local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false, 0)
    self.tweenOpen = TweenService:Create(self.navbar:getValue(), tweenInfo, {Position = UDim2.new(0,0,0,5)})
    self.tweenClose = TweenService:Create(self.navbar:getValue(), tweenInfo, {Position =  UDim2.new(0,0,0,-100)})
    
    local function request(endpoint: string)
        local success, response = pcall(function()
            local response = HttpService:RequestAsync(
                {
                    Url = url .. endpoint,
                    Method = "POST",
                    Headers = {
                        ["Content-Type"] = "application/json"
                    }
                }
            )
            return response
        end)

        if response.StatusCode == 200 then
            return response
        end
        return nil
    end

    coroutine.wrap(function()
        while ( poll == true ) do
            local startDate = Roact.None
            local concludeDate = Roact.None
            local objective = Roact.None

            do
                local response = request("/startDate")
                if response and response.StatusCode == 200 then
                    startDate = tonumber(response.Body)
                else
                    startDate = Roact.None
                end
            end

            do
                local response = request("/concludeDate")
                if response and response.StatusCode == 200 then
                    concludeDate = tonumber(response.Body)
                else
                    concludeDate = Roact.None
                end
            end

            do
                local response = request("/objective")
                if response and response.StatusCode == 200 then
                    objective = response.Body
                else
                    objective = defaultObjective
                end
            end

            if self.state.startDate ~= startDate or self.state.concludeDate ~= concludeDate or self.state.objective ~= objective then
                self:setState({
                    startDate = startDate,
                    concludeDate = concludeDate,
                    objective = objective
                })
            end
            wait(updateTime)
        end
    end)()

end

function App:willUnmount()
    poll = false
end

local function mapStateToProps(state, props)
	return {
		selectTheme = state.selectTheme
	}
end

return RoactRodux.connect(mapStateToProps)(App)