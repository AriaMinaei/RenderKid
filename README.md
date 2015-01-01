# RenderKid
[![Build Status](https://secure.travis-ci.org/AriaMinaei/RenderKid.png)](http://travis-ci.org/AriaMinaei/RenderKid)

RenderKid allows you to use HTML and CSS to style your CLI output, making it easy to create a beautiful, readable, and consistent look for your tool.

## Installation

Install with npm:
```
$ npm install renderkid
```

## Usage

```javascript
var RenderKid = require('renderkid');

var r = new RenderKid();

r.style({
  "ul": {
    "display": "block",
    "margin": "2 0 2" // Just like the CSS shorthand
  },

  "li": {
    "display": "block",
    "marginBottom": "1"
  },
  
  "key": {
    "color": "gray"
  },
  
  "value": {
    "color": "white"
  }
});

var output = r.render('
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
');

console.log(output);
```
