tools = require './tools'
tags = require './ansiPainter/tags'
styles = require './ansiPainter/styles'
{object} = require 'utila'

module.exports = class AnsiPainter
  @tags: tags

  paint: (s) ->
    @_replaceSpecialStrings @_renderDom @_parse s

  _replaceSpecialStrings: (str) ->
    str
    .replace(/&sp;/g, ' ')
    .replace(/&lt;/g, '<')
    .replace(/&gt;/g, '>')
    .replace(/&quot;/g, '"')
    .replace(/&amp;/g, '&')

  _parse: (string, injectFakeRoot = yes) ->
    if injectFakeRoot then string = '<none>' + string + '</none>'
    tools.toDom string

  _renderDom: (dom) ->
    parentStyles = bg: 'none', color: 'none'
    @_renderChildren dom, parentStyles

  _renderChildren: (children, parentStyles) ->
    ret = ''
    for own n, child of children
      ret += @_renderNode child, parentStyles

    ret

  _renderNode: (node, parentStyles) ->
    if node.type is 'text'
      @_renderTextNode node, parentStyles
    else
      @_renderTag node, parentStyles

  _renderTextNode: (node, parentStyles) ->
    @_wrapInStyle node.data, parentStyles

  _wrapInStyle: (str, style) ->
    styles.color(style.color) + styles.bg(style.bg) + str + styles.none()

  _renderTag: (node, parentStyles) ->
    tagStyles = @_getStylesForTagName node.name
    currentStyles = @_mixStyles parentStyles, tagStyles
    @_renderChildren node.children, currentStyles

  _mixStyles: (styles...) ->
    final = {}
    for style in styles
      for own key, val of style
        if not final[key]? or val isnt 'inherit'
          final[key] = val

    final

  _getStylesForTagName: (name) ->
    unless tags[name]?
      throw Error "Unknown tag name `#{name}`"

    tags[name]

  self = @

  @getInstance: ->
    unless self._instance?
      self._instance = new self
    self._instance

  @paint: (str) ->
    self.getInstance().paint str

  @strip: (s) ->
    s.replace(/\x1b\[[0-9]+m/g, '')