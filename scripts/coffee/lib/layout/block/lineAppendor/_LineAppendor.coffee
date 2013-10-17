module.exports = class _LineAppendor

	constructor: (@_config) ->

		@_lineNo = 0

	render: (inherited, options) ->

		@_lineNo++

		'<none>' + @_render(inherited, options) + '</none>'