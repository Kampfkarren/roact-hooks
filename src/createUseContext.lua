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
		local value, setValue = useState(if contextEntry == nil then nil else contextEntry.value)

		useEffect(function()
			if contextEntry == nil then
				return
			end

			if value ~= contextEntry.value then
				setValue(contextEntry.value)
			end
			
			return contextEntry.onUpdate:subscribe(setValue)
		end, { contextEntry })

		return value
	end
end

return createUseContext
