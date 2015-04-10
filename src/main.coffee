specificity = require '../specificity.js'

cache = {}

module.exports =
  specificity: (selector) ->
    cachedSpecificity = cache[selector]
    return cachedSpecificity if cachedSpecificity?

    selectorSpecificity = specificity.calculate(selector)[0]
    cache[selector] = selectorSpecificity
    selectorSpecificity
