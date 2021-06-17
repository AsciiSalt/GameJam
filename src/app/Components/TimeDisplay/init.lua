local TweenService = game:GetService('TweenService')
local Roact = require(script.Parent.Parent.Parent.Roact)
local osTime = os.time
local mathFloor = math.floor

local TimeDisplay = Roact.Component:extend("TimeDisplay")
local Components = {
    Radial = require(script.Radial),
    UTC = require(script.UTC)
}

local function getStatus(startDate, concludeDate)
    local status = ""
    local currentTime = osTime()

    if startDate == nil or concludeDate == nil then
        status = "Offline"
        return status
    end

    if currentTime < startDate then
        status = 'Game Jam begins in..'
    elseif currentTime >= startDate and currentTime < concludeDate then
        status = 'Game Jam ends in..'
    elseif currentTime >= concludeDate then
        status = 'There is currently no Game Jam.'
    end
    return status
end

function TimeDisplay:init()
    self:setState({
        days = 0,
        hours = 0,
        minutes = 0,
        seconds = 0,
        status = getStatus(self.props.startDate, self.props.concludeDate),
        startDate = self.props.startDate,
        concludeDate = self.props.concludeDate
    })
    self.label = Roact.createRef()
end

function TimeDisplay:render()
    local children = {}
    local selectedTheme: number = self.props.displayTheme
    if selectedTheme == 1 then
        children.UTCFrame = Roact.createElement(Components.UTC, {
            days = self.state.days,
            hours = self.state.hours,
            minutes = self.state.minutes,
            seconds = self.state.seconds
        })
    elseif selectedTheme == 2 then
        children.uiGrid = Roact.createElement("UIGridLayout", {
            CellPadding = UDim2.fromOffset(10, 10),
            CellSize = UDim2.fromOffset(175, 175),
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            SortOrder = Enum.SortOrder.LayoutOrder
        })
        children.padding = Roact.createElement("UIPadding", {
            PaddingTop = UDim.new(0, 5),
            PaddingBottom = UDim.new(0, 5),
            PaddingLeft = UDim.new(0, 5),
            PaddingRight = UDim.new(0, 5)
        })
        children.daysFrame = Roact.createElement(Components.Radial, { 
            label = "Days", 
            value = self.state.days,
            percent = (self.state.days/365),
            layout = 0
        })
        children.hoursFrame = Roact.createElement(Components.Radial, { 
            label = "Hours", 
            value = self.state.hours,
            percent = (self.state.hours/24),
            layout = 1
        })
        children.minutesFrame = Roact.createElement(Components.Radial, { 
            label = "Minutes", 
            value = self.state.minutes,
            percent = (self.state.minutes/60),
            layout = 2,
            transparency = 0.5
        })
        children.secondsFrame = Roact.createElement(Components.Radial, { 
            label = "Seconds", 
            value = self.state.seconds,
            percent = (self.state.seconds/60),
            layout = 3,
            transparency = 0.5
        })
    end

    return Roact.createElement("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0,0,0,0),
        BackgroundTransparency = 1,
        LayoutOrder = 1,
        ClipsDescendants = true,
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
        Label = Roact.createElement('TextLabel', {
            Size = UDim2.new(1, 0, 0, 25),
            Position = UDim2.new(0, 0, 0, -30),
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Bottom,
            RichText = true,
            Text =  '<font color="rgb(255, 255, 255)">Status</font>: ' ..
                    '<font color="rgb(236, 179, 44)">'.. self.state.status ..'</font>',
            TextScaled = true,
            TextColor3 = Color3.fromRGB(255,255,255),
            Font = Enum.Font.RobotoMono,
            [Roact.Ref] = self.label
        }, {
            uiTextSizeConstraint = Roact.createElement('UITextSizeConstraint', {
                MaxTextSize = 25,
                MinTextSize = 15
            })
        }),
        Roact.createElement("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1,0,1,0)
        }, children)
    })
end

function TimeDisplay:didMount()
    local startDate = self.props.startDate
    local concludeDate = self.props.concludeDate

    local function decideElapsed(): number
        local currentTime = osTime()
    
        if startDate == nil or concludeDate == nil then
            return 0
        end
    
        if currentTime < startDate then
            return startDate - currentTime
        elseif currentTime >= startDate and currentTime < concludeDate then
            return concludeDate - currentTime
        elseif currentTime >= concludeDate then
            return 0
        end

        return 0
    end

    local connection = game:GetService("RunService").RenderStepped:Connect(function(delta)
        if startDate ~= self.state.startDate or concludeDate ~= self.state.concludeDate then
            startDate = self.state.startDate
            concludeDate = self.state.concludeDate
        end
        if osTime() >= (concludeDate and concludeDate or 0) then
            wait()
            self:setState({
                days = 0,
                hours = 0,
                minutes = 0,
                seconds = 0,
                connection = nil,
                status = getStatus(startDate, concludeDate)
            })
            return
        end
        local elapsed = decideElapsed()
        local days    = mathFloor( elapsed / 86400 )
        local hours   = mathFloor( ( elapsed % 86400 ) / 3600 )
        local minutes = mathFloor( ( elapsed % 3600 ) / 60 )
        local seconds = mathFloor( elapsed % 60 )

        self:setState({
            days = days,
            hours = hours,
            minutes = minutes,
            seconds = seconds,
            status = getStatus(startDate, concludeDate)
        })
    end)

    local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false, 0)
    self.tweenOpen = TweenService:Create(self.label:getValue(), tweenInfo, {Position = UDim2.new(0,0,0,30)})
    self.tweenClose = TweenService:Create(self.label:getValue(), tweenInfo, {Position =  UDim2.new(0,0,0,-30)})

    self:setState({ connection = connection })
end

function TimeDisplay:didUpdate(previousProps, previousState)
    if previousProps.startDate == self.props.startDate  or previousProps.concludeDate == self.props.concludeDate then
        return
    end
    self:setState({
        startDate = self.props.startDate,
        concludeDate = self.props.concludeDate
    })
end

function TimeDisplay:willUnmount()
    if self.state.connection then
        self.state.connection:Disconnect()
    end
end

return TimeDisplay