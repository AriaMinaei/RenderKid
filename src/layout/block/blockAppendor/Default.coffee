tools = require '../../../tools'

module.exports = class DefaultBlockAppendor extends require './_BlockAppendor'
  _render: (options) ->
    tools.repeatString "\n", @_config.amount