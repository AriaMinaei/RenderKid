module.exports = tags =

	'none': color: 'none', bg: 'none'

	'bg-none': color: 'inherit', bg: 'none'

	'color-none': color: 'none', bg: 'inherit'

colors = [

	'black'
	'red'
	'green'
	'yellow'
	'blue'
	'magenta'
	'cyan'
	'white'

	'grey'
	'bright-red'
	'bright-green'
	'bright-yellow'
	'bright-blue'
	'bright-magenta'
	'bright-cyan'
	'bright-white'

]

for color in colors

	tags[color] = color: color, bg: 'inherit'

	tags["bg-#{color}"] = color: 'inherit', bg: color