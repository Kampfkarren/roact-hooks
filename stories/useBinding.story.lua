local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Hooks = require(ReplicatedStorage.Hooks)
local Roact = require(ReplicatedStorage.Roact)

local e = Roact.createElement

local function Stopwatch(_props, hooks)
	local timer, setTimer = hooks.useBinding(0)

	hooks.useEffect(function()
		local running = true

		spawn(function()
			while running do
				setTimer(timer:getValue() + wait())
			end
		end)

		return function()
			running = false
		end
	end)

	return e("TextLabel", {
		Size = UDim2.fromScale(1, 1),
		Text = timer:map(function(time)
			return "Time: " .. ("%.02f"):format(time)
		end),
		TextSize = 32,
	})
end

Stopwatch = Hooks.new(Roact)(Stopwatch)

return function(target)
	local handle = Roact.mount(e(Stopwatch), target, "Stopwatch")

	return function()
		Roact.unmount(handle)
	end
end
