module.exports = class _LinePrependor

	constructor: (@_config) ->

		@_lineNo = -1

	render: (inherited, options) ->

		@_lineNo++

		'<none>' + @_render(inherited, options) + '</none>'