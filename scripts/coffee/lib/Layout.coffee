Block = require './layout/Block'
SpecialString = require './layout/SpecialString'
{object} = require 'utila'

module.exports = class Layout

	self = @

	@_rootBlockConfig:

		linePrependor: options: amount: 0
		lineAppendor: options: amount: 0

		blockPrependor: options: amount: 0
		blockAppendor: options: amount: 0

	constructor: (rootBlockConfig) ->

		@_written = ''

		@_lastWritingPurpose

		@_activeBlock = null

		conf = object.append self._rootBlockConfig, rootBlockConfig

		@_root = new Block @, null, conf, '__root'

		@_root._open()

	_write: (str) ->

		@_written += str

		@

	_setLastWritingPurpose: (purpose) ->

		@_lastWritingPurpose = purpose

		@

	_getLastWritingPurpose: ->

		@_lastWritingPurpose

	get: ->

		do @_ensureClosed

		@_written

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