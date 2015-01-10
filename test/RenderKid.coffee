RenderKid = require '../src/RenderKid'
{strip} = require '../src/AnsiPainter'

match = do ->

	r = new RenderKid

	r.style

		span:

			display: 'inline'

		div:

			display: 'block'

	match = (input, expected) ->

		strip(r.render(input)).trim().should.equal expected.trim()

describe "RenderKid", ->

	describe "constructor()", ->

		it "should work", ->

			new RenderKid

	describe "whitespace management - inline", ->

		it "shouldn't put extra whitespaces", ->

			input = """

			a<span>b</span>c

			"""

			expected = """

				abc

			"""

			match input, expected

		it "should allow 1 whitespace character on each side", ->

			input = """

			a<span>   b     </span>c

			"""

			expected = """

				a b c

			"""

			match input, expected

		it "should eliminate extra whitespaces inside text", ->

			input = """

			a<span>b1 \n  b2</span>c

			"""

			expected = """

				ab1 b2c

			"""

			match input, expected

		it "should allow line breaks with <br />", ->

			input = """

			a<span>b1<br />b2</span>c

			"""

			expected = """

				ab1\nb2c

			"""

			match input, expected

		it "should allow line breaks with &nl;", ->

			input = """

			a<span>b1&nl;b2</span>c

			"""

			expected = """

				ab1\nb2c

			"""

			match input, expected

		it "should allow whitespaces with &sp;", ->

			input = """

			a<span>b1&sp;b2</span>c

			"""

			expected = """

				ab1 b2c

			"""

			match input, expected

	describe "whitespace management - block", ->

		it "should add one linebreak between two blocks", ->

			input = """

				<div>a</div>
				<div>b</div>

			"""

			expected = """

				a
				b

			"""

			match input, expected

		it "should ignore empty blocks", ->

			input = """

				<div>a</div>
				<div></div>
				<div>b</div>

			"""

			expected = """

				a
				b

			"""

			match input, expected

		it "should add an extra linebreak between two adjacent blocks inside an inline", ->

			input = """

				<span>
					<div>a</div>
					<div>b</div>
				</span>

			"""

			expected = """

				a

				b

			"""

			match input, expected