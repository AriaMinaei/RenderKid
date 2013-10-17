require './_prepare'

spec ['RenderKid'], (RenderKid) ->

	test 'Basics', ->

		kid = new RenderKid

		kid.style

			'body':

				width: '60'

			'blue':

				color: 'white'

				display: 'inline'

				marginLeft: '1'

				marginRight: 1

				padding: '0 1'

				background: 'cyan'

			'red':

				color: 'black'

				background: 'red'

				display: 'block'

				margin: '1 2'

				bullet: '">" left color:bright-red bg:white'

		string = "stuff <blue>in<br>(break) blue</blue> more
		stuff. <red>block <br>stuff</red> and more <blue>stuff</blue>."

		kid.render(string).then (result) ->

			console.log result

			# inspect '- result: ' + result