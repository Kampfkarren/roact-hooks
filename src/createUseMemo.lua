local dependenciesDifferent = require(script.Parent.dependenciesDifferent)

local function createUseMemo(useValue)
	return function(createValue, dependencies)
		local currentValue = useValue(nil)

		local needToRecalculate = dependencies == nil

		if currentValue.value == nil or dependenciesDifferent(dependencies, currentValue.value.dependencies) then
			needToRecalculate = true
		end

		if needToRecalculate then
			currentValue.value = {
				dependencies = dependencies,
				memoizedValue = { createValue() },
			}
		end

		return unpack(currentValue.value.memoizedValue)
	end
end

return createUseMemo
