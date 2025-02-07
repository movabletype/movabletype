; (function ($) {
    var BEF = MT.BlockEditorField;
    BEF.Horizon = function () { BEF.apply(this, arguments) };
    $.extend(BEF.Horizon, {
        label: trans('Horizontal Rule'),
        icon_class: 'ic_hr',
        icon_url: StaticURI + 'images/sprite.svg#ic_hr',
        type: 'horizon',
        create_button: function () {
          return $('<button type="button" class="btn btn-contentblock">' + this.get_icon() + this.label + '</button>');
        },
        get_icon: function(){
            return '<svg role="img" class="mt-icon"><title>' + this.label + '</title><use xlink:href="' + this.icon_url + '"></use></svg>';
        }
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
        get_icon: function() {
          return BEF.Horizon.get_icon();
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
