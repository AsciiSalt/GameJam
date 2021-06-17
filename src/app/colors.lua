local colors = {
    days = {112, 187, 187},
    hours = {52, 186, 235},
    minutes = {172, 196, 51},
    seconds = {204, 184, 29},
    milliseconds = {204, 114, 29}
}
local metadata = { -- i got lazy
    __call = function(self, index)
        local color = colors[index]
        if color then
            return Color3.fromRGB(color[1], color[2], color[3])
        end
        return Color3.new(0, 0, 0)
    end
}
setmetatable(colors, metadata)
return colors