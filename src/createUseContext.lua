local function createUseContext(component, useEffect, useState)
	-- HACK: I'd like to just use the values from the consumers directly.
	-- However, we don't know what contexts to listen to until `useContext` is called.
	-- Thus, we do this insanely unstable method for doing it. :)
	local fakeConsumer = setmetatable({}, {
		__index = component,
	})

	return function(context)
		context.Consumer.init(fakeConsumer)

		local contextEntry = fakeConsumer.contextEntry
		local value, setValue = useState(contextEntry.value)

		useEffect(function()
			return contextEntry.onUpdate:subscribe(setValue)
		end, {})

		return value
	end
end

return createUseContext
