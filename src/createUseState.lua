local function createUseState(component)
	return function(defaultValue)
		component.hookCounter += 1
		local hookCount = component.hookCounter
		local value = component.state[hookCount]

		-- TODO: This won't work if you explicitly set the state to nil.
		if value == nil then
			value = defaultValue
		end

		return value, function(newValue)
			component:setState({
				[hookCount] = newValue,
			})
		end
	end
end

return createUseState
