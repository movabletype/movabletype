; (function ($) {
    var BEF = MT.BlockEditorField;
    BEF.Text = function () { BEF.apply(this, arguments) };
    $.extend(BEF.Text, {
        label: trans('__TEXT_BLOCK__'),
        icon_url: StaticURI + 'images/sprite.svg#ic_textcolor',
        type: 'text',
        create_button: function () {
            return $('<button type="button" class="btn btn-contentblock">' + this.get_icon() + this.label + '</button>');
        },
        get_icon: function(){
            return '<svg role="img" class="mt-icon"><title>' + this.label + '</title><use xlink:href="' + this.icon_url + '"></use></svg>';
        }
    });
    $.extend(BEF.Text.prototype, BEF.prototype, {
        get_id: function(){
          return this.id;
        },
        get_label: function(){
          return BEF.Text.label;
        },
        get_type: function () {
            return BEF.Text.type;
        },
        get_icon: function() {
            return BEF.Text.get_icon();
        },
        create: function (id, data) {
            var self = this;
            self.id = id;
            if(!self.data.value){
              self.data.value = '';
            }

            self.edit_field = $('<div></div>');
            self.edit_field_input = $('<textarea id="' + self.id + '-text" class="mt-contentblock__textarea" name="' + self.id + '-text" mt:watch-change="1"></textarea>');
            self.edit_field_input.text(self.data.value);
            self.edit_field.append(self.edit_field_input);
            if (MT.EditorManager) {
                self.edit_field_input_mobile = $('<textarea id="' + self.id + '-text-mobile" class="mt-contentblock__textarea" name="' + self.id + '-text-mobile" mt:watch-change="1"></textarea>');
                self.edit_field_input_mobile.text(self.data.value);
                self.edit_field_input_mobile.hide();
                self.edit_field.append(self.edit_field_input_mobile);
            }
            self.edit_field.append($('<input type="hidden" data-target="' + self.id + '-text" value="richtext">'));

            self.editors = [];
            $(window).one('field_created', function(editor_id){
              $('#' + self.id + '-text').each(function (index, element) {
                  if(MT.EditorManager){
                      var editor = new MT.EditorManager(this.id, {
                          format: 'richtext',
                          wrap: true,
                      });
                      self.editors.push(editor);
                  }
              });
              if (MT.EditorManager) {
                  if (MT.Util.isMobileView()) {
                      self._change_to_mobile_view();
                  }
                  $(window).on('change_to_mobile_view', function () {
                      self._sync_pc_data_to_mobile();
                      self._change_to_mobile_view();
                  }).on('change_to_pc_view', function () {
                      self._sync_mobile_data_to_pc();
                      self._change_to_pc_view();
                  });
              }
            });
            return self.edit_field;
        },
        save: function(){
            if (MT.Util.isMobileView()) {
                this.data.value = $('#' + this.id + '-text-mobile').val();
            } else {
                if($('#' + this.id + '-text').prop('tagName') == 'TEXTAREA'){
                    this.data.value = $('#' + this.id + '-text').val();
                } else {
                    for (var i = 0; i < this.editors.length; i++) {
                        if(this.id + '-text' == this.editors[i].id){
                            this.editors[i].save();
                            this.data.value = this.editors[i].getContent();
                        }
                    }
                }
            }
        },
        get_data: function () {
            var self = this;
            self.save();
            return {
                'value': self.data.value,
                'html': self.get_html(),
                'options': self.options,
            };
        },
        get_html: function () {
            var self = this;
            var html = '<div>' + self.data.value + '</div>';

            return html;
        },
        _change_to_mobile_view: function () {
            this.editors.forEach(function (editor) {
                editor.hide();
            });
            this.edit_field_input_mobile.show();
        },
        _change_to_pc_view: function () {
            this.editors.forEach(function (editor) {
                editor.show();
            });
            this.edit_field_input_mobile.hide();
        },
        _sync_mobile_data_to_pc: function () {
            var mobile_data = $('#' + this.id + '-text-mobile').val();
            $('#' + this.id + '-text').each(function (index, pc_editor) {
                if (pc_editor.tagName == 'TEXTAREA') {
                    $(pc_editor).val(mobile_data);
                } else {
                    $(pc_editor).html(mobile_data);
                }
            });
        },
        _sync_pc_data_to_mobile: function () {
            var $pc_editor = $('#' + this.id + '-text').first();
            var pc_data;
            if ($pc_editor.prop('tagName') == 'TEXTAREA') {
                pc_data = $pc_editor.val();
            } else {
                pc_data = $pc_editor.html();
                if (pc_data == '<p><br data-mce-bogus="1"></p>') {
                    return;
                }
            }
            $('#' + this.id + '-text-mobile').val(pc_data);
        },
    });

    MT.BlockEditorFieldManager.register('text', BEF.Text);

})(jQuery);
