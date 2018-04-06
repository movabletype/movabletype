# Riot.js SVG Sprite Component

## Installation
    npm ins riot-ss --save-dev

Import script
```html
<script src="riot.ss.min.js"></script>
```
Webpack or Browserify:

```js
require('riot-ss')
```

## What is the problems for use riot in svg

Original HTML `<use>`  element usage:
```html
<svg><use xlink:href="#symbol_id" /></svg>
```

In riot.js may you try:

```html
<svg><use xlink:href="#{symbol_id}" /></svg>
```

**!!! DOESN'T WORK**  WHY? Because `<use>` element can't dynamic change `xlink:href` attriabute for link symbol `#id`

## Use svg srpite component

```html
<ss link="{symbol_id}"></ss>
```

```js
this.symbol_id = 'edit'
```

yield:

```html
<svg><use xlink:href="#edit" /></svg>
```
**Congratulation !!!** Shorten and work fine now.

> Note: Please without `#` syntax, component will add this automated.

## Options
- `link`  link to symbol #id

- `class` set class name