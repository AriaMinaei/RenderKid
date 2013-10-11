require './_prepare'

purify = (obj) ->

	if typeof obj isnt 'object' then return obj

	ret = {}

	for own key, val of obj

		continue if key in ['prev', 'next', 'parent', 'attribs', 'length']

		continue if val instanceof Function

		ret[key] = purify val

	ret

inspectDom = (obj) ->

	inspect purify obj

spec ['RenderKid'], (RenderKid) ->

	test 'Basics', ->

		kid = new RenderKid

		kid.style

			'body':

				color: 'white !important'

				width: '10'

			'green':

				color: 'green'

				background: 'red'

				display: 'block !important'

		# inspect kid._styles._userStyles._rulesBySelector

		string = "Some text <green>in green</green>."

		kid.render(string).then (result) ->

			# console.log result