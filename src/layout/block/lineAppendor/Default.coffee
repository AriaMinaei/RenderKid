tools = require '../../../tools'

module.exports = class DefaultLineAppendor extends require './_LineAppendor'
  _render: (inherited, options) ->
    inherited + tools.repeatString " ", @_config.amount