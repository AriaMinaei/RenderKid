require '../../_prepare'

StyleSheet = mod 'renderKid/styles/StyleSheet'

describe "normalizeSelector()"

it 'should remove unnecessary spaces', ->

	StyleSheet.normalizeSelector(' body+a   s >   a ')

	.should.equal 'body+a s>a'