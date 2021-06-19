local createUseContext = require(script.createUseContext)
local createUseEffect = require(script.createUseEffect)
local createUseState = require(script.createUseState)

local Hooks = {}

local function createHooks(component)
	local useEffect = createUseEffect(component)
	local useState = createUseState(component)

	local useContext = createUseContext(component, useEffect, useState)

	return {
		useContext = useContext,
		useEffect = useEffect,
		useState = useState,
	}
end

function Hooks.new(roact)
	return function(render, name)
		assert(typeof(render) == "function", "Hooked components must be functions.")

		local classComponent = roact.Component:extend(name or debug.info(render, "n"))

		function classComponent:init()
			self.effectDependencies = {}
			self.effects = {}
			self.unmountEffects = {}

			self.hooks = createHooks(self)
		end

		function classComponent:runEffects()
			for index, effectData in ipairs(self.effects) do
				local effect, dependsOn = unpack(effectData)

				if dependsOn ~= nil then
					local lastDependencies = self.effectDependencies[index]
					if lastDependencies ~= nil then
						local anythingChanged = false

						for dependencyIndex = 1, select("#", unpack(dependsOn)) do
							if lastDependencies[dependencyIndex] ~= dependsOn[dependencyIndex] then
								anythingChanged = true
								break
							end
						end

						if not anythingChanged then
							continue
						end
					end

					self.effectDependencies[index] = dependsOn
				end

				self.unmountEffects[index] = effect()
			end
		end

		function classComponent:didMount()
			self:runEffects()
		end

		function classComponent:didUpdate()
			self:runEffects()
		end

		function classComponent:willUnmount()
			for index = 1, #self.effects do
				self.unmountEffects[index]()
			end
		end

		function classComponent:render()
			self.hookCounter = 0

			return render(self.props, self.hooks)
		end

		return classComponent
	end
end

return Hooks
