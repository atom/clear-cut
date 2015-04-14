global.document ?= createElement: ->
  querySelector: (selector) ->
    if selector is '<>'
      throw new Error('invalid selector')
    else
      []

{calculateSpecificity, isSelectorValid, validateSelector} = require '../index'

describe "clear-cut", ->
  describe "specificity(selector)", ->
    it "computes the specificity of a selector", ->
      expect(calculateSpecificity('#an-id')).toBe 100
      expect(calculateSpecificity('#an-id {')).toBe 100
      expect(calculateSpecificity('#an-id, #another-id')).toBe 100

      expect(calculateSpecificity('#an-id:after')).toBe 101
      expect(calculateSpecificity('body#an-id')).toBe 101
      expect(calculateSpecificity('body #an-id')).toBe 101

      expect(calculateSpecificity('#an-id[foo]')).toBe 110
      expect(calculateSpecificity('#an-id[foo=bar]')).toBe 110
      expect(calculateSpecificity('#an-id.a-class')).toBe 110
      expect(calculateSpecificity('#an-id:not(.a-class)')).toBe 110
      expect(calculateSpecificity('#an-id .a-class')).toBe 110
      expect(calculateSpecificity('.a-class #an-id')).toBe 110
      expect(calculateSpecificity('.a-class#an-id')).toBe 110

      expect(calculateSpecificity('#an-id #another-id')).toBe 200
      expect(calculateSpecificity('#an-id > #another-id')).toBe 200

      expect(calculateSpecificity('.a-class')).toBe 10
      expect(calculateSpecificity('.a-class {')).toBe 10
      expect(calculateSpecificity('.a-class, .b-class')).toBe 10

      expect(calculateSpecificity('.a-class:after')).toBe 11
      expect(calculateSpecificity('body.a-class')).toBe 11
      expect(calculateSpecificity('body .a-class')).toBe 11

      expect(calculateSpecificity('.a-class.b-class')).toBe 20
      expect(calculateSpecificity('.a-class:not(.b-class)')).toBe 20
      expect(calculateSpecificity('.a-class .b-class')).toBe 20
      expect(calculateSpecificity('.a-class > .b-class')).toBe 20
      expect(calculateSpecificity('.a-class[foo]')).toBe 20
      expect(calculateSpecificity('.a-class[foo=bar]')).toBe 20

      expect(calculateSpecificity('body')).toBe 1
      expect(calculateSpecificity('body {')).toBe 1

      expect(calculateSpecificity('body:after')).toBe 2
      expect(calculateSpecificity('body div')).toBe 2

      expect(calculateSpecificity('body div > span')).toBe 3
      expect(calculateSpecificity('body div > span')).toBe 3

      expect(calculateSpecificity('body[foo]')).toBe 11
      expect(calculateSpecificity('body[foo=bar]')).toBe 11
      expect(calculateSpecificity('body:not(.a-class)')).toBe 11

      expect(calculateSpecificity('#id')).toBeGreaterThan(calculateSpecificity('body'))
      expect(calculateSpecificity('#id')).toBeGreaterThan(calculateSpecificity('.class'))
      expect(calculateSpecificity('.a.b')).toBeGreaterThan(calculateSpecificity('.a'))
      expect(calculateSpecificity('body div')).toBeGreaterThan(calculateSpecificity('body'))

      expect(calculateSpecificity('<>')).toBe 1

  describe "isSelectorValid(selector)", ->
    it "returns true if the selector is valid, false otherwise", ->
      expect(isSelectorValid('body')).toBe true
      expect(isSelectorValid('body')).toBe true
      expect(isSelectorValid('<>')).toBe false
      expect(isSelectorValid('<>')).toBe false

  describe "validateSelector(selector)", ->
    it "throws an error if the selector is invalid", ->
      expect(validateSelector('body')).toBeUndefined()
      badSelector = "<>"
      validateError = null
      try
        validateSelector(badSelector)
      catch error
        validateError = error

      expect(validateError.message).toContain(badSelector)
      expect(validateError.code).toBe 'EBADSELECTOR'
      expect(validateError.name).toBe 'SyntaxError'
