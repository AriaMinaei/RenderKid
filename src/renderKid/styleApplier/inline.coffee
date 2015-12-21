tools = require '../../tools'
_common = require './_common'

module.exports = inlineStyleApplier = self =
  applyTo: (el, style) ->
    ret = _common.getStyleTagsFor style

    if style.marginLeft?
      ret.before = (tools.repeatString "&sp;", parseInt style.marginLeft) + ret.before

    if style.marginRight?
      ret.after += tools.repeatString "&sp;", parseInt style.marginRight

    if style.paddingLeft?
      ret.before += tools.repeatString "&sp;", parseInt style.paddingLeft

    if style.paddingRight?
      ret.after = (tools.repeatString "&sp;", parseInt style.paddingRight) + ret.after

    ret