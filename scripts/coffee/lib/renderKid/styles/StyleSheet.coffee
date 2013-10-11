Rule = require './Rule'

module.exports = class StyleSheet

	self = @

	constructor: ->

		@_rulesBySelector = {}

	setRule: (selector, styles) ->

		if typeof selector is 'string'

			@_setRule selector, styles

		else if typeof selector is 'object'

			for key, val of selector

				@_setRule key, val
		@

	_setRule: (s, styles) ->

		for selector in self.splitSelectors s

			@_setSingleRule selector, styles

		@

	_setSingleRule: (s, styles) ->

		selector = self.normalizeSelector s

		unless rule = @_rulesBySelector[selector]

			rule = new Rule selector

			@_rulesBySelector[selector] = rule

		rule.setStyles styles

		@

	getRulesFor: (el) ->

		rules = []

		for selector, rule of @_rulesBySelector

			if rule.selector.matches el then rules.push rule

		rules

	@normalizeSelector: (selector) ->

		selector
		.replace(/[\s]+/g, ' ')
		.replace(/[\s]*([>\,\+]{1})[\s]*/g, '$1')
		.trim()

	@splitSelectors: (s) ->

		s.trim().split ','