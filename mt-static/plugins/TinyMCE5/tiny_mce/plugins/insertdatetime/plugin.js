/**
 * Copyright (c) Tiny Technologies, Inc. All rights reserved.
 * Licensed under the LGPL or a commercial license.
 * For LGPL see License.txt in the project root for license information.
 * For commercial licenses see https://www.tiny.cloud/
 *
 * Version: 5.10.2 (2021-11-17)
 */
(function () {
    'use strict';

    var global$1 = tinymce.util.Tools.resolve('tinymce.PluginManager');

    var getDateFormat = function (editor) {
      return editor.getParam('insertdatetime_dateformat', editor.translate('%Y-%m-%d'));
    };
    var getTimeFormat = function (editor) {
      return editor.getParam('insertdatetime_timeformat', editor.translate('%H:%M:%S'));
    };
    var getFormats = function (editor) {
      return editor.getParam('insertdatetime_formats', [
        '%H:%M:%S',
        '%Y-%m-%d',
        '%I:%M:%S %p',
        '%D'
      ]);
    };
    var getDefaultDateTime = function (editor) {
      var formats = getFormats(editor);
      return formats.length > 0 ? formats[0] : getTimeFormat(editor);
    };
    var shouldInsertTimeElement = function (editor) {
      return editor.getParam('insertdatetime_element', false);
    };

    var daysShort = 'Sun Mon Tue Wed Thu Fri Sat Sun'.split(' ');
    var daysLong = 'Sunday Monday Tuesday Wednesday Thursday Friday Saturday Sunday'.split(' ');
    var monthsShort = 'Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec'.split(' ');
    var monthsLong = 'January February March April May June July August September October November December'.split(' ');
    var addZeros = function (value, len) {
      value = '' + value;
      if (value.length < len) {
        for (var i = 0; i < len - value.length; i++) {
          value = '0' + value;
        }
      }
      return value;
    };
    var getDateTime = function (editor, fmt, date) {
      if (date === void 0) {
        date = new Date();
      }
      fmt = fmt.replace('%D', '%m/%d/%Y');
      fmt = fmt.replace('%r', '%I:%M:%S %p');
      fmt = fmt.replace('%Y', '' + date.getFullYear());
      fmt = fmt.replace('%y', '' + date.getYear());
      fmt = fmt.replace('%m', addZeros(date.getMonth() + 1, 2));
      fmt = fmt.replace('%d', addZeros(date.getDate(), 2));
      fmt = fmt.replace('%H', '' + addZeros(date.getHours(), 2));
      fmt = fmt.replace('%M', '' + addZeros(date.getMinutes(), 2));
      fmt = fmt.replace('%S', '' + addZeros(date.getSeconds(), 2));
      fmt = fmt.replace('%I', '' + ((date.getHours() + 11) % 12 + 1));
      fmt = fmt.replace('%p', '' + (date.getHours() < 12 ? 'AM' : 'PM'));
      fmt = fmt.replace('%B', '' + editor.translate(monthsLong[date.getMonth()]));
      fmt = fmt.replace('%b', '' + editor.translate(monthsShort[date.getMonth()]));
      fmt = fmt.replace('%A', '' + editor.translate(daysLong[date.getDay()]));
      fmt = fmt.replace('%a', '' + editor.translate(daysShort[date.getDay()]));
      fmt = fmt.replace('%%', '%');
      return fmt;
    };
    var updateElement = function (editor, timeElm, computerTime, userTime) {
      var newTimeElm = editor.dom.create('time', { datetime: computerTime }, userTime);
      timeElm.parentNode.insertBefore(newTimeElm, timeElm);
      editor.dom.remove(timeElm);
      editor.selection.select(newTimeElm, true);
      editor.selection.collapse(false);
    };
    var insertDateTime = function (editor, format) {
      if (shouldInsertTimeElement(editor)) {
        var userTime = getDateTime(editor, format);
        var computerTime = void 0;
        if (/%[HMSIp]/.test(format)) {
          computerTime = getDateTime(editor, '%Y-%m-%dT%H:%M');
        } else {
          computerTime = getDateTime(editor, '%Y-%m-%d');
        }
        var timeElm = editor.dom.getParent(editor.selection.getStart(), 'time');
        if (timeElm) {
          updateElement(editor, timeElm, computerTime, userTime);
        } else {
          editor.insertContent('<time datetime="' + computerTime + '">' + userTime + '</time>');
        }
      } else {
        editor.insertContent(getDateTime(editor, format));
      }
    };

    var register$1 = function (editor) {
      editor.addCommand('mceInsertDate', function (_ui, value) {
        insertDateTime(editor, value !== null && value !== void 0 ? value : getDateFormat(editor));
      });
      editor.addCommand('mceInsertTime', function (_ui, value) {
        insertDateTime(editor, value !== null && value !== void 0 ? value : getTimeFormat(editor));
      });
    };

    var Cell = function (initial) {
      var value = initial;
      var get = function () {
        return value;
      };
      var set = function (v) {
        value = v;
      };
      return {
        get: get,
        set: set
      };
    };

    var global = tinymce.util.Tools.resolve('tinymce.util.Tools');

    var register = function (editor) {
      var formats = getFormats(editor);
      var defaultFormat = Cell(getDefaultDateTime(editor));
      var insertDateTime = function (format) {
        return editor.execCommand('mceInsertDate', false, format);
      };
      editor.ui.registry.addSplitButton('insertdatetime', {
        icon: 'insert-time',
        tooltip: 'Insert date/time',
        select: function (value) {
          return value === defaultFormat.get();
        },
        fetch: function (done) {
          done(global.map(formats, function (format) {
            return {
              type: 'choiceitem',
              text: getDateTime(editor, format),
              value: format
            };
          }));
        },
        onAction: function (_api) {
          insertDateTime(defaultFormat.get());
        },
        onItemAction: function (_api, value) {
          defaultFormat.set(value);
          insertDateTime(value);
        }
      });
      var makeMenuItemHandler = function (format) {
        return function () {
          defaultFormat.set(format);
          insertDateTime(format);
        };
      };
      editor.ui.registry.addNestedMenuItem('insertdatetime', {
        icon: 'insert-time',
        text: 'Date/time',
        getSubmenuItems: function () {
          return global.map(formats, function (format) {
            return {
              type: 'menuitem',
              text: getDateTime(editor, format),
              onAction: makeMenuItemHandler(format)
            };
          });
        }
      });
    };

    function Plugin () {
      global$1.add('insertdatetime', function (editor) {
        register$1(editor);
        register(editor);
      });
    }

    Plugin();

}());
