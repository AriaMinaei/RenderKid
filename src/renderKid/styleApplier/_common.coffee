AnsiPainter = require '../../AnsiPainter'

module.exports = _common =
  getStyleTagsFor: (style) ->
    tagsToAdd = []

    if style.color?
      tagName = 'color-' + style.color
      unless AnsiPainter.tags[tagName]?
        throw Error "Unknown color `#{style.color}`"

      tagsToAdd.push tagName

    if style.background?
      tagName = 'bg-' + style.background
      unless AnsiPainter.tags[tagName]?
        throw Error "Unknown background `#{style.background}`"

      tagsToAdd.push tagName

    ret = before: '', after: ''

    for tag in tagsToAdd
      ret.before = "<#{tag}>" + ret.before
      ret.after = ret.after + "</#{tag}>"

    ret