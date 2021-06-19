local function createUseState(component)
	return function(defaultValue)
		-- TODO: This won't work if you have multiple useState on the same line.
		-- That's kind of funny.
		local identity, line = debug.info(2, "fl")
		local value = component.state[identity] and component.state[identity][line]

		-- TODO: This won't work if you explicitly set the state to nil.
		if value == nil then
			value = defaultValue
		end

		return value, function(newValue)
			local newStateForIdentity = {}

			if component.state[identity] ~= nil then
				for key, otherValue in pairs(component.state[identity]) do
					newStateForIdentity[key] = otherValue
				end
			end

			newStateForIdentity[line] = newValue

			component:setState({
				[identity] = newStateForIdentity,
			})
		end
	end
end

return createUseState
