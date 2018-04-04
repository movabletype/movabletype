'use strict';

Object.defineProperty(exports, "__esModule", {
  value: true
});

var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

var _aTemplate2 = require('a-template');

var _aTemplate3 = _interopRequireDefault(_aTemplate2);

var _clone = require('clone');

var _clone2 = _interopRequireDefault(_clone);

var _deepExtend = require('deep-extend');

var _deepExtend2 = _interopRequireDefault(_deepExtend);

var _util = require('./util.js');

var _util2 = _interopRequireDefault(_util);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _possibleConstructorReturn(self, call) { if (!self) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return call && (typeof call === "object" || typeof call === "function") ? call : self; }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function, not " + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

var template = '<!-- BEGIN showMenu:exist -->\n<ul class="a-table-menu" style="top:{menuY}px;left:{menuX}px;">\n\t<!-- BEGIN mode:touch#cell -->\n\t<li data-action-click="mergeCells">\\{message.mergeCells\\}</li>\n\t<li data-action-click="splitCell">\\{message.splitCell\\}</li>\n\t<li data-action-click="changeCellTypeTo(th)">\\{message.changeToTh\\}</li>\n\t<li data-action-click="changeCellTypeTo(td)">\\{message.changeToTd\\}</li>\n\t<li data-action-click="align(left)">\\{message.alignLeft\\}</li>\n\t<li data-action-click="align(center)">\\{message.alignCenter\\}</li>\n\t<li data-action-click="align(right)">\\{message.alignRight\\}</li>\n\t<!-- END mode:touch#cell -->\n\t<!-- BEGIN mode:touch#col -->\n\t<li data-action-click="insertColLeft({selectedRowNo})">\\{message.addColumnLeft\\}</li>\n\t<li data-action-click="insertColRight({selectedRowNo})">\\{message.addColumnRight\\}</li>\n\t<li data-action-click="removeCol({selectedRowNo})">\\{message.removeColumn\\}</li>\n\t<!-- END mode:touch#col -->\n\t<!-- BEGIN mode:touch#row -->\n\t<li data-action-click="insertRowAbove({selectedColNo})">\\{message.addRowTop\\}</li>\n\t<li data-action-click="insertRowBelow({selectedColNo})">\\{message.addRowBottom\\}</li>\n\t<li data-action-click="removeRow({selectedColNo})">\\{message.removeRow\\}</li>\n\t<!-- END mode:touch#row -->\n</ul>\n<!-- END showMenu:exist -->\n<div class="a-table-wrapper">\n\t<!-- BEGIN inputMode:touch#table -->\n\t<table class="a-table">\n\t\t<tr class="a-table-header js-table-header">\n\t\t\t<th class="a-table-first"></th>\n\t\t\t<!-- BEGIN highestRow:loop -->\n\t\t\t<!-- \\BEGIN selectedRowNo:touch#{i} -->\n\t\t\t<th data-action-click="unselect()" class="selected"><span class="a-table-toggle-btn"></span></th>\n\t\t\t<!-- \\END selectedRowNo:touch#{i} -->\n\t\t\t<!-- \\BEGIN selectedRowNo:touchnot#{i} -->\n\t\t\t<th data-action-click="selectRow({i})"><span class="a-table-toggle-btn"></span></th>\n\t\t\t<!-- \\END selectedRowNo:touchnot#{i} -->\n\t\t\t\n\t\t\t<!-- END highestRow:loop -->\n\t\t</tr>\n\t\t<!-- BEGIN row:loop -->\n\t\t<tr>\n\t\t\t<!-- \\BEGIN selectedColNo:touchnot#{i} -->\n\t\t\t<th class="a-table-side js-table-side" data-action-click="selectCol({i})"><span class="a-table-toggle-btn"></span></th>\n\t\t\t<!-- \\END selectedColNo:touchnot#{i} -->\n\t\t\t<!-- \\BEGIN selectedColNo:touch#{i} -->\n\t\t\t<th class="a-table-side js-table-side selected" data-action-click="unselect()"><span class="a-table-toggle-btn"></span></th>\n\t\t\t<!-- \\END selectedColNo:touch#{i} -->\n\t\t\t<!-- \\BEGIN row.{i}.col:loop -->\n\t\t\t<td colspan="\\{colspan\\}" rowspan="\\{rowspan\\}" data-action="updateTable(\\{i\\},{i})" data-cell-id="\\{i\\}-{i}" class="<!-- \\BEGIN selected:exist -->a-table-selected<!-- \\END selected:exist --><!-- \\BEGIN type:touch#th --> a-table-th<!-- END \\type:touch#th --><!-- \\BEGIN mark.top:exist --> a-table-border-top<!-- \\END mark.top:exist --><!-- \\BEGIN mark.right:exist --> a-table-border-right<!-- \\END mark.right:exist --><!-- \\BEGIN mark.bottom:exist --> a-table-border-bottom<!-- \\END mark.bottom:exist --><!-- \\BEGIN mark.left:exist --> a-table-border-left<!-- \\END mark.left:exist --><!-- \\BEGIN cellClass:exist --> \\{cellClass\\}<!-- \\END cellClass:exist -->"><div class="a-table-editable \\{align\\}" contenteditable>\\{value\\}</div></td>\n\t\t\t<!-- \\END row.{i}.col:loop -->\n\t\t</tr>\n\t\t<!-- END row:loop -->\n\t</table>\n\t<!-- END inputMode:touch#table -->\n\t<!-- BEGIN inputMode:touch#source -->\n\t<textarea data-bind="tableResult" class="a-table-textarea" data-action-input="updateResult"></textarea>\n\t<!-- END inputMode:touch#source -->\n</div>\n';
var menu = '<!-- BEGIN showBtnList:exist -->\n<div class="a-table-btn-group-list">\n\t<div class="\\{mark.btn.group\\}">\n\t\t<!-- BEGIN inputMode:touch#table -->\n\t\t<button type="button" class="\\{mark.btn.item\\}" data-action-click="changeInputMode(source)"><i class="\\{mark.icon.source\\}"></i></button>\n\t\t<!-- END inputMode:touch#table -->\n\t\t<!-- BEGIN inputMode:touch#source -->\n\t\t<button type="button" class="\\{mark.btn.itemActive\\}" data-action-click="changeInputMode(table)"><i class="\\{mark.icon.source\\}"></i></button>\n\t\t<!-- END inputMode:touch#source -->\n\t</div>\n\t<div class="\\{mark.btn.group\\}">\n\t\t<button type="button" class="\\{mark.btn.item\\}" data-action-click="mergeCells"><i class="\\{mark.icon.merge\\}"></i></button><button type="button" class="\\{mark.btn.item\\}" data-action-click="splitCell()"><i class="\\{mark.icon.split\\}"></i></button><button type="button" class="\\{mark.btn.item\\}" data-action-click="undo()"><i class="\\{mark.icon.undo\\}"></i></button>\n\t</div>\n\t<div class="\\{mark.btn.group\\}">\n\t\t<button type="button" class="\\{mark.btn.item\\}" data-action-click="changeCellTypeTo(td)"><!-- BEGIN mark.icon.td:empty -->td<!-- END mark.icon.td:empty --><!-- BEGIN mark.icon.td:exist --><i class="\\{mark.icon.td\\}"></i><!-- END mark.icon.td:exist --></button><button type="button" class="\\{mark.btn.item\\}" data-action-click="changeCellTypeTo(th)"><!-- BEGIN mark.icon.th:empty -->th<!-- END mark.icon.th:empty --><!-- BEGIN mark.icon.th:exist --><i class="\\{mark.icon.th\\}"></i><!-- END mark.icon.th:exist --></button>\n\t</div>\n\t<div class="\\{mark.btn.group\\}">\n\t\t<button type="button" class="\\{mark.btn.item\\}" data-action-click="align(left)"><i class="\\{mark.icon.alignLeft\\}"></i></button><button type="button" class="\\{mark.btn.item\\}" data-action-click="align(center)"><i class="\\{mark.icon.alignCenter\\}"></i></button><button type="button" class="\\{mark.btn.item\\}" data-action-click="align(right)"><i class="\\{mark.icon.alignRight\\}"></i></button>\n\t</div>\n\t<div class="\\{mark.btn.group\\}">\n\t\t<div class="\\{mark.actionGroup\\}">\n\t\t\t<label class="\\{mark.label\\}">\u30BB\u30EB</label>\n\t\t\t<select class="\\{mark.selector.self\\}" data-bind="cellClass" data-action-change="changeCellClass()">\n\t\t\t\t<option value="">---</option>\n\t\t\t\t<!-- BEGIN selector.option:loop -->\n\t\t\t\t<option value="{value}">{label}</option>\n\t\t\t\t<!-- END selector.option:loop -->\n\t\t\t</select>\n\t\t</div>\n\t</div>\n\t<!-- BEGIN tableOption:exist -->\n\t<div class="\\{mark.btn.group\\}">\n\t\t<div class="\\{mark.actionGroup\\}">\n\t\t\t<label class="\\{mark.label\\}">\u30C6\u30FC\u30D6\u30EB</label>\n\t\t\t<select class="\\{mark.selector.self\\}" data-bind="tableClass" data-action-change="update">\n\t\t\t\t<option value="">---</option>\n\t\t\t\t<!-- BEGIN tableOption:loop -->\n\t\t\t\t<option value="{value}">{label}</option>\n\t\t\t\t<!-- END tableOption:loop -->\n\t\t\t</select>\n\t\t</div>\n\t</div>\n\t<!-- END tableOption:exist -->\n</div>\n<!-- END showBtnList:exist -->\n';
var returnTable = '<table class="{tableClass}">\n\t<!-- BEGIN row:loop -->\n\t<tr>\n\t\t<!-- \\BEGIN row.{i}.col:loop -->\n\t\t<!-- \\BEGIN type:touch#th -->\n\t\t<th<!-- \\BEGIN colspan:touchnot#1 --> colspan="\\{colspan\\}"<!-- \\END colspan:touchnot#1 --><!-- \\BEGIN rowspan:touchnot#1 --> rowspan="\\{rowspan\\}"<!-- \\END rowspan:touchnot#1 --> class="<!-- \\BEGIN align:exist -->\\{align\\}[getStyleByAlign]<!-- \\END align:exist --><!-- \\BEGIN cellClass:exist --> \\{cellClass\\}<!-- \\END cellClass:exist -->">\\{value\\}</th>\n\t\t<!-- \\END type:touch#th -->\n\t\t<!-- \\BEGIN type:touch#td -->\n\t\t<td<!-- \\BEGIN colspan:touchnot#1 --> colspan="\\{colspan\\}"<!-- \\END colspan:touchnot#1 --><!-- \\BEGIN rowspan:touchnot#1 --> rowspan="\\{rowspan\\}"<!-- \\END rowspan:touchnot#1 --> class="<!-- \\BEGIN align:exist -->\\{align\\}[getStyleByAlign] <!-- \\END align:exist --><!-- \\BEGIN cellClass:exist -->\\{cellClass\\}<!-- \\END cellClass:exist -->">\\{value\\}</td>\n\t\t<!-- \\END type:touch#td -->\n\t\t<!-- \\END row.{i}.col:loop -->\n\t</tr>\n\t<!-- END row:loop -->\n</table>\n';


var defs = {
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
    splitError3: 'You can\'t split the cell anymore'
  }
};

var aTable = function (_aTemplate) {
  _inherits(aTable, _aTemplate);

  function aTable(ele, option) {
    _classCallCheck(this, aTable);

    var _this = _possibleConstructorReturn(this, (aTable.__proto__ || Object.getPrototypeOf(aTable)).call(this));

    _this.id = aTable.getUniqId();
    _this.menu_id = aTable.getUniqId();
    _this.addTemplate(_this.id, template);
    _this.addTemplate(_this.menu_id, _util2.default.removeIndentNewline(menu));
    _this.data = (0, _deepExtend2.default)({}, defs, option);
    var data = _this.data;
    var selector = typeof ele === 'string' ? document.querySelector(ele) : ele;
    data.point = { x: -1, y: -1 };
    data.selectedRowNo = -1;
    data.selectedColNo = -1;
    data.showBtnList = true;
    data.row = _this.parse('<table>' + selector.innerHTML + '</table>');
    data.tableResult = _this.getTable();
    data.tableClass = selector.getAttribute('class') || "";
    data.highestRow = _this.highestRow;
    data.history = [];
    data.inputMode = 'table';
    data.cellClass = '';
    data.history.push((0, _clone2.default)(data.row));
    _this.convert = {};
    _this.convert.getStyleByAlign = _this.getStyleByAlign;
    _this.convert.setClass = _this.setClass;
    var html = '\n    <div class=\'a-table-container\'>\n        <div data-id=\'' + _this.menu_id + '\'></div>\n        <div class=\'a-table-outer\'>\n          <div class=\'a-table-inner\'>\n            <div data-id=\'' + _this.id + '\'></div>\n          </div>\n        </div>\n    </div>';
    _util2.default.before(selector, html);
    _util2.default.removeElement(selector);
    _this.update();
    return _this;
  }

  _createClass(aTable, [{
    key: 'highestRow',
    value: function highestRow() {
      var arr = [];
      var firstRow = this.data.row[0];
      var i = 0;
      if (!firstRow) {
        return arr;
      }
      var row = firstRow.col;
      row.forEach(function (item) {
        var length = parseInt(item.colspan);
        for (var t = 0; t < length; t++) {
          arr.push(i);
          i++;
        }
      });
      return arr;
    }
  }, {
    key: '_getTableLength',
    value: function _getTableLength(table) {
      return {
        x: this._getRowLength(table[0].col),
        y: this._getColLength(table)
      };
    }
  }, {
    key: '_getRowLength',
    value: function _getRowLength(row) {
      var length = 0;
      row.forEach(function (item) {
        length += parseInt(item.colspan);
      });
      return length;
    }
  }, {
    key: '_getColLength',
    value: function _getColLength(table) {
      var length = 0;
      var rowspan = 0;
      table.forEach(function (row) {
        if (rowspan === 0) {
          rowspan = parseInt(row.col[0].rowspan);
          length += rowspan;
        }
        rowspan--;
      });
      return length;
    }
  }, {
    key: '_getElementByQuery',
    value: function _getElementByQuery(query) {
      return document.querySelector('[data-id=\'' + this.id + '\'] ' + query);
    }
  }, {
    key: '_getElementsByQuery',
    value: function _getElementsByQuery(query) {
      return document.querySelectorAll('[data-id=\'' + this.id + '\'] ' + query);
    }
  }, {
    key: '_getSelf',
    value: function _getSelf() {
      return document.querySelector('[data-id=\'' + this.id + '\']');
    }
  }, {
    key: 'getCellByIndex',
    value: function getCellByIndex(x, y) {
      return this._getElementByQuery('[data-cell-id=\'' + x + '-' + y + '\']');
    }
  }, {
    key: 'getCellInfoByIndex',
    value: function getCellInfoByIndex(x, y) {
      var id = this.id;
      var cell = this.getCellByIndex(x, y);
      if (!cell) {
        return false;
      }
      var pos = _util2.default.offset(cell);
      var left = pos.left;
      var top = pos.top;
      var returnLeft = -1;
      var returnTop = -1;
      var width = parseInt(cell.getAttribute('colspan'));
      var height = parseInt(cell.getAttribute('rowspan'));
      var headers = this._getElementsByQuery('.js-table-header th');
      var sides = this._getElementsByQuery('.js-table-side');
      [].forEach.call(headers, function (header, index) {
        if (_util2.default.offset(header).left === left) {
          returnLeft = index;
        }
      });
      [].forEach.call(sides, function (side, index) {
        if (_util2.default.offset(side).top === top) {
          returnTop = index;
        }
      });
      return { x: returnLeft - 1, y: returnTop, width: width, height: height };
    }
  }, {
    key: 'getLargePoint',
    value: function getLargePoint() {
      var minXArr = [];
      var minYArr = [];
      var maxXArr = [];
      var maxYArr = [];
      for (var i = 0, n = arguments.length; i < n; i++) {
        minXArr.push(arguments[i].x);
        minYArr.push(arguments[i].y);
        maxXArr.push(arguments[i].x + arguments[i].width);
        maxYArr.push(arguments[i].y + arguments[i].height);
      }
      var minX = Math.min.apply(Math, minXArr);
      var minY = Math.min.apply(Math, minYArr);
      var maxX = Math.max.apply(Math, maxXArr);
      var maxY = Math.max.apply(Math, maxYArr);
      return { x: minX, y: minY, width: maxX - minX, height: maxY - minY };
    }
  }, {
    key: 'getSelectedPoints',
    value: function getSelectedPoints() {
      var arr = [];
      var self = this;
      this.data.row.forEach(function (item, i) {
        if (!item.col) {
          return false;
        }
        item.col.forEach(function (obj, t) {
          if (obj.selected) {
            var point = self.getCellInfoByIndex(t, i);
            if (point) {
              arr.push(point);
            }
          }
        });
      });
      return arr;
    }
  }, {
    key: 'getSelectedPoint',
    value: function getSelectedPoint() {
      var arr = this.getSelectedPoints();
      if (arr && arr[0]) {
        return arr[0];
      }
    }
  }, {
    key: 'getAllPoints',
    value: function getAllPoints() {
      var arr = [];
      var self = this;
      this.data.row.forEach(function (item, i) {
        if (!item || !item.col) {
          return;
        }
        item.col.forEach(function (obj, t) {
          var point = self.getCellInfoByIndex(t, i);
          if (point) {
            arr.push(point);
          }
        });
      });
      return arr;
    }
  }, {
    key: 'getCellIndexByPos',
    value: function getCellIndexByPos(x, y) {
      var a = void 0,
          b = void 0;
      var self = this;
      this.data.row.forEach(function (item, i) {
        if (!item || !item.col) {
          return;
        }
        item.col.forEach(function (obj, t) {
          var point = self.getCellInfoByIndex(t, i);
          if (point.x === x && point.y === y) {
            a = t;
            b = i;
          }
        });
      });
      return { row: b, col: a };
    }
  }, {
    key: 'getCellByPos',
    value: function getCellByPos(x, y) {
      var index = this.getCellIndexByPos(x, y);
      if (!this.data.row[index.row]) {
        return;
      }
      return this.data.row[index.row].col[index.col];
    }
  }, {
    key: 'hitTest',
    value: function hitTest(point1, point2) {
      if (point1.x < point2.x + point2.width && point2.x < point1.x + point1.width && point1.y < point2.y + point2.height && point2.y < point1.y + point1.height) {
        return true;
      }
      return false;
    }
  }, {
    key: 'markup',
    value: function markup() {
      var data = this.data;
      if (data.splited) {
        data.splited = false;
        return;
      }
      var points = this.getSelectedPoints();
      var point1 = this.getLargePoint.apply(null, points);
      var self = this;
      data.row.forEach(function (item, i) {
        if (!item || !item.col) {
          return false;
        }
        item.col.forEach(function (obj, t) {
          var point = self.getCellInfoByIndex(t, i);
          var mark = {};
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
  }, {
    key: 'selectRange',
    value: function selectRange(a, b) {
      var data = this.data;
      if (!data.point) {
        return;
      }
      var self = this;
      data.row[a].col[b].selected = true;
      var points = this.getSelectedPoints();
      var point3 = this.getLargePoint.apply(null, points);
      data.row.forEach(function (item, i) {
        if (!item || !item.col) {
          return false;
        }
        item.col.forEach(function (obj, t) {
          var point = self.getCellInfoByIndex(t, i);
          if (point && self.hitTest(point3, point)) {
            obj.selected = true;
          }
        });
      });
      if (points.length > 1) {
        this.update();
      }
    }
  }, {
    key: 'select',
    value: function select(a, b) {
      var data = this.data;
      data.point = { x: b, y: a };
      data.row.forEach(function (item, i) {
        if (!item || !item.col) {
          return false;
        }
        item.col.forEach(function (obj, t) {
          if (i !== a || t !== b) {
            obj.selected = false;
          }
        });
      });
      if (!data.row[a].col[b].selected) {
        data.row[a].col[b].selected = true;
      }
    }
  }, {
    key: 'unselectCells',
    value: function unselectCells() {
      this.data.row.forEach(function (item, i) {
        if (!item || !item.col) {
          return false;
        }
        item.col.forEach(function (obj, t) {
          obj.selected = false;
        });
      });
    }
  }, {
    key: 'removeCell',
    value: function removeCell(cell) {
      var row = this.data.row;
      for (var i = 0, n = row.length; i < n; i++) {
        var col = row[i].col;
        for (var t = 0, m = col.length; t < m; t++) {
          var obj = col[t];
          if (obj === cell) {
            col.splice(t, 1);
            t--;
            m--;
          }
        }
      }
    }
  }, {
    key: 'removeSelectedCellExcept',
    value: function removeSelectedCellExcept(cell) {
      var row = this.data.row;
      for (var i = 0, n = row.length; i < n; i++) {
        var col = row[i].col;
        for (var t = 0, m = col.length; t < m; t++) {
          var obj = col[t];
          if (obj !== cell && obj.selected) {
            col.splice(t, 1);
            t--;
            m--;
          }
        }
      }
    }
  }, {
    key: 'contextmenu',
    value: function contextmenu() {
      var data = this.data;
      this.e.preventDefault();
      data.showMenu = true;
      data.menuX = this.e.clientX;
      data.menuY = this.e.clientY;
      this.update();
    }
  }, {
    key: 'parse',
    value: function parse(html) {
      var format = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : 'html';

      var self = this;
      var arr1 = [];
      var doc = _util2.default.parseHTML(html);
      var trs = doc.querySelectorAll('tr');
      [].forEach.call(trs, function (tr) {
        var ret2 = {};
        var arr2 = [];
        var cells = tr.querySelectorAll('th,td');
        ret2.col = arr2;
        [].forEach.call(cells, function (cell) {
          var obj = {};
          var html = format === 'html' ? cell.innerHTML : cell.innerText;
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
          var classAttr = cell.getAttribute('class');
          var cellClass = '';
          if (classAttr) {
            var classList = classAttr.split(/\s+/);
            classList.forEach(function (item) {
              var align = self.getAlignByStyle(item);
              if (align) {
                obj.align = align;
              } else {
                cellClass += ' ' + item;
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
  }, {
    key: 'parseText',
    value: function parseText(text) {
      var arr1 = [];
      // replace newline codes inside double quotes to <br> tag
      text = text.replace(/"(([\n\r\t]|.)*?)"/g, function (match, str) {
        return str.replace(/[\n\r]/g, '<br>');
      });
      var rows = text.split(String.fromCharCode(13));
      rows.forEach(function (row) {
        var ret2 = {};
        var arr2 = [];
        ret2.col = arr2;
        var cells = row.split(String.fromCharCode(9));
        cells.forEach(function (cell) {
          var obj = {};
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
  }, {
    key: 'getTableClass',
    value: function getTableClass(html) {
      return _util2.default.parseHTML(html).getAttribute('class');
    }
  }, {
    key: 'toMarkdown',
    value: function toMarkdown(html) {
      var table = _util2.default.parseHTML(html);
      var ret = '';
      var trs = table.querySelectorAll('tr');
      [].forEach.call(trs, function (tr, i) {
        ret += '| ';
        var children = tr.querySelectorAll('td,th');
        [].forEach.call(children, function (child) {
          ret += child.innerHTML;
          ret += ' | ';
        });
        if (i === 0) {
          ret += '\n| ';
          [].forEach.call(children, function (child) {
            ret += '--- | ';
          });
        }
        ret += '\n';
      });
      return ret;
    }
  }, {
    key: 'getTable',
    value: function getTable() {
      return this.getHtml(returnTable, true).replace(/ class=""/g, '').replace(/class="(.*)? "/g, 'class="$1"');
    }
  }, {
    key: 'getMarkdown',
    value: function getMarkdown() {
      return this.toMarkdown(this.getHtml(returnTable, true));
    }
  }, {
    key: 'putCaret',
    value: function putCaret(elem) {
      if (!elem) {
        return;
      }
      elem.focus();
      if (typeof window.getSelection !== 'undefined' && typeof document.createRange !== 'undefined') {
        var range = document.createRange();
        range.selectNodeContents(elem);
        range.collapse(false);
        var sel = window.getSelection();
        sel.removeAllRanges();
        sel.addRange(range);
      } else if (typeof document.body.createTextRange !== 'undefined') {
        var textRange = document.body.createTextRange();
        textRange.moveToElementText(elem);
        textRange.collapse(false);
        textRange.select();
      }
    }
  }, {
    key: 'onUpdated',
    value: function onUpdated() {
      var _this2 = this;

      var points = this.getAllPoints();
      var point = this.getLargePoint.apply(null, points);
      var width = point.width;
      var table = this._getElementByQuery('table');
      var inner = this._getSelf().parentNode;
      var elem = this._getElementByQuery('.a-table-selected .a-table-editable');
      var selectedPoints = this.getSelectedPoints();
      if (elem && !this.data.showMenu && selectedPoints.length === 1) {
        setTimeout(function () {
          _this2.putCaret(elem);
        }, 1);
      }

      // for scroll
      if (table) {
        inner.style.width = '9999px';
        var tableWidth = table.offsetWidth;
        inner.style.width = tableWidth + 'px';
      } else {
        inner.style.width = 'auto';
      }

      if (this.afterRendered) {
        this.afterRendered();
      }
    }
  }, {
    key: 'undo',
    value: function undo() {
      var data = this.data;
      var row = data.row;
      var hist = data.history;
      if (data.history.length === 0) {
        return;
      }

      while (JSON.stringify(row) === JSON.stringify(data.row)) {
        row = hist.pop();
      }

      if (row) {
        if (hist.length === 0) {
          hist.push((0, _clone2.default)(row));
        }
        data.row = row;
        this.update();
      }
    }
  }, {
    key: 'insertRow',
    value: function insertRow(a, newrow) {
      var data = this.data;
      var row = data.row;
      if (row[a]) {
        row.splice(a, 0, { col: newrow });
      } else if (row.length === a) {
        row.push({ col: newrow });
      }
    }
  }, {
    key: 'insertCellAt',
    value: function insertCellAt(a, b, item) {
      var data = this.data;
      var row = data.row;
      if (row[a] && row[a].col) {
        row[a].col.splice(b, 0, item);
      }
    }
  }, {
    key: 'unselect',
    value: function unselect() {
      var data = this.data;
      this.unselectCells();
      data.selectedColNo = -1;
      data.selectedRowNo = -1;
      data.showMenu = false;
      this.update();
    }
  }, {
    key: 'selectRow',
    value: function selectRow(i) {
      var data = this.data;
      this.unselectCells();
      data.showMenu = false;
      var points = this.getAllPoints();
      var point1 = this.getLargePoint.apply(null, points);
      var newpoint = { x: parseInt(i), y: 0, width: 1, height: point1.height };
      var targetPoints = [];
      var self = this;
      points.forEach(function (point) {
        if (self.hitTest(newpoint, point)) {
          targetPoints.push(point);
        }
      });
      targetPoints.forEach(function (point) {
        var cell = self.getCellByPos(point.x, point.y);
        cell.selected = true;
      });
      data.mode = 'col';
      data.selectedColNo = -1;
      data.selectedRowNo = i;
      this.contextmenu();
      this.update();
    }
  }, {
    key: 'selectCol',
    value: function selectCol(i) {
      var points = this.getAllPoints();
      var point1 = this.getLargePoint.apply(null, points);
      var newpoint = { x: 0, y: parseInt(i), width: point1.width, height: 1 };
      var targetPoints = [];
      var self = this;
      var data = this.data;
      this.unselectCells();
      data.showMenu = false;
      points.forEach(function (point) {
        if (self.hitTest(newpoint, point)) {
          targetPoints.push(point);
        }
      });
      targetPoints.forEach(function (point) {
        var cell = self.getCellByPos(point.x, point.y);
        cell.selected = true;
      });
      data.mode = 'row';
      data.selectedRowNo = -1;
      data.selectedColNo = i;
      this.contextmenu();
      this.update();
    }
  }, {
    key: 'removeCol',
    value: function removeCol(selectedno) {
      var data = this.data;
      data.showMenu = false;
      var self = this;
      var points = this.getAllPoints();
      var point1 = this.getLargePoint.apply(null, points);
      var newpoint = { x: parseInt(selectedno), y: 0, width: 1, height: point1.height };
      var targetPoints = [];
      points.forEach(function (point) {
        if (self.hitTest(newpoint, point)) {
          targetPoints.push(point);
        }
      });
      targetPoints.forEach(function (point) {
        var cell = self.getCellByPos(point.x, point.y);
        if (cell.colspan === 1) {
          self.removeCell(cell);
        } else {
          cell.colspan = parseInt(cell.colspan) - 1;
        }
      });
      data.history.push((0, _clone2.default)(data.row));
      this.update();
      if (this.afterAction) {
        this.afterAction();
      }
    }
  }, {
    key: 'removeRow',
    value: function removeRow(selectedno) {
      var data = this.data;
      data.showMenu = false;
      var self = this;
      var points = this.getAllPoints();
      var point1 = this.getLargePoint.apply(null, points);
      selectedno = parseInt(selectedno);
      var newpoint = { x: 0, y: selectedno, width: point1.width, height: 1 };
      var nextpoint = { x: 0, y: selectedno + 1, width: point1.width, height: 1 };
      var targetPoints = [];
      var removeCells = [];
      var insertCells = [];
      points.forEach(function (point) {
        if (self.hitTest(newpoint, point)) {
          targetPoints.push(point);
        }
      });
      points.forEach(function (point) {
        if (self.hitTest(nextpoint, point)) {
          var cell = self.getCellByPos(point.x, point.y);
          cell.x = point.x;
          if (point.y === nextpoint.y) {
            insertCells.push(cell);
          }
        }
      });
      targetPoints.forEach(function (point) {
        var cell = self.getCellByPos(point.x, point.y);
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
      insertCells.sort(function (a, b) {
        if (a.x > b.x) {
          return 1;
        }
        return -1;
      });
      removeCells.forEach(function (cell) {
        self.removeCell(cell);
      });
      data.row.splice(selectedno, 1);
      if (insertCells.length > 0) {
        data.row[selectedno] = { col: insertCells };
      }
      data.history.push((0, _clone2.default)(data.row));
      this.update();
    }
  }, {
    key: 'updateTable',
    value: function updateTable(b, a) {
      var data = this.data;
      var e = this.e;
      var type = e.type;
      var points = this.getSelectedPoints();
      var isSmartPhone = aTable.isSmartPhone();
      if (type === 'mouseup' && this.data.showMenu) {
        return;
      }
      var _ref = [parseInt(a), parseInt(b)];
      a = _ref[0];
      b = _ref[1];

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
        var elem = this._getElementByQuery('.a-table-selected .a-table-editable');
        _util2.default.triggerEvent(elem, 'copy');
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
        var _elem = this._getElementByQuery('.a-table-selected .a-table-editable');
        if (points.length > 1) {
          this.putCaret(_elem);
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
        } // todo
      } else if (type === 'input') {
        if (_util2.default.hasClass(this.e.target, 'a-table-editable') && this.e.target.parentNode.getAttribute('data-cell-id') === b + '-' + a) {
          data.history.push((0, _clone2.default)(data.row));
          data.row[a].col[b].value = this.e.target.innerHTML.replace(/{(.*?)}/g, '&lcub;$1&rcub;');
        }
        if (this.afterEntered) {
          this.afterEntered();
        }
      } else if (type === 'keyup' && aTable.getBrowser().indexOf('ie') !== -1) {
        if (_util2.default.hasClass(this.e.target, 'a-table-editable') && this.e.target.parentNode.getAttribute('data-cell-id') === b + '-' + a) {
          data.history.push((0, _clone2.default)(data.row));
          data.row[a].col[b].value = this.e.target.innerHTML.replace(/{(.*?)}/g, '&lcub;$1&rcub;');
        }
        if (this.afterEntered) {
          this.afterEntered();
        }
      }
    }
  }, {
    key: 'copyTable',
    value: function copyTable(e) {
      var points = this.getSelectedPoints();
      if (points.length <= 1) {
        return;
      }
      e.preventDefault();
      var copy_text = '<meta name="generator" content="Sheets"><table>';
      this.data.row.forEach(function (item, i) {
        if (!item.col) {
          return false;
        }
        copy_text += '<tr>';
        item.col.forEach(function (obj, t) {
          if (obj.selected) {
            copy_text += '<' + obj.type + ' colspan="' + obj.colspan + '" rowspan="' + obj.rowspan + '">' + obj.value + '</' + obj.type + '>';
          }
        });
        copy_text += '</tr>';
      });
      copy_text += '</table>';
      copy_text = copy_text.replace(/<table>(<tr><\/tr>)*/g, "<table>");
      copy_text = copy_text.replace(/(<tr><\/tr>)*<\/table>/g, "</table>");
      if (e.clipboardData) {
        e.clipboardData.setData('text/html', copy_text);
      } else if (window.clipboardData) {
        window.clipboardData.setData('Text', copy_text);
      }
    }
  }, {
    key: 'pasteTable',
    value: function pasteTable(e) {
      var pastedData = void 0;
      var data = this.data;
      if (e.clipboardData) {
        this.processPaste(e.clipboardData.getData('text/html'));
      } else if (window.clipboardData) {
        this.getClipBoardData();
      }
    }
  }, {
    key: 'getClipBoardData',
    value: function getClipBoardData() {
      var savedContent = document.createDocumentFragment();
      var point = this.getSelectedPoint();
      var index = this.getCellIndexByPos(point.x, point.y);
      var cell = this.getCellByIndex(index.col, index.row);
      var editableDiv = cell.querySelector('.a-table-editable');
      while (editableDiv.childNodes.length > 0) {
        savedContent.appendChild(editableDiv.childNodes[0]);
      }
      this.waitForPastedData(editableDiv, savedContent);
      return true;
    }
  }, {
    key: 'waitForPastedData',
    value: function waitForPastedData(elem, savedContent) {
      var _this3 = this;

      if (elem.childNodes && elem.childNodes.length > 0) {
        var pastedData = elem.innerHTML;
        elem.innerHTML = "";
        elem.appendChild(savedContent);
        this.processPaste(pastedData);
      } else {
        setTimeout(function () {
          _this3.waitForPastedData(elem, savedContent);
        }, 20);
      }
    }
  }, {
    key: 'processPaste',
    value: function processPaste(pastedData) {
      var e = this.e;
      e.preventDefault();
      var selectedPoint = this.getSelectedPoint();
      var tableHtml = pastedData.match(/<table(.*)>(([\n\r\t]|.)*?)<\/table>/i);
      var data = this.data;
      if (tableHtml && tableHtml[0]) {
        var newRow = this.parse(tableHtml[0], 'text');
        if (newRow && newRow.length) {
          this.insertTable(newRow, {
            x: selectedPoint.x,
            y: selectedPoint.y
          });
          data.history.push((0, _clone2.default)(data.row));
          return;
        }
      }
      // for excel;
      var row = this.parseText(pastedData);
      if (row && row[0] && row[0].col && row[0].col.length > 1) {
        var _selectedPoint = this.getSelectedPoint();
        this.insertTable(row, {
          x: _selectedPoint.x,
          y: _selectedPoint.y
        });
        this.update();
        data.history.push((0, _clone2.default)(data.row));
      } else {
        if (e.clipboardData) {
          var content = e.clipboardData.getData('text/plain');
          document.execCommand('insertText', false, content);
        } else if (window.clipboardData) {
          var _content = window.clipboardData.getData('Text');
          _util2.default.replaceSelectionWithHtml(_content);
        }
      }
    }
  }, {
    key: 'insertTable',
    value: function insertTable(table, pos) {
      var _this4 = this;

      var currentLength = this._getTableLength(this.data.row);
      var copiedLength = this._getTableLength(table);
      var offsetX = pos.x + copiedLength.x - currentLength.x;
      var offsetY = pos.y + copiedLength.y - currentLength.y;
      var length = currentLength.x;
      var row = this.data.row;
      var targets = [];
      var rows = [];
      var data = this.data;
      var prevRow = (0, _clone2.default)(data.row);
      while (offsetY > 0) {
        var newRow = [];
        for (var i = 0; i < length; i++) {
          var newcell = { type: 'td', colspan: 1, rowspan: 1, value: '' };
          newRow.push(newcell);
        }
        this.insertRow(currentLength.y, newRow);
        offsetY--;
      }
      if (offsetX > 0) {
        this.data.row.forEach(function (item) {
          for (var _i = 0; _i < offsetX; _i++) {
            item.col.push({ type: 'td', colspan: 1, rowspan: 1, value: '' });
          }
        });
      }

      this.update();
      var destPos = {};
      var vPos = {
        x: pos.x,
        y: pos.y
      };

      vPos.y += copiedLength.y - 1;
      vPos.x += copiedLength.x - 1;

      this.data.row.forEach(function (item, i) {
        if (!item.col) {
          return false;
        }
        item.col.forEach(function (obj, t) {
          var point = _this4.getCellInfoByIndex(t, i);
          if (point.x + point.width - 1 === vPos.x && point.y + point.height - 1 === vPos.y) {
            destPos.x = t;
            destPos.y = i;
          }
        });
      });

      if (typeof destPos.x === 'undefined') {
        alert(this.data.message.pasteError1);
        this.data.row = prevRow;
        this.update();
        return;
      }

      this.selectRange(destPos.y, destPos.x); //todo

      var selectedPoints = this.getSelectedPoints();
      var largePoint = this.getLargePoint.apply(null, selectedPoints);

      if (largePoint.width !== copiedLength.x || largePoint.height !== copiedLength.y) {
        alert(this.data.message.pasteError1);
        this.data.row = prevRow;
        this.update();
        return;
      }

      var bound = { x: 0, y: largePoint.y, width: largePoint.x, height: largePoint.height };
      var points = this.getAllPoints();

      points.forEach(function (point) {
        if (_this4.hitTest(bound, point)) {
          var index = _this4.getCellIndexByPos(point.x, point.y);
          var cell = _this4.getCellByPos(point.x, point.y);
          targets.push(index);
        }
      });

      targets.forEach(function (item) {
        var row = item.row;
        if (item.row < largePoint.y) {
          return;
        }
        if (!rows[row]) {
          rows[row] = [];
        }
        rows[row].push(item);
      });
      for (var _i2 = 1, n = rows.length; _i2 < n; _i2++) {
        if (!rows[_i2]) {
          continue;
        }
        rows[_i2].sort(function (a, b) {
          if (a.col > b.col) {
            return 1;
          }
          return -1;
        });
      }
      for (var _i3 = largePoint.y, _n = _i3 + largePoint.height; _i3 < _n; _i3++) {
        if (!rows[_i3]) {
          rows[_i3] = [];
          rows[_i3].push({ row: _i3, col: -1 });
        }
      }
      this.removeSelectedCellExcept();
      var t = 0;
      rows.forEach(function (row) {
        var index = row[row.length - 1];
        if (table[t]) {
          table[t].col.reverse().forEach(function (cell) {
            _this4.insertCellAt(index.row, index.col + 1, { type: 'td', colspan: parseInt(cell.colspan), rowspan: parseInt(cell.rowspan), value: cell.value, selected: true });
          });
        }
        t++;
      });
      this.update();
    }
  }, {
    key: 'updateResult',
    value: function updateResult() {
      var data = this.data;
      data.row = this.parse(data.tableResult);
      data.tableClass = this.getTableClass(data.tableResult);
      data.history.push((0, _clone2.default)(data.row));
      if (data.inputMode === 'table') {
        this.update();
      }
      if (this.afterEntered) {
        this.afterEntered();
      }
    }
  }, {
    key: 'insertColRight',
    value: function insertColRight(selectedno) {
      var data = this.data;
      data.selectedRowNo = parseInt(selectedno);
      data.showMenu = false;
      var self = this;
      var points = this.getAllPoints();
      var point1 = this.getLargePoint.apply(null, points);
      var newpoint = { x: parseInt(selectedno), y: 0, width: 1, height: point1.height };
      var targetPoints = [];
      points.forEach(function (point) {
        if (self.hitTest(newpoint, point)) {
          targetPoints.push(point);
        }
      });
      targetPoints.forEach(function (point) {
        var index = self.getCellIndexByPos(point.x, point.y);
        var cell = self.getCellByPos(point.x, point.y);
        var newcell = { type: 'td', colspan: 1, rowspan: cell.rowspan, value: '' };
        if (typeof index.row !== 'undefined' && typeof index.col !== 'undefined') {
          if (point.width + point.x - newpoint.x > 1) {
            cell.colspan = parseInt(cell.colspan) + 1;
            cell.colspan += '';
          } else {
            self.insertCellAt(index.row, index.col + 1, newcell);
          }
        }
      });
      data.history.push((0, _clone2.default)(data.row));
      this.update();
      if (this.afterAction) {
        this.afterAction();
      }
    }
  }, {
    key: 'insertColLeft',
    value: function insertColLeft(selectedno) {
      var data = this.data;
      selectedno = parseInt(selectedno);
      data.selectedRowNo = selectedno + 1;
      data.showMenu = false;
      var self = this;
      var points = this.getAllPoints();
      var point1 = this.getLargePoint.apply(null, points);
      var newpoint = { x: parseInt(selectedno) - 1, y: 0, width: 1, height: point1.height };
      var targetPoints = [];
      points.forEach(function (point) {
        if (self.hitTest(newpoint, point)) {
          targetPoints.push(point);
        }
      });
      if (selectedno === 0) {
        var length = point1.height;
        for (var i = 0; i < length; i++) {
          var newcell = { type: 'td', colspan: 1, rowspan: 1, value: '' };
          self.insertCellAt(i, 0, newcell);
        }
        data.history.push((0, _clone2.default)(data.row));
        self.update();
        if (this.afterAction) {
          this.afterAction();
        }
        return;
      }
      targetPoints.forEach(function (point) {
        var index = self.getCellIndexByPos(point.x, point.y);
        var cell = self.getCellByPos(point.x, point.y);
        var newcell = { type: 'td', colspan: 1, rowspan: cell.rowspan, value: '' };
        if (typeof index.row !== 'undefined' && typeof index.col !== 'undefined') {
          if (point.width + point.x - newpoint.x > 1) {
            cell.colspan = parseInt(cell.colspan) + 1;
            cell.colspan += '';
          } else {
            self.insertCellAt(index.row, index.col + 1, newcell);
          }
        }
      });
      data.history.push((0, _clone2.default)(data.row));
      this.update();
      if (this.afterAction) {
        this.afterAction();
      }
    }
  }, {
    key: 'beforeUpdated',
    value: function beforeUpdated() {
      this.changeSelectOption();
      this.markup();
    }
  }, {
    key: 'insertRowBelow',
    value: function insertRowBelow(selectedno) {
      var data = this.data;
      data.showMenu = false;
      data.selectedColNo = parseInt(selectedno);
      var self = this;
      var points = this.getAllPoints();
      var point1 = this.getLargePoint.apply(null, points);
      selectedno = parseInt(selectedno);
      var newpoint = { x: 0, y: selectedno + 1, width: point1.width, height: 1 };
      var targetPoints = [];
      var newRow = [];
      points.forEach(function (point) {
        if (self.hitTest(newpoint, point)) {
          targetPoints.push(point);
        }
      });
      if (targetPoints.length === 0) {
        var length = point1.width;
        for (var i = 0; i < length; i++) {
          var newcell = { type: 'td', colspan: 1, rowspan: 1, value: '' };
          newRow.push(newcell);
        }
        self.insertRow(selectedno + 1, newRow);
        self.update();
        return;
      }
      targetPoints.forEach(function (point) {
        var index = self.getCellIndexByPos(point.x, point.y);
        var cell = self.getCellByPos(point.x, point.y);
        if (!cell) {
          return;
        }
        var newcell = { type: 'td', colspan: 1, rowspan: 1, value: '' };
        if (typeof index.row !== 'undefined' && typeof index.col !== 'undefined') {
          if (point.height > 1 && point.y <= selectedno) {
            cell.rowspan = parseInt(cell.rowspan) + 1;
            cell.rowspan += '';
          } else if (index.row === selectedno + 1) {
            var _length = parseInt(cell.colspan);
            for (var _i4 = 0; _i4 < _length; _i4++) {
              newRow.push({ type: 'td', colspan: 1, rowspan: 1, value: '' });
            }
          } else {
            self.insertCellAt(index.row + 1, index.col, newcell);
          }
        }
      });
      this.insertRow(selectedno + 1, newRow);
      data.history.push((0, _clone2.default)(data.row));
      this.update();
    }
  }, {
    key: 'insertRowAbove',
    value: function insertRowAbove(selectedno) {
      var data = this.data;
      data.showMenu = false;
      data.selectedColNo = parseInt(selectedno) + 1;
      var self = this;
      var points = this.getAllPoints();
      var point1 = this.getLargePoint.apply(null, points);
      selectedno = parseInt(selectedno);
      var newpoint = { x: 0, y: selectedno - 1, width: point1.width, height: 1 };
      var targetPoints = [];
      var newRow = [];
      points.forEach(function (point) {
        if (self.hitTest(newpoint, point)) {
          targetPoints.push(point);
        }
      });
      if (selectedno === 0) {
        var length = point1.width;
        for (var i = 0; i < length; i++) {
          var newcell = { type: 'td', colspan: 1, rowspan: 1, value: '' };
          newRow.push(newcell);
        }
        self.insertRow(0, newRow);
        self.update();
        return;
      }
      targetPoints.forEach(function (point) {
        var index = self.getCellIndexByPos(point.x, point.y);
        var cell = self.getCellByPos(point.x, point.y);
        if (!cell) {
          return;
        }
        var newcell = { type: 'td', colspan: 1, rowspan: 1, value: '' };
        if (typeof index.row !== 'undefined' && typeof index.col !== 'undefined') {
          if (point.height > 1) {
            cell.rowspan = parseInt(cell.rowspan) + 1;
            cell.rowspan += '';
          } else if (index.row === selectedno - 1) {
            var _length2 = parseInt(cell.colspan);
            for (var _i5 = 0; _i5 < _length2; _i5++) {
              newRow.push({ type: 'td', colspan: 1, rowspan: 1, value: '' });
            }
          } else {
            self.insertCellAt(index.row, index.col, newcell);
          }
        }
      });
      this.insertRow(selectedno, newRow);
      data.history.push((0, _clone2.default)(this.data.row));
      this.update();
    }
  }, {
    key: 'mergeCells',
    value: function mergeCells() {
      var data = this.data;
      var points = this.getSelectedPoints();
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
      var point = this.getLargePoint.apply(null, points);
      var cell = this.getCellByPos(point.x, point.y);
      this.removeSelectedCellExcept(cell);
      cell.colspan = point.width;
      cell.rowspan = point.height;
      data.showMenu = false;
      data.history.push((0, _clone2.default)(data.row));
      this.update();
      if (this.afterAction) {
        this.afterAction();
      }
    }
  }, {
    key: 'splitCell',
    value: function splitCell() {
      var data = this.data;
      var selectedPoints = this.getSelectedPoints();
      var length = selectedPoints.length;
      if (length === 0) {
        alert(this.data.message.splitError1);
        return;
      } else if (length > 1) {
        alert(this.data.message.splitError2);
        return;
      }
      var selectedPoint = this.getSelectedPoint();
      var bound = { x: 0, y: selectedPoint.y, width: selectedPoint.x, height: selectedPoint.height };
      var points = this.getAllPoints();
      var currentIndex = this.getCellIndexByPos(selectedPoint.x, selectedPoint.y);
      var currentCell = this.getCellByPos(selectedPoint.x, selectedPoint.y);
      var width = parseInt(currentCell.colspan);
      var height = parseInt(currentCell.rowspan);
      var currentValue = currentCell.value;
      var self = this;
      var targets = [];
      var cells = [];
      var rows = [];
      if (width === 1 && height === 1) {
        alert(this.data.message.splitError3);
        return;
      }
      points.forEach(function (point) {
        if (self.hitTest(bound, point)) {
          var index = self.getCellIndexByPos(point.x, point.y);
          var cell = self.getCellByPos(point.x, point.y);
          targets.push(index);
        }
      });
      targets.forEach(function (item) {
        var row = item.row;
        if (item.row < currentIndex.row) {
          return;
        }
        if (!rows[row]) {
          rows[row] = [];
        }
        rows[row].push(item);
      });
      for (var i = 1, n = rows.length; i < n; i++) {
        if (!rows[i]) {
          continue;
        }
        rows[i].sort(function (a, b) {
          if (a.col > b.col) {
            return 1;
          }
          return -1;
        });
      }
      for (var _i6 = selectedPoint.y, _n2 = _i6 + height; _i6 < _n2; _i6++) {
        if (!rows[_i6]) {
          rows[_i6] = [];
          rows[_i6].push({ row: _i6, col: -1 });
        }
      }
      var first = true;
      rows.forEach(function (row) {
        var index = row[row.length - 1];
        for (var _i7 = 0; _i7 < width; _i7++) {
          var val = '';
          // スプリットされる前のコルのデータを保存
          if (first === true && _i7 === width - 1) {
            val = currentValue;
            first = false;
          }
          self.insertCellAt(index.row, index.col + 1, { type: 'td', colspan: 1, rowspan: 1, value: val, selected: true });
        }
      });
      this.removeCell(currentCell);
      data.showMenu = false;
      data.history.push((0, _clone2.default)(data.row));
      data.splited = true;
      this.update();
      if (this.afterAction) {
        this.afterAction();
      }
    }
  }, {
    key: 'changeCellTypeTo',
    value: function changeCellTypeTo(type) {
      var data = this.data;
      data.row.forEach(function (item, i) {
        item.col.forEach(function (obj, t) {
          if (obj.selected) {
            obj.type = type;
          }
        });
      });
      data.showMenu = false;
      data.history.push((0, _clone2.default)(data.row));
      this.update();
      if (this.afterAction) {
        this.afterAction();
      }
    }
  }, {
    key: 'align',
    value: function align(_align) {
      var data = this.data;
      data.row.forEach(function (item, i) {
        item.col.forEach(function (obj, t) {
          if (obj.selected) {
            obj.align = _align;
          }
        });
      });
      data.showMenu = false;
      data.history.push((0, _clone2.default)(data.row));
      this.update();
      if (this.afterAction) {
        this.afterAction();
      }
    }
  }, {
    key: 'getStyleByAlign',
    value: function getStyleByAlign(val) {
      var align = this.data.mark.align;
      if (align.default === val) {
        return '';
      }
      return align[val];
    }
  }, {
    key: 'getAlignByStyle',
    value: function getAlignByStyle(style) {
      var align = this.data.mark.align;
      if (align.right === style) {
        return 'right';
      } else if (align.center === style) {
        return 'center';
      } else if (align.left === style) {
        return 'left';
      }
    }
  }, {
    key: 'isSelectedCellsRectangle',
    value: function isSelectedCellsRectangle() {
      var selectedPoints = this.getSelectedPoints();
      var largePoint = this.getLargePoint.apply(null, selectedPoints);
      var points = this.getAllPoints();
      var flag = true;
      var self = this;
      points.forEach(function (point) {
        if (self.hitTest(largePoint, point)) {
          var cell = self.getCellByPos(point.x, point.y);
          if (!cell.selected) {
            flag = false;
          }
        }
      });
      return flag;
    }
  }, {
    key: 'changeInputMode',
    value: function changeInputMode(source) {
      var data = this.data;
      data.inputMode = source;
      if (source === 'source') {
        data.tableResult = this.getTable();
      } else {
        data.row = this.parse(data.tableResult);
        data.tableClass = this.getTableClass(data.tableResult);
      }
      this.update();
    }
  }, {
    key: 'changeCellClass',
    value: function changeCellClass() {
      var data = this.data;
      var cellClass = data.cellClass;
      data.row.forEach(function (item, i) {
        item.col.forEach(function (obj, t) {
          if (obj.selected) {
            obj.cellClass = cellClass;
          }
        });
      });
      data.history.push((0, _clone2.default)(data.row));
      this.update();
      if (this.afterAction) {
        this.afterAction();
      }
    }
  }, {
    key: 'changeSelectOption',
    value: function changeSelectOption() {
      var cellClass = void 0;
      var flag = true;
      var data = this.data;
      data.row.forEach(function (item) {
        item.col.forEach(function (obj) {
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
  }], [{
    key: 'isSmartPhone',
    value: function isSmartPhone() {
      var agent = navigator.userAgent;
      if (agent.indexOf('iPhone') > 0 || agent.indexOf('iPad') > 0 || agent.indexOf('ipod') > 0 || agent.indexOf('Android') > 0) {
        return true;
      }
      return false;
    }
  }, {
    key: 'getBrowser',
    value: function getBrowser() {
      var ua = window.navigator.userAgent.toLowerCase();
      var ver = window.navigator.appVersion.toLowerCase();
      var name = 'unknown';

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
  }, {
    key: 'getUniqId',
    value: function getUniqId() {
      return (Date.now().toString(36) + Math.random().toString(36).substr(2, 5)).toUpperCase();
    }
  }]);

  return aTable;
}(_aTemplate3.default);

exports.default = aTable;
module.exports = exports['default'];