htmlparser  = require 'htmlparser2'
{object} = require 'utila'
{objectToDom} = require 'dom-converter'

module.exports = self =

	repeatString: (str, times) ->

		output = ''

		for i in [0...times]

			output += str

		output

	toDom: (subject) ->

		if typeof subject is 'string'

			return self.stringToDom subject

		else if object.isBareObject subject

			return self._objectToDom subject

		else

			throw Error "tools.toDom() only supports strings and objects"

	stringToDom: (string) ->

		handler = new htmlparser.DomHandler

		parser = new htmlparser.Parser handler

		parser.write string

		parser.end()

		handler.dom

	_fixQuotesInDom: (input) ->

		if Array.isArray input

			for node in input

				self._fixQuotesInDom node

			return input

		node = input

		if node.type is 'text'

			return node.data = self._quoteNodeText node.data

		else

			return self._fixQuotesInDom node.children

	objectToDom: (o) ->

		unless Array.isArray(o)

			unless object.isBareObject(o)

				throw Error "objectToDom() only accepts a bare object or an array"

		self._fixQuotesInDom objectToDom o

	quote: (str) ->

		String(str)
		.replace(/</g, '&lt;')
		.replace(/>/g, '&gt;')
		.replace(/\"/g, '&quot;')
		.replace(/\ /g, '&sp;')
		.replace(/\n/g, '<br />')

	_quoteNodeText: (text) ->

		String(text)
		.replace(/\&/g, '&amp;')
		.replace(/</g, '&lt;')
		.replace(/>/g, '&gt;')
		.replace(/\"/g, '&quot;')
		.replace(/\ /g, '&sp;')
		.replace(/\n/g, "&nl;")