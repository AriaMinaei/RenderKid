defaultTheme = require './themes/default'
ansi = require './ansiColors'
dombie = require 'dombie'
wn	= require 'when'

Configurable_ = require('lax').Configurable_
classic = require('utila').classic
array = require('utila').array

trimLeft = (str) ->

	str.replace /^[\ ]+/, ''

formattedLineTokens =

	ansi: ///

		^
		\u
		001b
		\[
		[0-9]{1,2}
		m

	///

	tab: ///

		^
		[\t]{1}

	///

#
module.exports = classic.implement Configurable_, class RenderKid

	@_defaultConfig:

		theme: defaultTheme

	constructor: (initialConfig) ->

		do @_initConfig

		@config RenderKid._defaultConfig

		@config initialConfig

	render: (s) ->

		@_parse(s).then (obj) => @_renderObj obj

	_theme: (key) ->

		@config('theme.' + key)

	_parse: (s) ->

		later = wn.defer()

		dombie s, (er, res) ->

			if er?

				later.reject er

			else

				later.resolve res

			return

		later.promise

	_style: (content, styleKeyInTheme) ->

		ansi.color content, styleKeyInTheme

	_renderObj: (obj) ->

		unless Array.isArray obj

			throw Error "Xml string does not produce sensible results"

		@_renderChildren obj, 0

	_renderChildren: (nodes, indent) ->

		output = ''

		for node in nodes

			if node.type is 'tag'

				output += @_renderTag node, indent

			else if node.type is 'text'

				output += @_renderText node, indent

			else

				throw Error "Unexpected node type '#{node.type}"

		output

	_renderText: (node, indent) ->

		@_indent node.data, indent

	_fixTag: (node) ->

		return node if node.type isnt 'tag'

		indexesToRemove = []

		for child, i in node.children

			if child.type is 'text' and child.data.trim() is ''

				indexesToRemove.push i

		array.pluckMultiple node.children, indexesToRemove

	_renderTag: (node, indent) ->

		@_fixTag node

		switch node.name

			when 'item' then return @_renderTagItem node, indent

			when 'li.note' then return @_renderTagLiNote node, indent

			when 'li.success' then return @_renderTagLiSuccess node, indent

			when 'li.failure' then return @_renderTagLiFailure node, indent

			when 'pre' then return @_renderTagPre node, indent

			when 'br' then return @_renderTagBr node, indent

			else

				throw Error "Unrecognizable tag name '#{node.name}"

	_renderAnItem: (node, indent, sign, signStyle, title) ->

		signLength = sign.length

		before = '\n' + @_repeatString(' ', indent) + @_style sign, signStyle
		before += @_repeatString ' ', @_theme('indent') - signLength

		if title

			before += @_indent(title, indent + @_theme('indent'), no) + "\n"

		lines = @_renderChildren node.children, indent + @_theme('indent')

		if lines.length > 0 and lines[0] isnt "\n"

			lines = "\n" + lines

		unless title

			if lines[0] is "\n" then lines = lines.substr 1, lines.length

			lines = trimLeft lines

		text = before + lines

		text

	_repeatString: (str, times) ->

		output = ''
		for i in [0...times]

			output += str

		output

	_getTitle: (node, defaultStyle) ->

		if node.children[0]? and node.children[0].type is 'tag' and node.children[0].name is 'title'

			children = node.children.shift().children

			return '' if children.length is 0

			return @_style children[0].data, defaultStyle if children.length is 1 and children[0].type is 'text'

			return @_formatChildren children

		else

			# throw Error "Node doesn't come with a title"

			return ''

	_renderSignedTag: (node, indent, key) ->

		sign = @_theme "sign_#{key}"

		title = @_getTitle node, @_theme("#{key}_color")

		@_renderAnItem node, indent, sign, @_theme("sign_#{key}_color"), title

	_renderTagItem: (node, indent) ->

		@_renderSignedTag node, indent, 'item'

	_renderTagLiNote: (node, indent) ->

		@_renderSignedTag node, indent, 'note'

	_renderTagLiSuccess: (node, indent) ->

		@_renderSignedTag node, indent, 'success'

	_renderTagLiFailure: (node, indent) ->

		@_renderSignedTag node, indent, 'failure'

	_renderTagPre: (node, indent) ->

		childrenText = @_formatChildren node.children
		childrenText = childrenText.trim()

		(@_indent childrenText, indent) + "\n"

	_renderTagBr: -> "\n"

	_indent: (text, indent, indentFirstLineToo = yes) ->

		limit = @_theme('max_line_length') - indent

		originalLines = text.split "\n"

		finalLines = []

		for line in originalLines

			finalLines = finalLines.concat @_limitTextLineLength(line, limit).split("\n")

		indentChars = @_repeatString ' ', indent

		finalLines.map (line, i) ->

			if i is 0 and not indentFirstLineToo

				return line

			indentChars + line

		.join "\n"

	_indentLine: (text, indent) ->

		maxLineLength = @_theme 'max_line_length'

		lines = @_limitTextLineLength text, maxLineLength - indent

		indentChars = @_repeatString ' ', indent

		lines
		.split("\n")
		.map (line) ->

			indentChars + line

		.join("\n")

	_limitTextLineLength: (text, limit) ->

		text = text.trim()

		remainingText = text

		buffer = ''

		bufferLength = 0

		lines = []

		justSkippedSkipChar = no

		while remainingText.length isnt 0

			if m = remainingText.match formattedLineTokens.ansi

				addToBuffer = m[0]
				addToBufferLength = 0
				remainingText = remainingText.substr addToBuffer.length, remainingText.length

			else if remainingText.match formattedLineTokens.tab

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

	_formatChildren: (chidlren) ->

		formattedText = ''

		for child in chidlren

			formattedText += @_formatChild child

		formattedText

	_formatChild: (node) ->

		if node.type is 'text'

			return node.data

		switch node.name

			when 'strong' then return @_formatStrong node

			when 'em' then return @_formatEm node

			when 'trivial' then return @_formatTrivial node

			when 'br' then return @_formatBr node

			else

				throw Error "Unknown formatting tag '#{node.name}"

	_formatStrong: (node) ->

		@_formatSingleNode node, @_theme 'text_strong'

	_formatEm: (node) ->

		@_formatSingleNode node, @_theme 'text_em'

	_formatTrivial: (node) ->

		@_formatSingleNode node, @_theme 'text_trivial'

	_formatBr: (node) ->

		"\n"

	_formatSingleNode: (node, style) ->

		return '' if node.children.length is 0

		if node.children.length isnt 1

			throw Error "Format tags must not have any tags inside them"

		textNode = node.children[0]

		unless textNode.type is 'text'

			throw Error "Format tags must only come with a single text node child"

		@_style textNode.data, style