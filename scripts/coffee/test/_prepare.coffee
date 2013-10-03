# Preparing for the tests
amdefine = require('amdefine')(module)
path = require 'path'

pathToLib = path.resolve __dirname, '../../js/lib'

global.inspect = require('eyespect').inspector({pretty: yes})

require 'when/monitor/console'


# To load the dependencies in each test
global.spec = (dependencies, func) ->

	# Resolve paths for dependencies
	resolvedDependencies = dependencies.map (addr) ->

		path.resolve pathToLib, addr

	amdefine resolvedDependencies, func

color = do ->

	ANSI_CODES =

	    off: 0
	    bold: 1
	    italic: 3
	    underline: 4
	    blink: 5
	    inverse: 7
	    hidden: 8
	    black: 30
	    red: 31
	    green: 32
	    yellow: 33
	    blue: 34
	    magenta: 35
	    cyan: 36
	    white: 37
	    black_bg: 40
	    red_bg: 41
	    green_bg: 42
	    yellow_bg: 43
	    blue_bg: 44
	    magenta_bg: 45
	    cyan_bg: 46
	    white_bg: 47

	# https://github.com/loopj/commonjs-ansi-color
	setColor = (str, color) ->

	    return str  unless color

	    color_attrs = color.split("+")
	    ansi_str = ""
	    i = 0
	    attr = undefined

	    while attr = color_attrs[i]

	        ansi_str += "\u001b[" + ANSI_CODES[attr] + "m"

	        i++

	    ansi_str += str + "\u001b[" + ANSI_CODES["off"] + "m"

	    ansi_str

processErrorMessage = (msg) ->

	"          " + msg

didBeep = no
handleError = (name, err) ->

	console.log '       ' + color(name, 'red') + '\n'

	if err.actual?

		console.log '          Expected:'

		console.log '          "' + color(err.expected, 'yellow') + '"\n'

		console.log '          Actual:'
		console.log '          "' + color(err.actual, 'yellow') + '"\n'

	console.log '          Stack:'

	console.log color(processErrorMessage(err.stack), 'yellow')

	unless didBeep

		`console.log("\007")`

		didBeep = yes

handleSuccess = (name) ->

	console.log '     √ \x1b[32m%s\x1b[0m', name

w = require 'when'
timeout = require 'when/timeout'

global.test = (name, rest...) ->

	if rest.length is 1

		checkTimeout = yes

		fn = rest[0]

	else if rest.length is 2

		checkTimeout = Boolean rest[0]

		fn = rest[1]

	promise = w().then ->

		do fn

	if checkTimeout

		promise = timeout promise, 2000


	promise.then ->

		handleSuccess name

	, (err) ->

		handleError name, err

global._test = (name) ->

	console.log color('     # ' + name, 'bold')


global.chai = require 'chai'

global.should = chai.should()
global.expect = chai.expect
chai.use require 'chai-as-promised'
chai.Assertion.includeStack = yes

chai.use require 'sinon-chai'

sinon = require 'sinon'

global.getSpy = -> sinon.spy()

# We're gonna need assert
global.assert = require 'assert'

# should.js doesn't do deep equal.
Array::shouldEqual = (b, msg = '') ->

	if msg

		msg = '| ' + msg

	assert.deepEqual @, b, "The two arrays are not equal " + msg

Array::looselyEquals = (b) ->

	a = @

	return yes if a is b

	return no if a.length isnt b.length

	for val, i in a

		if Array.isArray val

			if Array.isArray b[i]

				return no unless val.looselyEquals b[i]

			else

				return no

		else

			return no if val isnt b[i]

	return yes

process.on 'exit', ->

	console.log "\n\n\n"

delay = require 'when/delay'

global.after = (ms, cb) ->

	delay(ms).then -> do cb