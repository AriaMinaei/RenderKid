module.exports = class _LineAppendor

	constructor: (@_config) ->

		@_lineNo = 0

	render: (inherited, options) ->

		@_lineNo++

		@_render inherited, options