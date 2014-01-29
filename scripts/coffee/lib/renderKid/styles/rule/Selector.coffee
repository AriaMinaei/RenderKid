CSSSelect = require 'CSSselect'

module.exports = class Selector

	self = @

	constructor: (@text) ->

		@_fn = CSSSelect.compile @text

		@priority = self.calculatePriority @text

	matches: (elem) ->

		CSSSelect.is elem, @_fn

	# This stupid piece of code is supposed to calculate
	# selector priority, somehow according to
	# http://www.w3.org/wiki/CSS/Training/Priority_level_of_selector
	@calculatePriority: (text) ->

		priotrity = 0

		if n = text.match /[\#]{1}/g

			priotrity += 100 * n.length

		if n = text.match /[a-zA-Z]+/g

			priotrity += 2 * n.length

		if n = text.match /\*/g

			priotrity += 1 * n.length

		priotrity