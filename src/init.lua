local createUseBinding = require(script.createUseBinding)
local createUseCallback = require(script.createUseCallback)
local createUseContext = require(script.createUseContext)
local createUseEffect = require(script.createUseEffect)
local createUseMemo = require(script.createUseMemo)
local createUseReducer = require(script.createUseReducer)
local createUseState = require(script.createUseState)
local createUseValue = require(script.createUseValue)

local Hooks = {}

local function createHooks(roact, component)
	local useEffect = createUseEffect(component)
	local useState = createUseState(component)
	local useValue = createUseValue(component)

	local useBinding = createUseBinding(roact, useValue)
	local useContext = createUseContext(component, useEffect, useState)
	local useMemo = createUseMemo(useValue)

	local useCallback = createUseCallback(useMemo)

	local useReducer = createUseReducer(useCallback, useState)

	return {
		useBinding = useBinding,
		useCallback = useCallback,
		useContext = useContext,
		useEffect = useEffect,
		useMemo = useMemo,
		useReducer = useReducer,
		useState = useState,
		useValue = useValue,
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

			self.hooks = createHooks(roact, self)
		end

		function classComponent:runEffects()
			for index = 1, self.hookCounter do
				local effectData = self.effects[index]
				if effectData == nil then
					continue
				end

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
			for index = 1, self.hookCounter do
				local unmountEffect = self.unmountEffects[index]

				if unmountEffect ~= nil then
					unmountEffect()
				end
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
