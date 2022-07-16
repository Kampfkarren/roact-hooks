type DependencyList = { unknown }
type Function<Args..., Rets...> = (Args...) -> Rets...

local function createUseCallback(useMemo)
	return function<Args..., Rets...>(callback: Function<Args..., Rets...>, dependencies: DependencyList?): Function<Args..., Rets...>
		return useMemo(function()
			return callback
		end, dependencies)
	end
end

return createUseCallback
