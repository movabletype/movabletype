import aTemplate from 'a-template';
import clone from 'clone';
import extend from 'deep-extend';
import template from './table.html';
import menu from './menu.html';
import returnTable from './return-table.html';
import util from './util.js';

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
    label: 'a-table-label',
    actionGroup: 'a-table-action-group',
    selector: {
      self: 'a-table-selector'
    }
  },
  message: {
    mergeCells: 'merge cell',
    splitCell: 'split cell',
    changeToTh: 'change to th',
    changeToTd: 'change to td',
    alignLeft: 'align left',
    alignCenter: 'align center',
    alignRight: 'align right',
    addColumnLeft: 'insert column on the left',
    addColumnRight: 'insert column on the right',
    removeColumn: 'remove column',
    addRowTop: 'insert row above',
    addRowBottom: 'insert row below',
    removeRow: 'remove row',
    source: 'Source',
    mergeCellError1: 'All possible cells should be selected so to merge cells into one',
    mergeCellConfirm1: 'The top left cell\'s value of the selected range will only be saved. Are you sure you want to continue?',
    pasteError1: 'You can\'t paste here',
    splitError1: 'Cell is not selected',
    splitError2: 'Only one cell should be selected',
    splitError3: 'You can\'t split the cell anymore',
  }
};


export default class aTable extends aTemplate {

  constructor(ele, option) {
    super();
    this.id = aTable.getUniqId();
    this.menu_id = aTable.getUniqId();
    this.addTemplate(this.id, template);
    this.addTemplate(this.menu_id, util.removeIndentNewline(menu));
    this.data = extend({}, defs, option);
    const data = this.data;
    const selector = typeof ele === 'string' ? document.querySelector(ele) : ele;
    data.point = { x: -1, y: -1 };
    data.selectedRowNo = -1;
    data.selectedColNo = -1;
    data.showBtnList = true;
    data.row = this.parse(`<table>${selector.innerHTML}</table>`);
    data.tableResult = this.getTable();
    data.tableClass = selector.getAttribute('class') || "";
    data.highestRow = this.highestRow;
    data.history = [];
    data.inputMode = 'table';
    data.cellClass = '';
    data.history.push(clone(data.row));
    this.convert = {};
    this.convert.getStyleByAlign = this.getStyleByAlign;
    this.convert.setClass = this.setClass;
    const html = `
    <div class='a-table-container'>
        <div data-id='${this.menu_id}'></div>
        <div class='a-table-outer'>
          <div class='a-table-inner'>
            <div data-id='${this.id}'></div>
          </div>
        </div>
    </div>`;
    util.before(selector, html);
    util.removeElement(selector);
    this.update();
  }

  highestRow() {
    const arr = [];
    const firstRow = this.data.row[0];
    let i = 0;
    if (!firstRow) {
      return arr;
    }
    const row = firstRow.col;
    row.forEach((item) => {
      const length = parseInt(item.colspan);
      for (let t = 0; t < length; t++) {
        arr.push(i);
        i++;
      }
    });
    return arr;
  }

  _getTableLength(table) {
    return {
      x: this._getRowLength(table[0].col),
      y: this._getColLength(table)
    }
  }

  _getRowLength(row) {
    let length = 0;
    row.forEach((item) => {
      length += parseInt(item.colspan);
    });
    return length;
  }

  _getColLength(table) {
    let length = 0;
    let rowspan = 0;
    table.forEach((row) => {
      if(rowspan === 0) {
        rowspan = parseInt(row.col[0].rowspan);
        length += rowspan;
      }
      rowspan--;
    });
    return length;
  }

  _getElementByQuery(query) {
    return document.querySelector(`[data-id='${this.id}'] ${query}`);
  }

  _getElementsByQuery(query) {
    return document.querySelectorAll(`[data-id='${this.id}'] ${query}`);
  }

  _getSelf() {
    return document.querySelector(`[data-id='${this.id}']`);
  }

  getCellByIndex(x, y) {
    return this._getElementByQuery(`[data-cell-id='${x}-${y}']`);
  }

  getCellInfoByIndex(x, y) {
    const id = this.id;
    const cell = this.getCellByIndex(x, y);
    if (!cell) {
      return false;
    }
    const pos = util.offset(cell);
    const left = pos.left;
    const top = pos.top;
    let returnLeft = -1;
    let returnTop = -1;
    const width = parseInt(cell.getAttribute('colspan'));
    const height = parseInt(cell.getAttribute('rowspan'));
    const headers = this._getElementsByQuery('.js-table-header th');
    const sides = this._getElementsByQuery('.js-table-side');
    [].forEach.call(headers, (header, index) => {
      if (util.offset(header).left === left) {
        returnLeft = index;
      }
    });
    [].forEach.call(sides, (side, index) => {
      if (util.offset(side).top === top) {
        returnTop = index;
      }
    });
    return { x: returnLeft - 1, y: returnTop, width, height };
  }

  getLargePoint() {
    const minXArr = [];
    const minYArr = [];
    const maxXArr = [];
    const maxYArr = [];
    for (let i = 0, n = arguments.length; i < n; i++) {
      minXArr.push(arguments[i].x);
      minYArr.push(arguments[i].y);
      maxXArr.push(arguments[i].x + arguments[i].width);
      maxYArr.push(arguments[i].y + arguments[i].height);
    }
    const minX = Math.min(...minXArr);
    const minY = Math.min(...minYArr);
    const maxX = Math.max(...maxXArr);
    const maxY = Math.max(...maxYArr);
    return { x: minX, y: minY, width: maxX - minX, height: maxY - minY };
  }

  getSelectedPoints() {
    const arr = [];
    const self = this;
    this.data.row.forEach((item, i) => {
      if (!item.col) {
        return false;
      }
      item.col.forEach((obj, t) => {
        if (obj.selected) {
          const point = self.getCellInfoByIndex(t, i);
          if (point) {
            arr.push(point);
          }
        }
      });
    });
    return arr;
  }

  getSelectedPoint() {
    const arr = this.getSelectedPoints();
    if (arr && arr[0]) {
      return arr[0];
    }
  }

  getAllPoints() {
    const arr = [];
    const self = this;
    this.data.row.forEach((item, i) => {
      if (!item || !item.col) {
        return;
      }
      item.col.forEach((obj, t) => {
        const point = self.getCellInfoByIndex(t, i);
        if (point) {
          arr.push(point);
        }
      });
    });
    return arr;
  }

  getCellIndexByPos(x, y) {
    let a,
      b;
    const self = this;
    this.data.row.forEach((item, i) => {
      if (!item || !item.col) {
        return;
      }
      item.col.forEach((obj, t) => {
        const point = self.getCellInfoByIndex(t, i);
        if (point.x === x && point.y === y) {
          a = t;
          b = i;
        }
      });
    });
    return { row: b, col: a };
  }

  getCellByPos(x, y) {
    const index = this.getCellIndexByPos(x, y);
    if (!this.data.row[index.row]) {
      return;
    }
    return this.data.row[index.row].col[index.col];
  }

  hitTest(point1, point2) {
    if ((point1.x < point2.x + point2.width)
      && (point2.x < point1.x + point1.width)
      && (point1.y < point2.y + point2.height)
      && (point2.y < point1.y + point1.height)) {
      return true;
    }
    return false;
  }

  markup() {
    const data = this.data;
    if (data.splited) {
      data.splited = false;
      return;
    }
    const points = this.getSelectedPoints();
    const point1 = this.getLargePoint.apply(null, points);
    const self = this;
    data.row.forEach((item, i) => {
      if (!item || !item.col) {
        return false;
      }
      item.col.forEach((obj, t) => {
        const point = self.getCellInfoByIndex(t, i);
        const mark = {};
        if (obj.selected) {
          if (point.x === point1.x) {
            mark.left = true;
          }
          if (point.x + point.width === point1.x + point1.width) {
            mark.right = true;
          }
          if (point.y === point1.y) {
            mark.top = true;
          }
          if (point.y + point.height === point1.y + point1.height) {
            mark.bottom = true;
          }
        }
        obj.mark = mark;
      });
    });
  }

  selectRange(a, b) {
    const data = this.data;
    if (!data.point) {
      return;
    }
    const self = this;
    data.row[a].col[b].selected = true;
    const points = this.getSelectedPoints();
    const point3 = this.getLargePoint.apply(null, points);
    data.row.forEach((item, i) => {
      if (!item || !item.col) {
        return false;
      }
      item.col.forEach((obj, t) => {
        const point = self.getCellInfoByIndex(t, i);
        if (point && self.hitTest(point3, point)) {
          obj.selected = true;
        }
      });
    });
    if (points.length > 1) {
      this.update();
    }
  }

  select(a, b) {
    const data = this.data;
    data.point = { x: b, y: a };
    data.row.forEach((item, i) => {
      if (!item || !item.col) {
        return false;
      }
      item.col.forEach((obj, t) => {
        if (i !== a || t !== b) {
          obj.selected = false;
        }
      });
    });
    if (!data.row[a].col[b].selected) {
      data.row[a].col[b].selected = true;
    }
  }

  unselectCells() {
    this.data.row.forEach((item, i) => {
      if (!item || !item.col) {
        return false;
      }
      item.col.forEach((obj, t) => {
        obj.selected = false;
      });
    });
  }

  removeCell(cell) {
    const row = this.data.row;
    for (let i = 0, n = row.length; i < n; i++) {
      const col = row[i].col;
      for (let t = 0, m = col.length; t < m; t++) {
        const obj = col[t];
        if (obj === cell) {
          col.splice(t, 1);
          t--;
          m--;
        }
      }
    }
  }

  removeSelectedCellExcept(cell) {
    const row = this.data.row;
    for (let i = 0, n = row.length; i < n; i++) {
      const col = row[i].col;
      for (let t = 0, m = col.length; t < m; t++) {
        const obj = col[t];
        if (obj !== cell && obj.selected) {
          col.splice(t, 1);
          t--;
          m--;
        }
      }
    }
  }

  contextmenu() {
    const data = this.data;
    this.e.preventDefault();
    data.showMenu = true;
    data.menuX = this.e.clientX;
    data.menuY = this.e.clientY;
    this.update();
  }

  parse(html, format = 'html') {
    const self = this;
    const arr1 = [];
    const doc = util.parseHTML(html);
    const trs = doc.querySelectorAll('tr');
    [].forEach.call(trs, (tr) => {
      const ret2 = {};
      const arr2 = [];
      const cells = tr.querySelectorAll('th,td');
      ret2.col = arr2;
      [].forEach.call(cells, (cell) => {
        const obj = {};
        const html = format === 'html' ? cell.innerHTML : cell.innerText;
        if (cell.tagName === 'TH') {
          obj.type = 'th';
        } else {
          obj.type = 'td';
        }
        obj.colspan = cell.getAttribute('colspan') || 1;
        obj.rowspan = cell.getAttribute('rowspan') || 1;
        obj.value = '';
        if (html) {
          obj.value = html.replace(/{(.*?)}/g, '&lcub;$1&rcub;');
        }
        const classAttr = cell.getAttribute('class');
        let cellClass = '';
        if (classAttr) {
          const classList = classAttr.split(/\s+/);
          classList.forEach((item) => {
            const align = self.getAlignByStyle(item);
            if (align) {
              obj.align = align;
            } else {
              cellClass += ` ${item}`;
            }
          });
        }
        obj.cellClass = cellClass.substr(1);
        arr2.push(obj);
      });
      arr1.push(ret2);
    });
    return arr1;
  }

  parseText(text) {
    const arr1 = [];
    // replace newline codes inside double quotes to <br> tag
    text = text.replace(/"(([\n\r\t]|.)*?)"/g, (match, str) => str.replace(/[\n\r]/g, '<br>'));
    const rows = text.split(String.fromCharCode(13));
    rows.forEach((row) => {
      const ret2 = {};
      const arr2 = [];
      ret2.col = arr2;
      const cells = row.split(String.fromCharCode(9));
      cells.forEach((cell) => {
        const obj = {};
        obj.type = 'td';
        obj.colspan = 1;
        obj.rowspan = 1;
        obj.value = '';
        if (cell) {
          obj.value = cell.replace(/{(.*?)}/g, '&lcub;$1&rcub;');
        }
        arr2.push(obj);
      });
      arr1.push(ret2);
    });
    return arr1;
  }

  getTableClass(html) {
    return util.parseHTML(html).getAttribute('class');
  }

  toMarkdown(html) {
    const table = util.parseHTML(html);
    let ret = '';
    const trs = table.querySelectorAll('tr');
    [].forEach.call(trs, (tr, i) => {
      ret += '| ';
      const children = tr.querySelectorAll('td,th');
      [].forEach.call(children, (child) => {
        ret += child.innerHTML;
        ret += ' | ';
      });
      if (i === 0) {
        ret += '\n| ';
        [].forEach.call(children, (child) => {
          ret += '--- | ';
        });
      }
      ret += '\n';
    });
    return ret;
  }

  getTable() {
    return this
      .getHtml(returnTable, true)
      .replace(/ class=""/g, '')
      .replace(/class="(.*)? "/g, 'class="$1"');
  }

  getMarkdown() {
    return this.toMarkdown(this.getHtml(returnTable, true));
  }

  putCaret(elem) {
    if(!elem) {
      return;
    }
    elem.focus();
    if (typeof window.getSelection !== 'undefined'
      && typeof document.createRange !== 'undefined') {
      const range = document.createRange();
      range.selectNodeContents(elem);
      range.collapse(false);
      const sel = window.getSelection();
      sel.removeAllRanges();
      sel.addRange(range);
    } else if (typeof document.body.createTextRange !== 'undefined') {
      const textRange = document.body.createTextRange();
      textRange.moveToElementText(elem);
      textRange.collapse(false);
      textRange.select();
    }
  }

  onUpdated() {
    const points = this.getAllPoints();
    const point = this.getLargePoint.apply(null, points);
    const width = point.width;
    const table = this._getElementByQuery('table');
    const inner = this._getSelf().parentNode;
    const elem = this._getElementByQuery('.a-table-selected .a-table-editable');
    const selectedPoints = this.getSelectedPoints();
    if (elem && !this.data.showMenu && selectedPoints.length === 1) {
      setTimeout(() => {
        this.putCaret(elem);
      }, 1);
    }

    // for scroll
    if (table) {
      inner.style.width = '9999px';
      const tableWidth = table.offsetWidth;
      inner.style.width = `${tableWidth}px`;
    } else {
      inner.style.width = 'auto';
    }

    if (this.afterRendered) {
      this.afterRendered();
    }
  }

  undo() {
    const data = this.data;
    let row = data.row;
    const hist = data.history;
    if (data.history.length === 0) {
      return;
    }

    while (JSON.stringify(row) === JSON.stringify(data.row)) {
      row = hist.pop();
    }

    if (row) {
      if (hist.length === 0) {
        hist.push(clone(row));
      }
      data.row = row;
      this.update();
    }
  }

  insertRow(a, newrow) {
    const data = this.data;
    const row = data.row;
    if (row[a]) {
      row.splice(a, 0, { col: newrow });
    } else if (row.length === a) {
      row.push({ col: newrow });
    }
  }

  insertCellAt(a, b, item) {
    const data = this.data;
    const row = data.row;
    if (row[a] && row[a].col) {
      row[a].col.splice(b, 0, item);
    }
  }

  unselect() {
    const data = this.data;
    this.unselectCells();
    data.selectedColNo = -1;
    data.selectedRowNo = -1;
    data.showMenu = false;
    this.update();
  }

  selectRow(i) {
    const data = this.data;
    this.unselectCells();
    data.showMenu = false;
    const points = this.getAllPoints();
    const point1 = this.getLargePoint.apply(null, points);
    const newpoint = { x: parseInt(i), y: 0, width: 1, height: point1.height };
    const targetPoints = [];
    const self = this;
    points.forEach((point) => {
      if (self.hitTest(newpoint, point)) {
        targetPoints.push(point);
      }
    });
    targetPoints.forEach((point) => {
      const cell = self.getCellByPos(point.x, point.y);
      cell.selected = true;
    });
    data.mode = 'col';
    data.selectedColNo = -1;
    data.selectedRowNo = i;
    if (data.increaseDecreaseRows) {
      this.contextmenu();
    }
    this.update();
  }

  selectCol(i) {
    const points = this.getAllPoints();
    const point1 = this.getLargePoint.apply(null, points);
    const newpoint = { x: 0, y: parseInt(i), width: point1.width, height: 1 };
    const targetPoints = [];
    const self = this;
    const data = this.data;
    this.unselectCells();
    data.showMenu = false;
    points.forEach((point) => {
      if (self.hitTest(newpoint, point)) {
        targetPoints.push(point);
      }
    });
    targetPoints.forEach((point) => {
      const cell = self.getCellByPos(point.x, point.y);
      cell.selected = true;
    });
    data.mode = 'row';
    data.selectedRowNo = -1;
    data.selectedColNo = i;
    if (data.increaseDecreaseColumns) {
      this.contextmenu();
    }
    this.update();
  }

  removeCol(selectedno) {
    const data = this.data;
    data.showMenu = false;
    const self = this;
    const points = this.getAllPoints();
    const point1 = this.getLargePoint.apply(null, points);
    const newpoint = { x: parseInt(selectedno), y: 0, width: 1, height: point1.height };
    const targetPoints = [];
    points.forEach((point) => {
      if (self.hitTest(newpoint, point)) {
        targetPoints.push(point);
      }
    });
    targetPoints.forEach((point) => {
      const cell = self.getCellByPos(point.x, point.y);
      if (cell.colspan === 1) {
        self.removeCell(cell);
      } else {
        cell.colspan = parseInt(cell.colspan) - 1;
      }
    });
    data.history.push(clone(data.row));
    this.update();
    if (this.afterAction) {
      this.afterAction();
    }
  }

  removeRow(selectedno) {
    const data = this.data;
    data.showMenu = false;
    const self = this;
    const points = this.getAllPoints();
    const point1 = this.getLargePoint.apply(null, points);
    selectedno = parseInt(selectedno);
    const newpoint = { x: 0, y: selectedno, width: point1.width, height: 1 };
    const nextpoint = { x: 0, y: selectedno + 1, width: point1.width, height: 1 };
    const targetPoints = [];
    const removeCells = [];
    const insertCells = [];
    points.forEach((point) => {
      if (self.hitTest(newpoint, point)) {
        targetPoints.push(point);
      }
    });
    points.forEach((point) => {
      if (self.hitTest(nextpoint, point)) {
        const cell = self.getCellByPos(point.x, point.y);
        cell.x = point.x;
        if (point.y === nextpoint.y) {
          insertCells.push(cell);
        }
      }
    });
    targetPoints.forEach((point) => {
      const cell = self.getCellByPos(point.x, point.y);
      if (cell.rowspan === 1) {
        removeCells.push(cell);
      } else {
        cell.rowspan = parseInt(cell.rowspan) - 1;
        if (selectedno === point.y) {
          cell.x = point.x;
          insertCells.push(cell);
        }
      }
    });
    insertCells.sort((a, b) => {
      if (a.x > b.x) {
        return 1;
      }
      return -1;
    });
    removeCells.forEach((cell) => {
      self.removeCell(cell);
    });
    data.row.splice(selectedno, 1);
    if (insertCells.length > 0) {
      data.row[selectedno] = { col: insertCells };
    }
    data.history.push(clone(data.row));
    this.update();
  }

  updateTable(b, a) {
    const data = this.data;
    const e = this.e;
    const type = e.type;
    const points = this.getSelectedPoints();
    const isSmartPhone = aTable.isSmartPhone();
    if (type === 'mouseup' && this.data.showMenu) {
      return;
    }
    [a, b] = [parseInt(a), parseInt(b)];
    data.mode = 'cell';
    data.selectedRowNo = -1;
    data.selectedColNo = -1;
    data.showMenu = false;
    if (type === 'compositionstart') {
      data.beingInput = true;
    } else if (type === 'compositionend') {
      data.beingInput = false;
    } else if (type === 'click' && !isSmartPhone) {
      if (this.e.shiftKey) {
        this.selectRange(a, b);
      }
    } else if (type === 'keydown' && e.keyCode == 67 && (e.ctrlKey || e.metaKey)) {
      const elem = this._getElementByQuery('.a-table-selected .a-table-editable');
      util.triggerEvent(elem,'copy');
    } else if (type === 'copy') {
      this.copyTable(e);
    } else if (type === 'paste') {
      this.pasteTable(e);
    } else if (type === 'mousedown' && !isSmartPhone) {
      if (this.e.button !== 2 && !this.e.ctrlKey) {
        this.mousedown = true;
        if (!this.data.beingInput) {
          if (points.length !== 1 || !this.data.row[a].col[b].selected) {
            this.select(a, b);
            this.update();
          }
        }
      }
    } else if (type === 'mousemove' && !isSmartPhone) {
      if (this.mousedown) {
        this.selectRange(a, b);
      }
    } else if (type === 'mouseup' && !isSmartPhone) {
      this.mousedown = false;
      const elem = this._getElementByQuery('.a-table-selected .a-table-editable');
      if (points.length > 1) {
        this.putCaret(elem);
      }
    } else if (type === 'contextmenu') {
      this.mousedown = false;
      this.contextmenu();
    } else if (type === 'touchstart') {
      if (points.length !== 1 || !this.data.row[a].col[b].selected) {
        if (!this.data.beingInput) {
          this.select(a, b);
          this.update();
        }
      }// todo
    } else if (type === 'input') {
      if (util.hasClass(this.e.target, 'a-table-editable') && this.e.target.parentNode.getAttribute('data-cell-id') === `${b}-${a}`) {
        data.history.push(clone(data.row));
        data.row[a].col[b].value = this.e.target.innerHTML.replace(/{(.*?)}/g, '&lcub;$1&rcub;');
      }
      if (this.afterEntered) {
        this.afterEntered();
      }
    } else if (type === 'keyup' && aTable.getBrowser().indexOf('ie') !== -1) {
      if (util.hasClass(this.e.target, 'a-table-editable') && this.e.target.parentNode.getAttribute('data-cell-id') === `${b}-${a}`) {
        data.history.push(clone(data.row));
        data.row[a].col[b].value = this.e.target.innerHTML.replace(/{(.*?)}/g, '&lcub;$1&rcub;');
      }
      if (this.afterEntered) {
        this.afterEntered();
      }
    }
  }

  copyTable(e) {
    const points = this.getSelectedPoints();
    if(points.length <= 1) {
      return;
    }
    e.preventDefault();
    let copy_text = '<meta name="generator" content="Sheets"><table>';
    this.data.row.forEach((item, i) => {
      if (!item.col) {
        return false;
      }
      copy_text += '<tr>'
      item.col.forEach((obj, t) => {
        if (obj.selected) {
          copy_text += `<${obj.type} colspan="${obj.colspan}" rowspan="${obj.rowspan}">${obj.value}</${obj.type}>`;
        }
      });
      copy_text += '</tr>'
    });
    copy_text += '</table>';
    copy_text = copy_text.replace(/<table>(<tr><\/tr>)*/g,"<table>");
    copy_text = copy_text.replace(/(<tr><\/tr>)*<\/table>/g,"</table>");
    if (e.clipboardData) {
      e.clipboardData.setData('text/html', copy_text);
    } else if (window.clipboardData) {
      window.clipboardData.setData('Text', copy_text);
    }
  }

  pasteTable(e) {
    let pastedData;
    const data = this.data;
    if (e.clipboardData) {
      this.processPaste(e.clipboardData.getData('text/html'));
    } else if (window.clipboardData) {
      this.getClipBoardData();
    }
  }

  getClipBoardData() {
    const savedContent = document.createDocumentFragment();
    const point = this.getSelectedPoint();
    const index = this.getCellIndexByPos(point.x, point.y);
    const cell = this.getCellByIndex(index.col,index.row);
    const editableDiv = cell.querySelector('.a-table-editable');
    while(editableDiv.childNodes.length > 0) {
    	savedContent.appendChild(editableDiv.childNodes[0]);
    }
    this.waitForPastedData(editableDiv, savedContent);
    return true;
  }

  waitForPastedData (elem, savedContent) {
    if (elem.childNodes && elem.childNodes.length > 0) {
      const pastedData = elem.innerHTML;
      elem.innerHTML = "";
      elem.appendChild(savedContent);
      this.processPaste(pastedData);
    } else {
      setTimeout(() => {
        this.waitForPastedData(elem, savedContent)
      }, 20);
    }
  }

  processPaste (pastedData) {
    const e = this.e;
    e.preventDefault();
    const selectedPoint = this.getSelectedPoint();
    const tableHtml = pastedData.match(/<table(.*)>(([\n\r\t]|.)*?)<\/table>/i);
    const data = this.data;
    if (tableHtml && tableHtml[0]) {
      const newRow = this.parse(tableHtml[0],'text');
      if (newRow && newRow.length) {
        this.insertTable(newRow,{
          x: selectedPoint.x,
          y: selectedPoint.y
        });
        data.history.push(clone(data.row));
        return;
      }
    }
    // for excel;
    const row = this.parseText(pastedData);
    if (row && row[0] && row[0].col && row[0].col.length > 1) {
      const selectedPoint = this.getSelectedPoint();
      this.insertTable(row,{
        x: selectedPoint.x,
        y: selectedPoint.y
      });
      this.update();
      data.history.push(clone(data.row));
    } else {
      if (e.clipboardData) {
        let content = e.clipboardData.getData('text/plain');
        document.execCommand('insertText', false, content);
      } else if (window.clipboardData) {
        let content = window.clipboardData.getData('Text');
        util.replaceSelectionWithHtml(content);
      }
    }
  }

  insertTable(table,pos) {
    const currentLength = this._getTableLength(this.data.row);
    const copiedLength = this._getTableLength(table);
    let offsetX = pos.x + copiedLength.x - currentLength.x;
    let offsetY = pos.y + copiedLength.y - currentLength.y;
    const length = currentLength.x;
    const row = this.data.row;
    const targets = [];
    const rows = [];
    const data = this.data;
    const prevRow = clone(data.row);
    while (offsetY > 0) {
      const newRow = [];
      for (let i = 0; i < length; i++) {
        const newcell = { type: 'td', colspan: 1, rowspan: 1, value: '' };
        newRow.push(newcell);
      }
      this.insertRow(currentLength.y,newRow);
      offsetY--;
    }
    if (offsetX > 0) {
      this.data.row.forEach((item) => {
        for (let i = 0; i < offsetX; i++) {
          item.col.push({ type: 'td', colspan: 1, rowspan: 1, value: '' });
        }
      });
    }

    this.update();
    const destPos = {}
    const vPos = {
      x: pos.x,
      y: pos.y
    };

    vPos.y += copiedLength.y - 1;
    vPos.x += copiedLength.x - 1;

    this.data.row.forEach((item, i) => {
      if (!item.col) {
        return false;
      }
      item.col.forEach((obj, t) => {
        const point = this.getCellInfoByIndex(t, i);
        if(point.x + point.width - 1 === vPos.x && point.y + point.height - 1 === vPos.y) {
          destPos.x = t;
          destPos.y = i;
        }
      });
    });

    if(typeof destPos.x === 'undefined') {
      alert(this.data.message.pasteError1);
      this.data.row = prevRow;
      this.update();
      return;
    }

    this.selectRange(destPos.y, destPos.x);//todo

    const selectedPoints = this.getSelectedPoints();
    const largePoint = this.getLargePoint.apply(null, selectedPoints);

    if(largePoint.width !== copiedLength.x || largePoint.height !== copiedLength.y) {
      alert(this.data.message.pasteError1);
      this.data.row = prevRow;
      this.update();
      return;
    }

    const bound = { x: 0, y: largePoint.y, width: largePoint.x, height: largePoint.height };
    const points = this.getAllPoints();

    points.forEach((point) => {
      if (this.hitTest(bound, point)) {
        const index = this.getCellIndexByPos(point.x, point.y);
        const cell = this.getCellByPos(point.x, point.y);
        targets.push(index);
      }
    });

    targets.forEach((item) => {
      const row = item.row;
      if (item.row < largePoint.y) {
        return;
      }
      if (!rows[row]) {
        rows[row] = [];
      }
      rows[row].push(item);
    });
    for (let i = 1, n = rows.length; i < n; i++) {
      if (!rows[i]) {
        continue;
      }
      rows[i].sort((a, b) => {
        if (a.col > b.col) {
          return 1;
        }
        return -1;
      });
    }
    for (let i = largePoint.y, n = i + largePoint.height; i < n; i++) {
      if (!rows[i]) {
        rows[i] = [];
        rows[i].push({ row: i, col: -1 });
      }
    }
    this.removeSelectedCellExcept();
    let t = 0;
    rows.forEach((row) => {
      const index = row[row.length - 1];
      if(table[t]){
        table[t].col.reverse().forEach(cell => {
          this.insertCellAt(index.row, index.col + 1, { type: 'td', colspan: parseInt(cell.colspan), rowspan: parseInt(cell.rowspan), value: cell.value, selected: true });
        });
      }
      t++;
    });
    this.update();
  }

  updateResult() {
    const data = this.data;
    data.row = this.parse(data.tableResult);
    data.tableClass = this.getTableClass(data.tableResult);
    data.history.push(clone(data.row));
    if (data.inputMode === 'table') {
      this.update();
    }
    if (this.afterEntered) {
      this.afterEntered();
    }
  }

  insertColRight(selectedno) {
    const data = this.data;
    data.selectedRowNo = parseInt(selectedno);
    data.showMenu = false;
    const self = this;
    const points = this.getAllPoints();
    const point1 = this.getLargePoint.apply(null, points);
    const newpoint = { x: parseInt(selectedno), y: 0, width: 1, height: point1.height };
    const targetPoints = [];
    points.forEach((point) => {
      if (self.hitTest(newpoint, point)) {
        targetPoints.push(point);
      }
    });
    targetPoints.forEach((point) => {
      const index = self.getCellIndexByPos(point.x, point.y);
      const cell = self.getCellByPos(point.x, point.y);
      const newcell = { type: 'td', colspan: 1, rowspan: cell.rowspan, value: '' };
      if (typeof index.row !== 'undefined' && typeof index.col !== 'undefined') {
        if (point.width + point.x - newpoint.x > 1) {
          cell.colspan = parseInt(cell.colspan) + 1;
          cell.colspan += '';
        } else {
          self.insertCellAt(index.row, index.col + 1, newcell);
        }
      }
    });
    data.history.push(clone(data.row));
    this.update();
    if (this.afterAction) {
      this.afterAction();
    }
  }

  insertColLeft(selectedno) {
    const data = this.data;
    selectedno = parseInt(selectedno);
    data.selectedRowNo = selectedno + 1;
    data.showMenu = false;
    const self = this;
    const points = this.getAllPoints();
    const point1 = this.getLargePoint.apply(null, points);
    const newpoint = { x: parseInt(selectedno) - 1, y: 0, width: 1, height: point1.height };
    const targetPoints = [];
    points.forEach((point) => {
      if (self.hitTest(newpoint, point)) {
        targetPoints.push(point);
      }
    });
    if (selectedno === 0) {
      const length = point1.height;
      for (let i = 0; i < length; i++) {
        const newcell = { type: 'td', colspan: 1, rowspan: 1, value: '' };
        self.insertCellAt(i, 0, newcell);
      }
      data.history.push(clone(data.row));
      self.update();
      if (this.afterAction) {
        this.afterAction();
      }
      return;
    }
    targetPoints.forEach((point) => {
      const index = self.getCellIndexByPos(point.x, point.y);
      const cell = self.getCellByPos(point.x, point.y);
      const newcell = { type: 'td', colspan: 1, rowspan: cell.rowspan, value: '' };
      if (typeof index.row !== 'undefined' && typeof index.col !== 'undefined') {
        if (point.width + point.x - newpoint.x > 1) {
          cell.colspan = parseInt(cell.colspan) + 1;
          cell.colspan += '';
        } else {
          self.insertCellAt(index.row, index.col + 1, newcell);
        }
      }
    });
    data.history.push(clone(data.row));
    this.update();
    if (this.afterAction) {
      this.afterAction();
    }
  }

  beforeUpdated() {
    this.changeSelectOption();
    this.markup();
  }

  insertRowBelow(selectedno) {
    const data = this.data;
    data.showMenu = false;
    data.selectedColNo = parseInt(selectedno);
    const self = this;
    const points = this.getAllPoints();
    const point1 = this.getLargePoint.apply(null, points);
    selectedno = parseInt(selectedno);
    const newpoint = { x: 0, y: selectedno + 1, width: point1.width, height: 1 };
    const targetPoints = [];
    const newRow = [];
    points.forEach((point) => {
      if (self.hitTest(newpoint, point)) {
        targetPoints.push(point);
      }
    });
    if (targetPoints.length === 0) {
      const length = point1.width;
      for (let i = 0; i < length; i++) {
        const newcell = { type: 'td', colspan: 1, rowspan: 1, value: '' };
        newRow.push(newcell);
      }
      self.insertRow(selectedno + 1, newRow);
      self.update();
      return;
    }
    targetPoints.forEach((point) => {
      const index = self.getCellIndexByPos(point.x, point.y);
      const cell = self.getCellByPos(point.x, point.y);
      if (!cell) {
        return;
      }
      const newcell = { type: 'td', colspan: 1, rowspan: 1, value: '' };
      if (typeof index.row !== 'undefined' && typeof index.col !== 'undefined') {
        if (point.height > 1 && point.y <= selectedno) {
          cell.rowspan = parseInt(cell.rowspan) + 1;
          cell.rowspan += '';
        } else if (index.row === selectedno + 1) {
          const length = parseInt(cell.colspan);
          for (let i = 0; i < length; i++) {
            newRow.push({ type: 'td', colspan: 1, rowspan: 1, value: '' });
          }
        } else {
          self.insertCellAt(index.row + 1, index.col, newcell);
        }
      }
    });
    this.insertRow(selectedno + 1, newRow);
    data.history.push(clone(data.row));
    this.update();
  }

  insertRowAbove(selectedno) {
    const data = this.data;
    data.showMenu = false;
    data.selectedColNo = parseInt(selectedno) + 1;
    const self = this;
    const points = this.getAllPoints();
    const point1 = this.getLargePoint.apply(null, points);
    selectedno = parseInt(selectedno);
    const newpoint = { x: 0, y: selectedno - 1, width: point1.width, height: 1 };
    const targetPoints = [];
    const newRow = [];
    points.forEach((point) => {
      if (self.hitTest(newpoint, point)) {
        targetPoints.push(point);
      }
    });
    if (selectedno === 0) {
      const length = point1.width;
      for (let i = 0; i < length; i++) {
        const newcell = { type: 'td', colspan: 1, rowspan: 1, value: '' };
        newRow.push(newcell);
      }
      self.insertRow(0, newRow);
      self.update();
      return;
    }
    targetPoints.forEach((point) => {
      const index = self.getCellIndexByPos(point.x, point.y);
      const cell = self.getCellByPos(point.x, point.y);
      if (!cell) {
        return;
      }
      const newcell = { type: 'td', colspan: 1, rowspan: 1, value: '' };
      if (typeof index.row !== 'undefined' && typeof index.col !== 'undefined') {
        if (point.height > 1) {
          cell.rowspan = parseInt(cell.rowspan) + 1;
          cell.rowspan += '';
        } else if (index.row === selectedno - 1) {
          const length = parseInt(cell.colspan);
          for (let i = 0; i < length; i++) {
            newRow.push({ type: 'td', colspan: 1, rowspan: 1, value: '' });
          }
        } else {
          self.insertCellAt(index.row, index.col, newcell);
        }
      }
    });
    this.insertRow(selectedno, newRow);
    data.history.push(clone(this.data.row));
    this.update();
  }

  mergeCells() {
    const data = this.data;
    const points = this.getSelectedPoints();
    if (!this.isSelectedCellsRectangle()) {
      alert(this.data.message.mergeCellError1);
      return;
    }
    if (points.length === 0) {
      return;
    }
    if (!confirm(this.data.message.mergeCellConfirm1)) {
      return;
    }
    const point = this.getLargePoint.apply(null, points);
    const cell = this.getCellByPos(point.x, point.y);
    this.removeSelectedCellExcept(cell);
    cell.colspan = point.width;
    cell.rowspan = point.height;
    data.showMenu = false;
    data.history.push(clone(data.row));
    this.update();
    if (this.afterAction) {
      this.afterAction();
    }
  }

  splitCell() {
    const data = this.data;
    const selectedPoints = this.getSelectedPoints();
    const length = selectedPoints.length;
    if (length === 0) {
      alert(this.data.message.splitError1);
      return;
    } else if (length > 1) {
      alert(this.data.message.splitError2);
      return;
    }
    const selectedPoint = this.getSelectedPoint();
    const bound = { x: 0, y: selectedPoint.y, width: selectedPoint.x, height: selectedPoint.height };
    const points = this.getAllPoints();
    const currentIndex = this.getCellIndexByPos(selectedPoint.x, selectedPoint.y);
    const currentCell = this.getCellByPos(selectedPoint.x, selectedPoint.y);
    const width = parseInt(currentCell.colspan);
    const height = parseInt(currentCell.rowspan);
    const currentValue = currentCell.value;
    const self = this;
    const targets = [];
    const cells = [];
    const rows = [];
    if (width === 1 && height === 1) {
      alert(this.data.message.splitError3);
      return;
    }
    points.forEach((point) => {
      if (self.hitTest(bound, point)) {
        const index = self.getCellIndexByPos(point.x, point.y);
        const cell = self.getCellByPos(point.x, point.y);
        targets.push(index);
      }
    });
    targets.forEach((item) => {
      const row = item.row;
      if (item.row < currentIndex.row) {
        return;
      }
      if (!rows[row]) {
        rows[row] = [];
      }
      rows[row].push(item);
    });
    for (let i = 1, n = rows.length; i < n; i++) {
      if (!rows[i]) {
        continue;
      }
      rows[i].sort((a, b) => {
        if (a.col > b.col) {
          return 1;
        }
        return -1;
      });
    }
    for (let i = selectedPoint.y, n = i + height; i < n; i++) {
      if (!rows[i]) {
        rows[i] = [];
        rows[i].push({ row: i, col: -1 });
      }
    }
    let first = true;
    rows.forEach((row) => {
      const index = row[row.length - 1];
      for (let i = 0; i < width; i++) {
        let val = '';
        // スプリットされる前のコルのデータを保存
        if (first === true && i === width - 1) {
          val = currentValue;
          first = false;
        }
        self.insertCellAt(index.row, index.col + 1, { type: 'td', colspan: 1, rowspan: 1, value: val, selected: true });
      }
    });
    this.removeCell(currentCell);
    data.showMenu = false;
    data.history.push(clone(data.row));
    data.splited = true;
    this.update();
    if (this.afterAction) {
      this.afterAction();
    }
  }

  changeCellTypeTo(type) {
    const data = this.data;
    data.row.forEach((item, i) => {
      item.col.forEach((obj, t) => {
        if (obj.selected) {
          obj.type = type;
        }
      });
    });
    data.showMenu = false;
    data.history.push(clone(data.row));
    this.update();
    if (this.afterAction) {
      this.afterAction();
    }
  }

  align(align) {
    const data = this.data;
    data.row.forEach((item, i) => {
      item.col.forEach((obj, t) => {
        if (obj.selected) {
          obj.align = align;
        }
      });
    });
    data.showMenu = false;
    data.history.push(clone(data.row));
    this.update();
    if (this.afterAction) {
      this.afterAction();
    }
  }

  getStyleByAlign(val) {
    const align = this.data.mark.align;
    if (align.default === val) {
      return '';
    }
    return align[val];
  }

  getAlignByStyle(style) {
    const align = this.data.mark.align;
    if (align.right === style) {
      return 'right';
    } else if (align.center === style) {
      return 'center';
    } else if (align.left === style) {
      return 'left';
    }
  }

  isSelectedCellsRectangle() {
    const selectedPoints = this.getSelectedPoints();
    const largePoint = this.getLargePoint.apply(null, selectedPoints);
    const points = this.getAllPoints();
    let flag = true;
    const self = this;
    points.forEach((point) => {
      if (self.hitTest(largePoint, point)) {
        const cell = self.getCellByPos(point.x, point.y);
        if (!cell.selected) {
          flag = false;
        }
      }
    });
    return flag;
  }

  changeInputMode(source) {
    const data = this.data;
    data.inputMode = source;
    if (source === 'source') {
      data.tableResult = this.getTable();
    } else {
      data.row = this.parse(data.tableResult);
      data.tableClass = this.getTableClass(data.tableResult);
    }
    this.update();
  }

  changeCellClass() {
    const data = this.data;
    const cellClass = data.cellClass;
    data.row.forEach((item, i) => {
      item.col.forEach((obj, t) => {
        if (obj.selected) {
          obj.cellClass = cellClass;
        }
      });
    });
    data.history.push(clone(data.row));
    this.update();
    if (this.afterAction) {
      this.afterAction();
    }
  }

  changeSelectOption() {
    let cellClass;
    let flag = true;
    const data = this.data;
    data.row.forEach((item) => {
      item.col.forEach((obj) => {
        if (obj.selected) {
          if (!cellClass) {
            cellClass = obj.cellClass;
          } else if (cellClass && cellClass !== obj.cellClass) {
            flag = false;
          }
        }
      });
    });
    if (flag && cellClass) {
      data.cellClass = cellClass;
    } else {
      data.cellClass = '';
    }
  }

  static isSmartPhone() {
    const agent = navigator.userAgent;
    if (agent.indexOf('iPhone') > 0 || agent.indexOf('iPad') > 0
        || agent.indexOf('ipod') > 0 || agent.indexOf('Android') > 0) {
      return true;
    }
    return false;
  }

  static getBrowser() {
    const ua = window.navigator.userAgent.toLowerCase();
    const ver = window.navigator.appVersion.toLowerCase();
    let name = 'unknown';

    if (ua.indexOf('msie') != -1) {
      if (ver.indexOf('msie 6.') != -1) {
        name = 'ie6';
      } else if (ver.indexOf('msie 7.') != -1) {
        name = 'ie7';
      } else if (ver.indexOf('msie 8.') != -1) {
        name = 'ie8';
      } else if (ver.indexOf('msie 9.') != -1) {
        name = 'ie9';
      } else if (ver.indexOf('msie 10.') != -1) {
        name = 'ie10';
      } else {
        name = 'ie';
      }
    } else if (ua.indexOf('trident/7') != -1) {
      name = 'ie11';
    } else if (ua.indexOf('chrome') != -1) {
      name = 'chrome';
    } else if (ua.indexOf('safari') != -1) {
      name = 'safari';
    } else if (ua.indexOf('opera') != -1) {
      name = 'opera';
    } else if (ua.indexOf('firefox') != -1) {
      name = 'firefox';
    }
    return name;
  }

  static getUniqId() {
    return (Date.now().toString(36) + Math.random().toString(36).substr(2, 5)).toUpperCase();
  }

}
