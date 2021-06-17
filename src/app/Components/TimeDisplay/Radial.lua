-- https://devforum.roblox.com/t/circular-radial-progress/454443
-- loy_i devforum post is how I got the method for using gradients to make a radial ui
local Roact = require(script.Parent.Parent.Parent.Parent.Roact)
local RoactRodux = require(script.Parent.Parent.Parent.Parent.RoactRodux)
local colors = require(script.Parent.Parent.Parent.colors)
local Actions = require(script.Parent.Parent.Parent.Parent.Actions)

function Radial(props)
    local label: string = (props.label ~= nil) and props.label or ""
    local value: number = (props.value ~= nil) and props.value or 0
    local percent: number = (props.percent ~= nil) and props.percent or 0
    local transparency: number = (props.transparency ~= nil) and props.transparency or 0

    local rotation = math.clamp(percent * 360, 0, 360)

    return Roact.createElement('Frame', {
        Size = UDim2.new(0, 50, 0, 50),
        Position = UDim2.new(0.5, -25, 0.5, -25),
        BackgroundTransparency = 1,
        LayoutOrder = props.layout
    }, {
        frame1 = Roact.createElement('Frame', {
            Size = UDim2.fromScale(0.5, 1),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ClipsDescendants = true
        }, {
            image = Roact.createElement('ImageButton', {
                Image = "rbxassetid://3587367081",
                Size = UDim2.fromScale(2, 1),
                BackgroundTransparency = 1
            }, {
                gradient = Roact.createElement('UIGradient', {
                    Rotation = math.clamp(rotation, 179, 360),
                    Transparency = NumberSequence.new({
                        NumberSequenceKeypoint.new(0, transparency),
                        NumberSequenceKeypoint.new(0.5, transparency),
                        NumberSequenceKeypoint.new(0.502, transparency), -- missing
                        NumberSequenceKeypoint.new(1, transparency) -- missing
                    }),
                    Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, colors(label:lower())), 
                        ColorSequenceKeypoint.new(0.5, colors(label:lower())), 
                        ColorSequenceKeypoint.new(0.502, Color3.fromRGB(0,0,0)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(0,0,0))
                    })
                })
            })
        }),
        frame2 = Roact.createElement('Frame', {
            Size = UDim2.fromScale(0.5, 1),
            Position = UDim2.fromScale(0.5, 0),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ClipsDescendants = true
        },{
            image = Roact.createElement('ImageLabel', {
                Image = "rbxassetid://3587367081",
                Size = UDim2.fromScale(2, 1),
                Position = UDim2.fromScale(-1, 0),
                BackgroundTransparency = 1
            }, {
                gradient = Roact.createElement('UIGradient', {
                    Rotation = math.clamp(rotation, 0, 180),
                    Transparency = NumberSequence.new({
                        NumberSequenceKeypoint.new(0,transparency),
                        NumberSequenceKeypoint.new(0.5,transparency),
                        NumberSequenceKeypoint.new(0.502,transparency), -- missing
                        NumberSequenceKeypoint.new(1,transparency) -- missing
                    }),
                    Color = ColorSequence.new({ 	
                        ColorSequenceKeypoint.new(0, colors(label:lower())), 
                        ColorSequenceKeypoint.new(0.5, colors(label:lower())), 
                        ColorSequenceKeypoint.new(0.502, Color3.fromRGB(0,0,0)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(0,0,0))
                    })
                })
            })
        }),
        textLabel = Roact.createElement('TextLabel', {
            Text = label,
            Size = UDim2.new(1, 0, 0, 20),
            Position = UDim2.new(0, 0, 1, 5),
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Center,
            TextYAlignment = Enum.TextYAlignment.Top,
            TextColor3 = colors(label:lower()),
            TextScaled = true
        }, {
            uiTextSizeConstraint = Roact.createElement('UITextSizeConstraint', {
                MaxTextSize = 15,
                MinTextSize = 8
            })
        }),
        counterLabel = Roact.createElement('TextLabel', {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Text = tostring(value),
            Size = UDim2.new(0, 50, 0, 50),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Center,
            TextYAlignment = Enum.TextYAlignment.Center,
            TextColor3 = colors(label:lower()),
            TextScaled = true
        }, {
            uiTextSizeConstraint = Roact.createElement('UITextSizeConstraint', {
                MaxTextSize = 15,
                MinTextSize = 7
            })
        })
    })
end

return Radial