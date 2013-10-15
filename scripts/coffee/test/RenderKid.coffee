require './_prepare'

spec ['RenderKid'], (RenderKid) ->

	_test 'Basics', ->

		kid = new RenderKid

		kid.style

			'body':

				width: '60'

			'blue':

				color: 'cyan'

				display: 'inline'

			'red':

				color: 'bright-red'

				display: 'block'

		string = "stuff <blue> in blue </blue> more stuff. <red>block stuff</red> and more <blue>stuff</blue>."

		kid.render(string).then (result) ->

			# console.log result

	_test 'render block', ->

		str = """

		"""

		RenderKid::_renderBlock str,

			indent:

				amount: 10