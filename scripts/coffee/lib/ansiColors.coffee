ansi =

	_colors:

		off: 0
		bold: 1
		italic: 3
		underline: 4
		blink: 5
		inverse: 7
		hidden: 8
		black: 30
		red: 31
		green: 32
		yellow: 33
		blue: 34
		magenta: 35
		cyan: 36
		white: 37
		black_bg: 40
		red_bg: 41
		green_bg: 42
		yellow_bg: 43
		blue_bg: 44
		magenta_bg: 45
		cyan_bg: 46
		white_bg: 47

		grey: 90
		tp: 205

	# https://github.com/loopj/commonjs-ansi-color
	color: (str, color) ->

		return str unless color

		color_attrs = color.split("+")
		ansi_str = ""
		i = 0
		attr = undefined

		while attr = color_attrs[i]

			unless ansi._colors[attr]?

				throw Error "Color '#{attr}' isn't included in the ansi colors list"

			ansi_str += "\u001b[" + ansi._colors[attr] + "m"

			i++

		ansi_str += str + "\u001b[" + ansi._colors["off"] + "m"

		ansi_str

module.exports = ansi