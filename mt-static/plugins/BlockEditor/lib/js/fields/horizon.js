; (function ($) {
    var BEF = MT.BlockEditorField;
    var label = trans('horizon');

    BEF.Horizon = function () { BEF.apply(this, arguments) };
    BEF.Horizon.create_button = function () {
        return $('<div class="row py-2 add"><div class="mt-icon--contentblock"><svg title="' + label + '" role="img" class="mt-icon mt-icon--sm"><use xlink:href="' + StaticURI + 'images/sprite.svg#ic_hr"></use></svg></div><label>' + label + '</label></div>');
    };
    $.extend(BEF.Horizon.prototype, BEF.prototype, {
        id: '',
        input_field: '',
        options: {},

        get_id: function () {
            return self.id;
        },
        get_type: function () {
            return 'horizon';
        },
        get_svg_name: function() {
          return 'ic_hr';
        },
        create: function (id, data) {
            this.id = id;
            return "";
        },
        set_option: function (name, val) {
            var style_name = name.replace('field_option_', '');
            this.options[style_name] = val;
        },
        get_data: function () {
            var self = this;
            return {
                'value': '',
                'html': self.get_html(),
                'options': self.options,
            };
        },
        get_html: function () {
            var self = this;
            var html = '<hr';
            Object.keys(self.options).forEach(function(key){
                html += ' ' + key + '="' + self.options[key] + '"';
            })
            html += '>';
            return html;
        }
    });

    MT.BlockEditorFieldManager.register('horizon', BEF.Horizon);

})(jQuery);
