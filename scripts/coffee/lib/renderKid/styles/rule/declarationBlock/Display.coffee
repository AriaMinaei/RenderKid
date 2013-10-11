_Declaration = require './_Declaration'

module.exports = class Display extends _Declaration

	self = @

	@_allowed: ['inline', 'block', 'none']

	_set: (val) ->

		val = String(val).toLowerCase()

		unless val in self._allowed

			throw Error "Unrecognizable value `#{val}` for `#{@prop}`"

		@val = val