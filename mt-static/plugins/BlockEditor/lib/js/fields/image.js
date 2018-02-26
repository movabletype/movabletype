; (function ($) {
    var BEF = MT.BlockEditorField;
    var label = trans('image');

    BEF.Image = function () { BEF.apply(this, arguments) };
    BEF.Image.create_button = function () {
        return $('<div class="add"><div class="mt-icon--contentblock"><svg title="' + label + '" role="img" class="mt-icon mt-icon--sm"><use xlink:href="' + StaticURI + 'images/sprite.svg#ic_image"></use></svg></div><label>' + label + '</label></div>');

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
            self.options_field = $('<div class="options"></div>');

            var option_alt = $('<div class="form-group"><label for="' + self.id + '_option_alt" class="form-control-label">' + trans('alt') + '</label><input type="text" name="field_option_alt" id="' + self.id + '_option_alt" class="form-control"></div>');
            self.options_field.append(option_alt);

            var option_title = $('<div class="form-group"><label for="' + self.id + '_option_title" class="form-control-label">' + trans('title') + '</label><input type="text" name="field_option_title" id="' + self.id + '_option_title" class="form-control"></div>');
            self.options_field.append(option_title);

            var option_width = $('<div class="form-group"><label for="' + self.id + '_option_width" class="form-control-label">' + trans('width') + '</label><div class="input-group"><input type="number" name="field_option_width"  id="' + self.id + '_option_width" class="form-control"><div class="input-group-append"><span class="input-group-text">px</span></div></div></div>');
            self.options_field.append(option_width);

            var option_align = $('<div class="form-group"><label for="' + self.id + '_option_arrangement" class="form-control-label mr-3">' + trans('Arrangement') + '</label><div class="btn-group btn-group-space alignbutton" role="group"></div></div>');

            var align_none = $('<button type="button" class="btn btn-default p-1 alignnone" data-arign="none" title="' + trans('none') + '" data-toggle="button" aria-pressed="false" ><svg title="AlignNone" role="img" class="mt-icon"><use xlink:href="' + StaticURI + 'images/sprite.svg#ic_alignnone"/></svg></button>');
            var align_laft = $('<button type="button" class="btn btn-default p-1 alignleft" data-arign="left" title="' + trans('Left Align Text') + '" data-toggle="button" aria-pressed="false" ><svg title="AlignLeft" role="img" class="mt-icon"><use xlink:href="' + StaticURI + 'images/sprite.svg#ic_alignleft"/></svg></button>');
            var align_center = $('<button type="button" class="btn btn-default p-1 aligncenter" data-arign="center" title="' + trans('Center Align Text') + '" data-toggle="button" aria-pressed="false" ><svg title="AlignCenter" role="img" class="mt-icon"><use xlink:href="' + StaticURI + 'images/sprite.svg#ic_aligncenter"/></svg></button>');
            var align_right = $('<button type="button" class="btn btn-default p-1 alignright" data-arign="right" title="' + trans('Right Align Text') + '" data-toggle="button" aria-pressed="false" ><svg title="AlignRight" role="img" class="mt-icon"><use xlink:href="' + StaticURI + 'images/sprite.svg#ic_alignright"/></svg></button>');

            option_align.find('.btn-group').append(align_none);
            option_align.find('.btn-group').append(align_laft);
            option_align.find('.btn-group').append(align_center);
            option_align.find('.btn-group').append(align_right);

            self.options_field.append(option_align);

            var option_caption = $('<div class="form-group"><label for="' + self.id + '_option_caption" class="form-control-label">' + trans('caption') + '</label><input type="text" name="field_option_caption" id="' + self.id + '_option_caption" class="form-control"></div>');
            self.options_field.append(option_caption);


            var callback = function () {
                return function () {
                    var name = $(this).attr('name');
                    var val = $(this).val();
                    self.set_option.call(self, name, val);
                };
            }();
            self.options_field.on('change', 'input', callback);

            option_align.find('.alignbutton button').on('click',function(){
              $('.alignbutton button').each(function(){
                $(this).removeClass('active');
                $(this).attr('aria-pressed', 'false');
              });
              var name = 'field_option_align';
              var val = $(this).attr('data-arign');
              self.set_option.call(self, name, val);
            });


            Object.keys(self.options).forEach(function (key) {
                self.options_field.find('input#' + self.id + '_option_' + key).val(self.options[key]);
            });

            if(self.options.align){
              var target = option_align.find('.alignbutton button[data-arign=' + self.options.align + ']');
              target.addClass('active');
              target.attr('aria-pressed', 'true');
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
                if( key == 'caption' ) return;
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
                html = '<figure>' + html + '<figcaption>' + self.options.caption + '<figcaption></figure>';
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
