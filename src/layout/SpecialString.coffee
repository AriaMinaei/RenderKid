module.exports = class SpecialString

	self = @

	@_tabRx: /^\t/

	@_tagRx: ///
		^
		<
		[^>]+
		>
	///

	@_quotedHtmlRx: ///
		^
		&
		(gt|lt|quot|amp|apos|sp)
		;
	///

	constructor: (str) ->

		unless @constructor is self

			return new self str

		@_str = String str

		@_len = 0

	_getStr: ->

		@_str

	set: (str) ->

		@_str = String str

		@

	clone: ->

		new SpecialString @_str

	isEmpty: ->

		@_str is ''

	isOnlySpecialChars: ->

		not @isEmpty() and @length is 0

	_reset: ->

		@_len = 0

	splitIn: (limit, trimLeftEachLine = no) ->

		buffer = ''

		bufferLength = 0

		lines = []

		justSkippedSkipChar = no

		self._countChars @_str, (char, charLength) ->

			if bufferLength > limit or bufferLength + charLength > limit

				lines.push buffer

				buffer = ''

				bufferLength = 0

			if bufferLength is 0 and char is ' ' and not justSkippedSkipChar and trimLeftEachLine

				justSkippedSkipChar = yes

			else

				buffer += char
				bufferLength += charLength
				justSkippedSkipChar = no

		if buffer.length > 0

			lines.push buffer

		lines

	trim: ->

		new SpecialString(@str.trim())

	trimLeft: ->

		new SpecialString(@str.replace(/^\s+/, ''))

	trimRight: ->

		new SpecialString(@str.replace(/\s+$/, ''))

	_getLength: ->

		sum = 0

		self._countChars @_str, (char, charLength) ->

			sum += charLength

			return

		sum

	cut: (from, to, trimLeft = no) ->

		unless to? then to = @length

		from = parseInt from

		if from >= to

			throw Error "`from` shouldn't be larger than `to`"

		before = ''

		after = ''

		cut = ''

		cur = 0

		self._countChars @_str, (char, charLength) =>

			if @str is 'ab<tag>'

				console.log charLength, char

			return if cur is from and char.match(/^\s+$/) and trimLeft

			if cur < from

				before += char

			# let's be greedy
			else if cur < to or cur + charLength <= to

				cut += char

			else

				after += char

			cur += charLength

			return

		@_str = before + after

		do @_reset

		SpecialString cut

	@_countChars: (text, cb) ->

		while text.length isnt 0

			if m = text.match self._tagRx

				char = m[0]
				charLength = 0
				text = text.substr char.length, text.length

			else if m = text.match self._quotedHtmlRx

				char = m[0]
				charLength = 1
				text = text.substr char.length, text.length

			else if text.match self._tabRx

				char = "\t"
				charLength = 8
				text = text.substr 1, text.length

			else

				char = text[0]
				charLength = 1
				text = text.substr 1, text.length

			cb.call null, char, charLength

		return

for prop in ['str', 'length'] then do ->

	methodName = '_get' + prop[0].toUpperCase() + prop.substr(1, prop.length)

	SpecialString::__defineGetter__ prop, -> do @[methodName]