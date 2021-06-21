local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Hooks = require(ReplicatedStorage.Hooks)
local Roact = require(ReplicatedStorage.Roact)

local e = Roact.createElement

local defaultProps = {
    name = "stranger",
}

local function Stranger(props, _hooks)
	return e("TextLabel", {
		Size = UDim2.fromScale(1, 1),
		Text = "Hello, " .. props.name,
		TextSize = 32,
	})
end

Stranger = Hooks.new(Roact)(Stranger, {
	name = "OverridenComponentName",
	defaultProps = defaultProps,
})

return function(target)
	local handle = Roact.mount(e(Stranger), target, "Stranger")

	return function()
		Roact.unmount(handle)
	end
end