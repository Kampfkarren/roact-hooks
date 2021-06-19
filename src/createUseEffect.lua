local function createUseEffect(component)
	return function(callback, dependsOn)
		assert(typeof(callback) == "function", "useEffect callback is not a function")

		-- TODO: This won't work if you have multiple useEffect on the same line.
		-- That's kind of funny.
		local identity, line = debug.info(2, "fl")

		-- TODO: This mutates the component in the middle of render. That's bad, right?
		-- It's idempotent, so it shouldn't matter.
		-- Is there a way to do this that keeps `render` truly pure?
		if component.effects[identity] == nil then
			component.effects[identity] = {}
		end

		component.effects[identity][line] = { callback, dependsOn }
	end
end

return createUseEffect
