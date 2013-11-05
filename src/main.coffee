specificity = require 'specificity'
module.exports =
  specificity: (selector) ->
    resultString = specificity.calculate(selector)[0].specificity
    [i, a, b, c] = resultString.split(',').map (value) -> parseInt(value)
    (a * 100) + (b * 10) + (c * 1)
