_Declaration = require './_Declaration'

module.exports = class _Length extends _Declaration

	_set: (val) ->

		unless /^[0-9]+$/.test String(val)

			throw Error "`#{@prop}` only takes an integer for value"

		@val = parseInt val