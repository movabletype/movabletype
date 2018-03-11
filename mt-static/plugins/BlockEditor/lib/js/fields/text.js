; (function ($) {

    var BEF = MT.BlockEditorField;
    var label = trans('Text');

    BEF.Text = function () { BEF.apply(this, arguments) };
    $.extend(BEF.Text, {
        label: trans('Text'),
        create_button: function () {
          return $('<button type="button" class="btn btn-contentblock"><svg title="' + label + '" role="img" class="mt-icon"><use xlink:href="' + StaticURI + 'images/sprite.svg#ic_textcolor"></use></svg>' + label + '</button>');
        },
    });
    $.extend(BEF.Text.prototype, BEF.prototype, {
        options: {},
        get_id: function () {
            return self.id;
        },
        get_type: function () {
            return 'text';
        },
        get_svg_name: function() {
            return 'ic_textcolor';
        },
        create: function (id, data) {
            var self = this;
            self.id = id;
            self.edit_field = $('<div class="form-group"></div>');
            self.edit_field_input = $('<textarea id="' + self.id + '-text" class="text high html5-form form-control content-field" name="' + self.id + '-text" mt:watch-change="1"></textarea>');
            self.edit_field_input.html(data["value"]);
            self.edit_field.append(self.edit_field_input);
            self.edit_field.append($('<input type="hidden" data-target="' + self.id + '-text" value="richtext">'));

            $(window).one('field_created', function(editor_id){
              $('#' + self.id + '-text').each(function (index, element) {
                  new MT.EditorManager(this.id, {
                      format: 'richtext',
                      wrap: true,
                  });
              });
            });

            return self.edit_field;
        },
        set_option: function (name, val) {
            var style_name = name.replace('field_option_', '');
            this.options[style_name] = val;
        },
        get_data: function () {
            var self = this;
            return {
                'value': $('#' + self.id + '-text').html(),
                'html': self.get_html(),
                'options': self.options,
            };
        },
        get_html: function () {
            var self = this;
            var html = '<div>' + $('#' + self.id + '-text').html() + '</div>';

            return html;
        }
    });

    MT.BlockEditorFieldManager.register('text', BEF.Text);

})(jQuery);
