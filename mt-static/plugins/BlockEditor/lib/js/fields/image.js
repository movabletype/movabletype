; (function ($) {
    var BEF = MT.BlockEditorField;
    BEF.Image = function () { BEF.apply(this, arguments) };
    $.extend(BEF.Image, {
        label: trans('image'),
        icon_url: StaticURI + 'images/sprite.svg#ic_image',
        icon: '<svg role="img" class="mt-icon"><title>' + this.label + '</title><use xlink:href="' + this.icon_url + '"></use></svg>',
        type: 'image',
        create_button: function () {
          return $('<button type="button" class="btn btn-contentblock">' + this.get_icon() + this.label + '</button>');
        },
        get_icon: function(){
            return '<svg role="img" class="mt-icon"><title>' + this.label + '</title><use xlink:href="' + this.icon_url + '"></use></svg>';
        }
    });
    $.extend(BEF.Image.prototype, BEF.prototype, {
        id: '',
        input_field: '',
        options_array: ['alt','title','width','align','caption','thumbnail'],

        get_id: function () {
            return self.id;
        },
        get_label: function(){
          return BEF.Image.label;
        },
        get_type: function () {
            return BEF.Image.type;
        },
        get_icon: function() {
            return BEF.Image.get_icon();
        },
        create: function (id, data) {
            var self = this;
            self.data = data;
            var asset_id = '';
            self.id = id;
            self.view_field = $('<div class="form-group asset_field clearfix"></div>');
            self.view_field.append(self.get_html());
            return self.view_field;
        },
        get_edit_field: function(){
            var self = this;
            var req_data = self._get_req_data();
            var options_field_id = 'asset-options-' + self.id;
            self.options_field = $('<div id="' + options_field_id + '"><div class="indicator"><img alt="' + trans('Loading...') + '" src="' + StaticURI + 'images/ic_loading-xsm.gif" witdh="16" height="16">'+ trans('Loading...') + '</div></div>');

            $.ajax({
                url: ScriptURI,
                type:'POST',
                data: req_data,
            })
            .done(function(data){
                self.options_field.append(data);
                self.options_field.find(' > indicator').remove();
            })
            .fail(function(jqXHR, textStatus, errorThrown){
                self.options_field = '';
            });

            return self.options_field;
        },
        _get_req_data: function(){
          var self = this;
          var req_data = {
            '__mode': 'blockeditor_dialog_list_asset',
            'edit_field': self.id,
            'blog_id': $('[name=blog_id]').val(),
            'dialog_view': 1,
            'filter': 'class',
            'next_mode': 'blockeditor_dialog_insert_options',
            'asset_select': 1,
            'magic_token': $('[name="magic_token"]').val(),
          };
          if(self.data.asset_id && self.data.asset_id != ''){
            req_data['asset_id'] = self.data.asset_id;
            req_data['edit'] = 1;
          }
          req_data['options'] = JSON.stringify(self.data.options);
          return req_data;
        },
        save: function(){
          var self = this;
          self.data.asset_id = $('.step3 .asset-option-id').val();
          self.data.asset_url = $('.step3 .asset-option-url').val();
          self.options_array.forEach(function(option){
            var field_name = '.asset-option-' + option;
            self.data.options[option] = self.options_field.find('.step3 ' + field_name).val();
          });
          var html = self.get_html();
          self.view_field.empty();
          this.view_field.append(html);
        },
        set_option: function (name, val) {
            var style_name = name.replace('field_option_', '');
            this.options[style_name] = val;
        },
        get_data: function () {
            var self = this;
            var data = {
                'asset_id': self.data.asset_id,
                'asset_url': self.data.asset_url,
                'html': self.get_html(),
                'options': self.data.options,
            };

            return data;
        },
        get_html: function () {
            var self = this;
            if(!self.data.asset_url || self.data.asset_url == ""){
                return '';
            }

            var img = $('<img>');
            img.attr('src', self.data.asset_url);
            Object.keys(self.data.options).forEach(function(key){
                if( key == 'caption' || key == 'thumbnail' ) return;
                if( key == 'align') {
                    img.addClass('mt-image-' + self.data.options[key]);
                    if(self.data.options[key] == 'left'){
                        img.attr('style', 'float: left; margin: 0 20px 20px 0;');
                    } else if( self.data.options[key] == 'right' ) {
                        img.attr('style', 'float: right; margin: 0 0 20px 20px;');
                    } else if( self.data.options[key] == 'center' ) {
                        img.attr('style', 'text-align: center; display: block; margin: 0 auto 20px;');
                    }
                } else {
                  img.attr(key, self.data.options[key]);
                }

            });
            if( self.data.options.caption ){
                var figcaption = $('<figcaption>');
                figcaption.text(self.data.options.caption);
                var figure = $('<figure>');
                figure.append(img);
                figure.append(figcaption);
                figure.attr('style', img.attr('style'));
                img.removeAttr('style');
                img = figure;
            }
            return img.prop('outerHTML');
        },
        get_src: function() {
            var self = this;
            return $('#img-' + self.id + '-url').val();
        }
    });

    MT.BlockEditorFieldManager.register('image', BEF.Image);

})(jQuery);
