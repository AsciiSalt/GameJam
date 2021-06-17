return function(state, action)
	state = state or 1
	if action.type == "selectTheme" then
		return action.theme -- state + action.theme
	end

	return state
end