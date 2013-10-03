require './_prepare'

spec ['RenderKid'], (RenderKid) ->

	test 'Complex items', ->

		s = new RenderKid

		string = """

		<item>
			<title>do-scripts</title>

			<li.note>
				<title>Running...</title>
			</li.note>
		</item>

		<item>
			<title>./scripts/**.coffee</title>
			<li.note>
				<title>Watching</title>
			</li.note>
		</item>

		<item>

			<title>./scritps/someFile.coffee</title>

			<li.note>
				<title>Change Detected</title>
			</li.note>

			<li.success>
				<title>Comments Verified</title>
			</li.success>

			<li.failure>

				<title>Coffee Lint:</title>

				<pre>
Line #27:Line contains tab indentation
Line #29:Line contains tab indentation
				</pre>

			</li.failure>

		</item>

		<item>

			<title>./scripts/tests/someTest.js</title>

			<li.success>

				<title>Test Passed:</title>

				<li.success>
					<title>StreamSource</title>
					<li.success>
						<title>#config()</title>
						<li.success>
							<title>Takes exactly one argument (This is going to be a long line. I'm testing to see if it indents this correctly.
							 Apparently it does.)</title>
						</li.success>
						<li.failure>
							<title>Appends</title>

							<pre>
Expected: <strong>"4"</strong>

Actual:   <em>"3"</em>

Stack:
expected 1 to equal 3

at Assertion.assertEqual (F:\\host\\bodo\\pado\\node_modules\\chai\\core\\assertions.js:375:12)
at Assertion.ctx.(anonymous function) [as equal](F:\\)
							</pre>
						</li.failure>

						<li.success>
							<pre>
							Since 2008, <strong>Python</strong> has consistently ranked in the top eight most popular programming languages as measured by the TIOBE Programming Community Index. It is the third most popular language whose grammatical syntax is not predominantly based on C, e.g. C++, C#, Objective-C, Java. Python does borrow heavily, however, from the expression and statement syntax of C, making it easier for programmers to transition between languages.
							</pre>
						</li.success>


					</li.success>
				</li.success>

			</li.success>

		</item>

		<item>
			<pre><trivial>Hello </trivial> <strong>You</strong></pre>
		</item>



		"""



		s.render(string).then (result) ->

			console.log result

		# result.should.eventually.equal '>  hello'