require './_prepare'

spec ['AnsiRenderer'], (AnsiRenderer) ->

	t = """
		 <bg-white><black>Black in White</black></bg-white>
	"""

	AnsiRenderer.render(t).then (result) ->

		console.log result