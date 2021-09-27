# roact-hooks
An implementation of [React hooks](https://reactjs.org/docs/hooks-intro.html) for [Roact](https://github.com/Roblox/roact). Does not make any modifications to Roact itself.

## Example
```lua
local Hooks = require(ReplicatedStorage.Hooks)
local Roact = require(ReplicatedStorage.Roact)

-- `props` are our normal passed in properties.
-- `hooks` is passed in by roact-hooks itself.
local function Example(props, hooks)
	local count, setCount = hooks.useState(0)

	hooks.useEffect(function()
		print("the count is", count)
	end)

	return Roact.createElement(Button, {
		onClick = function()
			setCount(count + 1)
		end,

		text = count,
	})
end

-- This returns a component that you can call `Roact.createElement` with
Example = Hooks.new(Roact)(Example)
```

## API
### Hooks.new
```
Hooks.new(Roact: Roact) -> (render: (props, hooks) -> RoactComponent | nil, options?: {
	name?: string,
	defaultProps?: Map<any, any>,
	componentType?: string,
	validateProps?: (props) -> (false, message: string) | true,
}) -> RoactComponent)
```

It is required you pass in the Roact you are using, since you can't combine multiple versions of Roact together.

Returns a function that can be used to create a new Roact component with hooks. An optional dictionary can be passed in. The following are the valid keys that can be used, and what they do.

#### name
Refers to the name used in debugging. If it is not passed, it'll use the function name of what was passed in. For instance, `Hooks.new(Roact)(Component)` will have the component name `"Component"`.

#### defaultProps
Defines default values for props to ensure props will have values even if they were not specified by the parent component.

## Implemented Hooks

### useState
`useState<T>(defaultValue: T) -> (T, update: (newValue: T) -> void)`

Used to store a stateful value. Returns the current value, and a function that can be used to set the value.

### useEffect
`useEffect(callback: () -> (() -> void)?, dependencies?: any[])`

Used to perform a side-effect with a callback function.

This callback function can return a destructor. When the component unmounts or the dependencies change, this function will be called.

You can also pass in a list of dependencies to `useEffect`. If passed, then only when those dependencies change will the callback function be re-ran.

### useContext
`useContext(context: RoactContext<T>) -> T`

Returns the value of the [context](https://roblox.github.io/roact/advanced/context/).

### useValue
`useValue(value: T) -> { value: T }`

Similar to [useRef in React](https://reactjs.org/docs/hooks-reference.html#useref). Creates a table that you can mutate without re-rendering the component every time. Think of it like a class variable (`self.something = 1` vs. `self:setState({ something = 1 })`).

### useCallback
`useCallback<F: (...args: any[]) -> any>(callback: F, dependencies: any[]): F`

Returns a [memoized](https://en.wikipedia.org/wiki/Memoization) callback.

`useCallback(callback, dependencies)` is equivalent to `useMemo(function() return callback end, dependencies)`.

### useMemo
`useMemo(createValue: () -> T, dependencies: any[]): T`

Returns a [memoized](https://en.wikipedia.org/wiki/Memoization) value.

`useMemo` will only recalculate the inner value when the dependencies have changed.

The function passed to `useMemo` runs during rendering, so don't perform any side effects.

### useBinding
`useBinding(defaultValue: T) -> RoactBinding<T>, (newValue: T) -> void`

Returns a [memoized](https://en.wikipedia.org/wiki/Memoization) [binding](https://roblox.github.io/roact/advanced/bindings-and-refs/#bindings).

These can then be used just like normal bindings in Roact.

### useReducer
`useReducer(reducer: (state: T, action: A), initialState: T) -> (T, (action: A) -> void)`

An alternative to `useState` that uses a reducer rather than state directly. If you’re familiar with Rodux, you already know how this works.

```lua
local initialState = { count = 0 }

local function reducer(state, action)
	if action.type == "increment" then
		return {
			count = state.count + 1,
		}
	elseif action.type == "decrement" then
		return {
			count = state.count - 1,
		}
	else
		error("Unknown type: " .. tostring(action.type))
	end
end

local function Counter(_props, hooks)
	local state, dispatch = hooks.useReducer(reducer, initialState)

	return e(Frame, {}, {
		Counter = e(Text, {
			text = state.count,
		}),

		Increment = e(Button, {
			onClick = function()
				dispatch({
					type = "increment",
				})
			end,
		}),

		Decrement = e(Button, {
			onClick = function()
				dispatch({
					type = "decrement",
				})
			end,
		}),
	})
end
```

## Rules of Hooks
The rules of roact-hooks are the same as [those found in React](https://reactjs.org/docs/hooks-rules.html).

### Don't call hooks conditionally or in loops.
Call all hooks from the top level of your function. Do not use them in loops or conditions.

### Only call hooks from Roact functions.

You can only call hooks from:
- Roact function components
- Custom hooks (a function that begins with the word `use`)
