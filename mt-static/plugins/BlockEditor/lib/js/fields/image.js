; (function ($) {
    var BEF = MT.BlockEditorField;
    var label = trans('image');

    BEF.Image = function () { BEF.apply(this, arguments) };
    $.extend(BEF.Image, {
        label: trans('image'),
        create_button: function () {
          return $('<button type="button" class="btn btn-contentblock"><svg title="' + label + '" role="img" class="mt-icon"><use xlink:href="' + StaticURI + 'images/sprite.svg#ic_image"></use></svg>' + label + '</button>');
        },
    });
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
            var asset_id = '';

            self.id = id;
            self.input_field = $('<div class="row no-gutters py-2"><div class="col"><div class="form-group"><div class="asset_field"><input type="hidden" name="' + id + '-url" id="' + id + '-url" value=""><input type="hidden" name="' + id + '" id="' + id + '" value=""></div></div></div></div>');
            var edit_link = $('<div class="edit-image-link"></div>');;
            var edit_image_link = $('<div class="rounded-circle action-link"><a href="#" class="edit_image mt-open-dialog mt-modal-open" data-mt-modal-large>' + trans('edit Image') + '</a></div>');
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
                self.asset_id = data.asset_id;
                self.input_field.find('#' + id).val(data.asset_id);
            }

            self.preview_field.append(edit_link);
            self.input_field.find('.asset_field').append(self.preview_field);
            // self.input_field.find('a.mt-modal-open').mtModal();

            edit_link.on('click', '.remove_image', function(event){
                event.preventDefault();
                self.preview_field.css('background-image', 'none');
                $('#' + id + '-url').val('');
                $('#' + id).val('');
                Object.keys(self.options).forEach(function (key) {
                    self.options_field.find('#' + self.id + '_option_' + key).val('');
                    self.options = [];
                });
            });
            edit_image_link.find('a').on('click',function(){
              var link = self.get_edit_link();
              $(this).mtModal.open(link, {large: true});
              return false;
            });

            return self.input_field;
        },
        get_edit_link: function(){
          var self = this;
          var data = self.get_data();
          var link = ScriptURI;
          link += '?__mode=blockeditor_dialog_list_asset';
          link += '&amp;edit_field=' + self.id;
          link += '&amp;blog_id=' + $('[name=blog_id]').val();
          link += '&amp;dialog_view=1';
          link += '&amp;filter=class';
          link += '&amp;filter_val=image';
          link += '&amp;next_mode=block_editor_dialog_insert_options';
          link += '&amp;asset_select=1';
          if(self.asset_id && self.asset_id != ''){
            link += '&amp;asset_id=' + self.asset_id ;
          }
          link += '&amp;options=' + JSON.stringify(self.options);
          return link;
        },
        get_field_options: function (field_options) {
            var self = this;
            self.options_field = $('<div class="options"></div>');

            self.options_field.append('<input type="hidden" name="field_option_alt" id="' + self.id + '_option_alt" class="form-control" mt:watch-change="1">');
            self.options_field.append('<input type="hidden" name="field_option_title" id="' + self.id + '_option_title" class="form-control" mt:watch-change="1">');
            self.options_field.append('<input type="hidden" name="field_option_width"  id="' + self.id + '_option_width" class="form-control" mt:watch-change="1">');
            self.options_field.append('<input type="hidden" name="field_option_align" id="' + self.id + '_option_align" class="form-control" mt:watch-change="1">');
            self.options_field.append('<input type="hidden" name="field_option_caption" id="' + self.id + '_option_caption" class="form-control" mt:watch-change="1">');
            self.options_field.append('<input type="hidden" name="field_option_thumbnail" id="' + self.id + '_option_thumbnail" class="form-control" mt:watch-change="1">');

            // change callback
            var callback = function () {
                return function () {
                    var name = $(this).attr('name');
                    var val = $(this).val();
                    self.set_option.call(self, name, val);
                };
            }();
            self.options_field.on('change', 'input', callback);
            
            // data set
            Object.keys(self.options).forEach(function (key) {
                self.options_field.find('#' + self.id + '_option_' + key).val(self.options[key]);
            });

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
                if( key == 'caption' || key == 'thumbnail' ) return;
                if( key == 'align') {
                    html += ' class="mt-image-' + self.options[key] + '"';
                    if(self.options[key] == 'left'){
                        html += ' style="float: left; margin: 0 20px 20px 0;"';
                    } else if( self.options[key] == 'right' ) {
                        html += ' style="float: right; margin: 0 0 20px 20px;"';
                    } else if( self.options[key] == 'center' ) {
                        html += ' style="text-align: center; display: block; margin: 0 auto 20px;"';
                    }
                } else {
                  html += ' ' + key + '="' + self.options[key] + '"';
                }
            });
            html += '>';
            if( self.options.caption ){
                html = '<figure>' + html + '<figcaption>' + self.options.caption + '</figcaption></figure>';
            }
            return html;
        },
        get_src: function() {
            var self = this;
            return $('#' + self.id + '-url').val();
        }
    });

    MT.BlockEditorFieldManager.register('image', BEF.Image);

})(jQuery);
