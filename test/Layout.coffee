Layout = require '../src/Layout'

emptyLine = "<none>  </none>"
nonEmptyLine = "<none>error</none>"

describe "Layout", ->
  describe "constructor()", ->
    it "should create root block", ->
      l = new Layout
      expect(l._root).to.exist
      l._root._name.should.equal '__root'

    it "should use extraNewlines:true by default", ->
      l = new Layout
      l._config.extraNewlines.should.equal true

  describe "_isEmptyLine()", ->
    it "should detect empty lines", ->
      l = new Layout
      l._isEmptyLine(emptyLine).should.equal true

    it "should detect non-empty lines", ->
      l = new Layout
      l._isEmptyLine(nonEmptyLine).should.equal false

  describe "_appendLine()", ->
    it "should include extra newlines by default", ->
      l = new Layout
      l._appendLine(emptyLine)
      l._written.length.should.equal 2

    it "should exclude extra newlines when requested", ->
      l = new Layout({ extraNewlines: false })
      l._appendLine(emptyLine)
      l._written.length.should.equal 0

  describe "get()", ->
    it "should not be allowed when any block is open", ->
      l = new Layout
      l.openBlock()
      (->
        l.get()
      ).should.throw Error
