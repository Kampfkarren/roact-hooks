local createMultiContextConsumer = require(script.createMultiContextConsumer)
local createUseContext = require(script.createUseContext)
local createUseEffect = require(script.createUseEffect)
local createUseState = require(script.createUseState)

local Hooks = {}

local function createHooks(component)
	return {
		useContext = createUseContext(component),
		useEffect = createUseEffect(component),
		useState = createUseState(component),
	}
end

function Hooks.new(roact)
	local MultiContextConsumer = createMultiContextConsumer(roact)

	return function(render, name)
		assert(typeof(render) == "function", "Hooked components must be functions.")

		local classComponent = roact.Component:extend(name or debug.info(render, "n"))

		function classComponent:init()
			self.contexts = nil
			self.effectDependencies = {}
			self.effects = {}
			self.unmountEffects = {}

			self.hooks = createHooks(self)
		end

		function classComponent:runEffects()
			for identity, effects in pairs(self.effects) do
				local identityDependencies = self.effectDependencies[identity]
				if identityDependencies == nil then
					identityDependencies = {}
					self.effectDependencies[identity] = identityDependencies
				end

				for line, effectData in pairs(effects) do
					local effect, dependsOn = unpack(effectData)

					if dependsOn ~= nil then
						local lastDependencies = identityDependencies[line]
						if lastDependencies ~= nil then
							local anythingChanged = false

							for index = 1, select("#", unpack(dependsOn)) do
								if lastDependencies[index] ~= dependsOn[index] then
									anythingChanged = true
									break
								end
							end

							if not anythingChanged then
								continue
							end
						end

						identityDependencies[line] = dependsOn
					end

					local cleanup = effect()

					if self.unmountEffects[identity] == nil then
						self.unmountEffects[identity] = {}
					end

					self.unmountEffects[identity][line] = cleanup
				end
			end
		end

		function classComponent:didMount()
			self:runEffects()
		end

		function classComponent:didUpdate()
			self:runEffects()
		end

		function classComponent:willUnmount()
			for _, unmountEffects in pairs(self.unmountEffects) do
				for _, unmountEffect in pairs(unmountEffects) do
					unmountEffect()
				end
			end
		end

		function classComponent:render()
			if self.contexts == nil then
				return render(self.props, self.hooks)
			else
				return roact.createElement(MultiContextConsumer, {
					contexts = self.contexts,
					render = function(contexts)
						self.mostRecentContexts = contexts
						return render(self.props, self.hooks)
					end,
				})
			end
		end

		return classComponent
	end
end

return Hooks
