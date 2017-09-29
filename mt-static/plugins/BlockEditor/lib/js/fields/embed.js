; (function ($) {

    var BEF = MT.BlockEditorField;
    var label = trans('embed');

    BEF.Embed = function () { BEF.apply(this, arguments) };
    BEF.Embed.create_button = function () {
        return $('<div class="row py-2 add"><div class="mt-icon--contentblock"><svg title="' + label + '" role="img" class="mt-icon mt-icon--sm"><use xlink:href="' + StaticURI + 'images/sprite.svg#ic_code"></use></svg></div><label>' + label + '</label></div>');
    };
    $.extend(BEF.Embed.prototype, BEF.prototype, {
        options: {},
        get_id: function () {
            return self.id;
        },
        get_type: function () {
            return 'Embed';
        },
        get_svg_name: function() {
            return 'ic_code';
        },
        create: function (id, data) {
            var self = this;
            self.id = id;
            self.edit_field = $('<div class="form-group"></div>');
            self.edit_field_input = $('<textarea id="' + id + '" class="text high html5-form form-control content-field"></textarea>');
            self.edit_field_input.val(data["value"]);
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

    MT.BlockEditorFieldManager.register('Embed', BEF.Embed);

})(jQuery);
