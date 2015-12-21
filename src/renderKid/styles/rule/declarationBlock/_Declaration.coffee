# Abstract Style Declaration
module.exports = class _Declaration
  self = @
  @importantClauseRx: /(\s\!important)$/

  @setOnto: (declarations, prop, val) ->
    unless dec = declarations[prop]
      declarations[prop] = new @ prop, val
    else
      dec.set val

  @sanitizeValue: (val) ->
    String(val).trim().replace /[\s]+/g, ' '

  @inheritAllowed: no

  constructor: (@prop, val) ->
    @important = no
    @set val

  get: ->
    @_get()

  _get: ->
    @val

  _pickImportantClause: (val) ->
    if self.importantClauseRx.test String(val)
      @important = yes
      val.replace self.importantClauseRx, ''
    else
      @important = no
      val

  set: (val) ->
    val = self.sanitizeValue val
    val = @_pickImportantClause val
    val = val.trim()

    return @ if @_handleNullOrInherit val
    @_set val
    this

  _set: (val) ->
    @val = val

  _handleNullOrInherit: (val) ->
    if val is ''
      @val = ''
      return true

    if val is 'inherit'
      if @constructor.inheritAllowed
        @val = 'inherit'
      else
        throw Error "Inherit is not allowed for `#{@prop}`"

      true
    else
      false