specificity = require 'specificity'

cache = {}

module.exports =
  specificity: (selector) ->
    cachedSpecificity = cache[selector]
    return cachedSpecificity if cachedSpecificity?

    resultString = specificity.calculate(selector)[0].specificity
    [i, a, b, c] = resultString.split(',').map (value) -> parseInt(value)
    selectorSpecificity = (a * 100) + (b * 10) + (c * 1)
    cache[selector] = selectorSpecificity
    selectorSpecificity
