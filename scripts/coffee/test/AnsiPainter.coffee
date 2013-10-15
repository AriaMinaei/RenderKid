require './_prepare'

spec ['AnsiPainter'], (AnsiPainter) ->

	t = """
		 <bg-white><black>Black in White</black></bg-white>
	"""

	AnsiPainter.render(t).then (result) ->

		console.log result