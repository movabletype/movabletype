;(function ($) {
    MT.BlockEditorFieldManager = function () {
        this.init.apply(this, arguments)
    }
    // Class method
    $.extend(MT.BlockEditorFieldManager, {
        fields: [],
        field_classes: {},
        register: function (id, field) {
            this.fields.push(field)
            this.field_classes[id] = field
        },
        get_fields: function () {
            return this.fields
        }
    })
    // Instance method
    $.extend(MT.BlockEditorFieldManager.prototype, {
        editor_id: '',
        field_instances: {},
        create_field_instance: {},
        init: function (id) {
            this.editor_id = id
            this.field_instances = {}
            return this
        },
        get_fields: function () {
            return MT.BlockEditorFieldManager.fields
        },
        get_field_classes: function () {
            return MT.BlockEditorFieldManager.field_classes
        },
        create_button: function (callback) {
            var buttons = []
            var self = this
            var fields = self.get_fields()
            var data = {}
            fields.forEach(function (field, index) {
                var button = $(field.create_button())
                button.attr('data-blockeditor-type', field.type)
                button = button.wrapAll('<div class="col-12 col-md-6 pb-3 button-col"></div>').parent()
                buttons.push(button)
            })
            return buttons
        },
        create_option_view: function (field_type) {
            var self = this
            var fields = self.get_field_classes()
            var id = self._generate_unique_id()
            if (!fields[field_type]) return
            var field_instance = new fields[field_type](id)
            var view_field = $(field_instance.create_field(field_instance, id, {}))
            var option_view = $(field_instance.get_edit_field())
            self.create_field_instance = field_instance

            return option_view
        },
        create_field: function (field_type, id, data) {
            var self = this
            var fields = self.get_field_classes()
            if (!id) {
                id = self._generate_unique_id()
            }
            var field_instance
            if (Object.keys(self.create_field_instance).length > 0) {
                field_instance = self.create_field_instance
                id = field_instance.id
            } else {
                var field_class = fields[field_type]
                if (!field_class) return
                field_instance = new field_class(id, data)
            }
            var order = data.order ? data.order : self.field_instances.length
            self.field_instances[id] = field_instance
            self.field_instances[id]['order'] = order
            var delete_clallback = function () {
                var self = this
                return function (id) {
                    delete self.field_instances[id]
                }
            }
            var field_content = field_instance.create_field(field_instance, id, data, delete_clallback.call(self))
            return field_content
        },
        create_save_field: function (field_type, id, data) {
            var self = this
            var field_content = self.create_field('', id, {})
            var field_instance
            self.create_field_instance.save()
            self.create_field_instance = {}
            return field_content
        },
        is_option: function (field_type) {
            var self = this
            var fields = self.get_field_classes()
            var field_class = fields[field_type]
            return typeof field_class.prototype.get_edit_field == 'function' ? true : false
        },
        change_mode: function (mode) {
            var self = this
            Object.keys(self.field_instances).forEach(function (field_id) {
                var field = self.field_instances[field_id]
                if (mode == 'sort') {
                    $('#contentblock-' + field_id + '-wrapper').hide()
                    var icon = field.get_icon()
                    var label = field.get_label()
                    var sorter = $('<div id="draggable-' + field_id + '" class="mt-draggable sort-enabled" draggable="true" aria-grabbed="false">')
                    sorter.append(
                        '<div class="col-auto mt-ic_move"><svg role="img" class="mt-icon"><title>' +
                            trans('Move') +
                            '</title><use xlink:href="' +
                            StaticURI +
                            'images/sprite.svg#ic_move"></use></svg></div>'
                    )
                    sorter.append('<div class="col">' + icon + label + '</div></div>')
                    sorter.append('<div class="block-field"></div>')
                    $('#contentblock-' + field_id + '-wrapper').before(sorter)
                    sorter.find('.block-field').append($('#contentblock-' + field_id + '-wrapper'))
                    $('#contentblock-' + field_id + '-wrapper').hide()
                } else {
                    $('#draggable-' + field_id).each(function () {
                        $(this).before($(this).find('.block-field [id$=-wrapper]'))
                        $('[id$=-wrapper]').show()
                        $(this).remove()
                    })
                }
            })
        },
        set_order: function (order) {
            var self = this
            jQuery.each(order, function (index, id_wrap_str) {
                var id = id_wrap_str.replace('draggable-', '')
                self.field_instances[id]['order'] = index + 1
            })
        },
        get_data: function () {
            var self = this
            var data = {}
            var max_order = 0
            Object.keys(self.field_instances).forEach(function (field_id, index) {
                var field = self.field_instances[field_id]
                data[field_id] = field.get_field_data(field_id)

                if (field.order && max_order < field.order) {
                    max_order = field.order
                    data[field_id].order = field.order
                } else {
                    if (field.order == undefined) {
                        max_order += 1
                        data[field_id].order = max_order
                    } else {
                        data[field_id].order = field.order
                    }
                }
            })
            return data
        },
        set_data: function (data) {
            var self = this
            var fields = self.get_fields()
            var field_classes = self.get_field_classes()
            var field_contens = []
            Object.keys(data).forEach(function (field_id, index) {
                var field_type = data[field_id].type
                var field_order = data[field_id].order ? data[field_id].order : field_contens.length
                field_contens[field_order] = self.create_field.call(self, field_type, field_id, data[field_id])
            })
            return field_contens
        },
        get_html: function () {
            var self = this
            var htmls = []
            Object.keys(self.field_instances).forEach(function (field_id) {
                var field = self.field_instances[field_id]
                htmls.push(field.get_html())
            })
            return htmls
        },
        _generate_unique_id: function () {
            return 'field-' + new Date().getTime().toString(16) + Math.floor(Math.random() * 9999).toString(16)
        }
    })
})(jQuery)
