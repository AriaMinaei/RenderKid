inlineStyleApplier = require './renderKid/styleApplier/inline'
blockStyleApplier = require './renderKid/styleApplier/block'
AnsiPainter = require './AnsiPainter'
Styles = require './renderKid/Styles'
Layout = require './Layout'
tools = require './tools'
{object} = require 'utila'
stripAnsi = require 'strip-ansi'

module.exports = class RenderKid
  self = @
  @AnsiPainter: AnsiPainter
  @Layout: Layout
  @quote: tools.quote
  @tools: tools
  @_defaultConfig:
    layout: terminalWidth: process.stdout.columns || 80

  constructor: (config = {}) ->
    @tools = self.tools
    @_config = object.append self._defaultConfig, config
    do @_initStyles

  _initStyles: ->
    @_styles = new Styles

  style: ->
    @_styles.setRule.apply @_styles, arguments

  _getStyleFor: (el) ->
    @_styles.getStyleFor el

  render: (input, withColors = yes) ->
    @_paint (@_renderDom @_toDom input), withColors

  _toDom: (input) ->
    if typeof input is 'string'
      @_parse input
    else if object.isBareObject(input) or Array.isArray(input)
      @_objToDom input
    else
      throw Error "Invalid input type. Only strings, arrays and objects are accepted"

  _objToDom: (o, injectFakeRoot = yes) ->
    if injectFakeRoot then o = body: o
    tools.objectToDom o

  _paint: (text, withColors) ->
    painted = AnsiPainter.paint(text)

    if withColors
      painted
    else
      stripAnsi painted

  _parse: (string, injectFakeRoot = yes) ->
    if injectFakeRoot then string = '<body>' + string + '</body>'
    tools.stringToDom string

  _renderDom: (dom) ->
    bodyTag = dom[0]
    layout = new Layout @_config.layout
    rootBlock = layout.getRootBlock()
    @_renderBlockNode bodyTag, null, rootBlock
    layout.get()

  _renderChildrenOf: (parentNode, parentBlock) ->
    nodes = parentNode.children
    for node in nodes
      @_renderNode node, parentNode, parentBlock

    return

  _renderNode: (node, parentNode, parentBlock) ->
    if node.type is 'text'
      @_renderText node, parentNode, parentBlock
    else if node.name is 'br'
      @_renderBr node, parentNode, parentBlock
    else if @_isBlock node
      @_renderBlockNode node, parentNode, parentBlock
    else if @_isNone node
      return
    else
      @_renderInlineNode node, parentNode, parentBlock

    return

  _renderText: (node, parentNode, parentBlock) ->
    text = node.data
    text = text.replace /\s+/g, ' '

    # let's only trim if the parent is an inline element
    unless parentNode?.styles?.display is 'inline'
      text = text.trim()

    return if text.length is 0

    text = text.replace /&nl;/g, "\n"
    parentBlock.write text

  _renderBlockNode: (node, parentNode, parentBlock) ->
    {before, after, blockConfig} =
      blockStyleApplier.applyTo node, @_getStyleFor node

    block = parentBlock.openBlock(blockConfig)
    if before isnt '' then block.write before
    @_renderChildrenOf node, block
    if after isnt '' then block.write after
    block.close()

  _renderInlineNode: (node, parentNode, parentBlock) ->
    {before, after} = inlineStyleApplier.applyTo node, @_getStyleFor node
    if before isnt '' then parentBlock.write before
    @_renderChildrenOf node, parentBlock
    if after isnt '' then parentBlock.write after

  _renderBr: (node, parentNode, parentBlock) ->
    parentBlock.write "\n"

  _isBlock: (node) ->
    not(node.type is 'text' or node.name is 'br' or @_getStyleFor(node).display isnt 'block')

  _isNone: (node) ->
    not (node.type is 'text' or node.name is 'br' or @_getStyleFor(node).display isnt 'none')