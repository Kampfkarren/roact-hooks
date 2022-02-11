local function createUseMemo(useValue)
	return function(createValue, dependencies)
		local currentValue = useValue(nil)

		local needToRecalculate = dependencies == nil

		if currentValue.value == nil then
			-- Defers calling of `createValue()` unless it is necessary.
			needToRecalculate = true
		elseif needToRecalculate == false then
			for index, dependency in pairs(dependencies) do
				if dependency ~= currentValue.value.dependencies[index] then
					needToRecalculate = true
					break
				end
			end
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
