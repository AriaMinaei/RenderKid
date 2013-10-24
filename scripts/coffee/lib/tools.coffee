htmlparser  = require 'htmlparser2'

module.exports = tools =

	repeatString: (str, times) ->

		output = ''

		for i in [0...times]

			output += str

		output

	toDom: (string) ->

		handler = new htmlparser.DomHandler

		parser = new htmlparser.Parser handler

		parser.write string

		parser.end()

		handler.dom

	quote: (str) ->

		String(str)
		.replace(/</g, '&lt;')
		.replace(/>/g, '&gt;')
		.replace(/\n/g, '<br>')
		.replace(/\"/g, '&quot;')
		.replace(/\ /g, '&nbsp;')
