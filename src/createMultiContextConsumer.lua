local function createMultiContextConsumer(roact)
    return function(props)
        local element = nil
        local contexts = {}

        for context in pairs(props.contexts) do
            local currentElement = element

            element = roact.createElement(context.Consumer, {
                render = function(value)
                    contexts[context] = value

                    if currentElement then
                        return currentElement
                    else
                        return props.render(contexts)
                    end
                end,
            })
        end

        return element
    end
end

return createMultiContextConsumer
