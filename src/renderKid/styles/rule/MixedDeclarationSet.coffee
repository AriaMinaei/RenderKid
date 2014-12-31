module.exports = class MixedDeclarationSet

	self = @

	@mix: (ruleSets...) ->

		mixed = new self

		for rules in ruleSets

			mixed.mixWithList rules

		mixed

	constructor: ->

		@_declarations = {}

	mixWithList: (rules) ->

		rules.sort (a, b) -> a.selector.priority > b.selector.priority

		for rule in rules

			@_mixWithRule rule

		@

	_mixWithRule: (rule) ->

		for prop, dec of rule.styles._declarations

			@_mixWithDeclaration dec

		return

	_mixWithDeclaration: (dec) ->

		cur = @_declarations[dec.prop]

		return if cur? and cur.important and not dec.important

		@_declarations[dec.prop] = dec

		return

	get: (prop) ->

		unless prop?

			return @_declarations

		return null unless @_declarations[prop]?

		@_declarations[prop].val

	toObject: ->

		obj = {}

		for prop, dec of @_declarations

			obj[prop] = dec.val

		obj