module.exports = class SpecialString

	self = @

	@tabRx: /^\t/

	@tagRx: ///
		^
		\<
		[^>]+
		>
	///

	@quotedHtmlRx: ///
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

	@_countChars: (text, cb) ->

		while text.length isnt 0

			if m = text.match self.tagRx

				char = m[0]
				charLength = 0
				text = text.substr char.length, text.length

			else if m = text.match self.quotedHtmlRx

				char = m[0]
				charLength = 1
				text = text.substr char.length, text.length

			else if text.match self.tabRx

				char = "\t"
				charLength = 8
				text = text.substr 1, text.length

			else

				char = text[0]
				charLength = 1
				text = text.substr 1, text.length

			cb.call null, char, charLength

		return