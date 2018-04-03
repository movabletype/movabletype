; (function ($) {
    var BEF = MT.BlockEditorField;
    var label = trans('horizon');

    BEF.Horizon = function () { BEF.apply(this, arguments) };
    $.extend(BEF.Horizon, {
        label: trans('horizon'),
        icon_class: 'ic_hr',
        type: 'horizon',
        create_button: function () {
          return $('<button type="button" class="btn btn-contentblock"><svg title="' + label + '" role="img" class="mt-icon"><use xlink:href="' + StaticURI + 'images/sprite.svg#ic_hr"></use></svg>' + label + '</button>');
        },
    });
    $.extend(BEF.Horizon.prototype, BEF.prototype, {
        id: '',
        input_field: '',
        options: {},

        get_id: function () {
            return self.id;
        },
        get_label: function(){
          return BEF.Horizon.label;
        },
        get_type: function () {
            return BEF.Horizon.type;
        },
        get_svg_name: function() {
          return BEF.Horizon.icon_class;
        },
        create: function () {
            this.view_field = $('<div class="form-group"></div>');
            this.view_field.append(this.get_html());
            return this.view_field;
        },
        get_data: function () {
            var self = this;
            return {
                'value': '',
                'html': self.get_html(),
                'options': {},
            };
        },
        get_html: function () {
            return '<hr>';
        }
    });

    MT.BlockEditorFieldManager.register('horizon', BEF.Horizon);

})(jQuery);
