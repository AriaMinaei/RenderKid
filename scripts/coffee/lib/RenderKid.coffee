AnsiPainter = require './AnsiPainter'
Layout = require './Layout'
Styles = require './renderKid/Styles'
tools = require './tools'
wn	= require 'when'

{array, classic} = require 'utila'

module.exports = class RenderKid

	@AnsiPainter: AnsiPainter
	@Layout: Layout

	constructor: ->

		do @_initStyles

	_initStyles: ->

		@_styles = new Styles

	style: ->

		@_styles.setRule.apply @_styles, arguments

	_getStyleFor: (el) ->

		styles = el.styles

		unless styles?

			el.styles = styles = @_styles.getStyleFor el

		styles

	render: (s) ->

		@_parse(s).then (dom) => @_renderDom dom

	_parse: (string, injectFakeRoot = yes) ->

		if injectFakeRoot then string = '<body>' + string + '</body>'

		tools.toDom string

	_renderDom: (dom) ->

		bodyTag = dom[0]

		# inspectDom bodyTag

		@_renderBlockEl bodyTag

	_renderBlockEl: (node) ->

		@_renderChildren node.children

	_renderChildren: (nodes) ->

		# for group in @_groupNodes nodes

			# console.log 'group'
			# inspectDom group

		return

	_renderInlineGroup: (group) ->

		str = ''

		for node in group

			'ss'

		str

	_groupNodes: (nodes) ->

		groups = []

		cur = []

		for node in nodes

			if @_isBlock node

				if cur.length > 0

					groups.push cur

					cur = []

				groups.push node

			else

				cur.push node

		if cur.length > 0 then groups.push cur

		groups

	_isBlock: (node) ->

		return no if node.type is 'text' or

			node.name is 'br' or @_getStyleFor(node).display isnt 'block'

		return yes