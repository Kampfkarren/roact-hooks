local function createUseBinding(roact, useValue)
	return function(defaultValue)
		return unpack(useValue({
			roact.createBinding(defaultValue)
		}).value)
	end
end

return createUseBinding
