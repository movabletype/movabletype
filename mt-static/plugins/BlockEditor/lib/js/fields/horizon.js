; (function ($) {
    var BEF = MT.BlockEditorField;

    BEF.Horizon = function () { BEF.apply(this, arguments) };
    BEF.Horizon.createButton = function () {
        return $('<span class="add">Horizon</span>');
    };
    $.extend(BEF.Horizon.prototype, BEF.prototype, {
        id: '',
        input_field: '',
        options: [],

        get_id: function () {
            return self.id;
        },
        get_type: function () {
            return 'horizon';
        },
        create: function (id, data) {
            this.id = id;
            this.input_field = $('<div class="hr_field"><hr><input type="hidden" name="' + id + '" id="' + id + '" value="hr"></div>');
            return this.input_field;
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
                'value': '',
                'html': self.get_html(),
            };
        },
        get_html: function () {
            var html = '<hr';
            if (this.class_names.length > 0) {
                html += ' class="' + this.class_names.join(' ') + '"';
            }
            html += '>';
            return html;
        }
    });

    MT.BlockEditorFieldManager.register('horizon', BEF.Horizon);

})(jQuery);