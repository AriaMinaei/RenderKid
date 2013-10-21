wn = require 'when'
htmlparser  = require 'htmlparser2'

module.exports = tools =

	repeatString: (str, times) ->

		output = ''

		for i in [0...times]

			output += str

		output

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