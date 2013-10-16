require './_prepare'

spec ['Layout'], (Layout) ->

	test 'basic', ->

		# I don't know exactly how the architecture would look like
		# in the end. So I won't get into unit tests for now.

		blockConfig =

			linePrependor: options: amount: 2
			lineAppendor: options: amount: 1

			blockPrependor: options: amount: 1
			blockAppendor: options: amount: 1

			terminalWidth: 80
			width: 80

		l = new Layout

			width: 80
			terminalWidth: 80

		l.write 'first line in root block'

		b = l.openBlock(blockConfig, 'b')

		b.write 'b second line in second block'

		b.write ' hello'

		c = b.openBlock(blockConfig, 'c')

		c.write i % 10 for i in [0..200]

		c.close()

		b.write 'b before d'

		b.openBlock(blockConfig, 'd').write('d').close()

		b.write 'b after... \n...d'

		b.close()

		l.write 'third line in third block'

		console.log 'got:', l.get()