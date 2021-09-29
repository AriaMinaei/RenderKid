S = require '../../src/layout/SpecialString'

describe "SpecialString", ->
  describe 'SpecialString()', ->
    it 'should return instance', ->
      new S('s').should.be.instanceOf S

  describe 'length()', ->
    it 'should return correct length for normal text', ->
      new S('hello').length.should.equal 5

    it 'should return correct length for text containing tabs and tags', ->
      new S('<a>he<you />l\tlo</a>').length.should.equal 13

    it "shouldn't count empty tags as tags", ->
      new S('<>><').length.should.equal 4

    it "should count length of single tag as 0", ->
      new S('<html>').length.should.equal 0

    it "should work correctly with html quoted characters", ->
      new S(' &gt;&lt; &sp;').length.should.equal 5

  describe 'splitIn()', ->
    it "should work correctly with normal text", ->
      new S("123456").splitIn(3).should.be.like ['123', '456']

    it "should work correctly with normal text containing tabs and tags", ->
      new S("12\t3<hello>456").splitIn(3).should.be.like ['12', '\t', '3<hello>45', '6']

    it "should not trimLeft all lines when trimLeft is no", ->
      new S('abc def').splitIn(3).should.be.like ['abc', ' de', 'f']

    it "should trimLeft all lines when trimLeft is true", ->
      new S('abc def').splitIn(3, yes).should.be.like ['abc', 'def']

  describe 'cut()', ->
    it "should work correctly with text containing tabs and tags", ->
      original = new S("12\t3<hello>456")
      cut = original.cut(2, 3)
      original.str.should.equal '123<hello>456'
      cut.str.should.equal '\t'

    it "should trim left when trimLeft is true", ->
      original = new S ' 132'
      cut = original.cut 0, 1, yes
      original.str.should.equal '32'
      cut.str.should.equal '1'

    it "should be greedy", ->
      new S("ab<tag>a").cut(0, 2).str.should.equal "ab<tag>"

  describe 'isOnlySpecialChars()', ->
    it "should work", ->
      new S("12\t3<hello>456").isOnlySpecialChars().should.equal no
      new S("<hello>").isOnlySpecialChars().should.equal yes

  describe 'clone()', ->
    it "should return independent instance", ->
      a = new S('hello')
      b = a.clone()
      a.str.should.equal b.str
      a.should.not.equal b

  describe 'trim()', ->
    it "should return an independent instance", ->
      s = new S('')
      s.trim().should.not.equal s

    it 'should return the same string when trim is not required', ->
      new S('hello').trim().str.should.equal 'hello'

    it 'should return trimmed string', ->
      new S(' hello').trim().str.should.equal 'hello'
