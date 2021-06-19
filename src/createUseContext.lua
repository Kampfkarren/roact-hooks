local function createUseContext(component)
	return function(context)
		if component.contexts == nil then
			component.contexts = {}
		end

		component.contexts[context] = true

		-- HACK: I'd like to just use the values from the consumers directly.
		-- However, we don't know what contexts to listen to until `useContext` is called.
		local contextEntry = component:__getContext(context.key)
		if contextEntry == nil then
			return contextEntry.value
		else
			return context.defaultValue
		end
	end
end

return createUseContext
