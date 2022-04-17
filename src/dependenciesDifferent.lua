local function dependenciesDifferent(dependencies, lastDependencies)
	local length = 0

	for index, dependency in pairs(dependencies) do
		length += 1

		if dependency ~= lastDependencies[index] then
			return true
		end
	end

	for _ in pairs(lastDependencies) do
		length -= 1
	end

	if length ~= 0 then
		return true
	end

	return false
end

return dependenciesDifferent
