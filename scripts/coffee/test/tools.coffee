require './_prepare'

tools = mod 'tools'

describe "quote()"

it "should convert html special strings to their entities", ->

	tools.quote(" abc<>\"\n")
	.should.equal '&nbsp;abc&lt;&gt;&quot;<br>'