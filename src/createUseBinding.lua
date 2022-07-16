local function createUseBinding(roact, useValue)
	return function<T>(defaultValue: T): (any, (newValue: T) -> ())
		return unpack(useValue({
			roact.createBinding(defaultValue)
		}).value)
	end
end

return createUseBinding
