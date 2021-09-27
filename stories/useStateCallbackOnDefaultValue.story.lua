local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Hooks = require(ReplicatedStorage.Hooks)
local Roact = require(ReplicatedStorage.Roact)

local e = Roact.createElement

local function UpdatesDefaultValue(_props, hooks)
	local counter, setCounter = hooks.useState(0)

	return e("TextButton", {
		Size = UDim2.fromScale(0.5, 0.5),
		Text = "Click me! The number is " .. counter,
		TextSize = 30,
		TextWrapped = true,

		[Roact.Event.Activated] = function()
			setCounter(function(newCounter)
				return newCounter + 1
			end)
		end,
	})
end

UpdatesDefaultValue = Hooks.new(Roact)(UpdatesDefaultValue)

return function(target)
	local handle = Roact.mount(e(UpdatesDefaultValue), target, "UpdatesDefaultValue")

	return function()
		Roact.unmount(handle)
	end
end

