{specificity} = require '../lib/main'

count = 0

calculate = (selector) ->
  count++
  specificity(selector)
  return

start = Date.now()

benchmark = ->
  for letter in 'abcdefghijklmnopqrztuvwxyz0123456789'
    calculate("a-custom-tag-#{letter}")
    calculate("a-custom-tag-#{letter}.a-class")
    calculate("a-custom-tag-#{letter}#an-id")

    calculate("body, a-custom-tag-#{letter}")
    calculate("body, a-custom-tag-#{letter}.a-class")
    calculate("body, a-custom-tag-#{letter}#an-id")

    calculate("body > a-custom-tag-#{letter}")
    calculate("body > a-custom-tag-#{letter}.a-class")
    calculate("body > a-custom-tag-#{letter}#an-id")

    calculate(".a-custom-tag-#{letter}")
    calculate(".a-custom-tag-#{letter}.a-class")
    calculate(".a-custom-tag-#{letter}#an-id")

    calculate(".a-class > .a-custom-tag-#{letter}")
    calculate(".a-class > .a-custom-tag-#{letter}.a-class")
    calculate(".a-class > .a-custom-tag-#{letter}#an-id")

    calculate(".a-class, .a-custom-tag-#{letter}")
    calculate(".a-class, .a-custom-tag-#{letter}.a-class")
    calculate(".a-class, .a-custom-tag-#{letter}#an-id")

    calculate("#a-custom-tag-#{letter}")
    calculate("#a-custom-tag-#{letter}.a-class")

    calculate("#an-id > #a-custom-tag-#{letter}")
    calculate("#an-id > #a-custom-tag-#{letter}.a-class")

    calculate("#an-id, #a-custom-tag-#{letter}")
    calculate("#an-id, #a-custom-tag-#{letter}.a-class")
  return

benchmark()
benchmark()

console.log "Calculated #{count} selector specificities in #{Date.now() - start}ms"
