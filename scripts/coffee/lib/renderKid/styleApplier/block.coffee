_common = require './_common'
{object} = require 'utila'

module.exports = blockStyleApplier = self =

	applyTo: (el, style) ->

		ret = _common.getStyleTagsFor style

		ret.blockConfig = config = {}

		@_margins style, config

		@_bullet style, config

		@_dims style, config

		ret

	_margins: (style, config) ->

		if style.marginLeft?

			object.appendOnto config, linePrependor:

				options: amount: parseInt style.marginLeft

		if style.marginRight?

			object.appendOnto config, lineAppendor:

				options: amount: parseInt style.marginRight

		if style.marginTop?

			object.appendOnto config, blockPrependor:

				options: amount: parseInt style.marginTop

		if style.marginBottom?

			object.appendOnto config, blockAppendor:

				options: amount: parseInt style.marginBottom

		return

	_bullet: (style, config) ->

		if style.bullet? and style.bullet.enabled

			bullet = style.bullet

			conf = {}

			conf.alignment = style.bullet.alignment

			{before, after} = _common.getStyleTagsFor color: bullet.color, background: bullet.background

			conf.char = before + bullet.char + after

			object.appendOnto config, linePrependor:

				options: bullet: conf

		return

	_dims: (style, config) ->

		if style.width?

			w = parseInt style.width

			config.width = w

		return