local selectTheme = require(script.selectTheme)

return function(state, action)
    state = state or {}
    return {
        selectTheme = selectTheme(state.selectTheme, action),
    }
end