local function createUseReducer(useCallback, useState)
	return function(reducer, initialState)
		local state, setState = useState(initialState)
		local dispatch = useCallback(function(action)
			setState(reducer(state, action))
		end, { state })

		return state, dispatch
	end
end

return createUseReducer
