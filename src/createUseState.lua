local NONE = {}

local function createUseState(component)
	return function(defaultValue)
		component.hookCounter += 1
		local hookCount = component.hookCounter
		local value = component.state[hookCount]

		if value == nil then
			value = defaultValue
		elseif value == NONE then
			value = nil
		end

		return value, function(newValue)
			if newValue == nil then
				newValue = NONE
			end

			component:setState({
				[hookCount] = newValue,
			})
		end
	end
end

return createUseState
