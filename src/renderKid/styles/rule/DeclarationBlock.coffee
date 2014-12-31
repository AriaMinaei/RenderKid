module.exports = class DeclarationBlock

	self = @

	constructor: ->

		@_declarations = {}

	set: (prop, value) ->

		if typeof prop is 'object'

			for key, val of prop

				@set key, val

			return @

		prop = self.sanitizeProp prop

		@_getDeclarationClass(prop)

		.setOnto @_declarations, prop, value

		@

	_getDeclarationClass: (prop) ->

		if prop[0] is '_'

			return Arbitrary

		unless cls = declarationClasses[prop]

			throw Error "Unkown property `#{prop}`. Write it as `_#{prop}` if you're defining a custom property"

		return cls

	@sanitizeProp: (prop) ->

		String(prop).trim()

Arbitrary = require './declarationBlock/Arbitrary'

declarationClasses =

	color: require './declarationBlock/Color'
	background: require './declarationBlock/Background'

	width: require './declarationBlock/Width'
	height: require './declarationBlock/Height'

	bullet: require './declarationBlock/Bullet'
	display: require './declarationBlock/Display'

	margin: require './declarationBlock/Margin'
	marginTop: require './declarationBlock/MarginTop'
	marginLeft: require './declarationBlock/MarginLeft'
	marginRight: require './declarationBlock/MarginRight'
	marginBottom: require './declarationBlock/MarginBottom'

	padding: require './declarationBlock/Padding'
	paddingTop: require './declarationBlock/PaddingTop'
	paddingLeft: require './declarationBlock/PaddingLeft'
	paddingRight: require './declarationBlock/PaddingRight'
	paddingBottom: require './declarationBlock/PaddingBottom'