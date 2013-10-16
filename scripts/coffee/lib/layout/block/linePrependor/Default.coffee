tools = require '../../../tools'

module.exports = class DefaultLinePrependor extends require './_LinePrependor'

	_render: (inherited, options) ->

		inherited + tools.repeatString " ", @_config.amount