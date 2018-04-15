; (function ($) {
    var BEF = MT.BlockEditorField;
    BEF.Text = function () { BEF.apply(this, arguments) };
    $.extend(BEF.Text, {
        label: trans('text'),
        icon_url: StaticURI + 'images/sprite.svg#ic_textcolor',
        type: 'text',
        create_button: function () {
            return $('<button type="button" class="btn btn-contentblock">' + this.get_icon() + this.label + '</button>');
        },
        get_icon: function(){
            return '<svg title="' + this.label + '" role="img" class="mt-icon"><use xlink:href="' + this.icon_url + '"></use></svg>';
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
            self.edit_field.append($('<input type="hidden" data-target="' + self.id + '-text" value="richtext">'));

            $(window).one('field_created', function(editor_id){
              $('#' + self.id + '-text').each(function (index, element) {
                  if(MT.EditorManager){
                      new MT.EditorManager(this.id, {
                          format: 'richtext',
                          wrap: true,
                      });
                  }
              });
            });
            return self.edit_field;
        },
        save: function(){
            if($('#' + this.id + '-text').prop('tagName') == 'TEXTAREA'){
                this.data.value = $('#' + this.id + '-text').val();
            } else {
                this.data.value = $('#' + this.id + '-text').html();
            }
        },
        get_data: function () {
            var self = this;
            if($('#' + this.id + '-text').prop('tagName') == 'TEXTAREA'){
                self.data.value = $('#' + this.id + '-text').val();
            } else {
                self.data.value = $('#' + this.id + '-text').html();
            }
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
        }
    });

    MT.BlockEditorFieldManager.register('text', BEF.Text);

})(jQuery);
