type Reducer<S, A> = (state: S, action: A) -> S

local function createUseReducer(useCallback, useState)
	return function<S, A>(reducer: Reducer<S, A>, initialState: S): (S, (action: A) -> ())
		local state, setState = useState(initialState)
		local dispatch = useCallback(function(action)
			setState(reducer(state, action))
		end, { state })

		return state, dispatch
	end
end

return createUseReducer
