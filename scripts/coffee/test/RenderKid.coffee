require './_prepare'

RenderKid = mod 'RenderKid'
{strip} = mod 'AnsiPainter'
match = do ->

	r = new RenderKid

	r.style

		span:

			display: 'inline'

		div:

			display: 'block'

	match = (input, expected) ->

		strip(r.render(input)).should.equal expected.trim()

describe "constructor()"

it "should work", ->

	new RenderKid

describe "whitespace management - inline"

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