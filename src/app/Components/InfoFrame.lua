local Roact = require(script.Parent.Parent.Parent.Roact)

local InfoFrame = Roact.Component:extend("InfoFrame")

function InfoFrame:init()
    self.ScrollingFrame = Roact.createRef()
end

function InfoFrame:render()
    return Roact.createElement("ScrollingFrame", {
        Size = UDim2.new(1,0,1,0),
        BackgroundTransparency = 0.9,
        BackgroundColor3 = Color3.fromRGB(43, 42, 42),
        LayoutOrder = 0,
        CanvasSize = UDim2.new(0,0,0,0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        [Roact.Ref] = self.ScrollingFrame
    }, {
        label = Roact.createElement('TextLabel', {
            Size = UDim2.new(0.9, 0, 0.9, 0),
            Position = UDim2.new(0.05, 0, 0.05, 0),
            -- AutomaticSize = Enum.AutomaticSize.XY,
            BackgroundTransparency = 1,
            BackgroundColor3 = Color3.fromRGB(36, 156, 255),
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top,
            Font = Enum.Font.RobotoMono,
            RichText = true,
            Text =  self.props.objective,
            TextSize = 50,
            TextColor3 = Color3.fromRGB(255,255,255),
            TextWrapped = true
        })
    })
end

function InfoFrame:didMount()
end

return InfoFrame