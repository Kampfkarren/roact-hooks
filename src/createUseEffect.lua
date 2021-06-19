local function createUseEffect(component)
	return function(callback, dependsOn)
		assert(typeof(callback) == "function", "useEffect callback is not a function")

		component.hookCounter += 1
		local hookCount = component.hookCounter

		-- TODO: This mutates the component in the middle of render. That's bad, right?
		-- It's idempotent, so it shouldn't matter.
		-- Is there a way to do this that keeps `render` truly pure?
		component.effects[hookCount] = { callback, dependsOn }
	end
end

return createUseEffect
