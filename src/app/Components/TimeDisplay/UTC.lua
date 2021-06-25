local TweenService = game:GetService("TweenService")
local Roact = require(script.Parent.Parent.Parent.Parent.Roact)
local colors = require(script.Parent.Parent.Parent.colors)

local UTC = Roact.Component:extend("TimeDisplay")

function UTC:init()
    self.label = Roact.createRef()
end

function UTC:render()
    local props = self.props
    local days: number = (props.days ~= nil) and props.days or 0
    local hours: number = (props.hours ~= nil) and props.hours or 0
    local minutes: number = (props.minutes ~= nil) and props.minutes or 0
    local seconds: number = (props.seconds ~= nil) and props.seconds or 0

    return Roact.createElement('Frame', {
        Size = UDim2.new(1, 0, 1, 0),
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
    },{
        timeLabel = Roact.createElement('TextLabel', {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Center,
            TextYAlignment = Enum.TextYAlignment.Center,
            RichText = true,
            Text =  '<font color="rgb(' .. table.concat(colors.days, ",") .. ')">' .. tostring(days) .. '</font>:' ..
                        '<font color="rgb(' .. table.concat(colors.hours, ",") .. ')">' .. (hours < 10 and "0"..tostring(hours) or tostring(hours)) .. '</font>:' ..
                        '<font color="rgb(' .. table.concat(colors.minutes, ",") .. ')">' .. (minutes < 10 and "0"..tostring(minutes) or tostring(minutes)) .. '</font>:' ..
                        '<font color="rgb(' .. table.concat(colors.seconds, ",") .. ')">' .. (seconds < 10 and "0"..tostring(seconds) or tostring(seconds)) .. '</font>',
            TextScaled = true,
            TextColor3 = Color3.fromRGB(255,255,255),
            Font = Enum.Font.RobotoMono
        }, {
            uiTextSizeConstraint = Roact.createElement('UITextSizeConstraint', {
                MaxTextSize = 25,
                MinTextSize = 4
            })
        }),
        label = Roact.createElement('TextLabel', {
            Size = UDim2.new(1, 0, 0, 25),
            Position = UDim2.new(0, 0, 1, 0),
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Center,
            TextYAlignment = Enum.TextYAlignment.Bottom,
            RichText = true,
            Text = '<font color="rgb(' .. table.concat(colors.days, ",") .. ')">Day</font>:' ..
                        '<font color="rgb(' .. table.concat(colors.hours, ",") .. ')">Hour</font>:' ..
                        '<font color="rgb(' .. table.concat(colors.minutes, ",") .. ')">Min</font>:' ..
                        '<font color="rgb(' .. table.concat(colors.seconds, ",") .. ')">Sec</font>',
            TextScaled = true,
            TextColor3 = Color3.fromRGB(255,255,255),
            Font = Enum.Font.RobotoMono,
            [Roact.Ref] = self.label
        }, {
            uiTextSizeConstraint = Roact.createElement('UITextSizeConstraint', {
                MaxTextSize = 25,
                MinTextSize = 13
            })
        }),
    })
end

function UTC:didMount()
    local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false, 0)
    self.tweenOpen = TweenService:Create(self.label:getValue(), tweenInfo, {Position = UDim2.new(0,0,1,-25)})
    self.tweenClose = TweenService:Create(self.label:getValue(), tweenInfo, {Position =  UDim2.new(0,0,1,0)})
end

return UTC