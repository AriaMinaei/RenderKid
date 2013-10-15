require './_prepare'

spec ['Layout'], (Layout) ->

	test 'basic', ->

		# debugger

		l = new Layout

		l.write 'first line in root block'

		b = l.openBlock({}, 'b')

		b.write 'second line in second block'

		b.write ' hello'

		b.openBlock({}, 'c').close()

		b.close()

		l.write 'third line in third block'

		console.log 'got:', l.get()