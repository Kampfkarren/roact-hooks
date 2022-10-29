local function createUseContext(component, useEffect, useState)
	-- HACK: I'd like to just use the values from the consumers directly.
	-- However, we don't know what contexts to listen to until `useContext` is called.
	-- Thus, we do this insanely unstable method for doing it. :)
	local fakeConsumer = setmetatable({}, {
		__index = component,
	})

	return function(context)
		local defaultValue

		fakeConsumer.props = {
			render = function(value)
				defaultValue = value
			end,
		}

		context.Consumer.init(fakeConsumer)
		context.Consumer.render(fakeConsumer)

		local contextEntry = fakeConsumer.contextEntry
		local value, setValue = useState(if contextEntry == nil then defaultValue else contextEntry.value)

		useEffect(function()
			if contextEntry == nil then
				if value ~= defaultValue then
					setValue(defaultValue)
				end
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
