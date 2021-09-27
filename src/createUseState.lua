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
			local storedDefaultValue = component.defaultStateValues[hookCount]
			if storedDefaultValue == NONE then
				value = nil
			elseif storedDefaultValue ~= nil then
				value = storedDefaultValue
			elseif type(defaultValue) == "function" then
				value = defaultValue()

				if value == nil then
					component.defaultStateValues[hookCount] = NONE
				else
					component.defaultStateValues[hookCount] = value
				end
			else
				value = defaultValue
				component.defaultStateValues[hookCount] = value
			end
		elseif value == NONE then
			value = nil
		end

		local setValue = setValues[hookCount]
		if setValue == nil then
			setValue = function(newValue)
				local currentValue = component.state[hookCount]

				if currentValue == nil then
					currentValue = component.defaultStateValues[hookCount]
				end

				if currentValue == NONE then
					currentValue = nil
				end

				newValue = extractValue(newValue, currentValue)

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
