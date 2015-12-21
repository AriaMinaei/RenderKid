tools = require '../../../tools'
SpecialString = require '../../SpecialString'

module.exports = class DefaultLinePrependor extends require './_LinePrependor'
  self = @

  @pad: (howMuch) ->
    tools.repeatString(" ", howMuch)

  _render: (inherited, options) ->
    if @_lineNo is 0 and bullet = @_config.bullet
      char = bullet.char
      charLen = SpecialString(char).length
      alignment = bullet.alignment
      space = @_config.amount
      toWrite = char
      addToLeft = ''
      addToRight = ''

      if space > charLen
        diff = space - charLen
        if alignment is 'right'
          addToLeft = self.pad diff
        else if alignment is 'left'
          addToRight = self.pad(diff)
        else if alignment is 'center'
          left = Math.round diff / 2
          addToLeft = self.pad left
          addToRight = self.pad diff - left
        else
          throw Error "Unkown alignment `#{alignment}`"
      output = addToLeft + char + addToRight
    else
      output = self.pad @_config.amount

    inherited + output