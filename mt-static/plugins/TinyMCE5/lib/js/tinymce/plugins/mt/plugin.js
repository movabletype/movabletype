/*
 * Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
 * This code cannot be redistributed without permission from www.sixapart.com.
 * For more information, consult your Movable Type license.
 *
 * $Id$
 */
;(function($) {
  $.each(['plugin', 'advanced', 'core'], function() {
      tinymce.ScriptLoader.add(tinymce.PluginManager.urls['mt'] + '/langs/plugin.js');
  });

  
      tinymce.Editor.prototype.addMTButton = function(name, opts) {
          var ed = this;
  
          var modes = {};
          var funcs = opts['onclickFunctions'];
          if (funcs) {
              opts['onAction'] = function(e) {
                  var mode = ed.mtEditorStatus['mode'];
                  var func = funcs[mode];
                  if (typeof(func) == 'string') {
                      ed.mtProxies[mode].execCommand(func);
                  }
                  else {
                      func.apply(ed, arguments);
                  }
                  ed.fire('onMTSourceButtonClick', e);
              };
              for (k in funcs) {
                  modes[k] = 1;
              }
          }
          else {
              modes = {wysiwyg:1,source:1};
          }
  
          if (! opts['isSupported']) {
              opts['isSupported'] = function(mode, format) {
                  if (! modes[mode]) {
                      return false;
                  }
  
                  if (funcs && mode == 'source') {
                      var func = funcs[mode];
                      if (typeof(func) == 'string') {
                          return ed.mtProxies['source'].isSupported(func, format);
                      }
                      else {
                          return true;
                      }
                  }
                  else {
                      return true;
                  }
              };
          }
          if (! opts['onSetup']) {
              opts['onSetup'] = function(buttonApi) {
                  ed.on('onMTSourceButtonClick', function(e) {
                      if(ed.mtProxies['source'] && buttonApi.setActive){
                          buttonApi.setActive( ed.mtProxies['source'].isStateActive(ed.sourceButtons[name]) );
                      }
                  });
              }
          }
  
          if (typeof(ed.mtButtons) == 'undefined') {
              ed.mtButtons = {};
          }
          ed.mtButtons[name] = opts;
          
          if (opts['toggle']) {
            return ed.ui.registry.addToggleButton(name, opts);
          }
          return ed.ui.registry.addButton(name, opts);
      };

  tinymce.create('tinymce.plugins.MovableType', {
      buttonSettings : '',

      _initButtonSettings : function(ed) {
          // TODO: 

          var plugin = this;
          plugin.buttonIDs = {};

          var buttonRows = {
              source: {},
              wysiwyg: {}
          };

          var index = 1;
          if( ed.inline ) {
              $.each(['wysiwyg'], function(i, k) {
                  var p = 'plugin_mt_' + k + '_insert_toolbar';
                  plugin.buttonSettings +=
                      (plugin.buttonSettings ? ',' : '') + ed.settings[p];

                  ed.settings['quickbars_insert_toolbar'] += ed.settings[p];
                  buttonRows[k][index-1] = 1;
                  index++;

                  var p = 'plugin_mt_' + k + '_selection_toolbar';
                  plugin.buttonSettings +=
                      (plugin.buttonSettings ? ',' : '') + ed.settings[p];

                  ed.settings['quickbars_selection_toolbar'] += ed.settings[p];
                  buttonRows[k][index-1] = 1;
                  index++;
              });
          } else {
              $.each(['common', 'source', 'wysiwyg'], function(i, k) {
                  var p = 'plugin_mt_' + k + '_buttons';
                  for (var j = 1; ed.settings[p+j]; j++) {
                      plugin.buttonSettings +=
                          (plugin.buttonSettings ? ',' : '') + ed.settings[p+j];

                      ed.settings['toolbar'+index] =
                          ed.settings[p + j];
                      if (k == 'common') {
                          buttonRows['source'][index-1] =
                              buttonRows['wysiwyg'][index-1] = 1;
                      }
                      else {
                          buttonRows[k][index-1] = 1;
                      }

                      index++;
                  }
              });
          }
          return buttonRows;
      },

      _setupIframeStatus : function(ed) {
          ed.on('postRender', function() {
              var $win        = $(window);
              var $c          = $(ed.getContainer());
              var $iframe     = $c.find('iframe');
              var $iframeWin  = $(ed.getWin());
              var ns          = '.tinymce_mt_iframe_status_' + ed.id;

              $iframeWin
                  .on('focus', function() {
                      $iframe.addClass('state-focus');
                  })
                  .on('blur', function() {
                      $iframe.removeClass('state-focus');
                  });

              function bindMousemoveToIframe() {
                  $iframeWin.on('mousemove' + ns, function() {
                      $iframeWin.off('mousemove' + ns);
                      $iframe.addClass('state-hover');
                      $win.on('mousemove' + ns, function() {
                          $win.off('mousemove' + ns);
                          $iframe.removeClass('state-hover');
                          bindMousemoveToIframe();
                      });
                  });
              }
              bindMousemoveToIframe();
          });
      },

      _setupExplicitButtonActivation : function(ed) {
          ed.on('postRender', function() {
              var win      = window;
              var button   = '$TinyMCEMTButtonActive';
              var $c       = $(ed.getContainer());
              var selector = '.mceButton, .mceListBoxEnabled, .mceSplitButtonEnabled a';
              $c.find(selector).on('mousedown', function() {
                  win[button] = $(this).addClass('psedo-active');
              });

              $.each([win.document, ed.getWin().document], function() {
                  var w     = this;
                  var ns    = '.tinymce_mt_button_activate';
                  var event = 'mouseup' + ns + ' touchend' + ns;
                  $(w)
                      .off(event)
                      .on(event, function() {
                          if (win[button]) {
                              win[button].removeClass('psedo-active');
                              win[button] = null;
                          }
                      });
              });
          });
      },

      init : function(ed, url) {
          var plugin         = this;
          var id             = ed.id;
          var idLengbth      = id.length;
          var blogId         = $('[name=blog_id]').val() || 0;
          var proxies        = {};
          var hiddenControls = [];
          var $container     = null;
          var savedBookmark  = null;

          var supportedButtonsCache = {};
          var buttonRows            = this._initButtonSettings(ed);
          ed.sourceButtons         = {};



          ed.mtProxies = proxies;
          ed.mtEditorStatus = {
              mode: 'wysiwyg',
              format: 'richtext'
          };

          function supportedButtons(mode, format) {
              var k = mode + '-' + format;
              if (! supportedButtonsCache[k]) {
                  supportedButtonsCache[k] = {};
                  $.each(ed.mtButtons, function(name, button) {
                      if (button.isSupported(mode, format)) {
                          supportedButtonsCache[k][name] = button;
                      }
                  });
              }

              return supportedButtonsCache[k];
          };

          function updateButtonVisibility() {
              var s = ed.mtEditorStatus;
              $.each(hiddenControls, function(i, k) {
                  var label = tinymce.util.I18n.translate(ed.mtButtons[k].tooltip);
                  $container.find('button[title="' + label + '"]')
                  .css({
                    display: ''
                  })
                  .removeClass('mce_mt_button_hidden');
              });
              hiddenControls = [];
              
              var supporteds = supportedButtons(s.mode, s.format);

              function update(key) {
                if (! supporteds[key]) {
                      var label = tinymce.util.I18n.translate(ed.mtButtons[key].tooltip);
                      $container.find('button[title="' + label + '"]')
                          .css({
                              display: 'none'
                          })
                          .addClass('mce_mt_button_hidden');
                      hiddenControls.push(key);
                  }
                }
              
              if (s.mode == 'source') {
                  proxies.source.setFormat(s.format);
                  $.each(ed.mtButtons, function(name, button) {
                    update(name);
                });
              }
              $(ed.editorContainer).find('.tox-toolbar-overlord .tox-toolbar').each(function(i) {
                  if (buttonRows[s.mode][i]) {
                      $(this).show();
                  }
                  else {
                      $(this).hide();
                  }
                  // common_buttons
                  if( i == 0 ){
                      $(this).addClass('float-right');
                  }
              });

          }

          function openDialog(mode, param) {
              createSessionHistoryFallback(location.href);
              var url = ScriptURI + '?' + '__mode=' + mode + '&amp;' + param;
              $.fn.mtModal.open(url, { large: true });
              var modal_close = function(e){
                if (e.keyCode == 27){
                  $.fn.mtModal.close();
                  $('body').off('keyup', modal_close);
                }
              };
              $('body').on('keyup', modal_close);
          }

          function setPopupWindowLoadedHook(callback) {
              $.each(ed.windowManager.windows, function(k, w) {
                  w.on('open', function(win){
                      var context = {
                          '$contents': this.$el.contents(),
                          'window': this
                      };
                      callback(context);
                  });
              });
          }

          function initSourceButtons(mode, format) {
              $.each(ed.mtButtons, function(name, button) {
                  var command;
                  if (
                      button['onclickFunctions'] &&
                      (command = button['onclickFunctions']['source']) &&
                      (typeof(command) == 'string') &&
                      (plugin.buttonSettings.indexOf(name) != -1)
                     ) {
                      ed.sourceButtons[name] = command;
                  }
              });
          }
          ed.on('init', function() {
              $container = $(ed.getContainer());
              updateButtonVisibility();
              initSourceButtons();
              // ed.theme.resizeBy(0, 0);
          });

          ed.on('PreInit', function() {
              // Escape/Unescape comment/cdata for security
              ed.parser.addNodeFilter('#comment,#cdata', function(nodes, name) {
                  var i, node;

                  for (i = 0; i < nodes.length; i++) {
                      node = nodes[i];
                      node.value = escape(node.value);
                  }
              });

              ed.serializer.addNodeFilter('#comment', function(nodes, name) {
                  var i, node;

                  for (i = 0; i < nodes.length; i++) {
                      node = nodes[i];
                      node.value = unescape(node.value);
                      if (node.value.indexOf('[CDATA[') === 0) {
                          node.name = '#cdata';
                          node.type = 4;
                          node.value = node.value.replace(/^\[CDATA\[|\]\]$/g, '');
                      }
                  }
              });

              ed.parser.addNodeFilter('link,meta', function(nodes, name) {
                  var i, node;

                  for (i = 0; i < nodes.length; i++) {
                      node = nodes[i];
                      node.remove();
                  }
              });
          });

          if (ed.settings['plugin_mt_tainted_input'] && tinymce.isIE) {
              ed.on('PreInit', function() {
                  var attrPrefix  = 'data-mce-mtie-',
                      placeholder = '-mt-placeholder:auto;',
                      valuePrefix = 'mce-mt-',
                      valueRegExp = new RegExp('^' + valuePrefix);

                  // Save/Restore CSS
                  ed.parser.addNodeFilter('link', function(nodes, name) {
                      var i, node;

                      for (i = 0; i < nodes.length; i++) {
                          node = nodes[i];
                          $.each(['type', 'rel'], function(i, k) {
                              var value = node.attr(k);
                              if (value) {
                                  node.attr(k, valuePrefix + value);
                              }
                          });
                      }
                  });

                  ed.parser.addNodeFilter('style', function(nodes, name) {
                      var i, node;

                      for (i = 0; i < nodes.length; i++) {
                          node = nodes[i];
                          node.attr('type', valuePrefix + (node.attr('type') || 'text/css'));
                      }
                  });

                  ed.serializer.addNodeFilter('link,style', function(nodes, name) {
                      var i, node, value;

                      for (i = 0; i < nodes.length; i++) {
                          node  = nodes[i];
                          $.each(['type', 'rel'], function(i, k) {
                              var value = node.attr(k);
                              if (value) {
                                  node.attr(k, value.replace(valueRegExp, ''));
                              }
                          });
                      }
                  });

                  ed.parser.addAttributeFilter('style', function(nodes, name) {
                      var i, node,
                          internalName = attrPrefix + name;

                      for (i = 0; i < nodes.length; i++) {
                          node = nodes[i];
                          node.attr(internalName, node.attr(name));
                          node.attr(name, placeholder);
                      }
                  });

                  ed.serializer.addAttributeFilter(attrPrefix + 'style', function(nodes, internalName) {
                      var i, node, savedValue, attrValue,
                          name = internalName.substring(attrPrefix.length);

                      for (i = 0; i < nodes.length; i++) {
                          node       = nodes[i];
                          attrValue  = node.attr(name)
                          savedValue = node.attr(internalName);

                          if (attrValue === placeholder) {
                              if (! (savedValue && savedValue.length > 0)) {
                                  savedValue = null;
                              }
                              node.attr(name, savedValue);
                          }
                          node.attr(internalName, null);
                      }
                  });
              });
          }

          this._setupExplicitButtonActivation(ed);
          this._setupIframeStatus(ed);

          ed.addQueryValueHandler('mtGetStatus', function() {
              return ed.mtEditorStatus;
          });

          ed.addCommand('mtSetStatus', function(status) {
              $.extend(ed.mtEditorStatus, status);
              updateButtonVisibility();
          });

          ed.addQueryValueHandler('mtGetProxies', function() {
              return proxies;
          });

          ed.addCommand('mtSetProxies', function(_proxies) {
              $.extend(proxies, _proxies);
          });

          ed.addCommand('mtRestoreBookmark', function(bookmark) {
              if (! bookmark) {
                  bookmark = savedBookmark;
              }
              if (bookmark) {
                  ed.selection.moveToBookmark(savedBookmark);
              }
          });

          ed.addQueryValueHandler('mtSaveBookmark', function() {
              return savedBookmark = ed.selection.getBookmark();
          });


          $(window).on('dialogDisposed', function() {
              if (savedBookmark) {
                  ed.selection.moveToBookmark(savedBookmark);
              }
              savedBookmark = null;
          });

          // Register buttons
          ed.ui.registry.addButton('mt_insert_html', {
              icon : 'addhtml',
              tooltip : 'insert_html',
              onAction : function() {

                  win = ed.windowManager.open({
                      title: trans('Insert HTML'),
                      body: {
                          type: 'panel',
                          items: [
                              {
                                  type: 'textarea',
                                  label: trans('HTML'),
                                  name: 'insert_html',
                                  classes: 'insert_html',
                                  text: '',
                                  minHeight: 290,
                                  autofocus: true
                              }
                          ]
                      },
                      buttons: [
                        {
                          type: 'cancel',
                          name: 'cancel',
                          text: 'Cancel'
                        },
                        {
                          type: 'submit',
                          name: 'save',
                          text: 'Save',
                          primary: true
                        }
                      ],
                      onSubmit: function(api) {
                          ed.execCommand('mceInsertContent', false, api.getData().insert_html);
                          api.close()
                      },
                      size: 'large',
                      // minWidth: Math.min(tinymce.DOM.getViewPort().w, ed.getParam('template_popup_width', 600)),
                      // minHeight: Math.min(tinymce.DOM.getViewPort().h, ed.getParam('template_popup_height', 500))
                  });
              }
          });

          ed.addMTButton('mt_insert_image', {
              icon : 'image',
              tooltip : 'insert_image',
              onAction : function() {
                  ed.execCommand('mtSaveBookmark');
                  openDialog(
                      'dialog_asset_modal',
                      '_type=asset&amp;edit_field=' + id + '&amp;blog_id=' + blogId + '&amp;dialog_view=1&amp;filter=class&amp;filter_val=image&amp;can_multi=1'
                  );
              }
          });

          ed.addMTButton('mt_insert_file', {
              icon : 'new-document',
              tooltip : 'insert_file',
              onAction : function() {
                  ed.execCommand('mtSaveBookmark');
                  openDialog(
                      'dialog_asset_modal',
                      '_type=asset&amp;edit_field=' + id + '&amp;blog_id=' + blogId + '&amp;dialog_view=1&amp;can_multi=1'
                  );
              }
          });

          ed.addMTButton('mt_source_bold', {
              tooltip : 'source_bold',
              text : 'strong',
              mtButtonClass: 'text',
              toggle: true,
              onclickFunctions : {
                  source: 'bold'
              },
          });

          ed.addMTButton('mt_source_italic', {
              tooltip : 'source_italic',
              text : 'em',
              mtButtonClass: 'text',
              toggle: true,
              onclickFunctions : {
                  source: 'italic'
              }
          });

          ed.addMTButton('mt_source_blockquote', {
              tooltip : 'source_blockquote',
              text : 'btn_blockquote',
              mtButtonClass: 'text',
              toggle: true,
              onclickFunctions : {
                  source: 'blockquote'
              }
          });

          ed.addMTButton('mt_source_unordered_list', {
              tooltip : 'source_unordered_list',
              text : 'ul',
              mtButtonClass: 'text',
              toggle: true,
              onclickFunctions : {
                  source: 'insertUnorderedList'
              }
          });

          ed.addMTButton('mt_source_ordered_list', {
              tooltip : 'source_ordered_list',
              text : 'ol',
              mtButtonClass: 'text',
              toggle: true,
              onclickFunctions : {
                  source: 'insertOrderedList'
              }
          });

          ed.addMTButton('mt_source_list_item', {
              tooltip : 'source_list_item',
              text : 'li',
              mtButtonClass: 'text',
              toggle: true,
              onclickFunctions : {
                  source: 'insertListItem'
              }
          });

          let _before_insert_content = function(){
            ed.off('beforeExecCommand', _insertContent);
            ed.on('beforeExecCommand', _insertContent);
          }
          let _insertContent = function(e) {
              if (e.command == 'mceInsertContent' && e.value) {
                  ed.mtProxies.source.editor.insertContent(e.value);
                  ed.off('beforeExecCommand', _insertContent);
              }
          };

          ed.addMTButton('mt_source_link', {
              icon : 'link',
              tooltip : 'insert_link',
              onclickFunctions : {
                  source: function(cmd, ui, val) {
                      ed.once('OpenWindow', function(dialog){
                        var s = ed.mtEditorStatus;
                        if( s.mode == 'source' && (s.format != '0' && s.format != '__default__')){
                            jQuery('.tox-dialog__body .tox-listbox.tox-listbox--select').attr('disabled', 'disabled');
                        }
                        jQuery('.tox-dialog__header button.tox-button--naked, .tox-dialog__footer button.tox-button--secondary').on('click', function(){
                            ed.off('CloseWindow');
                        });
                      });
                      ed.execCommand('mceLink');
                      ed.once('CloseWindow', function(dialog){
                        var data = dialog.dialog.getData();
                        if(data.url.value)
                        ed.mtProxies['source']
                        .execCommand(
                            'createLink',
                            null,
                            data.url.value,
                            {
                                'target': data.target,
                                'title': data.title,
                                'text': data.text,
                            }
                        );
                        dialog.dialog.setData({});
                    });
                  }
              }
          });

          ed.addMTButton('mt_source_template', {
              tooltip : 'Insert template',
              icon: 'template',
              onclickFunctions : {
                  source: function(buttonApi) {
                      ed.ui.registry.getAll().buttons.template.onAction(editor);
                      _before_insert_content()
                  }
              },
          });

          ed.addMTButton('mt_source_mode', {
              icon : 'sourcecode',
              tooltip : 'source_mode',
              toggle: true,
              onclickFunctions : {
                  wysiwyg: function() {
                      ed.execCommand('mtSetFormat', 'none.tinymce_temp');
                  },
                  source: function() {
                      ed.execCommand('mtSetFormat', 'richtext');
                  }
              },
              onSetup: function(buttonApi) {
                  ed.on('onMTSourceButtonClick', function(e) {
                      var s = ed.mtEditorStatus;
                      buttonApi.setActive( s.mode && s.mode == 'source');
                  });
              }
          });

/*
          var filterd_attrs = [];
          var regexp = new RegExp(/^on|action/);
          function addAttributeFilterRegexp(){
              var attrPrefix  = 'data-mce-mt-';
              var attrRegExp  = new RegExp('^' + attrPrefix);
              var placeholder = 'javascript:void("mce-mt-event-placeholer");return false';

              tinymce.util.Tools.each(ed.dom.select('*'), function (node) {
                  tinymce.util.Tools.each(node.attributes, function(attr){
                      if(filterd_attrs[attr.name]) return;
                      if(!regexp.test(attr.name)) return;
                      
                      // Save/Restore event handler of the node.
                      ed.parser.addAttributeFilter(attr.name, function(nodes, name) {
                          var internalName = attrPrefix + name;
                          tinymce.util.Tools.each(nodes, function(targetNode){
                              targetNode.attr(internalName, targetNode.attr(name));
                              targetNode.attr(name, placeholder);
                          });
                      });
                      
                      ed.serializer.addAttributeFilter(attrPrefix + attr.name, function(nodes, internalName) {
                          var name = internalName.substring(attrPrefix.length);
      
                          tinymce.util.Tools.each(nodes, function(targetNode){
                              var attrValue  = targetNode.attr(name)
                              var savedValue = targetNode.attr(internalName);
      
                              if (attrValue === placeholder) {
                                  if (! (savedValue && savedValue.length > 0)) {
                                      savedValue = null;
                                  }
                                  targetNode.attr(name, savedValue);
                              }
                              targetNode.attr(internalName, null);
                          });
                      });
                      filterd_attrs[attr.name] = 1;
                });
              });
          }
*/

          ed.on('NodeChange', function() {
              var s = ed.mtEditorStatus;

              if (s.mode == 'source' &&
                  s.format != 'none.tinymce_temp'
              ) {
                  $(ed.container).find('.tox-toolbar:eq(0)').css('display', 'none');
              }
              else {
                  $(ed.container).find('.tox-toolbar:eq(0)').css('display', '');
              }

              var active =
                  s.mode == 'source' &&
                  s.format == 'none.tinymce_temp';
              // cm.setActive('mt_source_mode', active);

              if (! ed.mtProxies['source']) {
                  return;
              }
          });
      },

      createControl : function(name, cm) {
          var editor = cm.editor;
          var ctrl   = editor.buttons[name];

          if (
                  (name == 'mt_insert_image')
                  || (name == 'mt_insert_file')
          ) {
              if (! this.buttonIDs[name]) {
                  this.buttonIDs[name] = [];
              }

              var id = name + '_' + this.buttonIDs[name].length;
              this.buttonIDs[name].push(id);

              return cm.createButton(id, $.extend({}, ctrl, {
                  'class': 'mce_' + name
              }));
          }

          if (ctrl && ctrl['mtButtonClass']) {
              var button, buttonClass, escapedButtonClass;

              switch (ctrl['mtButtonClass']) {
              case 'text':
                    buttonClass = tinymce.ui.MTTextButton;
                    break;
              default:
                    throw new Error('Not implemented:' + ctrl['mtButtonClass']);
              }

              if (cm._cls.button) {
                  escapedButtonClass = cm._cls.button;
              }
              cm._cls.button = buttonClass;

              button = cm.createButton(name, $.extend({}, ctrl));

              if (escapedButtonClass !== 'undefined') {
                  cm._cls.button = escapedButtonClass
              }

              return button;
          }


          return null;
      },

      getInfo : function() {
          return {
              longname : 'MovableType',
              author : 'Six Apart Ltd',
              authorurl : '',
              infourl : '',
              version : '1.0'
          };
      }
  });

  (function() {
    var each = tinymce.each;

    tinymce.create('static tinymce.plugins.MovableType.Cookie', {
      getHash : function(n) {
        var v = this.get(n), h;

        if (v) {
          each(v.split('&'), function(v) {
            v = v.split('=');
            h = h || {};
            h[unescape(v[0])] = unescape(v[1]);
          });
        }

        return h;
      },

      setHash : function(n, v, e, p, d, s) {
        var o = '';

        each(v, function(v, k) {
          o += (!o ? '' : '&') + escape(k) + '=' + escape(v);
        });

        this.set(n, o, e, p, d, s);
      },

      get : function(n) {
        var c = document.cookie, e, p = n + "=", b;

        // Strict mode
        if (!c)
          return;

        b = c.indexOf("; " + p);

        if (b == -1) {
          b = c.indexOf(p);

          if (b !== 0)
            return null;
        } else
          b += 2;

        e = c.indexOf(";", b);

        if (e == -1)
          e = c.length;

        return unescape(c.substring(b + p.length, e));
      },

      set : function(n, v, e, p, d, s) {
        document.cookie = n + "=" + escape(v) +
          ((e) ? "; expires=" + e.toGMTString() : "") +
          ((p) ? "; path=" + escape(p) : "") +
          ((d) ? "; domain=" + d : "") +
          ((s) ? "; secure" : "");
      },

      remove : function(name, path, domain) {
        var date = new Date();

        date.setTime(date.getTime() - 1000);

        this.set(name, '', date, path, domain);
      }
    });
  })();
 tinymce.PluginManager.add('mt', tinymce.plugins.MovableType);
})(jQuery);