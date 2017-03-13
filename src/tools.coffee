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
      self.stringToDom subject
    else if object.isBareObject subject
      self._objectToDom subject
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
      node.data = self._quoteNodeText node.data
    else
      self._fixQuotesInDom node.children

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

  getCols: ->
    # Based on https://github.com/jonschlinkert/window-size
    tty = require 'tty'

    cols =
      try
        if tty.isatty(1) && tty.isatty(2)
          if process.stdout.getWindowSize
            process.stdout.getWindowSize(1)[0]
          else if tty.getWindowSize
            tty.getWindowSize()[1]
          else if process.stdout.columns and process.stdout.rows
            process.stdout.rows

    if typeof cols is 'number' && number > 30 then cols else 80