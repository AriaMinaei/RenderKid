tools = require '../../../tools'

module.exports = class DefaultBlockPrependor extends require './_BlockPrependor'

	_render: (options) ->

		tools.repeatString "\n", @_config.amount