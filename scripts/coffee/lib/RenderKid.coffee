AnsiRenderer = require './AnsiRenderer'
Styles = require './renderKid/Styles'
tools = require './renderKid/tools'
wn	= require 'when'

{array, classic} = require 'utila'

module.exports = class RenderKid

	@AnsiRenderer: AnsiRenderer

	constructor: ->

		do @_initStyles

	_initStyles: ->

		@_styles = new Styles

	style: ->

		@_styles.setRule.apply @_styles, arguments

	_getStyleFor: (el) ->

		@_styles.getStyleFor el

	render: (s) ->

		@_parse(s).then (dom) => @_renderDom dom

	_parse: (string, injectFakeRoot = yes) ->

		if injectFakeRoot then string = '<body>' + string + '</body>'

		tools.toDom string

	_renderDom: (dom) ->

		bodyTag = dom[0]

		return

		@_renderChildren dom, 0

	_renderChildren: (nodes, indent) ->

		output = ''

		for node in nodes

			if node.type is 'tag'

				output += @_renderTag node, indent

			else if node.type is 'text'

				output += @_renderText node, indent

			else

				throw Error "Unexpected node type '#{node.type}"

		output

	_renderText: (node, indent) ->

		@_indent node.data, indent

	_fixTag: (node) ->

		return node if node.type isnt 'tag'

		indexesToRemove = []

		for child, i in node.children

			if child.type is 'text' and child.data.trim() is ''

				indexesToRemove.push i

		array.pluckMultiple node.children, indexesToRemove