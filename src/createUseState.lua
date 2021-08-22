local NONE = {}

local function extractValue(valueOrCallback, currentValue)
	if type(valueOrCallback) == "function" then
		return valueOrCallback(currentValue)
	else
		return valueOrCallback
	end
end

local function createUseState(component)
	local setValues = {}

	return function(defaultValue)
		component.hookCounter += 1
		local hookCount = component.hookCounter
		local value = component.state[hookCount]

		if value == nil then
			value = extractValue(defaultValue, nil)
		elseif value == NONE then
			value = nil
		end
		
		component.state[hookCount] = value
		
		local setValue = setValues[hookCount]
		if setValue == nil then
			setValue = function(newValue)
				newValue = extractValue(newValue, component.state[hookCount])

				if newValue == nil then
					newValue = NONE
				end

				component:setState({
					[hookCount] = newValue,
				})
			end

			setValues[hookCount] = setValue
		end

		return value, setValue
	end
end

return createUseState
