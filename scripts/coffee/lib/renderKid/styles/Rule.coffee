Selector = require './rule/Selector'
DeclarationBlock = require './rule/DeclarationBlock'

module.exports = class Rule

	constructor: (selector) ->

		@selector = new Selector selector

		@styles = new DeclarationBlock

	setStyles: (styles) ->

		@styles.set styles

		@