; (function ($) {

    var BEF = MT.BlockEditorField;
    var label = trans('embed');

    BEF.Embed = function () { BEF.apply(this, arguments) };
    $.extend(BEF.Embed, {
        label: trans('embed'),
        icon_class: 'ic_code',
        type: 'embed',
        create_button: function () {
          return $('<button type="button" class="btn btn-contentblock"><svg title="' + label + '" role="img" class="mt-icon"><use xlink:href="' + StaticURI + 'images/sprite.svg#ic_code"></use></svg>' + label + '</button>');
        },
    });
    $.extend(BEF.Embed.prototype, BEF.prototype, {
        options: {},
        get_id: function () {
            return self.id;
        },
        get_label: function(){
          return BEF.Embed.label;
        },
        get_type: function () {
            return BEF.Embed.type;
        },
        get_svg_name: function() {
            return BEF.Embed.icon_class;
        },
        create: function (id, data) {
            var self = this;
            self.id = id;
            self.edit_field = $('<div class="form-group"></div>');
            self.edit_field_input = $('<textarea id="' + id + '" class="form-control mt-contentblock__embed" name="' + id + '" mt:watch-change="1"></textarea>');
            self.edit_field_input.val(data["value"]);
            self.edit_field_input.prop('placeholder', trans('Please enter the embed code here.'));

            self.edit_field.append(self.edit_field_input);
            return self.edit_field;
        },
        set_option: function (name, val) {
            var style_name = name.replace('field_option_', '');
            this.options[style_name] = val;
        },
        get_data: function () {
            var self = this;
            return {
                'value': self.edit_field_input.val(),
                'html': self.get_html(),
                'options': self.options,
            };
        },
        get_html: function () {
            var self = this;
            var html = '<div';
            Object.keys(self.options).forEach(function(key){
                html += ' ' + key + '="' + self.options[key] + '"';
            })
            html += '>' + self.edit_field_input.val() + '</div>';

            return html;
        }
    });

    MT.BlockEditorFieldManager.register('embed', BEF.Embed);

})(jQuery);
