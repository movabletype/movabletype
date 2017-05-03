import aTemplate from 'a-template'
import { Zepto as $ } from 'zepto-browserify'
import clone from 'clone'
import template from './table.html'
import menu from './menu.html'
import returnTable from './return-table.html'

const defs = {
  showBtnList: true,
  lang: 'en',
  mark: {
    align: {
      default: 'left',
      left: 'left',
      center: 'center',
      right: 'right'
    },
    btn: {
      group: 'a-table-btn-list',
      item: 'a-table-btn',
      itemActive: 'a-table-btn-active'
    },
    icon: {
      alignLeft: 'a-table-icon a-table-icon-left',
      alignCenter: 'a-table-icon a-table-icon-center',
      alignRight: 'a-table-icon a-table-icon-right',
      undo: 'a-table-icon a-table-icon-undo',
      merge: 'a-table-icon a-table-icon-merge02',
      split: 'a-table-icon a-table-icon-split02',
      table: 'a-table-icon a-table-icon-th02',
      source: 'a-table-icon a-table-icon-source01',
      td: 'a-table-icon a-table-icon-td03',
      th: 'a-table-icon a-table-icon-th02'
    },
    selector: {
      self: 'a-table-selector'
    }
  }
}


class aTable extends aTemplate {

  constructor (ele, option) {
    super()
    this.id = aTable.getUniqId()
    this.menu_id = aTable.getUniqId()
    this.addTemplate(this.id,template)
    this.addTemplate(this.menu_id,menu)
    this.data = $.extend(true, {}, defs, option)
    const data = this.data
    data.point = { x: -1, y: -1 }
    data.selectedRowNo = -1
    data.selectedColNo = -1
    data.row = this.parse($(ele).html())
    data.tableClass = this.getTableClass(data.tableResult)
    data.highestRow = this.highestRow
    data.history = []
    data.inputMode = 'table'
    data.cellClass = ''
    data.history.push(clone(data.row))
    this.convert = {}
    this.convert.getStyleByAlign = this.getStyleByAlign
    this.convert.setClass = this.setClass
    const html = `
    <div class='a-table-container'>
        <div data-id='${this.menu_id}'></div>
        <div class='a-table-outer'>
          <div class='a-table-inner'>
            <div data-id='${this.id}'></div>
          </div>
        </div>
    </div>`
    $(ele).before(html);
    $(ele).remove()
    this.update()
  }

  highestRow () {
    const arr = []
    const firstRow = this.data.row[0]
    let i = 0;
    if(!firstRow){
      return arr
    }
    const row = firstRow.col;
    row.forEach((item) => {
      const length = parseInt(item.colspan)
      for (let t = 0; t < length; t++) {
        arr.push(i)
        i++
      }
    })
    return arr
  }

  getCellByIndex (x, y) {
    return $(`[data-id='${this.id}'] [data-cell-id='${x}-${y}']`)
  }

  getCellInfoByIndex (x, y) {
    const id = this.id
    const $cell = this.getCellByIndex(x, y)
    if ($cell.length === 0) {
      return false
    }
    const left = $cell.offset().left
    const top = $cell.offset().top
    let returnLeft = -1
    let returnTop = -1
    const width = parseInt($cell.attr('colspan'))
    const height = parseInt($cell.attr('rowspan'))
    $(`[data-id='${this.id}'] .js-table-header th`).each(function (i) {
      if ($(this).offset().left === left) {
        returnLeft = i
      }
    })
    $(`[data-id='${this.id}'] .js-table-side`).each(function (i) {
      if ($(this).offset().top === top) {
        returnTop = i
      }
    })
    return { x: returnLeft - 1, y: returnTop, width, height }
  }

  getLargePoint () {
    const minXArr = []
    const minYArr = []
    const maxXArr = []
    const maxYArr = []
    for (let i = 0, n = arguments.length; i < n; i++) {
      minXArr.push(arguments[i].x)
      minYArr.push(arguments[i].y)
      maxXArr.push(arguments[i].x + arguments[i].width)
      maxYArr.push(arguments[i].y + arguments[i].height)
    }
    const minX = Math.min(...minXArr)
    const minY = Math.min(...minYArr)
    const maxX = Math.max(...maxXArr)
    const maxY = Math.max(...maxYArr)
    return { x: minX, y: minY, width: maxX - minX, height: maxY - minY }
  }

  getSelectedPoints () {
    const arr = []
    const self = this
    this.data.row.forEach((item, i) => {
      if (!item.col) {
        return false
      }
      item.col.forEach((obj, t) => {
        if (obj.selected) {
          const point = self.getCellInfoByIndex(t, i)
          if (point) {
            arr.push(point)
          }
        }
      })
    })
    return arr
  }

  getSelectedPoint () {
    const arr = this.getSelectedPoints()
    if (arr && arr[0]) {
      return arr[0]
    }
  }

  getAllPoints () {
    const arr = []
    const self = this
    this.data.row.forEach((item, i) => {
      if (!item || !item.col) {
        return
      }
      item.col.forEach((obj, t) => {
        const point = self.getCellInfoByIndex(t, i)
        if (point) {
          arr.push(point)
        }
      })
    })
    return arr
  }

  getCellIndexByPos (x, y) {
    let a,
      b
    const self = this
    this.data.row.forEach((item, i) => {
      if (!item || !item.col) {
        return
      }
      item.col.forEach((obj, t) => {
        const point = self.getCellInfoByIndex(t, i)
        if (point.x === x && point.y === y) {
          a = t
          b = i
        }
      })
    })
    return { row: b, col: a }
  }

  getCellByPos (x, y) {
    const index = this.getCellIndexByPos(x, y)
    if (!this.data.row[index.row]) {
      return
    }
    return this.data.row[index.row].col[index.col]
  }

  hitTest (point1, point2) {
    if ((point1.x < point2.x + point2.width)
      && (point2.x < point1.x + point1.width)
      && (point1.y < point2.y + point2.height)
      && (point2.y < point1.y + point1.height)) {
      return true
    }
    return false
  }

  markup () {
    const data = this.data
    if (data.splited) {
      data.splited = false
      return
    }
    const points = this.getSelectedPoints()
    const point1 = this.getLargePoint.apply(null, points)
    const self = this
    data.row.forEach((item, i) => {
      if (!item || !item.col) {
        return false
      }
      item.col.forEach((obj, t) => {
        const point = self.getCellInfoByIndex(t, i)
        const mark = {}
        if (obj.selected) {
          if (point.x === point1.x) {
            mark.left = true
          }
          if (point.x + point.width === point1.x + point1.width) {
            mark.right = true
          }
          if (point.y === point1.y) {
            mark.top = true
          }
          if (point.y + point.height === point1.y + point1.height) {
            mark.bottom = true
          }
        }
        obj.mark = mark
      })
    })
  }

  selectRange (a, b) {
    const data = this.data
    if (!data.point) {
      return
    }
    const self = this
    data.row[a].col[b].selected = true
    const points = this.getSelectedPoints()
    const point3 = this.getLargePoint.apply(null, points)
    data.row.forEach((item, i) => {
      if (!item || !item.col) {
        return false
      }
      item.col.forEach((obj, t) => {
        const point = self.getCellInfoByIndex(t, i)
        if (point && self.hitTest(point3, point)) {
          obj.selected = true
        }
      })
    })
    if (points.length > 1) {
      this.update();
    }
  }

  select (a, b) {
    const data = this.data
    data.point = { x: b, y: a }
    data.row.forEach((item, i) => {
      if (!item || !item.col) {
        return false
      }
      item.col.forEach((obj, t) => {
        if (i !== a || t !== b) {
          obj.selected = false
        }
      })
    })
    if (!data.row[a].col[b].selected) {
      data.row[a].col[b].selected = true
    }
  }

  unselectCells () {
    this.data.row.forEach((item, i) => {
      if (!item || !item.col) {
        return false
      }
      item.col.forEach((obj, t) => {
        obj.selected = false
      })
    })
  }

  removeCell (cell) {
    const row = this.data.row
    for (let i = 0, n = row.length; i < n; i++) {
      const col = row[i].col
      for (let t = 0, m = col.length; t < m; t++) {
        const obj = col[t]
        if (obj === cell) {
          col.splice(t, 1)
          t--
          m--
        }
      }
    }
  }

  removeSelectedCellExcept (cell) {
    const row = this.data.row
    for (let i = 0, n = row.length; i < n; i++) {
      const col = row[i].col
      for (let t = 0, m = col.length; t < m; t++) {
        const obj = col[t]
        if (obj !== cell && obj.selected) {
          col.splice(t, 1)
          t--
          m--
        }
      }
    }
  }

  contextmenu () {
    const $ele = $(`[data-id='${this.id}']`)
    const $target = $(this.e.target)
    const data = this.data
    this.e.preventDefault()
    data.showMenu = true
    data.menuX = this.e.clientX
    data.menuY = this.e.clientY
    this.update();
  }

  parse (html) {
    const self = this
    const arr1 = []
    $('tr', html).each(function () {
      const ret2 = {}
      const arr2 = []
      ret2.col = arr2
      $('th,td', this).each(function () {
        const obj = {}
        const html = $(this).html();
        if ($(this).is('th')) {
          obj.type = 'th'
        } else {
          obj.type = 'td'
        }
        obj.colspan = $(this).attr('colspan') || 1
        obj.rowspan = $(this).attr('rowspan') || 1
        obj.value = '';
        if (html) {
          obj.value = html.replace(/{(.*?)}/g,"&lcub;$1&rcub;");
        }
        const classAttr = $(this).attr('class')
        let cellClass = ''
        if (classAttr) {
          const classList = classAttr.split(/\s+/)
          classList.forEach((item) => {
            const align = self.getAlignByStyle(item)
            if (align) {
              obj.align = align
            } else {
              cellClass += ` ${item}`
            }
          })
        }
        obj.cellClass = cellClass.substr(1)
        arr2.push(obj)
      })
      arr1.push(ret2)
    })
    return arr1
  }

  parseText (text) {
    const arr1 = [];
    //replace newline codes inside double quotes to <br> tag
    text = text.replace(/"(([\n\r\t]|.)*?)"/g, (match, str) => {
      return str.replace(/[\n\r]/g,'<br>');
    });
    const rows = text.split(String.fromCharCode(13));
    rows.forEach((row) => {
      const ret2 = {}
      const arr2 = []
      ret2.col = arr2
      const cells = row.split(String.fromCharCode(9));
      cells.forEach((cell) => {
        const obj = {};
        obj.type = 'td';
        obj.colspan = 1;
        obj.rowspan = 1;
        obj.value = '';
        if (cell) {
          obj.value = cell.replace(/{(.*?)}/g,"&lcub;$1&rcub;");
        }
        arr2.push(obj);
      })
      arr1.push(ret2);
    })
    arr1.pop();
    return arr1;
  }

  getTableClass (html) {
    return $(html).attr('class')
  }

  toMarkdown (html) {
    const $table = $(html)
    let ret = ''
    $table.find('tr').each(function (i) {
      ret += '| '
      const $children = $(this).children()
      $children.each(function () {
        ret += $(this).html()
        ret += ' | '
      })
      if (i === 0) {
        ret += '\n| '
        $children.each(() => {
          ret += '--- | '
        })
      }
      ret += '\n'
    })
    return ret
  }

  getTable () {
    return this
      .getHtml(returnTable, true)
      .replace(/ class=""/g, '')
      .replace(/class="(.*)? "/g, 'class="$1"')
  }

  getMarkdown () {
    return this.toMarkdown(this.getHtml(returnTable, true))
  }

  onUpdated () {
    const points = this.getAllPoints()
    const point = this.getLargePoint.apply(null, points)
    const width = point.width
    const selectedPoints = this.getSelectedPoints()
    const $th = $('.js-table-header th', `[data-id='${this.id}']`)
    const $table = $('table', `[data-id='${this.id}']`)
    const $inner = $table.parents('.a-table-inner')
    const elem = $('.a-table-selected .a-table-editable', `[data-id='${this.id}']`)[0]
    if (elem && !this.data.showMenu) {
      setTimeout(() => {
        elem.focus()
        if (selectedPoints.length !== 1){
          return;
        }
        if (typeof window.getSelection !== 'undefined'
          && typeof document.createRange !== 'undefined') {
          const range = document.createRange()
          range.selectNodeContents(elem)
          range.collapse(false)
          const sel = window.getSelection()
          sel.removeAllRanges()
          sel.addRange(range)
        } else if (typeof document.body.createTextRange !== 'undefined') {
          const textRange = document.body.createTextRange()
          textRange.moveToElementText(elem)
          textRange.collapse(false)
          textRange.select()
        }
      }, 1)
    }

    //for scroll
    $inner.width(9999);
    const tableWidth = $table.width();

    if(tableWidth) {
      $inner.width(tableWidth)
    } else {
      $inner.width('auto')
    }

    if (this.afterRendered) {
      this.afterRendered()
    }
  }

  undo () {
    const data = this.data
    let row = data.row
    const hist = data.history
    if (data.history.length === 0) {
      return
    }

    while (JSON.stringify(row) === JSON.stringify(data.row)) {
      row = hist.pop()
    }

    if (row) {
      if (hist.length === 0) {
        hist.push(clone(row))
      }
      data.row = row
      this.update();
    }
  }

  insertRow (a, newrow) {
    const data = this.data
    const row = data.row
    if (row[a]) {
      row.splice(a, 0, { col: newrow })
    } else if (row.length === a) {
      row.push({ col: newrow })
    }
  }

  insertCellAt (a, b, item) {
    const data = this.data
    const row = data.row
    if (row[a] && row[a].col) {
      row[a].col.splice(b, 0, item)
    }
  }

  selectRow (i) {
    const data = this.data
    this.unselectCells()
    data.showMenu = false
    const points = this.getAllPoints()
    const point1 = this.getLargePoint.apply(null, points)
    const newpoint = { x: parseInt(i), y: 0, width: 1, height: point1.height }
    const targetPoints = []
    const self = this
    points.forEach((point) => {
      if (self.hitTest(newpoint, point)) {
        targetPoints.push(point)
      }
    })
    targetPoints.forEach((point) => {
      const cell = self.getCellByPos(point.x, point.y)
      cell.selected = true
    })
    data.mode = 'col'
    data.selectedColNo = -1
    data.selectedRowNo = i
    this.contextmenu()
    this.update();
  }

  selectCol (i) {
    const points = this.getAllPoints()
    const point1 = this.getLargePoint.apply(null, points)
    const newpoint = { x: 0, y: parseInt(i), width: point1.width, height: 1 }
    const targetPoints = []
    const self = this
    const data = this.data
    this.unselectCells()
    data.showMenu = false
    points.forEach((point) => {
      if (self.hitTest(newpoint, point)) {
        targetPoints.push(point)
      }
    })
    targetPoints.forEach((point) => {
      const cell = self.getCellByPos(point.x, point.y)
      cell.selected = true
    })
    data.mode = 'row'
    data.selectedRowNo = -1
    data.selectedColNo = i
    this.contextmenu()
    this.update();
  }

  removeCol (selectedno) {
    const data = this.data
    data.showMenu = false
    const self = this
    const points = this.getAllPoints()
    const point1 = this.getLargePoint.apply(null, points)
    const newpoint = { x: parseInt(selectedno), y: 0, width: 1, height: point1.height }
    const targetPoints = []
    points.forEach((point) => {
      if (self.hitTest(newpoint, point)) {
        targetPoints.push(point)
      }
    })
    targetPoints.forEach((point) => {
      const cell = self.getCellByPos(point.x, point.y)
      if (cell.colspan === 1) {
        self.removeCell(cell)
      } else {
        cell.colspan = parseInt(cell.colspan) - 1
      }
    })
    data.history.push(clone(data.row))
    this.update();
  }

  removeRow (selectedno) {
    const data = this.data
    data.showMenu = false
    const self = this
    const points = this.getAllPoints()
    const point1 = this.getLargePoint.apply(null, points)
    selectedno = parseInt(selectedno)
    const newpoint = { x: 0, y: selectedno, width: point1.width, height: 1 }
    const nextpoint = { x: 0, y: selectedno + 1, width: point1.width, height: 1 }
    const targetPoints = []
    const removeCells = []
    const insertCells = []
    points.forEach((point) => {
      if (self.hitTest(newpoint, point)) {
        targetPoints.push(point)
      }
    })
    points.forEach((point) => {
      if (self.hitTest(nextpoint, point)) {
        const cell = self.getCellByPos(point.x, point.y)
        cell.x = point.x
        if (point.y === nextpoint.y) {
          insertCells.push(cell)
        }
      }
    })
    targetPoints.forEach((point) => {
      const cell = self.getCellByPos(point.x, point.y)
      if (cell.rowspan === 1) {
        removeCells.push(cell)
      } else {
        cell.rowspan = parseInt(cell.rowspan) - 1
        if (selectedno === point.y) {
          cell.x = point.x
          insertCells.push(cell)
        }
      }
    })
    insertCells.sort((a, b) => {
      if (a.x > b.x) {
        return 1
      } else {
        return -1
      }
    })
    removeCells.forEach((cell) => {
      self.removeCell(cell)
    })
    data.row.splice(selectedno, 1)
    if (insertCells.length > 0) {
      data.row[selectedno] = { col: insertCells }
    }
    data.history.push(clone(data.row))
    this.update();
  }

  updateTable (b, a) {
    const data = this.data
    const e = this.e
    const type = e.type
    const points = this.getSelectedPoints()
    const isSmartPhone = aTable.isSmartPhone()
    if (type === 'mouseup' && this.data.showMenu) {
      return
    }
    [a, b] = [parseInt(a), parseInt(b)]
    data.mode = 'cell'
    data.selectedRowNo = -1
    data.selectedColNo = -1
    data.showMenu = false
    if (type === 'compositionstart') {
      data.beingInput = true
    } else if (type === 'compositionend') {
      data.beingInput = false
    } else if (type === 'click' && !isSmartPhone) {
      if (this.e.shiftKey) {
        this.selectRange(a, b)
      }
    } else if (type === 'copy') {
      this.copyTable(e,points)
    } else if (type === 'paste') {
      this.pasteTable(e)
    } else if (type === 'mousedown' && !isSmartPhone) {
      if (this.e.button !== 2 && !this.e.ctrlKey) {
        this.mousedown = true
        if (!this.data.beingInput) {
          if (points.length !== 1 || !this.data.row[a].col[b].selected) {
            this.select(a, b)
            this.update()
          }
        }
      }
    } else if (type === 'mousemove' && !isSmartPhone) {
      if (this.mousedown) {
        this.selectRange(a, b)
      }
    } else if (type === 'mouseup' && !isSmartPhone) {
      this.mousedown = false
    } else if (type === 'contextmenu') {
      this.mousedown = false
      this.contextmenu()
    } else if (type === 'touchstart') {
      if (points.length !== 1 || !this.data.row[a].col[b].selected) {
        if (!this.data.beingInput) {
          this.select(a, b)
          this.update();
        }
      }
    } else if (type === 'input') {
      if ($(this.e.target).hasClass('a-table-editable') && $(this.e.target).parents('td').attr('data-cell-id') === `${b}-${a}`) {
        data.history.push(clone(data.row))
        data.row[a].col[b].value = $(this.e.target).html().replace(/{(.*?)}/g,"&lcub;$1&rcub;");
      }
      if (this.afterEntered) {
        this.afterEntered()
      }
    } else if (type === 'keyup' && aTable.getBrowser().indexOf('ie') !== -1 ) {
      if ($(this.e.target).hasClass('a-table-editable') && $(this.e.target).parents('td').attr('data-cell-id') === `${b}-${a}`) {
        data.history.push(clone(data.row))
        data.row[a].col[b].value = $(this.e.target).html().replace(/{(.*?)}/g,"&lcub;$1&rcub;");
      }
      if (this.afterEntered) {
        this.afterEntered()
      }
    }
  }

  copyTable (e, points) {
      e.preventDefault()
      let copy_y = -1
      let copy_text = '<meta name="generator" content="Sheets"><table>'
      let first = true
      points.forEach((point) => {
        const cell = this.getCellByPos(point.x, point.y)
        if (copy_y !== point.y) {
          if(!first){
            copy_text += '</tr>'
            first = false
          }
          copy_text += `<tr><${cell.type} colspan="${cell.colspan}" rowspan="${cell.rowspan}">${cell.value}</${cell.type}>`
        } else {
          copy_text += `<${cell.type} colspan="${cell.colspan}" rowspan="${cell.rowspan}">${cell.value}</${cell.type}>`
        }
        copy_y = point.y
      })
      copy_text += '</tr></table>'
      if (e.originalEvent.clipboardData) {
        e.originalEvent.clipboardData.setData('text/html',copy_text)
      } else if ( window.clipboardData ) {
        window.clipboardData.setData('Text',copy_text)
      }
  }

  pasteTable (e) {
      let pastedData
      const data = this.data
      if (e.originalEvent.clipboardData) {
        pastedData = e.originalEvent.clipboardData.getData('text/html')
      } else if ( window.clipboardData ) {
        pastedData = window.clipboardData.getData('Text')
      }
      if( pastedData ) {
        const tableHtml = pastedData.match(/<table(.*)>(([\n\r\t]|.)*?)<\/table>/i)
        if(tableHtml && tableHtml[0]) {
          const newRow = this.parse(tableHtml[0]);
          if(newRow && newRow.length) {
              e.preventDefault()
              data.row = newRow
              data.history.push(clone(data.row))
              this.update();
              return;
          }
        }
        //for excel;
        const row = this.parseText(pastedData);
        if(row && row.length) {
            e.preventDefault()
            data.row = row
            this.update();
            data.history.push(clone(data.row))
            return;
        }
      }
  }

  updateResult () {
    const data = this.data
    data.row = this.parse(data.tableResult)
    data.tableClass = this.getTableClass(data.tableResult)
    data.history.push(clone(data.row))
    if(data.inputMode === 'table'){
      this.update()
    }
    if (this.afterEntered) {
      this.afterEntered()
    }
  }

  insertColRight (selectedno) {
    const data = this.data
    data.selectedRowNo = parseInt(selectedno)
    data.showMenu = false
    const self = this
    const points = this.getAllPoints()
    const point1 = this.getLargePoint.apply(null, points)
    const newpoint = { x: parseInt(selectedno), y: 0, width: 1, height: point1.height }
    const targetPoints = []
    points.forEach((point) => {
      if (self.hitTest(newpoint, point)) {
        targetPoints.push(point)
      }
    })
    targetPoints.forEach((point) => {
      const index = self.getCellIndexByPos(point.x, point.y)
      const cell = self.getCellByPos(point.x, point.y)
      const newcell = { type: 'td', colspan: 1, rowspan: cell.rowspan, value: '' }
      if (typeof index.row !== 'undefined' && typeof index.col !== 'undefined') {
        if (point.width + point.x - newpoint.x > 1) {
          cell.colspan = parseInt(cell.colspan) + 1
          cell.colspan += ''
        } else {
          self.insertCellAt(index.row, index.col + 1, newcell)
        }
      }
    })
    data.history.push(clone(data.row))
    this.update();
  }

  insertColLeft (selectedno) {
    const data = this.data
    selectedno = parseInt(selectedno)
    data.selectedRowNo = selectedno + 1
    data.showMenu = false
    const self = this
    const points = this.getAllPoints()
    const point1 = this.getLargePoint.apply(null, points)
    const newpoint = { x: parseInt(selectedno) - 1, y: 0, width: 1, height: point1.height }
    const targetPoints = []
    points.forEach((point) => {
      if (self.hitTest(newpoint, point)) {
        targetPoints.push(point)
      }
    })
    if (selectedno === 0) {
      const length = point1.height
      for (let i = 0; i < length; i++) {
        const newcell = { type: 'td', colspan: 1, rowspan: 1, value: '' }
        self.insertCellAt(i, 0, newcell)
      }
      data.history.push(clone(data.row))
      self.update()
      return
    }
    targetPoints.forEach((point) => {
      const index = self.getCellIndexByPos(point.x, point.y)
      const cell = self.getCellByPos(point.x, point.y)
      const newcell = { type: 'td', colspan: 1, rowspan: cell.rowspan, value: '' }
      if (typeof index.row !== 'undefined' && typeof index.col !== 'undefined') {
        if (point.width + point.x - newpoint.x > 1) {
          cell.colspan = parseInt(cell.colspan) + 1
          cell.colspan += ''
        } else {
          self.insertCellAt(index.row, index.col + 1, newcell)
        }
      }
    })
    data.history.push(clone(data.row))
    this.update();
  }

  beforeUpdated () {
    this.changeSelectOption()
    this.markup()
  }

  insertRowBelow (selectedno) {
    const data = this.data
    data.showMenu = false
    data.selectedColNo = parseInt(selectedno)
    const self = this
    const points = this.getAllPoints()
    const point1 = this.getLargePoint.apply(null, points)
    selectedno = parseInt(selectedno)
    const newpoint = { x: 0, y: selectedno + 1, width: point1.width, height: 1 }
    const targetPoints = []
    const newRow = []
    points.forEach((point) => {
      if (self.hitTest(newpoint, point)) {
        targetPoints.push(point)
      }
    })
    if (targetPoints.length === 0) {
      const length = point1.width
      for (let i = 0; i < length; i++) {
        const newcell = { type: 'td', colspan: 1, rowspan: 1, value: '' }
        newRow.push(newcell)
      }
      self.insertRow(selectedno + 1, newRow)
      self.update()
      return
    }
    targetPoints.forEach((point) => {
      const index = self.getCellIndexByPos(point.x, point.y)
      const cell = self.getCellByPos(point.x, point.y)
      if (!cell) {
        return
      }
      const newcell = { type: 'td', colspan: 1, rowspan: 1, value: '' }
      if (typeof index.row !== 'undefined' && typeof index.col !== 'undefined') {
        if (point.height > 1 && point.y <= selectedno) {
          cell.rowspan = parseInt(cell.rowspan) + 1
          cell.rowspan += ''
        } else if (index.row === selectedno + 1) {
          const length = parseInt(cell.colspan)
          for (let i = 0; i < length; i++) {
            newRow.push({ type: 'td', colspan: 1, rowspan: 1, value: '' })
          }
        } else {
          self.insertCellAt(index.row + 1, index.col, newcell)
        }
      }
    })
    this.insertRow(selectedno + 1, newRow)
    data.history.push(clone(data.row))
    this.update();
  }

  insertRowAbove (selectedno) {
    const data = this.data
    data.showMenu = false
    data.selectedColNo = parseInt(selectedno) + 1
    const self = this
    const points = this.getAllPoints()
    const point1 = this.getLargePoint.apply(null, points)
    selectedno = parseInt(selectedno)
    const newpoint = { x: 0, y: selectedno - 1, width: point1.width, height: 1 }
    const targetPoints = []
    const newRow = []
    points.forEach((point) => {
      if (self.hitTest(newpoint, point)) {
        targetPoints.push(point)
      }
    })
    if (selectedno === 0) {
      const length = point1.width
      for (let i = 0; i < length; i++) {
        const newcell = { type: 'td', colspan: 1, rowspan: 1, value: '' }
        newRow.push(newcell)
      }
      self.insertRow(0, newRow)
      self.update()
      return
    }
    targetPoints.forEach((point) => {
      const index = self.getCellIndexByPos(point.x, point.y)
      const cell = self.getCellByPos(point.x, point.y)
      if (!cell) {
        return
      }
      const newcell = { type: 'td', colspan: 1, rowspan: 1, value: '' }
      if (typeof index.row !== 'undefined' && typeof index.col !== 'undefined') {
        if (point.height > 1) {
          cell.rowspan = parseInt(cell.rowspan) + 1
          cell.rowspan += ''
        } else if (index.row === selectedno - 1) {
          const length = parseInt(cell.colspan)
          for (let i = 0; i < length; i++) {
            newRow.push({ type: 'td', colspan: 1, rowspan: 1, value: '' })
          }
        } else {
          self.insertCellAt(index.row, index.col, newcell)
        }
      }
    })
    this.insertRow(selectedno, newRow)
    data.history.push(clone(this.data.row))
    this.update();
  }

  mergeCells () {
    const data = this.data
    const points = this.getSelectedPoints()
    if (!this.isSelectedCellsRectangle()) {
      if (data.lang === 'en') {
        alert('All possible cells should be selected so to merge cells into one')
      } else if (data.lang === 'ja') {
        alert('結合するには、結合範囲のすべてのセルを選択する必要があります。')
      }
      return
    }
    if (points.length === 0) {
      return
    }
    if (!confirm('セルを結合すると、一番左上の値のみが保持されます。 結合しますか？')){
      return
    }
    const point = this.getLargePoint.apply(null, points)
    const cell = this.getCellByPos(point.x, point.y)
    this.removeSelectedCellExcept(cell)
    cell.colspan = point.width
    cell.rowspan = point.height
    data.showMenu = false
    data.history.push(clone(data.row))
    this.update();
  }

  splitCell () {
    const data = this.data
    const selectedPoints = this.getSelectedPoints()
    const length = selectedPoints.length
    if (length === 0) {
      if (data.lang === 'en') {
        alert('No cell is selected')
      } else if (data.lang === 'ja') {
        alert('セルが選択されていません');
      }
      return;
    } else if (length > 1) {
      if (data.lang === 'en') {
        alert('Only One cell should be selected so to split')
      } else if (data.lang === 'ja') {
        alert('結合解除するには、セルが一つだけ選択されている必要があります')
      }
      return
    }
    const selectedPoint = this.getSelectedPoint()
    const bound = { x: 0, y: selectedPoint.y, width: selectedPoint.x, height: selectedPoint.height }
    const points = this.getAllPoints()
    const currentIndex = this.getCellIndexByPos(selectedPoint.x, selectedPoint.y)
    const currentCell = this.getCellByPos(selectedPoint.x, selectedPoint.y)
    const width = parseInt(currentCell.colspan)
    const height = parseInt(currentCell.rowspan)
    const currentValue = currentCell.value;
    const self = this
    const targets = []
    const cells = []
    const rows = []
    if(width === 1 && height === 1){
      if (data.lang === 'en') {
        alert('Selected cell cannnot be splited anymore')
      } else if (data.lang === 'ja') {
        alert('選択されたセルはこれ以上分割できません');
      }
      return;
    }
    points.forEach((point) => {
      if (self.hitTest(bound, point)) {
        const index = self.getCellIndexByPos(point.x, point.y)
        const cell = self.getCellByPos(point.x, point.y)
        targets.push(index)
      }
    })
    targets.forEach((item) => {
      const row = item.row
      if (item.row < currentIndex.row) {
        return
      }
      if (!rows[row]) {
        rows[row] = []
      }
      rows[row].push(item)
    })
    for (let i = 1, n = rows.length; i < n; i++) {
      if (!rows[i]) {
        continue
      }
      rows[i].sort((a, b) => {
        if (a.col > b.col) {
          return 1
        } else {
          return -1
        }
      })
    }
    for (let i = selectedPoint.y, n = i + height; i < n; i++) {
      if (!rows[i]) {
        rows[i] = []
        rows[i].push({ row: i, col: -1 })
      }
    }
    let first = true;
    rows.forEach((row) => {
      const index = row[row.length - 1]
      for (let i = 0; i < width; i++) {
        let val = '';
        //スプリットされる前のコルのデータを保存
        if(first === true && i === width - 1){
          val = currentValue;
          first = false;
        }
        self.insertCellAt(index.row, index.col + 1, { type: 'td', colspan: 1, rowspan: 1, value: val, selected: true })
      }
    })
    this.removeCell(currentCell)
    data.showMenu = false
    data.history.push(clone(data.row))
    data.splited = true
    this.update();
  }

  changeCellTypeTo (type) {
    const data = this.data
    data.row.forEach((item, i) => {
      item.col.forEach((obj, t) => {
        if (obj.selected) {
          obj.type = type
        }
      })
    })
    data.showMenu = false
    data.history.push(clone(data.row))
    this.update();
  }

  align (align) {
    const data = this.data
    data.row.forEach((item, i) => {
      item.col.forEach((obj, t) => {
        if (obj.selected) {
          obj.align = align
        }
      })
    })
    data.showMenu = false
    data.history.push(clone(data.row))
    this.update();
  }

  getStyleByAlign (val) {
    const align = this.data.mark.align
    if (align.default === val) {
      return ''
    }
    return align[val]
  }

  getAlignByStyle (style) {
    const align = this.data.mark.align
    if (align.right === style) {
      return 'right'
    } else if (align.center === style) {
      return 'center'
    } else if (align.left === style) {
      return 'left'
    }
  }

  isSelectedCellsRectangle () {
    const selectedPoints = this.getSelectedPoints()
    const largePoint = this.getLargePoint.apply(null, selectedPoints)
    const points = this.getAllPoints()
    let flag = true
    const self = this
    points.forEach((point) => {
      if (self.hitTest(largePoint, point)) {
        const cell = self.getCellByPos(point.x, point.y)
        if (!cell.selected) {
          flag = false
        }
      }
    })
    return flag
  }

  changeInputMode (source) {
    const data = this.data
    data.inputMode = source
    if (source === 'source') {
      data.tableResult = this.getTable()
    } else {
      data.row = this.parse(data.tableResult)
      data.tableClass = this.getTableClass(data.tableResult)
    }
    this.update()
  }

  changeCellClass () {
    const data = this.data
    const cellClass = data.cellClass
    data.row.forEach((item, i) => {
      item.col.forEach((obj, t) => {
        if (obj.selected) {
          obj.cellClass = cellClass
        }
      })
    })
    data.history.push(clone(data.row))
    this.update();
  }

  changeSelectOption () {
    let cellClass
    let flag = true
    const data = this.data
    data.row.forEach((item) => {
      item.col.forEach((obj) => {
        if (obj.selected) {
          if (!cellClass) {
            cellClass = obj.cellClass
          } else if (cellClass && cellClass !== obj.cellClass) {
            flag = false
          }
        }
      })
    })
    if (flag) {
      data.cellClass = cellClass
    } else {
      data.cellClass = ''
    }
  }

  static isSmartPhone () {
    const agent = navigator.userAgent
    if (agent.indexOf('iPhone') > 0 || agent.indexOf('iPad') > 0
        || agent.indexOf('ipod') > 0 || agent.indexOf('Android') > 0) {
      return true
    } else {
      return false
    }
  }

  static getBrowser () {
      const ua = window.navigator.userAgent.toLowerCase();
      const ver = window.navigator.appVersion.toLowerCase();
      let name = 'unknown';

      if (ua.indexOf("msie") != -1){
          if (ver.indexOf("msie 6.") != -1){
              name = 'ie6';
          }else if (ver.indexOf("msie 7.") != -1){
              name = 'ie7';
          }else if (ver.indexOf("msie 8.") != -1){
              name = 'ie8';
          }else if (ver.indexOf("msie 9.") != -1){
              name = 'ie9';
          }else if (ver.indexOf("msie 10.") != -1){
              name = 'ie10';
          }else{
              name = 'ie';
          }
      }else if(ua.indexOf('trident/7') != -1){
          name = 'ie11';
      }else if (ua.indexOf('chrome') != -1){
          name = 'chrome';
      }else if (ua.indexOf('safari') != -1){
          name = 'safari';
      }else if (ua.indexOf('opera') != -1){
          name = 'opera';
      }else if (ua.indexOf('firefox') != -1){
          name = 'firefox';
      }
      return name;
  }

  static getUniqId () {
    return (Date.now().toString(36) + Math.random().toString(36).substr(2, 5)).toUpperCase();
  }

}

module.exports = aTable
