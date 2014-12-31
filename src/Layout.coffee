Block = require './layout/Block'
{object} = require 'utila'
layoutConfig = require './layout/config'
SpecialString = require './layout/SpecialString'

module.exports = class Layout

	self = @

	@_rootBlockDefaultConfig:

		linePrependor: options: amount: 0
		lineAppendor: options: amount: 0

		blockPrependor: options: amount: 0
		blockAppendor: options: amount: 0

	@_defaultConfig:

		terminalWidth: 80

	constructor: (config = {}, rootBlockConfig = {}) ->

		@_written = []

		@_activeBlock = null

		@_config = layoutConfig config, self._defaultConfig

		# Every layout has a root block
		rootConfig = object.append self._rootBlockDefaultConfig, rootBlockConfig

		@_root = new Block @, null, rootConfig, '__root'

		@_root._open()

	getRootBlock: ->

		@_root

	_append: (text) ->

		@_written.push text

	_appendLine: (text) ->

		@_append text

		s = SpecialString(text)

		if s.length < @_config.terminalWidth

			@_append '<none>\n</none>'

		@

	get: ->

		do @_ensureClosed

		if @_written[@_written.length - 1] is '<none>\n</none>'

			@_written.pop()

		@_written.join ""

	_ensureClosed: ->

		if @_activeBlock isnt @_root

			throw Error "Not all the blocks have been closed.
				Please call block.close() on all open blocks."

		if @_root.isOpen() then @_root.close()

		return

for prop in ['openBlock', 'write'] then do ->

	method = prop

	Layout::[method] = ->

		@_root[method].apply @_root, arguments