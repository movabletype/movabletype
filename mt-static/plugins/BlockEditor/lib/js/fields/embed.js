; (function ($) {

    var BEF = MT.BlockEditorField;

    BEF.Embed = function () { BEF.apply(this, arguments) };
    BEF.Embed.createButton = function () {
        return $('<span class="add">Embed</span>');
    };
    $.extend(BEF.Embed.prototype, BEF.prototype, {
        get_id: function () {
            return self.id;
        },
        get_type: function () {
            return 'Embed';
        },
        create: function (id, data) {
            var self = this;
            self.id = id;
            self.edit_field_input = $('<textarea id="' + id + '" class="text short html5-form content-field"></textarea>');
            self.edit_field_input.val(data["value"]);
            return self.edit_field_input;
        },
        set_option: function (name, val) {
            var style_name = name.replace('field_option_', '');
            this.options[style_name] = val;
        },
        set_class_name: function (val) {
            var self = this;
            var class_names = val.split(' ');
            self.class_names = [];
            class_names.forEach(function (class_name) {
                self.class_names.push(class_name);
            });
        },
        get_data: function () {
            var self = this;
            return {
                'class_name': self.class_names.join(' '),
                'type': self.get_type(),
                'value': self.edit_field_input.val(),
                'html': self.get_html(),
            };
        },
        get_html: function () {
            var self = this;
            var html = '<div';
            if (this.class_names.length > 0) {
                html += ' class="' + this.class_names.join(' ') + '"';
            }
            html += '>' + self.edit_field_input.val() + '</div>';

            return html;
        }
    });

    MT.BlockEditorFieldManager.register('Embed', BEF.Embed);

})(jQuery);