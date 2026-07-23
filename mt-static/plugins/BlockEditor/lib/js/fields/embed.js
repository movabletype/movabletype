; (function ($) {
    var BEF = MT.BlockEditorField;
    BEF.Embed = function () { BEF.apply(this, arguments) };
    $.extend(BEF.Embed, {
        label: trans('Embed Code'),
        icon_url: StaticURI + 'images/sprite.svg#ic_code',
        type: 'embed',
        create_button: function () {
          return $('<button type="button" class="btn btn-contentblock">' + this.get_icon() + this.label + '</button>');
        },
        get_icon: function(){
            return '<svg role="img" class="mt-icon"><title>' + this.label + '</title><use xlink:href="' + this.icon_url + '"></use></svg>';
        }
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
        get_icon: function() {
            return BEF.Embed.get_icon();
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
