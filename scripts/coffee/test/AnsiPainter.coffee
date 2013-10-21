require './_prepare'

AnsiPainter = mod 'AnsiPainter'

paint = (t) ->

	AnsiPainter.paint(t)

it "should handle basic coloring", ->

	t = "<bg-white><black>a</black></bg-white>"

	paint(t).should.eventually.equal '\u001b[30m\u001b[47ma\u001b[0m'

it "should handle color in color", ->

	t = "<red>a<blue>b</blue></red>"

	paint(t).should.eventually.equal '\u001b[31ma\u001b[0m\u001b[34mb\u001b[0m'

it "should skip empty tags", ->

	t = "<blue></blue>a"

	paint(t).should.eventually.equal 'a\u001b[0m'

it "should convert html entities", ->

	t = "&gt;&lt;&quot;"

	paint(t).should.eventually.equal '><"\u001b[0m'