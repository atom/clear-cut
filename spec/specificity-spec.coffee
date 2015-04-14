global.document ?= createElement: ->
  querySelector: (selector) ->
    if selector is '<>'
      throw new Error('invalid selector')
    else
      []

{specificity, isSelectorValid} = require '../index'

describe "clear-cut", ->
  describe "specificity(selector)", ->
    it "computes the specificity of a selector", ->
      expect(specificity('#an-id')).toBe 100
      expect(specificity('#an-id {')).toBe 100
      expect(specificity('#an-id, #another-id')).toBe 100

      expect(specificity('#an-id:after')).toBe 101
      expect(specificity('body#an-id')).toBe 101
      expect(specificity('body #an-id')).toBe 101

      expect(specificity('#an-id[foo]')).toBe 110
      expect(specificity('#an-id[foo=bar]')).toBe 110
      expect(specificity('#an-id.a-class')).toBe 110
      expect(specificity('#an-id:not(.a-class)')).toBe 110
      expect(specificity('#an-id .a-class')).toBe 110
      expect(specificity('.a-class #an-id')).toBe 110
      expect(specificity('.a-class#an-id')).toBe 110

      expect(specificity('#an-id #another-id')).toBe 200
      expect(specificity('#an-id > #another-id')).toBe 200

      expect(specificity('.a-class')).toBe 10
      expect(specificity('.a-class {')).toBe 10
      expect(specificity('.a-class, .b-class')).toBe 10

      expect(specificity('.a-class:after')).toBe 11
      expect(specificity('body.a-class')).toBe 11
      expect(specificity('body .a-class')).toBe 11

      expect(specificity('.a-class.b-class')).toBe 20
      expect(specificity('.a-class:not(.b-class)')).toBe 20
      expect(specificity('.a-class .b-class')).toBe 20
      expect(specificity('.a-class > .b-class')).toBe 20
      expect(specificity('.a-class[foo]')).toBe 20
      expect(specificity('.a-class[foo=bar]')).toBe 20

      expect(specificity('body')).toBe 1
      expect(specificity('body {')).toBe 1

      expect(specificity('body:after')).toBe 2
      expect(specificity('body div')).toBe 2

      expect(specificity('body div > span')).toBe 3
      expect(specificity('body div > span')).toBe 3

      expect(specificity('body[foo]')).toBe 11
      expect(specificity('body[foo=bar]')).toBe 11
      expect(specificity('body:not(.a-class)')).toBe 11

      expect(specificity('#id')).toBeGreaterThan(specificity('body'))
      expect(specificity('#id')).toBeGreaterThan(specificity('.class'))
      expect(specificity('.a.b')).toBeGreaterThan(specificity('.a'))
      expect(specificity('body div')).toBeGreaterThan(specificity('body'))

      expect(specificity('<>')).toBe 1

  describe "isSelectorValid(selector)", ->
    it "returns true if the selector is valid, false otherwise", ->
      expect(isSelectorValid('body')).toBe true
      expect(isSelectorValid('body')).toBe true
      expect(isSelectorValid('<>')).toBe false
      expect(isSelectorValid('<>')).toBe false
