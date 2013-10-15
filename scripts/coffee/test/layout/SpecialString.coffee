require '../_prepare'

spec ['layout/SpecialString'], (SpecialString) ->

	test 'returns instance', ->

		SpecialString('s').should.be.instanceOf SpecialString

	test '::length() returns correct length for normal text', ->

		SpecialString('hello').length().should.equal 5

	test '::length() returns correct length for text containing tabs and tags', ->

		SpecialString('<a>he<you />l\tlo</a>').length().should.equal 13

	test "::length() doesn't count empty tags as tags", ->

		SpecialString('<>><').length().should.equal 4

	test "::length() works correctly with html quoted characters", ->

		SpecialString(' &gt;&lt; &nbsp;').length().should.equal 5

	test "::splitIn() works correct with normal text", ->

		SpecialString("123456").splitIn(3).should.be.like ['123', '456']

	test "::splitIn() works correct with normal text containing tabs and tags", ->

		SpecialString("12\t3<hello>456").splitIn(3).should.be.like ['12', '\t', '3<hello>45', '6']