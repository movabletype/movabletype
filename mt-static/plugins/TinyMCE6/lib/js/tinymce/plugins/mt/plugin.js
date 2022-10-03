/*
 * Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
 * This code cannot be redistributed without permission from www.sixapart.com.
 * For more information, consult your Movable Type license.
 *
 * $Id$
 */
;(function ($) {
    'use strict'

    tinymce.Editor.prototype.addMTButton = function (name, opts) {
        var ed = this

        var modes = {}
        var funcs = opts['onclickFunctions']
        if (funcs) {
            opts['onAction'] = function (e) {
                var mode = ed.mtEditorStatus['mode']
                var func = funcs[mode]
                if (typeof func == 'string') {
                    ed.mtProxies[mode].execCommand(func)
                } else {
                    func.apply(ed, arguments)
                }
                ed.fire('onMTSourceButtonClick', e)
            }
            for (var k in funcs) {
                modes[k] = 1
            }
        } else {
            modes = { wysiwyg: 1, source: 1 }
        }

        if (!opts['isSupported']) {
            opts['isSupported'] = function (mode, format) {
                if (!modes[mode]) {
                    return false
                }

                if (funcs && mode == 'source') {
                    var func = funcs[mode]
                    if (typeof func == 'string') {
                        return ed.mtProxies['source'].isSupported(func, format)
                    } else {
                        return true
                    }
                } else {
                    return true
                }
            }
        }
        if (!opts['onSetup']) {
            opts['onSetup'] = function (buttonApi) {
                ed.on('onMTSourceButtonClick', function (e) {
                    if (ed.mtProxies['source'] && buttonApi.setActive) {
                        buttonApi.setActive(ed.mtProxies['source'].isStateActive(ed.sourceButtons[name]))
                    }
                })
            }
        }

        if (typeof ed.mtButtons == 'undefined') {
            ed.mtButtons = {}
        }
        ed.mtButtons[name] = opts

        if (opts['toggle']) {
            return ed.ui.registry.addToggleButton(name, opts)
        }
        return ed.ui.registry.addButton(name, opts)
    }

    var initButtonSettings = function (editor) {
        var index = 1
        var config = MT.Editor.TinyMCE.config
        editor.buttonRows = {
            source: {},
            wysiwyg: {}
        }
        if (editor.inline) {
            $.each(['wysiwyg'], function (i, k) {
                var p = 'plugin_mt_' + k + '_insert_toolbar'
                editor.buttonSettings += (editor.buttonSettings ? ',' : '') + config[p]
                editor.options.set('quickbars_insert_toolbar', config[p])
                editor.buttonRows[k][index - 1] = 1
                index++

                p = 'plugin_mt_' + k + '_selection_toolbar'
                editor.buttonSettings += (editor.buttonSettings ? ',' : '') + config[p]
                editor.options.set('quickbars_selection_toolbar', config[p])
                editor.buttonRows[k][index - 1] = 1
                index++
            })
            editor.options.set('toolbar', '')
        } else {
            $.each(['common', 'source', 'wysiwyg'], function (i, k) {
                var p = 'plugin_mt_' + k + '_buttons'
                for (var j = 1; config[p + j]; j++) {
                    editor.buttonSettings += (editor.buttonSettings ? ',' : '') + config[p + j]
                    editor.options.set('toolbar' + index, config[p + j])

                    if (k == 'common') {
                        editor.buttonRows['source'][index - 1] = editor.buttonRows['wysiwyg'][index - 1] = 1
                    } else {
                        editor.buttonRows[k][index - 1] = 1
                    }
                    index++
                }
            })
        }
    }
    var supportedButtons = function (editor, mode, format) {
        var k = mode + '-' + format
        if (!editor.supportedButtonsCache[k]) {
            editor.supportedButtonsCache[k] = {}
            $.each(editor.mtButtons, function (name, button) {
                if (button.isSupported(mode, format)) {
                    editor.supportedButtonsCache[k][name] = button
                }
            })
        }
        return editor.supportedButtonsCache[k]
    }

    var updateButtonVisibility = function (editor) {
        var s = editor.mtEditorStatus
        $.each(editor.hiddenControls, function (i, k) {
            var label = tinymce.util.I18n.translate(editor.mtButtons[k].tooltip)
            $(editor.getContainer())
                .find('button[title="' + label + '"]')
                .css({
                    display: ''
                })
                .removeClass('mce_mt_button_hidden')
        })
        editor.hiddenControls = []

        var supporteds = supportedButtons(editor, s.mode, s.format)

        function update(key) {
            if (!supporteds[key]) {
                var label = tinymce.util.I18n.translate(editor.mtButtons[key].tooltip)
                $(editor.getContainer())
                    .find('button[title="' + label + '"]')
                    .css({
                        display: 'none'
                    })
                    .addClass('mce_mt_button_hidden')
                editor.hiddenControls.push(key)
            }
        }

        if (s.mode == 'source') {
            editor.mtProxies[s.mode].setFormat(s.format)
            $.each(editor.mtButtons, function (name, button) {
                update(name)
            })
        }
        $(editor.editorContainer)
            .find('.tox-toolbar-overlord .tox-toolbar')
            .each(function (i) {
                if (editor.buttonRows[s.mode][i]) {
                    $(this).show()
                } else {
                    $(this).hide()
                }
                // common_buttons
                if (i == 0) {
                    $(this).addClass('float-right')
                }
            })
    }
    var setUpEditor = function (editor) {
        editor.sourceButtons = {}
        editor.mtEditorStatus = {
            mode: 'wysiwyg',
            format: 'richtext'
        }
        editor.mtProxies = {}
        editor.supportedButtonsCache = {}
        initButtonSettings(editor)
        editor.on('init', function () {
            updateButtonVisibility(editor)
        })

        editor.on('NodeChange', function () {
            var s = editor.mtEditorStatus
            if (s.mode == 'source' && s.format != 'none.tinymce_temp') {
                $(editor.container).find('.tox-toolbar:eq(0)').css('display', 'none')
            } else {
                $(editor.container).find('.tox-toolbar:eq(0)').css('display', '')
            }
            editor.statusCache = s
            if (!editor.mtProxies['source']) {
                return
            }
        })
    }

    var register_commands = function (editor) {
        editor.addCommand('mtRestoreBookmark', function (bookmark) {
            if (!bookmark) {
                bookmark = editor.savedBookmark
            }
            if (bookmark) {
                editor.selection.moveToBookmark(editor.savedBookmark)
            }
        })

        editor.addQueryValueHandler('mtSaveBookmark', function () {
            return (editor.savedBookmark = editor.selection.getBookmark())
        })

        $(window).on('dialogDisposed', function () {
            if (editor.savedBookmark) {
                editor.selection.moveToBookmark(editor.savedBookmark)
            }
            editor.savedBookmark = null
        })

        editor.addQueryValueHandler('mtGetProxies', function () {
            return editor.mtProxies
        })

        editor.addCommand('mtSetProxies', function (_proxies) {
            $.extend(editor.mtProxies, _proxies)
        })

        editor.addQueryValueHandler('mtGetStatus', function () {
            return editor.mtEditorStatus
        })

        editor.addCommand('mtSetStatus', function (status) {
            $.extend(editor.mtEditorStatus, status)
            updateButtonVisibility(editor)
        })
    }

    var openDialog = function (mode, param) {
        var url = ScriptURI + '?' + '__mode=' + mode + '&amp;' + param
        $.fn.mtModal.open(url, { large: true })
        var modal_close = function (e) {
            if (e.keyCode == 27) {
                $.fn.mtModal.close()
                $('body').off('keyup', modal_close)
            }
        }
        $('body').on('keyup', modal_close)
    }

    var register_buttons = function (editor) {
        var id = editor.id
        var blogId = $('[name=blog_id]').val() || 0

        editor.ui.registry.addButton('mt_insert_html', {
            icon: 'addhtml',
            tooltip: 'insert_html',
            onAction: function () {
                editor.windowManager.open({
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
                    size: 'large',
                    onSubmit: function (api) {
                        editor.execCommand('mceInsertContent', false, api.getData().insert_html)
                        api.close()
                    }
                })
            }
        })

        editor.ui.registry.addButton('mt_insert_image', {
            icon: 'image',
            tooltip: 'insert_image',
            onAction: function () {
                editor.execCommand('mtSaveBookmark')
                openDialog('dialog_asset_modal', '_type=asset&amp;edit_field=' + id + '&amp;blog_id=' + blogId + '&amp;dialog_view=1&amp;filter=class&amp;filter_val=image&amp;can_multi=1')
            }
        })

        editor.ui.registry.addButton('mt_insert_file', {
            icon: 'new-document',
            tooltip: 'insert_file',
            onAction: function () {
                editor.execCommand('mtSaveBookmark')
                openDialog('dialog_asset_modal', '_type=asset&amp;edit_field=' + id + '&amp;blog_id=' + blogId + '&amp;dialog_view=1&amp;can_multi=1')
            }
        })

        editor.addMTButton('mt_source_bold', {
            text: 'strong',
            tooltip: 'source_bold',
            onclickFunctions: {
                source: 'bold'
            }
        })

        editor.addMTButton('mt_source_italic', {
            tooltip: 'source_italic',
            text: 'em',
            toggle: true,
            onclickFunctions: {
                source: 'italic'
            }
        })

        editor.addMTButton('mt_source_blockquote', {
            tooltip: 'source_blockquote',
            text: 'btn_blockquote',
            toggle: true,
            onclickFunctions: {
                source: 'blockquote'
            }
        })

        editor.addMTButton('mt_source_unordered_list', {
            tooltip: 'source_unordered_list',
            text: 'ul',
            toggle: true,
            onclickFunctions: {
                source: 'insertUnorderedList'
            }
        })

        editor.addMTButton('mt_source_ordered_list', {
            tooltip: 'source_ordered_list',
            text: 'ol',
            toggle: true,
            onclickFunctions: {
                source: 'insertOrderedList'
            }
        })

        editor.addMTButton('mt_source_list_item', {
            tooltip: 'source_list_item',
            text: 'li',
            toggle: true,
            onclickFunctions: {
                source: 'insertListItem'
            }
        })

        editor.addMTButton('mt_source_link', {
            icon: 'link',
            tooltip: 'insert_link',
            onclickFunctions: {
                source: function (cmd, ui, val) {
                    editor.once('OpenWindow', function (dialog) {
                        var s = editor.mtEditorStatus
                        if (s.mode == 'source' && s.format != '0' && s.format != '__default__') {
                            jQuery('.tox-dialog__body .tox-listbox.tox-listbox--select').attr('disabled', 'disabled')
                        }
                        jQuery('.tox-dialog__header button.tox-button--naked, .tox-dialog__footer button.tox-button--secondary').on('click', function () {
                            editor.off('CloseWindow')
                        })
                    })
                    editor.execCommand('mceLink')
                    editor.once('CloseWindow', function (dialog) {
                        var data = dialog.dialog.getData()
                        if (data.url.value)
                            editor.mtProxies['source'].execCommand('createLink', null, data.url.value, {
                                target: data.target,
                                title: data.title,
                                text: data.text
                            })
                        dialog.dialog.setData({})
                    })
                }
            }
        })

        var _before_insert_content = function (editor) {
            editor.off('beforeExecCommand', _insertContent)
            editor.on('beforeExecCommand', _insertContent)
        }
        var _insertContent = function (e) {
            if (e.command == 'mceInsertContent' && e.value) {
                editor.mtProxies.source.editor.insertContent(e.value)
                editor.off('beforeExecCommand', _insertContent)
            }
        }

        editor.addMTButton('mt_source_template', {
            tooltip: 'Insert template',
            icon: 'template',
            onclickFunctions: {
                source: function (buttonApi) {
                    editor.ui.registry.getAll().buttons.template.onAction(editor)
                    _before_insert_content(editor)
                }
            }
        })

        editor.addMTButton('mt_source_mode', {
            icon: 'sourcecode',
            tooltip: 'source_mode',
            toggle: true,
            onclickFunctions: {
                wysiwyg: function () {
                    editor.execCommand('mtSetFormat', 'none.tinymce_temp')
                },
                source: function () {
                    editor.execCommand('mtSetFormat', 'richtext')
                }
            },
            onSetup: function (buttonApi) {
                editor.on('onMTSourceButtonClick', function (e) {
                    var s = editor.mtEditorStatus
                    buttonApi.setActive(s.mode && s.mode == 'source')
                })
            }
        })
    }

    var Plugin = () => {
        var global = tinymce.util.Tools.resolve('tinymce.PluginManager')
        global.add('mt', (editor) => {
            register_commands(editor)
            register_buttons(editor)
            setUpEditor(editor)
            return {}
        })
    }

    tinymce.ScriptLoader.add(tinymce.PluginManager.urls['mt'] + '/langs/plugin.js')
    Plugin()

    class MovableTypeCookie {
        static getHash(n) {
            var v = this.get(n),
                h

            if (v) {
                tinymce.each(v.split('&'), function (v) {
                    v = v.split('=')
                    h = h || {}
                    h[unescape(v[0])] = unescape(v[1])
                })
            }

            return h
        }

        static setHash(n, v, e, p, d, s) {
            var o = ''

            tinymce.each(v, function (v, k) {
                o += (!o ? '' : '&') + escape(k) + '=' + escape(v)
            })

            this.set(n, o, e, p, d, s)
        }

        static get(n) {
            var c = document.cookie,
                e,
                p = n + '=',
                b

            // Strict mode
            if (!c) return

            b = c.indexOf('; ' + p)

            if (b == -1) {
                b = c.indexOf(p)

                if (b !== 0) return null
            } else b += 2

            e = c.indexOf(';', b)

            if (e == -1) e = c.length

            return unescape(c.substring(b + p.length, e))
        }

        static set(n, v, e, p, d, s) {
            document.cookie = n + '=' + escape(v) + (e ? '; expires=' + e.toGMTString() : '') + (p ? '; path=' + escape(p) : '') + (d ? '; domain=' + d : '') + (s ? '; secure' : '')
        }

        static remove(name, path, domain) {
            var date = new Date()

            date.setTime(date.getTime() - 1000)

            this.set(name, '', date, path, domain)
        }
    }
    tinymce.util.MovableTypeCookie = MovableTypeCookie
})(jQuery)
