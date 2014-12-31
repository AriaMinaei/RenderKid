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

		if @_parent? then @_parent.write @_whatToPrependToBlock()

		do @_activate

		@

	close: ->

		do @_deactivate

		@_closed = yes

		if @_parent? then @_parent.write @_whatToAppendToBlock()

		@

	isOpen: ->

		@_wasOpenOnce and not @_closed

	write: (str) ->

		do @_ensureActive

		return if str is ''

		str = String str

		@_buffer += str

		@

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

		# special characters (such as <bg-white>) don't require
		# any wrapping...
		if SpecialString(str).isOnlySpecialChars()

			# ... and directly get appended to the layout.
			@_layout._append str

			return

		# we'll be removing from the original string till it's empty
		remaining = str

		# we might need to add a few line breaks at the end of the text.
		lineBreaksToAppend = 0

		# if text starts with line breaks...
		if m = remaining.match /^\n+/

			# ... we want to write the exact same number of line breaks
			# to the layout.
			for i in [1..m[0].length]

				@_writeLine ''

			remaining = remaining.substr m[0].length, remaining.length

		# and if the text ends with line breaks...
		if m = remaining.match /\n+$/

			# we want to write the exact same number of line breaks
			# to the end of the layout.
			lineBreaksToAppend = m[0].length

			remaining = remaining.substr 0, remaining.length - m[0].length

		# now let's parse the body of the text.
		while remaining.length > 0

			# anything other than a break line...
			if m = remaining.match /^[^\n]+/

				# ... should be wrapped as a block of text.
				@_writeLine m[0]

				remaining = remaining.substr m[0].length, remaining.length

			# for any number of line breaks we find inside the text...
			else if m = remaining.match /^\n+/

				# ... we write one less break line to the layout.
				for i in [1...m[0].length]

					@_writeLine ''

				remaining = remaining.substr m[0].length, remaining.length

		# if we had line breaks to append to the layout...
		if lineBreaksToAppend > 0

			# ... we append the exact same number of line breaks to the layout.
			for i in [1..lineBreaksToAppend]

				@_writeLine ''

		return

	# wraps a line into multiple lines if necessary, adds horizontal margins,
	# etc, and appends it to the layout.
	_writeLine: (str) ->

		# we'll be cutting from our string as we go
		remaining = SpecialString str

		# this will continue until nothing is left of our block.
		loop

			# left margin...
			toPrepend = @_toPrependToLine()

			# ... and its length
			toPrependLength = SpecialString(toPrepend).length

			# right margin...
			toAppend = @_toAppendToLine()

			# ... and its length
			toAppendLength = SpecialString(toAppend).length

			# how much room is left for content
			roomLeft = @_layout._config.terminalWidth - (toPrependLength + toAppendLength)

			# how much room each line of content will have
			lineContentLength = Math.min @_config.width, roomLeft

			# cut line content, only for the amount needed
			lineContent = remaining.cut(0, lineContentLength, yes)

			# line will consist of both margins and the content
			line = toPrepend + lineContent.str + toAppend

			# send it off to layout
			@_layout._appendLine line

			break if remaining.isEmpty()


		return