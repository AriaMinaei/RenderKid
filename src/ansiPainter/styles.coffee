module.exports = styles = {}

styles.codes = codes =
  'none': 0

  'black': 30
  'red': 31
  'green': 32
  'yellow': 33
  'blue': 34
  'magenta': 35
  'cyan': 36
  'white': 37

  'grey': 90
  'bright-red': 91
  'bright-green': 92
  'bright-yellow': 93
  'bright-blue': 94
  'bright-magenta': 95
  'bright-cyan': 96
  'bright-white': 97

  'bg-black': 40
  'bg-red': 41
  'bg-green': 42
  'bg-yellow': 43
  'bg-blue': 44
  'bg-magenta': 45
  'bg-cyan': 46
  'bg-white': 47

  'bg-grey': 100
  'bg-bright-red': 101
  'bg-bright-green': 102
  'bg-bright-yellow': 103
  'bg-bright-blue': 104
  'bg-bright-magenta': 105
  'bg-bright-cyan': 106
  'bg-bright-white': 107

styles.color = (str) ->
  return '' if str is 'none'
  code = codes[str]
  unless code?
    throw Error "Unknown color `#{str}`"

  "\x1b[" + code + "m"

styles.bg = (str) ->
  return '' if str is 'none'
  code = codes['bg-' + str]
  unless code?
    throw Error "Unknown bg color `#{str}`"

  "\x1B[" + code + "m"

styles.none = (str) ->
  "\x1B[" + codes.none + "m"