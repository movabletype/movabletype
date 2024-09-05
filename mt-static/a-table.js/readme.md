# a-table.js
Simple Table UI for generating table html

[![CircleCI](https://circleci.com/gh/appleple/a-table.js.svg?style=shield)](https://circleci.com/gh/appleple/a-table.js)
[![npm version](https://badge.fury.io/js/a-table.svg)](https://badge.fury.io/js/a-table)

## Install

### npm
`npm install a-table`

### standalone
```html
<script src="https://unpkg.com/a-table@1.4.10/build/a-table.min.js"></script>
```

### css
```html
<link rel="stylesheet" href="https://unpkg.com/a-table@1.4.10/css/a-table.css">
```

### fonts
```html
<link rel="stylesheet" type="text/css" href="https://unpkg.com/a-table@1.4.10/fonts/a-table-icon.css">
```

## Demo
https://appleple.github.io/a-table.js/

## Usage
```js
import aTable from 'a-table';
const table = new aTable('.table', {
  lang:'ja',
  mark:{
    btn:{
      group:'acms-admin-btn-group acms-admin-btn-group-inline',
      item:'acms-admin-btn',
      itemActive:'acms-admin-btn acms-admin-btn-active'
    }
  },
  selector:{
    option:[
      {label:'赤',value:'red'},
      {label:'青',value:'blue'},
      {label:'黄色',value:'yellow'}
    ]
  }
});
table.afterRendered =
table.afterEntered = function(){
  document.querySelector('.test').innerText = this.getTable();
  document.querySelector('.markdown').innerText = this.getMarkdown();
}
table.afterRendered();
```

## Licence
[MIT](https://github.com/appleple/a-table.js/blob/master/LICENSE)
