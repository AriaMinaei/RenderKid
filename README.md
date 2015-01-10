# RenderKid
[![Build Status](https://secure.travis-ci.org/AriaMinaei/RenderKid.png)](http://travis-ci.org/AriaMinaei/RenderKid)

RenderKid allows you to use HTML and CSS to style your CLI output, making it easy to create a beautiful, readable, and consistent look for your tool.

## Installation

Install with npm:
```
$ npm install renderkid
```

## Usage

```coffeescript
RenderKid = require('renderkid')

r = new RenderKid()

r.style({
  "ul": {
    display: "block"
    margin: "2 0 2"
  }

  "li": {
    display: "block"
    marginBottom: "1"
  }

  "key": {
    color: "grey"
    marginRight: "1"
  }

  "value": {
    color: "bright-white"
  }
})

output = r.render("
<ul>
  <li>
    <key>Name:</key>
    <value>RenderKid</value>
  </li>
  <li>
    <key>Version:</key>
    <value>0.2</value>
  </li>
  <li>
    <key>Last Update:</key>
    <value>Jan 2015</value>
  </li>
</ul>
")

console.log(output)
```

![screenshot of usage](https://github.com/AriaMinaei/RenderKid/raw/master/docs/images/usage.png)

## Stylesheet properties

### Display mode

Elements can have a `display` of either `inline`, `block`, or `none`:
```coffeescript
r.style({
  "div": {
    display: "block"
  }

  "span": {
    display: "inline" # default
  }

  "hidden": {
    display: "none"
  }
})

output = r.render("
<div>This will fill one or more rows.</div>
<span>These</span> <span>will</span> <span>be</span> in the same <span>line.</span>
<hidden>This won't be displayed.</hidden>
")

console.log(output)
```

![screenshot of usage](https://github.com/AriaMinaei/RenderKid/raw/master/docs/images/display.png)


### Margin

Margins work just like they do in browsers:
```coffeescript
r.style({
  "li": {
    display: "block"

    marginTop: "1"
    marginRight: "2"
    marginBottom: "3"
    marginLeft: "4"

    # or the shorthand version:
    "margin": "1 2 3 4"
  },

  "highlight": {
    display: "inline"
    marginLeft: "2"
    marginRight: "2"
  }
})

r.render("
<ul>
  <li>Item <highlgiht>1</highlight></li>
  <li>Item <highlgiht>2</highlight></li>
  <li>Item <highlgiht>3</highlight></li>
</ul>
")
```

### Padding

See margins above. Paddings work the same way, only inward.

### Width and Height

Block elements can have explicit width and height:
```coffeescript
r.style({
  "box": {
    display: "block"
    "width": "4"
    "height": "2"
  }
})

r.render("<box>This is a box and some of its text will be truncated.</box>")
```

### Colors

You can set a custom color and background color for each element:

```coffeescript
r.style({
  "error": {
    color: "black"
    background: "red"
  }
})
```

List of colors currently supported are `black`, `red`, `green`, `yellow`, `blue`, `magenta`, `cyan`, `white`, `grey`, `bright-red`, `bright-green`, `bright-yellow`, `bright-blue`, `bright-magenta`, `bright-cyan`, `bright-white`.

### Bullte points

Right now, we have a special property called `bullet` that takes care of bullet points:
```coffeescript
r.style({
  "li": {
    bullet: '"<grey>-</grey>"'
    marginLeft: "4"
  }
})

r.render("
<li>Item 1</li>
<li>Item 2</li>
<li>Item 3</li>
")
```
For bullet points to work, you need to set a specific `marginLeft`. The bullet character falls on the leftmost side of the block. For example, if `marginLeft` is set to `4`, and the bullet character is `-`, then the bullet point will read like `-    `. (The rest is filled with spaces).

*TODO: More examples are needed here*
