require '../../_prepare'

spec ['renderKid/styles/StyleSheet'], (StyleSheet) ->

	test '::normalizeSelector', ->

		StyleSheet.normalizeSelector(' body+a   s >   a ')
		.should.equal 'body+a s>a'