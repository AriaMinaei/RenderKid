inlineStyleApplier = require './renderKid/styleApplier/inline'
blockStyleApplier = require './renderKid/styleApplier/block'
renderKidConfig = require './renderKid/config'
AnsiPainter = require './AnsiPainter'
Layout = require './Layout'
Styles = require './renderKid/Styles'
tools = require './tools'

{object} = require 'utila'

module.exports = class RenderKid

	self = @

	@AnsiPainter: AnsiPainter

	@Layout: Layout

	@_defaultConfig:

		layout: terminalWidth: 80

	@quote: tools.quote

	constructor: (config = {}) ->

		@_config = renderKidConfig config, self._defaultConfig

		do @_initStyles

	_initStyles: ->

		@_styles = new Styles

	style: ->

		@_styles.setRule.apply @_styles, arguments

	_getStyleFor: (el) ->

		@_styles.getStyleFor el

	render: (input) ->

		return @_paint @_renderDom @_toDom input

	_toDom: (input) ->

		if typeof input is 'string'

			return @_parse input

		else if object.isBareObject(input) or Array.isArray(input)

			return @_objToDom input

		else

			throw Error "Invalid input type. Only strings, arrays and objects are accepted"

	_objToDom: (o, injectFakeRoot = yes) ->

		if injectFakeRoot then o = body: o

		tools.objectToDom o

	_paint: (text) ->

		AnsiPainter.paint(text)

	_parse: (string, injectFakeRoot = yes) ->

		if injectFakeRoot then string = '<body>' + string + '</body>'

		tools.stringToDom string

	_renderDom: (dom) ->

		bodyTag = dom[0]

		layout = new Layout @_config.layout

		rootBlock = layout.getRootBlock()

		@_renderBlockNode bodyTag, rootBlock

		layout.get()

	_renderChildren: (nodes, parentBlock) ->

		for node in nodes

			@_renderNode node, parentBlock

		return

	_renderNode: (node, parentBlock) ->

		if node.type is 'text'

			@_renderText node, parentBlock

		else if node.name is 'br'

			@_renderBr node, parentBlock

		else if @_isBlock node

			@_renderBlockNode node, parentBlock

		else

			@_renderInlineNode node, parentBlock

		return

	_renderText: (node, parentBlock) ->

		text = node.data

		text = text.replace /[\s]+/g, ' '

		text = text.trim()

		return if text.length is 0

		parentBlock.write text

	_renderBlockNode: (node, parentBlock) ->

		{before, after, blockConfig} =

			blockStyleApplier.applyTo node, @_getStyleFor node

		block = parentBlock.openBlock(blockConfig)

		if before isnt '' then block.write before

		@_renderChildren node.children, block

		if after isnt '' then block.write after

		block.close()

	_renderInlineNode: (node, parentBlock) ->

		{before, after} = inlineStyleApplier.applyTo node, @_getStyleFor node

		if before isnt '' then parentBlock.write before

		@_renderChildren node.children, parentBlock

		if after isnt '' then parentBlock.write after

	_renderBr: (node, parentBlock) ->

		parentBlock.write "\n"

	_isBlock: (node) ->

		return no if node.type is 'text' or

			node.name is 'br' or @_getStyleFor(node).display isnt 'block'

		return yes