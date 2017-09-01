; (function ($) {
    var BEF = MT.BlockEditorField;

    BEF.Image = function () { BEF.apply(this, arguments) };
    BEF.Image.createButton = function () {
        return $('<span class="add">Image</span>');
    };
    $.extend(BEF.Image.prototype, BEF.prototype, {
        id: '',
        input_field: '',
        options: {},

        get_id: function () {
            return self.id;
        },
        get_type: function () {
            return 'image';
        },
        create: function (id, data) {
            var self = this;
            self.id = id;
            self.input_field = $('<div class="asset_field"><a href="' + ScriptURI + '?__mode=dialog_list_asset&amp;edit_field=' + id + '&amp;blog_id=' + $('[name=blog_id]').val() + '&amp;dialog_view=1&amp;filter=class&amp;filter_val=image&amp;no_insert=1&amp;next_mode=block_editor_asset" class="mt-open-dialog mt-modal-open" data-mt-modal-large>edit Image</a><input type="hidden" name="' + id + '" id="' + id + '" value=""></div>');
            self.input_field.find('#' + id).val(data.value);
            self.preview_field = $('<div></div>');
            self.preview_field.attr('id', id + '-preview');
            if (data.preview_html && data.preview_html != "") {
                self.preview_field.append(data.preview_html);
            }
            self.input_field.find('a').append(self.preview_field);
            self.input_field.find('a.mt-modal-open').mtModal();

            if(data.options && Object.keys(data.options).length > 0){
                self.options = data.options;
            }

            return self.input_field;
        },
        get_field_options: function (field_options) {
            var self = this;
            var option_alt = $('<label>alt<input type="text" name="field_option_alt"></label>');
            self.options_field = $('<div class="options"></div>');
            self.options_field.append(option_alt);
            var callback = function () {
                return function () {
                    var name = $(this).attr('name');
                    var val = $(this).val();
                    self.set_option.call(self, name, val);
                };
            }();
            self.options_field.on('change', 'input', callback);
            if(self.options.alt){
                option_alt.find('input').val(self.options.alt);
            }

            return field_options.append(self.options_field);
        },
        set_option: function (name, val) {
            var style_name = name.replace('field_option_', '');
            this.options[style_name] = val;
        },
        set_class_name: function (val) {
            var self = this;
            var class_names = val.split(' ');
            self.class_names = [];
            class_names.forEach(function (class_name) {
                self.class_names.push(class_name);
            });
        },
        get_data: function () {
            var self = this;
            return {
                'class_name': self.class_names.join(' '),
                'type': self.get_type(),
                'value': self.input_field.find('#' + self.id).val(),
                'preview_html': self.get_html(),
                'html': self.get_html(),
                'options': self.options,
            };
        },
        get_html: function () {
            var self = this;
            Object.keys(self.options).forEach(function(key){
                self.preview_field.find('img').attr(key, self.options[key]);
            })
            return self.preview_field.html();
        }
    });

    MT.BlockEditorFieldManager.register('image', BEF.Image);

})(jQuery);
