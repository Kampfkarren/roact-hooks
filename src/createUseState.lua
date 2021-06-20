local NONE = {}

local function extractValue(valueOrCallback)
	if type(valueOrCallback) == "function" then
		return valueOrCallback()
	else
		return valueOrCallback
	end
end

local function createUseState(component)
	return function(defaultValue)
		component.hookCounter += 1
		local hookCount = component.hookCounter
		local value = component.state[hookCount]

		if value == nil then
			value = extractValue(defaultValue)
		elseif value == NONE then
			value = nil
		end

		return value, function(newValue)
			newValue = extractValue(newValue)

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
