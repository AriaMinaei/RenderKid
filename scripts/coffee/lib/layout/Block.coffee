{number} = require 'utila'
tools = require '../tools'

module.exports = class Block

	constructor: (@_layout, @_parent, @_config, @_name = '') ->

		@_closed = no

		@_wasOpenOnce = no

		@_active = no

		@_buffer = ''

		@_didSeparateBlock = no

	_activate: (deactivateParent = yes) ->

		if @_active

			throw Error "This block is already active. This is probably a bug in RenderKid itself"

		if @_closed

			throw Error "This block is closed and cannot be activated. This is probably a bug in RenderKid itself"

		@_active = yes

		@_layout._activeBlock = @

		if deactivateParent

			if @_parent? then @_parent._deactivate no

		@

	_deactivate: (activateParent = yes) ->

		do @_ensureActive

		do @_flushBuffer

		if activateParent

			if @_parent? then @_parent._activate no

		@_active = no

		@

	_ensureActive: ->

		unless @_wasOpenOnce

			throw Error "This block has never been open before. This is probably a bug in RenderKid itself."

		unless @_active

			throw Error "This block is not active. This is probably a bug in RenderKid itself."

		if @_closed

			throw Error "This block is already closed. This is probably a bug in RenderKid itself."

	_open: ->

		if @_wasOpenOnce

			throw Error "Block._open() has been called twice. This is probably a RenderKid bug."

		@_wasOpenOnce = yes

		if @_config.marginTop > 0

			@_parent._write (tools.repeatString "\n", @_config.marginTop), 'marginTop'

		do @_activate

		@

	close: ->

		do @_deactivate

		@_closed = yes

		if @_parent?

			if @_config.marginBottom > 0

				@_parent._write (tools.repeatString "\n", @_config.marginBottom), 'marginBottom'

		@

	write: (str) ->

		@_write str, 'user-input'

	_write: (str, purpose) ->

		do @_ensureActive

		@_layout._setLastWritingPurpose purpose

		do @_ensureBlockSeparation

		do @_ensureInlineSeparation

		@__write str, purpose

		@

	__write: (str, purpose) ->

		@_buffer += str

		@_layout._setLastWritingPurpose purpose

		return

	openBlock: (config, name) ->

		do @_ensureActive

		do @_flushBuffer

		block = new Block @_layout, @, config, name

		block._open()

		block

	_flushBuffer: ->

		return if @_buffer is ''

		str = @_buffer

		@_buffer = ''

		@_writeInline str

		return

	###*
	 * This is to ensure that the current block is separated
	 * from its last sibling block.
	###
	_ensureBlockSeparation: ->

		return if @_didSeparateBlock

		@_didSeparateBlock = yes

		if @_parent? and @_isOkToWriteBlockSeparator()

			do @_deactivate

			@_parent._write "\n", 'block-separation'

			do @_activate

	###*
	 * This is to make sure that each inline piece of text in the current
	 * block is separated from its last sibling block.
	###
	_ensureInlineSeparation: ->

		return unless @_buffer is ''

		if @_isOkToWriteBlockSeparator()

			@__write "\n", 'block-separation'

		return

	_isOkToWriteBlockSeparator: ->

		@_layout._getLastWritingPurpose() isnt 'block-separation'

	_writeInline: (str) ->

		@_layout._write str
