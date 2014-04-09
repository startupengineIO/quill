_   = require('lodash')
DOM = require('./dom')


class Format
  @types:
    LINE: 'line'

  @FORMATS:
    bold:
      tag: 'B'
      preformat: 'bold'

    underline:
      tag: 'U'
      preformat: 'underline'

    strike:
      tag: 'S'
      preformat: 'strikeThrough'

    italic:
      tag: 'I'
      preformat: 'italic'

    color:
      style: 'color'
      preformat: 'foreColor'

    background:
      style: 'backgroundColor'
      preformat: 'backColor'

    font:
      style: 'fontFamily'
      preformat: 'fontName'

    size:
      style: 'fontSize'
      preformat: 'fontSize'

    link:
      tag: 'A'
      attribute: 'href'

    image:
      tag: 'IMG'
      attribute: 'src'

    align:
      type: Format.types.LINE
      style: 'textAlign'

    list:
      tag: 'OL'
      type: Format.types.LINE

    bullet:
      tag: 'UL'
      type: Format.types.LINE


  constructor: (@config) ->

  add: (node, value) ->
    return this.remove(node) unless value
    return if this.match(node)
    if _.isString(@config.tag)
      formatNode = node.ownerDocument.createElement(@config.tag)
      if DOM.isVoid(formatNode)
        node.parentNode.insertBefore(formatNode, node)
        DOM.removeNode(node)
        node = formatNode
      else
        node = DOM.wrap(formatNode, node)
    if _.isString(@config.style)
      node.style[@config.style] = value
    if _.isString(@config.attribute)
      node.setAttribute(@config.attribute, value)
    return node

  isType: (type) ->
    return type == @config.type

  match: (node) ->
    return false unless DOM.isElement(node)
    return false if _.isString(@config.tag) and node.tagName != @config.tag
    return false if _.isString(@config.style) and !node.style[@config.style]
    return false if _.isString(@config.attribute) and !node.hasAttribute(@config.attribute)
    return true

  remove: (node) ->
    return unless this.match(node)
    if _.isString(@config.style)
      node.style[@config.style] = null
    if _.isString(@config.attribute)
      node.removeAttribute(@config.attribute)
    if _.isString(@config.tag)
      return DOM.switchTag(node, 'span')
    return node

  value: (node) ->
    return @config.value(node) or null if _.isFunction(@config.value)
    return node.style[@config.style] or null if _.isString(@config.style)
    return node.getAttribute(@config.attribute) or null if _.isString(@config.attribute)
    return true if _.isString(@config.tag) and node.tagName == @config.tag
    # TODO class regex
    return false


module.exports = Format
