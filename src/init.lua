local createUseState = require(script.createUseState)

local Hooks = {}

local function createHooks(component)
	return {
		useState = createUseState(component),
	}
end

function Hooks.new(roact)
	return function(render, name)
		assert(typeof(render) == "function", "Hooked components must be functions.")

		local classComponent = roact.Component:extend(name)

		function classComponent:init()
			self.hooks = createHooks(self)
		end

		function classComponent:render()
			return render(self.props, self.hooks)
		end

		return classComponent
	end
end

return Hooks
