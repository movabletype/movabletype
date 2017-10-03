; (function ($) {
    var BEF = MT.BlockEditorField;
    var label = trans('image');

    BEF.Image = function () { BEF.apply(this, arguments) };
    BEF.Image.create_button = function () {
        return $('<div class="row py-2 add"><div class="mt-icon--contentblock"><svg title="' + label + '" role="img" class="mt-icon mt-icon--sm"><use xlink:href="' + StaticURI + 'images/sprite.svg#ic_image"></use></svg></div><label>' + label + '</label></div>');

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
        get_svg_name: function() {
            return 'ic_image';
        },
        create: function (id, data) {
            var self = this;
            self.id = id;
            self.input_field = $('<div class="row no-gutters py-2"><div class="col"><div class="form-group"><div class="asset_field"><input type="hidden" name="' + id + '-url" id="' + id + '-url" value=""><input type="hidden" name="' + id + '" id="' + id + '" value=""></div></div></div></div>');
            var edit_link = $('<div class="edit-image-link"></div>');;
            var edit_image_link = $('<div class="rounded-circle action-link"><a href="' + ScriptURI + '?__mode=dialog_list_asset&amp;edit_field=' + id + '&amp;blog_id=' + $('[name=blog_id]').val() + '&amp;dialog_view=1&amp;filter=class&amp;filter_val=image&amp;no_insert=1&amp;next_mode=block_editor_asset" class="edit_image mt-open-dialog mt-modal-open" data-mt-modal-large>' + trans('edit Image') + '</a></div>');
            var delete_image_link = $('<div class="remove_image rounded-circle action-link"><a href="#" class="remove_image">' + trans('delete') + '</a></div>');
            edit_link.append(edit_image_link);
            edit_link.append(delete_image_link);
            self.input_field.find('#' + id).val(data.value);
            self.preview_field = $('<div></div>');
            self.preview_field.attr('id', id + '-preview');
            self.preview_field.addClass('img-preview');
            if (data.asset_url && data.asset_url != "") {
                self.preview_field.css('background-image', 'url(' + data.asset_url + ')');
                self.input_field.find('#' + id + '-url').val(data.asset_url);
            }
            if(data.asset_id && data.asset_id != ""){
                self.input_field.find('#' + id).val(data.asset_id);
            }

            self.preview_field.append(edit_link);
            self.input_field.find('.asset_field').append(self.preview_field);
            self.input_field.find('a.mt-modal-open').mtModal();

            edit_link.on('click', '.remove_image', function(event){
                event.preventDefault();
                self.preview_field.css('background-image', 'none');
                $('#' + id + '-url').val('');
                $('#' + id).val('');
            })

            return self.input_field;
        },
        get_field_options: function (field_options) {
            var self = this;
            var option_alt = $('<div class="form-group"><label for="' + self.id + '_option_lat" class="form-control-label">alt</label><input type="text" name="field_option_alt" id="' + self.id + '_option_alt" class="form-control"></div>');
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
        get_data: function () {
            var self = this;
            var data = {
                'asset_id': $('#' + self.id).val(),
                'asset_url': self.get_src(),
                'html': self.get_html(),
                'options': self.options,
            };

            return data;
        },
        get_html: function () {
            var self = this;
            if($('#' + self.id + '-url').val() == ""){
                return '';
            }
            var html = '<img';
            html += ' src="' + $('#' + self.id + '-url').val() + '"';
            Object.keys(self.options).forEach(function(key){
                html += ' ' + key + '="' + self.options[key] + '"';
            })
            html += '>';
            return html;
        },
        get_src: function() {
            var self = this;
            return $('#' + self.id + '-url').val();
        }
    });

    MT.BlockEditorFieldManager.register('image', BEF.Image);

})(jQuery);
