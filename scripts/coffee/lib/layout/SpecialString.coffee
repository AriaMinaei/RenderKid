module.exports = class SpecialString

	self = @

	@_tabRx: /^\t/

	@_tagRx: ///
		^
		\<
		[^>]+
		>
	///

	@_quotedHtmlRx: ///
		^
		\&
		(gt|lt|quot|amp|apos|nbsp)
		\;
	///

	constructor: (str) ->

		unless @constructor is self

			return new self str

		@_str = String str

		@_lenCalculated = no

		@_len = 0

	@::__defineGetter__ 'str', ->

		@_str

	toString: ->

		@_str

	_reset: ->

		@_lenCalculated = no

		@_len = 0

	splitIn: (limit) ->

		buffer = ''

		bufferLength = 0

		lines = []

		justSkippedSkipChar = no

		self._countChars @_str, (char, charLength) ->

			if bufferLength > limit or bufferLength + charLength > limit

				lines.push buffer

				buffer = ''

				bufferLength = 0

			if bufferLength is 0 and char is ' ' and not justSkippedSkipChar

				justSkippedSkipChar = yes

			else

				buffer += char
				bufferLength += charLength
				justSkippedSkipChar = no

		if buffer.length > 0

			lines.push buffer

		lines

	length: ->

		if @_lenCalculated then return @_len

		sum = 0

		self._countChars @_str, (char, charLength) ->

			sum += charLength

			return

		@_lenCalculated = yes

		@_len = sum

		@_len

	cut: (from, to) ->

		unless to? then to = @length()

		from = parseInt from

		if from >= to

			throw Error "`from` shouldn't be larger than `to`"

		before = ''

		after = ''

		cut = ''

		cur = 0

		self._countChars @_str, (char, charLength) ->

			if cur < from

				before += char

			else if cur < to

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