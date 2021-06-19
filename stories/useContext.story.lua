local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Hooks = require(ReplicatedStorage.Hooks)
local Roact = require(ReplicatedStorage.Roact)

local e = Roact.createElement

local CounterContext1 = Roact.createContext()
local CounterContext2 = Roact.createContext()

local hook = Hooks.new(Roact)

local function Consumer(_props, hooks)
	local counter1 = hooks.useContext(CounterContext1)
	local counter2 = hooks.useContext(CounterContext2)

	return e("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
	}, {
		UIListLayout = e("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			Padding = UDim.new(0, 5),
			SortOrder = Enum.SortOrder.LayoutOrder,
		}),

		Counters = e("TextLabel", {
			BackgroundTransparency = 1,
			Font = Enum.Font.Code,
			LayoutOrder = 1,
			Size = UDim2.new(1, 0, 0, 38),
			Text = counter1.counter .. "/" .. counter2.counter,
			TextColor3 = Color3.new(0, 1, 0),
			TextSize = 32,
		}),

		IncrementCounter1 = e("TextButton", {
			BackgroundColor3 = Color3.new(1, 0, 0),
			Font = Enum.Font.Code,
			LayoutOrder = 2,
			Size = UDim2.new(1, 0, 0, 38),
			Text = "Increase counter 1",
			TextColor3 = Color3.new(1, 1, 1),
			TextScaled = true,
			[Roact.Event.Activated] = function()
				counter1.increment()
			end,
		}),

		IncrementCounter2 = e("TextButton", {
			BackgroundColor3 = Color3.new(1, 0, 0),
			Font = Enum.Font.Code,
			LayoutOrder = 3,
			Size = UDim2.new(1, 0, 0, 38),
			Text = "Increase counter 2",
			TextColor3 = Color3.new(1, 1, 1),
			TextScaled = true,
			[Roact.Event.Activated] = function()
				counter2.increment()
			end,
		}),
	})
end

local function App(_props, hooks)
	local counter1, setCounter1 = hooks.useState(5)
	local counter2, setCounter2 = hooks.useState(10)

	return e(CounterContext1.Provider, {
		value = {
			counter = counter1,
			increment = function()
				setCounter1(counter1 + 1)
			end,
		},
	}, {
		e(CounterContext2.Provider, {
			value = {
				counter = counter2,
				increment = function()
					setCounter2(counter2 + 1)
				end,
			},
		}, {
			Consumer = e(Consumer),
		}),
	})
end

App = hook(App)
Consumer = hook(Consumer)

return function(target)
	local handle = Roact.mount(e(App), target, "Component")

	return function()
		Roact.unmount(handle)
	end
end