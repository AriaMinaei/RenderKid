_Declaration = require './_Declaration'

module.exports = class Bullet extends _Declaration

	self = @

	_set: (val) ->

		val = String val

		original = val

		char = null

		enabled = no

		color = 'none'

		bg = 'none'

		if m = val.match(/\"([^"]+)\"/) or m = val.match(/\'([^']+)\'/)

			char = m[1]

			val = val.replace m[0], ''

			enabled = yes

		if m = val.match(/(none|left|right|center)/)

			alignment = m[1]

			val = val.replace m[0], ''

		else

			alignment = 'left'

		if alignment is 'none' then enabled = no

		if m = val.match /color\:([\w\-]+)/

			color = m[1]

			val = val.replace m[0], ''

		if m = val.match /bg\:([\w\-]+)/

			bg = m[1]

			val = val.replace m[0], ''

		if val.trim() isnt ''

			throw Error "Unrecognizable value `#{original}` for `#{@prop}`"

		@val =

			enabled: enabled
			char: char
			alignment: alignment
			background: bg
			color: color