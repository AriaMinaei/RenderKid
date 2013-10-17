StyleSheet = require './styles/StyleSheet'
MixedDeclarationSet = require './styles/rule/MixedDeclarationSet'

module.exports = class Styles

	self = @

	@defaultRules:

		'*':

			display: 'inline'

		'body':

			background: 'none'

			color: 'white'

			display: 'block'

			width: '80 !important'

	constructor: ->

		@_defaultStyles = new StyleSheet

		@_userStyles = new StyleSheet

		do @_setDefaultStyles

	_setDefaultStyles: ->

		@_defaultStyles.setRule self.defaultRules

		return

	setRule: (selector, rules) ->

		@_userStyles.setRule.apply @_userStyles, arguments

		@

	getStyleFor: (el) ->

		styles = el.styles

		unless styles?

			el.styles = styles = @_getComputedStyleFor el

		styles

	_getRawStyleFor: (el) ->

		def = @_defaultStyles.getRulesFor el

		user = @_userStyles.getRulesFor el

		MixedDeclarationSet.mix(def, user).toObject()

	_getComputedStyleFor: (el) ->

		decs = {}

		parent = el.parent

		for prop, val of @_getRawStyleFor el

			unless val is 'inherit'

				decs[prop] = val

			else

				throw Error "Inherited styles are not supported yet."

		decs