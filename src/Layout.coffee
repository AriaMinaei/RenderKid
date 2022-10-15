Block = require './layout/Block'
{cloneAndMergeDeep} = require './tools'
SpecialString = require './layout/SpecialString'
terminalWidth = require('./tools').getCols()

module.exports = class Layout
  self = @

  @_rootBlockDefaultConfig:
    linePrependor: options: amount: 0
    lineAppendor: options: amount: 0
    blockPrependor: options: amount: 0
    blockAppendor: options: amount: 0

  @_defaultConfig:
    extraNewlines: true
    terminalWidth: terminalWidth

  constructor: (config = {}, rootBlockConfig = {}) ->
    @_written = []
    @_activeBlock = null
    @_config = cloneAndMergeDeep self._defaultConfig, config

    # Every layout has a root block
    rootConfig = cloneAndMergeDeep self._rootBlockDefaultConfig, rootBlockConfig
    @_root = new Block @, null, rootConfig, '__root'
    @_root._open()

  getRootBlock: ->
    @_root

  _append: (text) ->
    @_written.push text

  # Returns `true` when a line contains no text.
  # First regex removes whitespace.
  # Second regex removes HTML script tags.
  _isEmptyLine: (line) ->
    return line.replace(/\s/g, '').replace(/(<([^>]+)>)/ig, '') == ''

  _appendLine: (text) ->
    if !@_config.extraNewlines && @_isEmptyLine(text)
      return this

    @_append text
    s = new SpecialString(text)
    if s.length < @_config.terminalWidth
      @_append '<none>\n</none>'

    return this

  get: ->
    do @_ensureClosed
    if @_written[@_written.length - 1] is '<none>\n</none>'
      @_written.pop()
    @_written.join ""

  _ensureClosed: ->
    if @_activeBlock isnt @_root
      throw Error "Not all the blocks have been closed.
        Please call block.close() on all open blocks."

    if @_root.isOpen()
      @_root.close()

    return

for prop in ['openBlock', 'write'] then do ->
  method = prop
  Layout::[method] = ->
    @_root[method].apply @_root, arguments
