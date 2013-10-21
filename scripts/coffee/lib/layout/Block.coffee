blockConfig = require './block/config'
SpecialString = require './SpecialString'

module.exports = class Block

	self = @

	@defaultConfig =

		blockPrependor:

			fn: require './block/blockPrependor/Default'

			options: amount: 0

		blockAppendor:

			fn: require './block/blockAppendor/Default'

			options: amount: 0

		linePrependor:

			fn: require './block/linePrependor/Default'

			options: amount: 0

		lineAppendor:

			fn: require './block/lineAppendor/Default'

			options: amount: 0

		lineWrapper:

			fn: require './block/lineWrapper/Default'

			options: lineWidth: null

		width: 80

		prefixRaw: ''
		suffixRaw: ''

	constructor: (@_layout, @_parent, config = {}, @_name = '') ->

		@_config = blockConfig config, self.defaultConfig

		@_closed = no

		@_wasOpenOnce = no

		@_active = no

		@_buffer = ''

		@_didSeparateBlock = no

		@_linePrependor =

			new @_config.linePrependor.fn @_config.linePrependor.options

		@_lineAppendor =

			new @_config.lineAppendor.fn @_config.lineAppendor.options

		@_blockPrependor =

			new @_config.blockPrependor.fn @_config.blockPrependor.options

		@_blockAppendor =

			new @_config.blockAppendor.fn @_config.blockAppendor.options

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

		if @_parent? then @_parent._write @_whatToPrependToBlock(), 'margin'

		do @_activate

		@_layout._write @_config.prefixRaw

		@

	close: ->

		do @_deactivate

		@_closed = yes

		@_layout._write @_config.suffixRaw

		if @_parent? then @_parent._write @_whatToAppendToBlock(), 'margin'

		@

	isOpen: ->

		@_wasOpenOnce and not @_closed

	write: (str) ->

		@_write str, 'user-input'

	_write: (str, purpose) ->

		do @_ensureActive

		return if str is ''

		str = String str

		if SpecialString(str).length > 0

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

	_toPrependToLine: ->

		fromParent = ''

		if @_parent?

			fromParent = @_parent._toPrependToLine()

		@_linePrependor.render fromParent

	_toAppendToLine: ->

		fromParent = ''

		if @_parent?

			fromParent = @_parent._toAppendToLine()

		@_lineAppendor.render fromParent

	_whatToPrependToBlock: ->

		@_blockPrependor.render()

	_whatToAppendToBlock: ->

		@_blockAppendor.render()

	_writeInline: (str) ->

		if SpecialString(str).isOnlySpecialChars()

			@_layout._write str

			return

		# yeah, I can't even look at myself right now...
		if str.match(/^\n{2,}$/) and @_layout._getLastWritingPurpose() is 'margin'

			@_layout._write str.substr(1, str.length)

			@_layout._setLastWritingPurpose 'block-separation'

			return

		lines = []

		for line in str.split "\n"

			lines.push @_writeLine line

		@_layout._write lines.join "<none>\n</none>"

		return

	_writeLine: (str) ->

		remaining = SpecialString str

		ret = ''

		while not remaining.isEmpty()

			toPrepend = @_toPrependToLine()

			toPrependLength = SpecialString(toPrepend).length

			toAppend = @_toAppendToLine()

			toAppendLength = SpecialString(toAppend).length

			lineContentLength = @_config.width - toPrependLength - toAppendLength

			lineContent = remaining.cut(0, lineContentLength, yes)

			line = toPrepend + lineContent.str + toAppend

			# if the current line is shorter than the terminal line width,
			# we should add a line break to make sure we go off to the next line.
			if SpecialString(line).length < @_layout._config.terminalWidth and remaining.length > 0

				line += "\n"

			ret += line

		ret