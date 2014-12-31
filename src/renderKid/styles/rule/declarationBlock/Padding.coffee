_Declaration = require './_Declaration'

PaddingTop = require './PaddingTop'
PaddingLeft = require './PaddingLeft'
PaddingRight = require './PaddingRight'
PaddingBottom = require './PaddingBottom'

module.exports = class Padding extends _Declaration

	self = @

	@setOnto: (declarations, prop, originalValue) ->

		append = ''

		val = _Declaration.sanitizeValue originalValue

		if _Declaration.importantClauseRx.test String(val)

			append = ' !important'

			val = val.replace _Declaration.importantClauseRx, ''

		val = val.trim()

		if val.length is 0

			return self._setAllDirections declarations, append, append, append, append

		vals = val.split(" ").map (val) -> val + append

		if vals.length is 1

			self._setAllDirections declarations, vals[0], vals[0], vals[0], vals[0]

		else if vals.length is 2

			self._setAllDirections declarations, vals[0], vals[1], vals[0], vals[1]

		else if vals.length is 3

			self._setAllDirections declarations, vals[0], vals[1], vals[2], vals[1]

		else if vals.length is 4

			self._setAllDirections declarations, vals[0], vals[1], vals[2], vals[3]

		else

			throw Error "Can't understand value for padding: `#{originalValue}`"



	@_setAllDirections: (declarations, top, right, bottom, left) ->

		PaddingTop.setOnto declarations, 'paddingTop', top
		PaddingTop.setOnto declarations, 'paddingRight', right
		PaddingTop.setOnto declarations, 'paddingBottom', bottom
		PaddingTop.setOnto declarations, 'paddingLeft', left

		return