wn = require 'when'
htmlparser  = require 'htmlparser2'

module.exports = tools =

	ansiRx: ///

		^
		\u
		001b
		\[
		[0-9]{1,2}
		m

	///

	tabRx: ///

		^
		[\t]{1}

	///

	trimLeft: (str) ->

		str.replace /^[\ ]+/, ''

	limitTextLineLength: (text, limit) ->

		text = text.trim()

		remainingText = text

		buffer = ''

		bufferLength = 0

		lines = []

		justSkippedSkipChar = no

		while remainingText.length isnt 0

			if m = remainingText.match tools.ansiRx

				addToBuffer = m[0]
				addToBufferLength = 0
				remainingText = remainingText.substr addToBuffer.length, remainingText.length

			else if remainingText.match tools.tabRx

				addToBuffer = "\t"
				addToBufferLength = 8
				remainingText = remainingText.substr 1, remainingText.length

			else

				addToBuffer = remainingText[0]
				addToBufferLength = 1
				remainingText = remainingText.substr 1, remainingText.length

			if bufferLength > limit or bufferLength + addToBufferLength > limit

				lines.push buffer

				buffer = ''

				bufferLength = 0

			if bufferLength is 0 and addToBuffer is ' ' and not justSkippedSkipChar

				justSkippedSkipChar = yes

			else

				buffer += addToBuffer
				bufferLength += addToBufferLength
				justSkippedSkipChar = no


		if buffer.length > 0

			lines.push buffer

		lines.join "\n"

	repeatString: (str, times) ->

		output = ''

		for i in [0...times]

			output += str

		output

	indent: (text, indent, maxLineLength, indentFirstLineToo = yes) ->

		limit = maxLineLength - indent

		originalLines = text.split "\n"

		finalLines = []

		for line in originalLines

			finalLines = finalLines.concat tools.limitTextLineLength(line, limit).split("\n")

		indentChars = tools.repeatString ' ', indent

		finalLines.map (line, i) ->

			if i is 0 and not indentFirstLineToo

				return line

			indentChars + line

		.join "\n"

	indentLine: (text, maxLineLength, indent) ->

		lines = tools.limitTextLineLength text, maxLineLength - indent

		indentChars = tools.repeatString ' ', indent

		lines
		.split("\n")
		.map (line) ->

			indentChars + line

		.join("\n")

	toDom: (string) ->

		later = wn.defer()

		handler = new htmlparser.DomHandler (err, dom) ->

			if err?

				later.reject err

			else

				later.resolve dom

		parser = new htmlparser.Parser handler

		parser.write string

		parser.end()

		later.promise

	escape: (str) ->

		String(str)
		.replace(/([<]{1})/g, "&lt;")
		.replace(/([>]{1})/g, "&gt;")