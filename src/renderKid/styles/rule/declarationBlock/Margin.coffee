_Declaration = require './_Declaration'

MarginTop = require './MarginTop'
MarginLeft = require './MarginLeft'
MarginRight = require './MarginRight'
MarginBottom = require './MarginBottom'

module.exports = class Margin extends _Declaration

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

			throw Error "Can't understand value for margin: `#{originalValue}`"



	@_setAllDirections: (declarations, top, right, bottom, left) ->

		MarginTop.setOnto declarations, 'marginTop', top
		MarginTop.setOnto declarations, 'marginRight', right
		MarginTop.setOnto declarations, 'marginBottom', bottom
		MarginTop.setOnto declarations, 'marginLeft', left

		return