Block = require './layout/Block'
SpecialString = require './layout/SpecialString'

module.exports = class Layout

	constructor: ->

		@_written = ''

		@_lastWritingPurpose

		@_activeBlock = null

		@_root = new Block @, null, {}, '_root'

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

		@_root.close()

		return

for prop in ['openBlock', 'write'] then do ->

	method = prop

	Layout::[method] = ->

		@_root[method].apply @_root, arguments