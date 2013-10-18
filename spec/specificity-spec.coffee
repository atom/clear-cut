{specificity} = require '../src/main'

describe "specificity", ->
  it "computes the specificity of a selector", ->
    expect(specificity('#id')).toBeGreaterThan(specificity('body'))
    expect(specificity('.a.b')).toBeGreaterThan(specificity('.a'))
